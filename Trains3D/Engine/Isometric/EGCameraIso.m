#import "EGCameraIso.h"

#import "GEMat4.h"
#import "EGMatrixModel.h"
#import "GL.h"
#import "ATObserver.h"
#import "ATReact.h"
#import "EGDirector.h"
@implementation EGCameraIso
static CGFloat _EGCameraIso_ISO;
static GEMat4* _EGCameraIso_m;
static GEMat4* _EGCameraIso_w;
static ODClassType* _EGCameraIso_type;
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
        _ww = ((CGFloat)(_tilesOnScreen.x + _tilesOnScreen.y));
        _matrixModel = ^EGImMatrixModel*() {
            CGFloat isoWW = _ww * _EGCameraIso_ISO;
            CGFloat isoWW2 = isoWW / 2;
            CGFloat as = (isoWW - _viewportRatio * egCameraReserveHeight(_reserve) + egCameraReserveWidth(_reserve)) / (isoWW * _viewportRatio);
            CGFloat angleSin = ((as > 1.0) ? 1.0 : as);
            return [EGImMatrixModel imMatrixModelWithM:_EGCameraIso_m w:_EGCameraIso_w c:^GEMat4*() {
                CGFloat ang = (asin(angleSin) * 180) / M_PI;
                GEMat4* t = [[GEMat4 identity] translateX:-_center.x y:0.0 z:_center.y];
                GEMat4* r = [[[GEMat4 identity] rotateAngle:((float)(ang)) x:1.0 y:0.0 z:0.0] rotateAngle:-45.0 x:0.0 y:1.0 z:0.0];
                return [r mulMatrix:t];
            }() p:[GEMat4 orthoLeft:((float)(-isoWW2 - _reserve.left)) right:((float)(isoWW2 + _reserve.right)) bottom:((float)(-isoWW2 * angleSin - _reserve.bottom)) top:((float)(isoWW2 * angleSin + _reserve.top)) zNear:-1000.0 zFar:1000.0]];
        }();
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCameraIso class]) {
        _EGCameraIso_type = [ODClassType classTypeWithCls:[EGCameraIso class]];
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

- (ODClassType*)type {
    return [EGCameraIso type];
}

+ (GEMat4*)m {
    return _EGCameraIso_m;
}

+ (GEMat4*)w {
    return _EGCameraIso_w;
}

+ (ODClassType*)type {
    return _EGCameraIso_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCameraIso* o = ((EGCameraIso*)(other));
    return GEVec2Eq(self.tilesOnScreen, o.tilesOnScreen) && EGCameraReserveEq(self.reserve, o.reserve) && eqf(self.viewportRatio, o.viewportRatio) && GEVec2Eq(self.center, o.center);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.tilesOnScreen);
    hash = hash * 31 + EGCameraReserveHash(self.reserve);
    hash = hash * 31 + floatHash(self.viewportRatio);
    hash = hash * 31 + GEVec2Hash(self.center);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tilesOnScreen=%@", GEVec2Description(self.tilesOnScreen)];
    [description appendFormat:@", reserve=%@", EGCameraReserveDescription(self.reserve)];
    [description appendFormat:@", viewportRatio=%f", self.viewportRatio];
    [description appendFormat:@", center=%@", GEVec2Description(self.center)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCameraIsoMove
static ODClassType* _EGCameraIsoMove_type;
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
        __currentBase = _base;
        __camera = _base;
        _changed = [ATSignal signal];
        _scale = [ATVar applyInitial:@1.0 limits:^id(id s) {
            EGCameraIsoMove* _self = _weakSelf;
            return numf((floatClampMinMax(unumf(s), _self->_minScale, _self->_maxScale)));
        }];
        _scaleObs = [_scale observeF:^void(id s) {
            EGCameraIsoMove* _self = _weakSelf;
            _self->__camera = [EGCameraIso cameraIsoWithTilesOnScreen:geVec2DivF(_self->__currentBase.tilesOnScreen, unumf(s)) reserve:egCameraReserveDivF4(_self->__currentBase.reserve, ((float)(unumf(s)))) viewportRatio:_self->__currentBase.viewportRatio center:_self->__camera.center];
            [_self->_changed post];
        }];
        _center = [ATVar applyInitial:wrap(GEVec2, __camera.center) limits:^id(id cen) {
            EGCameraIsoMove* _self = _weakSelf;
            if(unumf([_self->_scale value]) <= 1) {
                return wrap(GEVec2, [_self->__currentBase naturalCenter]);
            } else {
                GEVec2 centerP = geVec4Xy(([[_self->__currentBase.matrixModel wcp] mulVec4:geVec4ApplyVec2ZW((uwrap(GEVec2, cen)), 0.0, 1.0)]));
                GEVec2 cp = geRectClosestPointForVec2([_self centerBounds], centerP);
                if(GEVec2Eq(cp, centerP)) {
                    return cen;
                } else {
                    GEMat4* mat4 = [[_self->__currentBase.matrixModel wcp] inverse];
                    GEVec4 p0 = [mat4 mulVec4:GEVec4Make(cp.x, cp.y, -1.0, 1.0)];
                    GEVec4 p1 = [mat4 mulVec4:GEVec4Make(cp.x, cp.y, 1.0, 1.0)];
                    GELine3 line = GELine3Make(geVec4Xyz(p0), (geVec3SubVec3(geVec4Xyz(p1), geVec4Xyz(p0))));
                    return wrap(GEVec2, (geVec3Xy((geLine3RPlane(line, (GEPlaneMake((GEVec3Make(0.0, 0.0, 0.0)), (GEVec3Make(0.0, 0.0, 1.0)))))))));
                }
            }
        }];
        _centerObs = [_center observeF:^void(id cen) {
            EGCameraIsoMove* _self = _weakSelf;
            _self->__camera = [EGCameraIso cameraIsoWithTilesOnScreen:[_self camera].tilesOnScreen reserve:[_self camera].reserve viewportRatio:[_self camera].viewportRatio center:uwrap(GEVec2, cen)];
            [_self->_changed post];
        }];
        __startScale = 1.0;
        _panEnabled = YES;
        _tapEnabled = YES;
        _pinchEnabled = YES;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCameraIsoMove class]) _EGCameraIsoMove_type = [ODClassType classTypeWithCls:[EGCameraIsoMove class]];
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
    return [EGRecognizers recognizersWithItems:(@[[EGRecognizer applyTp:[EGPinch pinch] began:^BOOL(id<EGEvent> event) {
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
}], [EGRecognizer applyTp:[EGPan panWithFingers:_panFingers] began:^BOOL(id<EGEvent> event) {
    __startPan = [event location];
    return _panEnabled && unumf([_scale value]) > 1.0;
} changed:^void(id<EGEvent> event) {
    [_center setValue:wrap(GEVec2, (geVec2SubVec2((geVec2AddVec2(__camera.center, __startPan)), [event location])))];
} ended:^void(id<EGEvent> event) {
}], [EGRecognizer applyTp:[EGTap tapWithFingers:_tapFingers taps:2] on:^BOOL(id<EGEvent> event) {
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
}]])];
}

