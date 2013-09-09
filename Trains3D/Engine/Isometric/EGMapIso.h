#import "objd.h"
#import "EGVec.h"
#import "EGTypes.h"
@class EGMesh;
@class EGMaterial;

@class EGMapSso;
@class EGMapSsoView;

@interface EGMapSso : NSObject
@property (nonatomic, readonly) EGVec2I size;
@property (nonatomic, readonly) EGRectI limits;
@property (nonatomic, readonly) id<CNSeq> fullTiles;
@property (nonatomic, readonly) id<CNSeq> partialTiles;
@property (nonatomic, readonly) id<CNSeq> allTiles;

+ (id)mapSsoWithSize:(EGVec2I)size;
- (id)initWithSize:(EGVec2I)size;
- (ODClassType*)type;
- (BOOL)isFullTile:(EGVec2I)tile;
- (BOOL)isPartialTile:(EGVec2I)tile;
- (EGRectI)cutRectForTile:(EGVec2I)tile;
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


