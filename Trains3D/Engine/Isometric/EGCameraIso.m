#import "EGCameraIso.h"

#import "GEMat4.h"
#import "EGMatrixModel.h"
#import "math.h"
#import "GL.h"
#import "CNObserver.h"
#import "CNReact.h"
@implementation EGCameraIso
static CGFloat _EGCameraIso_ISO;
static GEMat4* _EGCameraIso_m;
static GEMat4* _EGCameraIso_w;
static CNClassType* _EGCameraIso_type;
@synthesize tilesOnScreen = _tilesOnScreen;
@synthesize reserve = _reserve;
@synthesize viewportRatio = _viewportRatio;
@synthesize center = _center;
@synthesize matrixModel = _matrixModel;

+ (instancetype)cameraIsoWithTilesOnScreen:(GEVec2)tilesOnScreen reserve:(EGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio center:(GEVec2)center {
    return [[EGCameraIso alloc] initWithTilesOnScreen:tilesOnScreen reserve:reserve viewportRatio:viewportRatio center:center];
}

- (instancetype)initWithTilesOnScreen:(GEVec2)tilesOnScreen reserve:(EGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio center:(GEVec2)center {
    self = [super init];
    if(self) {
        _tilesOnScreen = tilesOnScreen;
        _reserve = reserve;
        _viewportRatio = viewportRatio;
        _center = center;
        _ww = ((CGFloat)(tilesOnScreen.x + tilesOnScreen.y));
        _matrixModel = ({
            CGFloat isoWW = _ww * _EGCameraIso_ISO;
            CGFloat isoWW2 = isoWW / 2;
            CGFloat as = (isoWW - viewportRatio * egCameraReserveHeight(reserve) + egCameraReserveWidth(reserve)) / (isoWW * viewportRatio);
            CGFloat angleSin = ((as > 1.0) ? 1.0 : as);
            [EGImMatrixModel imMatrixModelWithM:_EGCameraIso_m w:_EGCameraIso_w c:({
                CGFloat ang = (asin(angleSin) * 180) / M_PI;
                GEMat4* t = [[GEMat4 identity] translateX:-center.x y:0.0 z:center.y];
                GEMat4* r = [[[GEMat4 identity] rotateAngle:((float)(ang)) x:1.0 y:0.0 z:0.0] rotateAngle:-45.0 x:0.0 y:1.0 z:0.0];
                [r mulMatrix:t];
            }) p:[GEMat4 orthoLeft:((float)(-isoWW2 - reserve.left)) right:((float)(isoWW2 + reserve.right)) bottom:((float)(-isoWW2 * angleSin - reserve.bottom)) top:((float)(isoWW2 * angleSin + reserve.top)) zNear:-1000.0 zFar:1000.0]];
        });
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCameraIso class]) {
        _EGCameraIso_type = [CNClassType classTypeWithCls:[EGCameraIso class]];
        _EGCameraIso_ISO = EGMapSso.ISO;
        _EGCameraIso_m = [[GEMat4 identity] rotateAngle:90.0 x:1.0 y:0.0 z:0.0];
        _EGCameraIso_w = [[GEMat4 identity] rotateAngle:-90.0 x:1.0 y:0.0 z:0.0];
    }
}

+ (EGCameraIso*)applyTilesOnScreen:(GEVec2)tilesOnScreen reserve:(EGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio {
    return [EGCameraIso cameraIsoWithTilesOnScreen:tilesOnScreen reserve:reserve viewportRatio:viewportRatio center:geVec2DivF((geVec2SubVec2(tilesOnScreen, (GEVec2Make(1.0, 1.0)))), 2.0)];
}

- (NSUInteger)cullFace {
    return ((NSUInteger)(GL_FRONT));
}

- (GEVec2)naturalCenter {
    return geVec2DivF((geVec2SubVec2(_tilesOnScreen, (GEVec2Make(1.0, 1.0)))), 2.0);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CameraIso(%@, %@, %f, %@)", geVec2Description(_tilesOnScreen), egCameraReserveDescription(_reserve), _viewportRatio, geVec2Description(_center)];
}

- (CNClassType*)type {
    return [EGCameraIso type];
}

+ (GEMat4*)m {
    return _EGCameraIso_m;
}

+ (GEMat4*)w {
    return _EGCameraIso_w;
}

+ (CNClassType*)type {
    return _EGCameraIso_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGCameraIsoMove
static CNClassType* _EGCameraIsoMove_type;
@synthesize base = _base;
@synthesize minScale = _minScale;
@synthesize maxScale = _maxScale;
@synthesize panFingers = _panFingers;
@synthesize tapFingers = _tapFingers;
@synthesize changed = _changed;
@synthesize scale = _scale;
@synthesize center = _center;
@synthesize panEnabled = _panEnabled;
@synthesize tapEnabled = _tapEnabled;
@synthesize pinchEnabled = _pinchEnabled;

+ (instancetype)cameraIsoMoveWithBase:(EGCameraIso*)base minScale:(CGFloat)minScale maxScale:(CGFloat)maxScale panFingers:(NSUInteger)panFingers tapFingers:(NSUInteger)tapFingers {
    return [[EGCameraIsoMove alloc] initWithBase:base minScale:minScale maxScale:maxScale panFingers:panFingers tapFingers:tapFingers];
}

- (instancetype)initWithBase:(EGCameraIso*)base minScale:(CGFloat)minScale maxScale:(CGFloat)maxScale panFingers:(NSUInteger)panFingers tapFingers:(NSUInteger)tapFingers {
    self = [super init];
    __weak EGCameraIsoMove* _weakSelf = self;
    if(self) {
        _base = base;
        _minScale = minScale;
        _maxScale = maxScale;
        _panFingers = panFingers;
        _tapFingers = tapFingers;
        __currentBase = base;
        __camera = base;
        _changed = [CNSignal signal];
        _scale = [CNVar limitedInitial:@1.0 limits:^id(id s) {
            return numf((floatClampMinMax(unumf(s), minScale, maxScale)));
        }];
        _scaleObs = [_scale observeF:^void(id s) {
            EGCameraIsoMove* _self = _weakSelf;
            if(_self != nil) {
                _self->__camera = [EGCameraIso cameraIsoWithTilesOnScreen:geVec2DivF4(_self->__currentBase.tilesOnScreen, ((float)(unumf(s)))) reserve:egCameraReserveDivF4(_self->__currentBase.reserve, ((float)(unumf(s)))) viewportRatio:_self->__currentBase.viewportRatio center:_self->__camera.center];
                [_self->_changed post];
            }
        }];
        _center = [CNVar limitedInitial:wrap(GEVec2, __camera.center) limits:^id(id cen) {
            EGCameraIsoMove* _self = _weakSelf;
            if(_self != nil) {
                if(unumf([_self->_scale value]) <= 1) {
                    return wrap(GEVec2, [_self->__currentBase naturalCenter]);
                } else {
                    GEVec2 centerP = geVec4Xy(([[_self->__currentBase.matrixModel wcp] mulVec4:geVec4ApplyVec2ZW((uwrap(GEVec2, cen)), 0.0, 1.0)]));
                    GEVec2 cp = geRectClosestPointForVec2([_self centerBounds], centerP);
                    if(geVec2IsEqualTo(cp, centerP)) {
                        return cen;
                    } else {
                        GEMat4* mat4 = [[_self->__currentBase.matrixModel wcp] inverse];
                        GEVec4 p0 = [mat4 mulVec4:GEVec4Make(cp.x, cp.y, -1.0, 1.0)];
                        GEVec4 p1 = [mat4 mulVec4:GEVec4Make(cp.x, cp.y, 1.0, 1.0)];
                        GELine3 line = GELine3Make(geVec4Xyz(p0), (geVec3SubVec3(geVec4Xyz(p1), geVec4Xyz(p0))));
                        return wrap(GEVec2, (geVec3Xy((geLine3RPlane(line, (GEPlaneMake((GEVec3Make(0.0, 0.0, 0.0)), (GEVec3Make(0.0, 0.0, 1.0)))))))));
                    }
                }
            } else {
                return nil;
            }
        }];
        _centerObs = [_center observeF:^void(id cen) {
            EGCameraIsoMove* _self = _weakSelf;
            if(_self != nil) {
                _self->__camera = [EGCameraIso cameraIsoWithTilesOnScreen:[_self camera].tilesOnScreen reserve:[_self camera].reserve viewportRatio:[_self camera].viewportRatio center:uwrap(GEVec2, cen)];
                [_self->_changed post];
            }
        }];
        __startPan = GEVec2Make(-1.0, -1.0);
        __startScale = 1.0;
        __pinchLocation = GEVec2Make(-1.0, -1.0);
        __startCenter = GEVec2Make(-1.0, -1.0);
        _panEnabled = YES;
        _tapEnabled = YES;
        _pinchEnabled = YES;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCameraIsoMove class]) _EGCameraIsoMove_type = [CNClassType classTypeWithCls:[EGCameraIsoMove class]];
}

- (EGCameraIso*)camera {
    return __camera;
}

- (CGFloat)viewportRatio {
    return __currentBase.viewportRatio;
}

- (void)setViewportRatio:(CGFloat)viewportRatio {
    __currentBase = [EGCameraIso cameraIsoWithTilesOnScreen:__currentBase.tilesOnScreen reserve:__currentBase.reserve viewportRatio:viewportRatio center:__currentBase.center];
    __camera = [EGCameraIso cameraIsoWithTilesOnScreen:__camera.tilesOnScreen reserve:__camera.reserve viewportRatio:viewportRatio center:__camera.center];
}

- (EGCameraReserve)reserve {
    return __currentBase.reserve;
}

- (void)setReserve:(EGCameraReserve)reserve {
    __currentBase = [EGCameraIso cameraIsoWithTilesOnScreen:__currentBase.tilesOnScreen reserve:reserve viewportRatio:__currentBase.viewportRatio center:__currentBase.center];
    __camera = [EGCameraIso cameraIsoWithTilesOnScreen:__camera.tilesOnScreen reserve:reserve viewportRatio:__camera.viewportRatio center:__camera.center];
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers recognizersWithItems:(@[((EGRecognizer*)([EGRecognizer applyTp:[EGPinch pinch] began:^BOOL(id<EGEvent> event) {
    if(_pinchEnabled) {
        __startScale = unumf([_scale value]);
        __pinchLocation = [event location];
        __startCenter = __camera.center;
        return YES;
    } else {
        return NO;
    }
} changed:^void(id<EGEvent> event) {
    CGFloat s = ((EGPinchParameter*)([event param])).scale;
    [_scale setValue:numf(__startScale * s)];
    [_center setValue:wrap(GEVec2, (((s <= 1.0) ? __startCenter : ((s < 2.0) ? geVec2AddVec2(__startCenter, (geVec2MulF((geVec2SubVec2(__pinchLocation, __startCenter)), s - 1.0))) : __pinchLocation))))];
} ended:^void(id<EGEvent> event) {
}])), ((EGRecognizer*)([EGRecognizer applyTp:[EGPan panWithFingers:_panFingers] began:^BOOL(id<EGEvent> event) {
    __startPan = [event location];
    return _panEnabled && unumf([_scale value]) > 1.0;
} changed:^void(id<EGEvent> event) {
    [_center setValue:wrap(GEVec2, (geVec2SubVec2((geVec2AddVec2(__camera.center, __startPan)), [event location])))];
} ended:^void(id<EGEvent> event) {
}])), ((EGRecognizer*)([EGRecognizer applyTp:[EGTap tapWithFingers:_tapFingers taps:2] on:^BOOL(id<EGEvent> event) {
    if(_tapEnabled) {
        if(!(eqf(unumf([_scale value]), _maxScale))) {
            GEVec2 loc = [event location];
            [_scale setValue:numf(_maxScale)];
            [_center setValue:wrap(GEVec2, loc)];
        } else {
            [_scale setValue:@1.0];
            [_center setValue:wrap(GEVec2, [__currentBase naturalCenter])];
        }
        return YES;
    } else {
        return NO;
    }
}]))])];
}

- (GERect)centerBounds {
    GEVec2 sizeP = geVec2ApplyF(2.0 - 2.0 / unumf([_scale value]));
    return GERectMake((geVec2DivF(sizeP, -2.0)), sizeP);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CameraIsoMove(%@, %f, %f, %lu, %lu)", _base, _minScale, _maxScale, (unsigned long)_panFingers, (unsigned long)_tapFingers];
}

- (CNClassType*)type {
    return [EGCameraIsoMove type];
}

+ (CNClassType*)type {
    return _EGCameraIsoMove_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

