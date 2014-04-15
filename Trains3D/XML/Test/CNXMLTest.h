#import "objd.h"
#import "TSTestCase.h"
@class CNXML;
@class CNXMLElement;

@class CNXMLTest;

@interface CNXMLTest : TSTestCase
+ (instancetype)test;
- (instancetype)init;
- (ODClassType*)type;
- (void)testChild;
- (void)testAttributes;
+ (ODClassType*)type;
@end