- (GERect)centerBounds {
    GEVec2 sizeP = geVec2ApplyF(2.0 - 2.0 / unumf([_scale value]));
    return GERectMake((geVec2DivF(sizeP, -2.0)), sizeP);
}

- (BOOL)isProcessorActive {
    return !(unumb([[EGDirector current].isPaused value]));
}

- (ODClassType*)type {
    return [EGCameraIsoMove type];
}

+ (ODClassType*)type {
    return _EGCameraIsoMove_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCameraIsoMove* o = ((EGCameraIsoMove*)(other));
    return [self.base isEqual:o.base] && eqf(self.minScale, o.minScale) && eqf(self.maxScale, o.maxScale) && self.panFingers == o.panFingers && self.tapFingers == o.tapFingers;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.base hash];
    hash = hash * 31 + floatHash(self.minScale);
    hash = hash * 31 + floatHash(self.maxScale);
    hash = hash * 31 + self.panFingers;
    hash = hash * 31 + self.tapFingers;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"base=%@", self.base];
    [description appendFormat:@", minScale=%f", self.minScale];
    [description appendFormat:@", maxScale=%f", self.maxScale];
    [description appendFormat:@", panFingers=%lu", (unsigned long)self.panFingers];
    [description appendFormat:@", tapFingers=%lu", (unsigned long)self.tapFingers];
    [description appendString:@">"];
    return description;
}

@end


