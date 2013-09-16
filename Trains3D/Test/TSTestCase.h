#import "objd.h"
#import <SenTestingKit/SenTestingKit.h>

@class TSTestCase;

@interface TSTestCase : SenTestCase
+ (id)testCase;
- (id)init;
- (void)assertEqualsA:(id)a b:(id)b;
- (void)assertTrueValue:(BOOL)value;
@end


