#import "objd.h"
#import <SenTestingKit/SenTestingKit.h>

@class CNTestCase;

@interface CNTestCase : SenTestCase
+ (id)testCase;
- (id)init;
- (void)assertEqualsA:(id)a b:(id)b;
- (void)assertTrueValue:(BOOL)value;
@end


