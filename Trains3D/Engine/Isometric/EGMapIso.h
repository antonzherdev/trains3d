#import "objd.h"
#import "GEVec.h"
#import "GERect.h"
#import "EGMesh.h"
@class EGMaterial;

@class EGMapSso;
@class EGMapSsoView;

@interface EGMapSso : NSObject
@property (nonatomic, readonly) GEVec2i size;
@property (nonatomic, readonly) GERectI limits;
@property (nonatomic, readonly) id<CNSeq> fullTiles;
@property (nonatomic, readonly) id<CNSeq> partialTiles;
@property (nonatomic, readonly) id<CNSeq> allTiles;

+ (id)mapSsoWithSize:(GEVec2i)size;
- (id)initWithSize:(GEVec2i)size;
- (ODClassType*)type;
- (BOOL)isFullTile:(GEVec2i)tile;
- (BOOL)isPartialTile:(GEVec2i)tile;
- (GERectI)cutRectForTile:(GEVec2i)tile;
+ (CGFloat)ISO;
+ (ODType*)type;
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
+ (ODType*)type;
@end


