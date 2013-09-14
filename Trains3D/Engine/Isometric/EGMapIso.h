#import "objd.h"
#import "GEVec.h"
#import "GERect.h"
@class EGMesh;
@class EGMaterial;

@class EGMapSso;
@class EGMapSsoView;

@interface EGMapSso : NSObject
@property (nonatomic, readonly) GEVec2I size;
@property (nonatomic, readonly) GERectI limits;
@property (nonatomic, readonly) id<CNSeq> fullTiles;
@property (nonatomic, readonly) id<CNSeq> partialTiles;
@property (nonatomic, readonly) id<CNSeq> allTiles;

+ (id)mapSsoWithSize:(GEVec2I)size;
- (id)initWithSize:(GEVec2I)size;
- (ODClassType*)type;
- (BOOL)isFullTile:(GEVec2I)tile;
- (BOOL)isPartialTile:(GEVec2I)tile;
- (GERectI)cutRectForTile:(GEVec2I)tile;
+ (CGFloat)ISO;
+ (ODClassType*)type;
@end


@interface EGMapSsoView : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) EGMesh* plane;

+ (id)mapSsoViewWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (ODClassType*)type;
- (void)drawLayout;
- (EGMesh*)createPlane;
- (void)drawPlaneWithMaterial:(EGMaterial*)material;
+ (ODClassType*)type;
@end


