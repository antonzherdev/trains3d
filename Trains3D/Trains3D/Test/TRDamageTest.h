#import "objd.h"
#import "TSTestCase.h"
#import "PGVec.h"
#import "TRRailPoint.h"
#import "TRRailroad.h"
@class TRLevelFactory;
@class CNFuture;

@class TRDamageTest;

@interface TRDamageTest : TSTestCase
+ (instancetype)damageTest;
- (instancetype)init;
- (CNClassType*)type;
- (void)testMain;
- (NSString*)description;
+ (CNClassType*)type;
@end


