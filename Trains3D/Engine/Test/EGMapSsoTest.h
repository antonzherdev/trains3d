#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
@class EGMapSso;
@class CNChain;

@class EGMapSsoTest;

@interface EGMapSsoTest : TSTestCase
+ (instancetype)mapSsoTest;
- (instancetype)init;
- (CNClassType*)type;
- (void)testFullPartialTile;
- (void)testFullTiles;
- (void)testPartialTiles;
- (NSString*)description;
+ (CNClassType*)type;
@end


