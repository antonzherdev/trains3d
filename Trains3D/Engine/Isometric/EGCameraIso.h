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
@property (nonatomic, readonly) float yReserve;
@property (nonatomic, readonly) CGFloat viewportRatio;
@property (nonatomic, readonly) GEVec2 center;
@property (nonatomic, readonly) EGMatrixModel* matrixModel;

+ (id)cameraIsoWithTilesOnScreen:(GEVec2)tilesOnScreen yReserve:(float)yReserve viewportRatio:(CGFloat)viewportRatio center:(GEVec2)center;
- (id)initWithTilesOnScreen:(GEVec2)tilesOnScreen yReserve:(float)yReserve viewportRatio:(CGFloat)viewportRatio center:(GEVec2)center;
- (ODClassType*)type;
+ (EGCameraIso*)applyTilesOnScreen:(GEVec2)tilesOnScreen yReserve:(float)yReserve viewportRatio:(CGFloat)viewportRatio;
- (NSUInteger)cullFace;
- (GEVec2)naturalCenter;
+ (GEMat4*)m;
+ (GEMat4*)w;
+ (ODClassType*)type;
@end


@interface EGCameraIsoMove : NSObject<EGInputProcessor>
@property (nonatomic, readonly) EGCameraIso* base;
@property (nonatomic, readonly) CGFloat misScale;
@property (nonatomic, readonly) CGFloat maxScale;
@property (nonatomic, readonly) CGFloat panFingers;

+ (id)cameraIsoMoveWithBase:(EGCameraIso*)base misScale:(CGFloat)misScale maxScale:(CGFloat)maxScale panFingers:(CGFloat)panFingers;
- (id)initWithBase:(EGCameraIso*)base misScale:(CGFloat)misScale maxScale:(CGFloat)maxScale panFingers:(CGFloat)panFingers;
- (ODClassType*)type;
- (EGCameraIso*)camera;
- (CGFloat)scale;
- (void)setScale:(CGFloat)scale;
- (GEVec2)center;
- (void)setCenter:(GEVec2)center;
- (CGFloat)viewportRatio;
- (void)setViewportRatio:(CGFloat)viewportRatio;
- (CGFloat)yReserve;
- (void)setYReserve:(CGFloat)yReserve;
- (EGRecognizers*)recognizers;
- (GEQuad)centerBounds;
+ (CNNotificationHandle*)cameraChangedNotification;
+ (ODClassType*)type;
@end


