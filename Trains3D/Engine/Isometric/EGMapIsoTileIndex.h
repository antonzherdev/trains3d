#import "objd.h"
#import "EGTypes.h"

@class EGMapSsoTileIndex;

@interface EGMapSsoTileIndex : NSObject
@property (nonatomic, readonly) EGISize mapSize;

+ (id)mapSsoTileIndexWithMapSize:(EGISize)mapSize;
- (id)initWithMapSize:(EGISize)mapSize;
- (id)lookupWithDef:(id(^)())def forTile:(EGIPoint)forTile;
- (id)lookupForTile:(EGIPoint)forTile;
- (id)setObject:(id)object forTile:(EGIPoint)forTile;
- (NSArray*)values;
- (void)clear;
@end


