#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
#import "EGInput.h"
@class EGMapSso;
@class GEMat4;
@class EGMatrixModel;
@class EGDirector;

@class EGCameraIso;
@class EGCameraIsoMove;

@interface EGCameraIso : NSObject<EGCamera>
@property (nonatomic, readonly) GEVec2 tilesOnScreen;
@property (nonatomic, readonly) float zReserve;
@property (nonatomic, readonly) GEVec2 center;
@property (nonatomic, readonly) CGFloat viewportRatio;
@property (nonatomic, readonly) EGMatrixModel* matrixModel;

+ (id)cameraIsoWithTilesOnScreen:(GEVec2)tilesOnScreen zReserve:(float)zReserve center:(GEVec2)center;
- (id)initWithTilesOnScreen:(GEVec2)tilesOnScreen zReserve:(float)zReserve center:(GEVec2)center;
- (ODClassType*)type;
- (NSUInteger)cullFace;
+ (GEMat4*)m;
+ (GEMat4*)w;
+ (ODClassType*)type;
@end


@interface EGCameraIsoMove : NSObject<EGInputProcessor>
@property (nonatomic, readonly) EGCameraIso* base;
@property (nonatomic, readonly) CGFloat misScale;
@property (nonatomic, readonly) CGFloat maxScale;

+ (id)cameraIsoMoveWithBase:(EGCameraIso*)base misScale:(CGFloat)misScale maxScale:(CGFloat)maxScale;
- (id)initWithBase:(EGCameraIso*)base misScale:(CGFloat)misScale maxScale:(CGFloat)maxScale;
- (ODClassType*)type;
- (EGCameraIso*)camera;
- (void)setScale:(CGFloat)scale;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


