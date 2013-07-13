#import "objd.h"
#import "EGTypes.h"

@class EGMapSsoTileIndex;

@interface EGMapSsoTileIndex : NSObject
@property (nonatomic, readonly) EGSizeI mapSize;

+ (id)mapSsoTileIndexWithMapSize:(EGSizeI)mapSize;
- (id)initWithMapSize:(EGSizeI)mapSize;
- (id)lookupWithDef:(id(^)())def forTile:(EGPointI)forTile;
- (id)lookupForTile:(EGPointI)forTile;
- (id)setObject:(id)object forTile:(EGPointI)forTile;
- (NSArray*)values;
- (void)clear;
@end


