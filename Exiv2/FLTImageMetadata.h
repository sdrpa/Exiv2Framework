
// Created by Sinisa Drpa on 9/29/15.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Exiv2Metadata) {
   Exiv2MetadataExif = 1,
   Exiv2MetadataXmp,
   Exiv2MetadataIptc
};

@interface FLTImageMetadata : NSObject

- (instancetype)initWithImageAtURL:(NSURL *)fileURL;

@property (nonatomic, strong) NSArray *exifKeys;
@property (nonatomic, strong) NSArray *xmpKeys;
@property (nonatomic, strong) NSArray *iptcKeys;

- (id)valueForKey:(NSString *)key metadataType:(Exiv2Metadata)metadataType;

@end