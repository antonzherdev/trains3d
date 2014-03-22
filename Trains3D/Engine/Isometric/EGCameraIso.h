#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
#import "EGMapIso.h"
#import "EGInput.h"
@class GEMat4;
@class EGMatrixModel;
@class EGImMatrixModel;
@class ATSignal;
@class ATVar;
@class ATObserver;
@class EGDirector;
@class ATReact;

@class EGCameraIso;
@class EGCameraIsoMove;

@interface EGCameraIso : NSObject<EGCamera> {
@private
    GEVec2 _tilesOnScreen;
    EGCameraReserve _reserve;
    CGFloat _viewportRatio;
    GEVec2 _center;
    CGFloat _ww;
    EGMatrixModel* _matrixModel;
}
@property (nonatomic, readonly) GEVec2 tilesOnScreen;
@property (nonatomic, readonly) EGCameraReserve reserve;
@property (nonatomic, readonly) CGFloat viewportRatio;
@property (nonatomic, readonly) GEVec2 center;
@property (nonatomic, readonly) EGMatrixModel* matrixModel;

+ (instancetype)cameraIsoWithTilesOnScreen:(GEVec2)tilesOnScreen reserve:(EGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio center:(GEVec2)center;
- (instancetype)initWithTilesOnScreen:(GEVec2)tilesOnScreen reserve:(EGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio center:(GEVec2)center;
- (ODClassType*)type;
+ (EGCameraIso*)applyTilesOnScreen:(GEVec2)tilesOnScreen reserve:(EGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio;
- (NSUInteger)cullFace;
- (GEVec2)naturalCenter;
+ (GEMat4*)m;
+ (GEMat4*)w;
+ (ODClassType*)type;
@end


@interface EGCameraIsoMove : NSObject<EGInputProcessor> {
@private
    EGCameraIso* _base;
    CGFloat _misScale;
    CGFloat _maxScale;
    NSUInteger _panFingers;
    NSUInteger _tapFingers;
    EGCameraIso* __currentBase;
    EGCameraIso* __camera;
    ATSignal* _changed;
    ATVar* _scale;
    ATObserver* _scaleObs;
    ATVar* _center;
    ATObserver* _centerObs;
    GEVec2 __startPan;
    CGFloat __startScale;
    GEVec2 __pinchLocation;
    GEVec2 __startCenter;
    BOOL _panEnabled;
    BOOL _tapEnabled;
    BOOL _pinchEnabled;
}
@property (nonatomic, readonly) EGCameraIso* base;
@property (nonatomic, readonly) CGFloat misScale;
@property (nonatomic, readonly) CGFloat maxScale;
@property (nonatomic, readonly) NSUInteger panFingers;
@property (nonatomic, readonly) NSUInteger tapFingers;
@property (nonatomic, readonly) ATSignal* changed;
@property (nonatomic, readonly) ATVar* scale;
@property (nonatomic, readonly) ATVar* center;
@property (nonatomic) BOOL panEnabled;
@property (nonatomic) BOOL tapEnabled;
@property (nonatomic) BOOL pinchEnabled;

+ (instancetype)cameraIsoMoveWithBase:(EGCameraIso*)base misScale:(CGFloat)misScale maxScale:(CGFloat)maxScale panFingers:(NSUInteger)panFingers tapFingers:(NSUInteger)tapFingers;
- (instancetype)initWithBase:(EGCameraIso*)base misScale:(CGFloat)misScale maxScale:(CGFloat)maxScale panFingers:(NSUInteger)panFingers tapFingers:(NSUInteger)tapFingers;
- (ODClassType*)type;
- (EGCameraIso*)camera;
- (CGFloat)viewportRatio;
- (void)setViewportRatio:(CGFloat)viewportRatio;
- (EGCameraReserve)reserve;
- (void)setReserve:(EGCameraReserve)reserve;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


