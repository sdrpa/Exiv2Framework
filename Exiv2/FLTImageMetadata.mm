
// Created by Sinisa Drpa on 9/29/15.

#import <Foundation/Foundation.h>

#import "FLTImageMetadata.h"

#include <string>
#include <exiv2/exiv2.hpp>
#include <iostream>
#include <iomanip>

@interface FLTImageMetadata () {
   Exiv2::Image::AutoPtr _image;
   Exiv2::ExifData _exifData;
   Exiv2::XmpData _xmpData;
   Exiv2::IptcData _iptcData;
}
@end

@implementation FLTImageMetadata

- (instancetype)init {
   @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use initWithImageAtURL:" userInfo:nil];
}

- (instancetype)initWithImageAtURL:(NSURL *)imageURL {
   self = [super init];
   if (self) {
      NSString *imagePath = [imageURL path];
      _image = Exiv2::ImageFactory::open([imagePath UTF8String]);
      assert(_image.get() != 0);
      _image->readMetadata();
      
      _exifData = _image->exifData();
      _xmpData = _image->xmpData();
      _iptcData = _image->iptcData();
   }
   return self;
}

/**
 Returns array of available EXIF properties inside the image
*/
- (NSArray *)exifKeys {
   NSMutableArray *mutableArray = [NSMutableArray array];
   for (Exiv2::ExifData::const_iterator md = _exifData.begin();
        md != _exifData.end(); ++md) {
      [mutableArray addObject:[NSString stringWithUTF8String:md->key().c_str()]];
   }
   return [mutableArray copy];
}

/**
 Returns array of available XMP properties inside the image
 */
- (NSArray *)xmpKeys {
   NSMutableArray *mutableArray = [NSMutableArray array];
   for (Exiv2::XmpData::const_iterator md = _xmpData.begin();
        md != _xmpData.end(); ++md) {
      [mutableArray addObject:[NSString stringWithUTF8String:md->key().c_str()]];
   }
   return [mutableArray copy];
}

/**
 Returns array of available IPTC properties inside the image
 */
- (NSArray *)iptcKeys {
   NSMutableArray *mutableArray = [NSMutableArray array];
   for (Exiv2::IptcData::const_iterator md = _iptcData.begin();
        md != _iptcData.end(); ++md) {
      [mutableArray addObject:[NSString stringWithUTF8String:md->key().c_str()]];
   }
   return [mutableArray copy];
}

/**
 Returns value for metadata property or nil if the value for key doesn't exist
 */
- (id)valueForMetadataKey:(NSString *)key {
   Exiv2Metadata metadataType = [self metadataTypeForKey:key];
   return (metadataType != Exiv2MetadataUnknown) ? [self valueForMetadataKey:key metadataType:metadataType] : nil;
}

- (Exiv2Metadata)metadataTypeForKey:(NSString *)key {
   Exiv2Metadata metadataType = Exiv2MetadataUnknown;
   for (NSString *exifKey in [self exifKeys]) {
      if ([key isEqualToString:exifKey]) {
         return Exiv2MetadataExif;
      }
   }
   for (NSString *xmpKey in [self xmpKeys]) {
      if ([key isEqualToString:xmpKey]) {
         return Exiv2MetadataXmp;
      }
   }
   for (NSString *iptcKey in [self iptcKeys]) {
      if ([key isEqualToString:iptcKey]) {
         return Exiv2MetadataIptc;
      }
   }
   
   return metadataType;
}

/**
 Returns value for metadata property or nil if the value for key doesn't exist
 */
- (id)valueForMetadataKey:(NSString *)key metadataType:(Exiv2Metadata)metadataType {
   switch (metadataType) {
      case Exiv2MetadataExif:
         return [self valueForExifMetadata:_exifData[key.UTF8String]];
      case Exiv2MetadataXmp:
         return nil;
      case Exiv2MetadataIptc:
         return nil;
      default:
         return nil;
   }
}

/**
 Returns appropriate Objective-C (NSString, NSNumber, or NSArray for tuples (Rational)) value for metadata
 */
