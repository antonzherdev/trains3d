#import "objd.h"
#import "TSTestCase.h"
@class CNXML;
@class CNXMLElement;

@class CNXMLTest;

@interface CNXMLTest : TSTestCase
+ (instancetype)test;
- (instancetype)init;
- (CNClassType*)type;
- (void)testChild;
- (void)testAttributes;
+ (CNClassType*)type;
@end


