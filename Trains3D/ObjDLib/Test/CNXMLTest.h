#import "objdcore.h"
#import "TSTestCase.h"
@class CNXML;
@class CNXMLElement;
@protocol CNIterable;
@class ODClassType;

@class CNXMLTest;

@interface CNXMLTest : TSTestCase
+ (instancetype)test;
- (instancetype)init;
- (ODClassType*)type;
- (void)testChild;
- (void)testAttributes;
+ (ODClassType*)type;
@end


