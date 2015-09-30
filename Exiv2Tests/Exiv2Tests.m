
// Created by Sinisa Drpa on 9/30/15.

#import <XCTest/XCTest.h>
#import <Exiv2/Exiv2.h>

@interface FLTImageMetadata ()
- (void)printExif;
- (void)printXmp;
@end

#pragma mark

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
   NSURL *imageURL = [[[NSBundle bundleForClass:[self class]] resourceURL] URLByAppendingPathComponent:@"Photosphere.jpg"];
   FLTImageMetadata *metadata = [[FLTImageMetadata alloc] initWithImageAtURL:imageURL];
   NSArray *exifKeys = [metadata exifKeys];
   NSUInteger expectedCount = 28;
   XCTAssertEqual(expectedCount, [exifKeys count], @"Pass");
}

- (void)testXmpKeys {
   NSURL *imageURL = [[[NSBundle bundleForClass:[self class]] resourceURL] URLByAppendingPathComponent:@"Photosphere.jpg"];
   FLTImageMetadata *metadata = [[FLTImageMetadata alloc] initWithImageAtURL:imageURL];
   NSArray *xmpKeys = [metadata xmpKeys];
   NSUInteger expectedCount = 15;
   XCTAssertEqual(expectedCount, [xmpKeys count], @"Pass");
}

- (void)testPrintExif {
   //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Photosphere" ofType:@"jpg"];
   NSURL *imageURL = [[[NSBundle bundleForClass:[self class]] resourceURL] URLByAppendingPathComponent:@"Photosphere.jpg"];
   FLTImageMetadata *metadata = [[FLTImageMetadata alloc] initWithImageAtURL:imageURL];
   [metadata printExif];
}

- (void)testPrintXmp {
   //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Photosphere" ofType:@"jpg"];
   NSURL *imageURL = [[[NSBundle bundleForClass:[self class]] resourceURL] URLByAppendingPathComponent:@"Photosphere.jpg"];
   FLTImageMetadata *metadata = [[FLTImageMetadata alloc] initWithImageAtURL:imageURL];
   [metadata printXmp];
}

@end
