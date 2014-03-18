#import "objd.h"
#import "TSTestCase.h"
@class ATVar;
@class ATReact;
@class ATReactFlag;

@class ATReactTest;

@interface ATReactTest : TSTestCase
+ (instancetype)reactTest;
- (instancetype)init;
- (ODClassType*)type;
- (void)testMap;
- (void)testReactFlag;
+ (ODClassType*)type;
@end


