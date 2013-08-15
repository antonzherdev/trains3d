#import "objd.h"
#import "EGTypes.h"
@class EGMapSso;
@protocol CNIterator;
@protocol CNBuilder;
@protocol CNTraversable;
@protocol CNIterable;

@class EGMapSsoTileIndex;

@interface EGMapSsoTileIndex : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) id(^initial)();

+ (id)mapSsoTileIndexWithMap:(EGMapSso*)map initial:(id(^)())initial;
- (id)initWithMap:(EGMapSso*)map initial:(id(^)())initial;
- (id)objectForTile:(EGPointI)tile;
- (id<CNIterable>)values;
@end