- (id)valueForExifMetadata:(Exiv2::Exifdatum)metadatum {
   const char *typeName = metadatum.typeName();
   if (strcmp(typeName, "Ascii") == 0) {
      return [self valueForAsciiTypeWithMetadata:metadatum];
   }
   else if ((strcmp(typeName, "Short") == 0) || (strcmp(typeName, "Long") == 0)) {
      return [self valueForShortLongTypeWithMetadata:metadatum];
   }
   else if (strcmp(typeName, "Rational") == 0) {
      return [self valueForRationalTypeWithMetadata:metadatum];
   }
   else if (strcmp(typeName, "Undefined") == 0) {
      return [self valueForUndefinedTypeWithMetadata:metadatum];
   }
   
   return [NSString stringWithFormat:@"%s", metadatum.toString().c_str()];;
}

- (NSString *)valueForAsciiTypeWithMetadata:(Exiv2::Exifdatum)metadatum {
   return [NSString stringWithFormat:@"%s", metadatum.toString().c_str()];
}

- (NSNumber *)valueForShortLongTypeWithMetadata:(Exiv2::Exifdatum)metadatum {
   return @(metadatum.toLong());
}

- (NSArray *)valueForRationalTypeWithMetadata:(Exiv2::Exifdatum)metadatum {
   NSUInteger count = metadatum.count();
   NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:count];
   for (NSUInteger i=0; i<count; i++) {
      std::pair<int32_t, int32_t> rational = metadatum.toRational(i);
      double value = (double)rational.first / (double)rational.second;
      [mutableArray addObject:@(value)];
   }
   return [mutableArray copy];
}

- (NSArray *)valueForUndefinedTypeWithMetadata:(Exiv2::Exifdatum)metadatum {
   NSUInteger count = metadatum.count();
   NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:count];
   for (NSUInteger i=0; i<count; i++) {
      NSString *string = [NSString stringWithCString:metadatum.toString(i).c_str()
                                            encoding:[NSString defaultCStringEncoding]];
      [mutableArray addObject:string];
   }
   return [mutableArray copy];
}

#pragma mark -

- (void)printExif {
   if (_exifData.empty()) {
      NSLog(@"No EXIF data found in the file");
      return;
   }
   
   Exiv2::ExifData::const_iterator end = _exifData.end();
   for (Exiv2::ExifData::const_iterator i = _exifData.begin(); i != end; ++i) {
      const char* tn = i->typeName();
      std::cout << std::setw(44) << std::setfill(' ') << std::left
      << i->key() << " "
      << "0x" << std::setw(4) << std::setfill('0') << std::right
      << std::hex << i->tag() << " "
      << std::setw(9) << std::setfill(' ') << std::left
      << (tn ? tn : "Unknown") << " "
      << std::dec << std::setw(3)
      << std::setfill(' ') << std::right
      << i->count() << "  "
      << std::dec << i->value()
      << "\n";
   }
}

- (void)printXmp {
   if (_xmpData.empty()) {
      NSLog(@"No XMP data found in the file");
      return;
   }
   
   for (Exiv2::XmpData::const_iterator md = _xmpData.begin();
        md != _xmpData.end(); ++md) {
      std::cout << std::setfill(' ') << std::left
      << std::setw(44)
      << md->key() << " "
      << std::setw(9) << std::setfill(' ') << std::left
      << md->typeName() << " "
      << std::dec << std::setw(3)
      << std::setfill(' ') << std::right
      << md->count() << "  "
      << std::dec << md->value()
      << std::endl;
   }
}

- (void)printIpct {
   if (_iptcData.empty()) {
      NSLog(@"No IPTC data found in the file");
      return;
   }
   
   Exiv2::IptcData::iterator end = _iptcData.end();
   for (Exiv2::IptcData::iterator md = _iptcData.begin(); md != end; ++md) {
      std::cout << std::setw(44) << std::setfill(' ') << std::left
      << md->key() << " "
      << "0x" << std::setw(4) << std::setfill('0') << std::right
      << std::hex << md->tag() << " "
      << std::setw(9) << std::setfill(' ') << std::left
      << md->typeName() << " "
      << std::dec << std::setw(3)
      << std::setfill(' ') << std::right
      << md->count() << "  "
      << std::dec << md->value()
      << std::endl;
   }
}

@end
