#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
#import "EGMapIso.h"
#import "EGInput.h"
@class GEMat4;
@class EGMatrixModel;
@class EGImMatrixModel;
@class CNSignal;
@class CNVar;
@class CNObserver;

@class EGCameraIso;
@class EGCameraIsoMove;

@interface EGCameraIso : EGCamera_impl {
@protected
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
- (CNClassType*)type;
+ (EGCameraIso*)applyTilesOnScreen:(GEVec2)tilesOnScreen reserve:(EGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio;
- (NSUInteger)cullFace;
- (GEVec2)naturalCenter;
- (NSString*)description;
+ (GEMat4*)m;
+ (GEMat4*)w;
+ (CNClassType*)type;
@end


@interface EGCameraIsoMove : EGInputProcessor_impl {
@protected
    EGCameraIso* _base;
    CGFloat _minScale;
    CGFloat _maxScale;
    NSUInteger _panFingers;
    NSUInteger _tapFingers;
    EGCameraIso* __currentBase;
    EGCameraIso* __camera;
    CNSignal* _changed;
    CNVar* _scale;
    CNObserver* _scaleObs;
    CNVar* _center;
    CNObserver* _centerObs;
    GEVec2 __startPan;
    CGFloat __startScale;
    GEVec2 __pinchLocation;
    GEVec2 __startCenter;
    BOOL _panEnabled;
    BOOL _tapEnabled;
    BOOL _pinchEnabled;
}
@property (nonatomic, readonly) EGCameraIso* base;
@property (nonatomic, readonly) CGFloat minScale;
@property (nonatomic, readonly) CGFloat maxScale;
@property (nonatomic, readonly) NSUInteger panFingers;
@property (nonatomic, readonly) NSUInteger tapFingers;
@property (nonatomic, readonly) CNSignal* changed;
@property (nonatomic, readonly) CNVar* scale;
@property (nonatomic, readonly) CNVar* center;
@property (nonatomic) BOOL panEnabled;
@property (nonatomic) BOOL tapEnabled;
@property (nonatomic) BOOL pinchEnabled;

+ (instancetype)cameraIsoMoveWithBase:(EGCameraIso*)base minScale:(CGFloat)minScale maxScale:(CGFloat)maxScale panFingers:(NSUInteger)panFingers tapFingers:(NSUInteger)tapFingers;
- (instancetype)initWithBase:(EGCameraIso*)base minScale:(CGFloat)minScale maxScale:(CGFloat)maxScale panFingers:(NSUInteger)panFingers tapFingers:(NSUInteger)tapFingers;
- (CNClassType*)type;
- (EGCameraIso*)camera;
- (CGFloat)viewportRatio;
- (void)setViewportRatio:(CGFloat)viewportRatio;
- (EGCameraReserve)reserve;
- (void)setReserve:(EGCameraReserve)reserve;
- (EGRecognizers*)recognizers;
- (NSString*)description;
+ (CNClassType*)type;
@end


