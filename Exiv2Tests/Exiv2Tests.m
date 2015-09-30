//
//  Exiv2Tests.m
//  Exiv2Tests
//
//  Created by Sinisa Drpa on 9/30/15.
//  Copyright © 2015 Tagtaxa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Exiv2/Exiv2.h>

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

- (void)testPrintEXIF {
   //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Photosphere" ofType:@"jpg"];
   NSURL *imageURL = [[[NSBundle bundleForClass:[self class]] resourceURL] URLByAppendingPathComponent:@"Photosphere.jpg"];
   FLTImageMetadata *metadata = [[FLTImageMetadata alloc] initWithImageAtURL:imageURL];
   [metadata printEXIF];
}

@end
