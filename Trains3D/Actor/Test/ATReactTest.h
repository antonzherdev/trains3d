#import "objd.h"
#import "TSTestCase.h"
@class ATVar;
@class ATReact;

@class ATReactTest;

@interface ATReactTest : TSTestCase
+ (instancetype)reactTest;
- (instancetype)init;
- (ODClassType*)type;
- (void)testMap;
+ (ODClassType*)type;
@end


