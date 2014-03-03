#import "objd.h"
#import <XCTest/XCTest.h>

@class TSTestCase;

@interface TSTestCase : XCTestCase
+ (id)testCase;
- (id)init;

- (void)repeatTimes:(int)n f:(void (^)())f;
@end

#define assertEquals(a, b) XCTAssertEqualObjects(a, b, @"");
#define assertTrue(t) XCTAssertTrue(t, @"");
#define assertFalse(t) XCTAssertFalse(t, @"");


