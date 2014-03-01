#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
@class EGMapSso;

@class EGMapSsoTest;

@interface EGMapSsoTest : TSTestCase
+ (instancetype)mapSsoTest;
- (instancetype)init;
- (ODClassType*)type;
- (void)testFullPartialTile;
- (void)testFullTiles;
- (void)testPartialTiles;
+ (ODClassType*)type;
@end


