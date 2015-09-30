
// Created by Sinisa Drpa on 9/29/15.

#import <Foundation/Foundation.h>

@interface FLTImageMetadata : NSObject

- (instancetype)initWithImageAtURL:(NSURL *)fileURL;

@property (nonatomic, strong) NSArray *exifKeys;
@property (nonatomic, strong) NSArray *xmpKeys;


@end