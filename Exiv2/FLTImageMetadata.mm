
// Created by Sinisa Drpa on 9/29/15.

#import <Foundation/Foundation.h>

#import "FLTImageMetadata.h"

#include <string>
#include <exiv2/exiv2.hpp>
#include <iostream>
#include <iomanip>

@interface FLTImageMetadata () {
   Exiv2::Image::AutoPtr image;
   Exiv2::ExifData exifData;
}
@end

@implementation FLTImageMetadata

- (instancetype)initWithImageAtURL:(NSURL *)fileURL {
   self = [super init];
   if (self) {
      image = Exiv2::ImageFactory::open([[fileURL path] UTF8String]);
      assert(image.get() != 0);
      image->readMetadata();
      
      exifData = image->exifData();
      //NSAssert(!exifData.empty(), @"No EXIF data found in the file:%@", [fileURL path]);
   }
   return self;
}

- (void)printEXIF {
   Exiv2::ExifData::const_iterator end = exifData.end();
   for (Exiv2::ExifData::const_iterator i = exifData.begin(); i != end; ++i) {
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

@end
