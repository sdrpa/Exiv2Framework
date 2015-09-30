
// Created by Sinisa Drpa on 9/30/15.

#import <XCTest/XCTest.h>
#import <Exiv2/Exiv2.h>

@interface FLTImageMetadata ()
- (void)printExif;
- (void)printXmp;
- (void)printIpct;
@end

#pragma mark

static NSString * kExifSampleImageFilename = @"Photosphere.jpg";
static NSString * kXmpSampleImageFilename  = @"Photosphere.jpg";
static NSString * kIptcSampleImageFilename = @"Station.jpg";

@interface Exiv2Tests : XCTestCase

@end

@implementation Exiv2Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExifKeys {
   NSURL *imageURL = [[[NSBundle bundleForClass:[self class]] resourceURL] URLByAppendingPathComponent:kExifSampleImageFilename];
   FLTImageMetadata *metadata = [[FLTImageMetadata alloc] initWithImageAtURL:imageURL];
   NSArray *keys = [metadata exifKeys];
   NSUInteger expectedCount = 28;
   XCTAssertEqual(expectedCount, [keys count], @"Pass");
}

- (void)testXmpKeys {
   NSURL *imageURL = [[[NSBundle bundleForClass:[self class]] resourceURL] URLByAppendingPathComponent:kXmpSampleImageFilename];
   FLTImageMetadata *metadata = [[FLTImageMetadata alloc] initWithImageAtURL:imageURL];
   NSArray *keys = [metadata xmpKeys];
   NSUInteger expectedCount = 15;
   XCTAssertEqual(expectedCount, [keys count], @"Pass");
}

- (void)testIptcKeys {
   NSURL *imageURL = [[[NSBundle bundleForClass:[self class]] resourceURL] URLByAppendingPathComponent:kIptcSampleImageFilename];
   FLTImageMetadata *metadata = [[FLTImageMetadata alloc] initWithImageAtURL:imageURL];
   NSArray *keys = [metadata iptcKeys];
   NSUInteger expectedCount = 18;
   XCTAssertEqual(expectedCount, [keys count], @"Pass");
}

#pragma mark

- (void)testvalueForMetadataKeyWhereReturnValueIsString {
   NSURL *imageURL = [[[NSBundle bundleForClass:[self class]] resourceURL] URLByAppendingPathComponent:kExifSampleImageFilename];
   FLTImageMetadata *metadata = [[FLTImageMetadata alloc] initWithImageAtURL:imageURL];
   NSString *make = [metadata valueForMetadataKey:@"Exif.Image.Make"];
   XCTAssertTrue([make isEqualToString:@"Apple"]);
}

- (void)testvalueForKeyMetadataTypeWhereReturnValueIsNumber {
   NSURL *imageURL = [[[NSBundle bundleForClass:[self class]] resourceURL] URLByAppendingPathComponent:kExifSampleImageFilename];
   FLTImageMetadata *metadata = [[FLTImageMetadata alloc] initWithImageAtURL:imageURL];
   NSNumber *tag = [metadata valueForMetadataKey:@"Exif.Image.ExifTag"];
   XCTAssertTrue([tag isEqual:@(148)]);
}

#pragma mark

- (void)testPrintExif {
   NSURL *imageURL = [[[NSBundle bundleForClass:[self class]] resourceURL] URLByAppendingPathComponent:kExifSampleImageFilename];
   FLTImageMetadata *metadata = [[FLTImageMetadata alloc] initWithImageAtURL:imageURL];
   [metadata printExif];
}

- (void)testPrintXmp {
   NSURL *imageURL = [[[NSBundle bundleForClass:[self class]] resourceURL] URLByAppendingPathComponent:kXmpSampleImageFilename];
   FLTImageMetadata *metadata = [[FLTImageMetadata alloc] initWithImageAtURL:imageURL];
   [metadata printXmp];
}

- (void)testPrintIpct {
   NSURL *imageURL = [[[NSBundle bundleForClass:[self class]] resourceURL] URLByAppendingPathComponent:kIptcSampleImageFilename];
   FLTImageMetadata *metadata = [[FLTImageMetadata alloc] initWithImageAtURL:imageURL];
   [metadata printIpct];
}

@end
