#import "EGCameraIso.h"

#import "EGMapIso.h"
#import "GEMat4.h"
#import "EGContext.h"
#import "GL.h"
#import "EGDirector.h"
@implementation EGCameraIso{
    GEVec2 _tilesOnScreen;
    float _zReserve;
    GEVec2 _center;
    CGFloat _ww;
    float _yReserve;
    CGFloat _viewportRatio;
    EGMatrixModel* _matrixModel;
}
static CGFloat _EGCameraIso_ISO;
static GEMat4* _EGCameraIso_m;
static GEMat4* _EGCameraIso_w;
static ODClassType* _EGCameraIso_type;
@synthesize tilesOnScreen = _tilesOnScreen;
@synthesize zReserve = _zReserve;
@synthesize center = _center;
@synthesize viewportRatio = _viewportRatio;
@synthesize matrixModel = _matrixModel;

+ (id)cameraIsoWithTilesOnScreen:(GEVec2)tilesOnScreen zReserve:(float)zReserve center:(GEVec2)center {
    return [[EGCameraIso alloc] initWithTilesOnScreen:tilesOnScreen zReserve:zReserve center:center];
}

- (id)initWithTilesOnScreen:(GEVec2)tilesOnScreen zReserve:(float)zReserve center:(GEVec2)center {
    self = [super init];
    if(self) {
        _tilesOnScreen = tilesOnScreen;
        _zReserve = zReserve;
        _center = center;
        _ww = ((CGFloat)(_tilesOnScreen.x + _tilesOnScreen.y));
        _yReserve = _zReserve * 0.612372;
        _viewportRatio = (2 * _ww) / (_yReserve * 2 + _ww);
        _matrixModel = ^EGMatrixModel*() {
            CGFloat isoWW2 = (_ww * _EGCameraIso_ISO) / 2;
            return [EGMatrixModel applyM:_EGCameraIso_m w:_EGCameraIso_w c:^GEMat4*() {
                GEMat4* t = [[GEMat4 identity] translateX:-_center.x y:0.0 z:_center.y];
                GEMat4* r = [[[GEMat4 identity] rotateAngle:30.0 x:1.0 y:0.0 z:0.0] rotateAngle:-45.0 x:0.0 y:1.0 z:0.0];
                return [r mulMatrix:t];
            }() p:[GEMat4 orthoLeft:((float)(-isoWW2)) right:((float)(isoWW2)) bottom:((float)(-(_ww * _EGCameraIso_ISO) / 4)) top:((float)(((_ww + 4 * _yReserve) * _EGCameraIso_ISO) / 4)) zNear:-1000.0 zFar:1000.0]];
        }();
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCameraIso_type = [ODClassType classTypeWithCls:[EGCameraIso class]];
    _EGCameraIso_ISO = EGMapSso.ISO;
    _EGCameraIso_m = [[GEMat4 identity] rotateAngle:90.0 x:1.0 y:0.0 z:0.0];
    _EGCameraIso_w = [[GEMat4 identity] rotateAngle:-90.0 x:1.0 y:0.0 z:0.0];
}

+ (EGCameraIso*)applyTilesOnScreen:(GEVec2)tilesOnScreen zReserve:(float)zReserve {
    return [EGCameraIso cameraIsoWithTilesOnScreen:tilesOnScreen zReserve:zReserve center:geVec2DivF(geVec2SubVec2(tilesOnScreen, GEVec2Make(1.0, 1.0)), 2.0)];
}

- (NSUInteger)cullFace {
    return ((NSUInteger)(GL_FRONT));
}

- (GEVec2)naturalCenter {
    return geVec2DivF(geVec2SubVec2(_tilesOnScreen, GEVec2Make(1.0, 1.0)), 2.0);
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
    return GEVec2Eq(self.tilesOnScreen, o.tilesOnScreen) && eqf4(self.zReserve, o.zReserve) && GEVec2Eq(self.center, o.center);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.tilesOnScreen);
    hash = hash * 31 + float4Hash(self.zReserve);
    hash = hash * 31 + GEVec2Hash(self.center);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tilesOnScreen=%@", GEVec2Description(self.tilesOnScreen)];
    [description appendFormat:@", zReserve=%f", self.zReserve];
    [description appendFormat:@", center=%@", GEVec2Description(self.center)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCameraIsoMove{
    EGCameraIso* _base;
    CGFloat _misScale;
    CGFloat _maxScale;
    CGFloat _panFingers;
    CGFloat __scale;
    EGCameraIso* __camera;
    GEVec2 __startPan;
    CGFloat __startScale;
}
static CNNotificationHandle* _EGCameraIsoMove_cameraChangedNotification;
static ODClassType* _EGCameraIsoMove_type;
@synthesize base = _base;
@synthesize misScale = _misScale;
@synthesize maxScale = _maxScale;
@synthesize panFingers = _panFingers;

+ (id)cameraIsoMoveWithBase:(EGCameraIso*)base misScale:(CGFloat)misScale maxScale:(CGFloat)maxScale panFingers:(CGFloat)panFingers {
    return [[EGCameraIsoMove alloc] initWithBase:base misScale:misScale maxScale:maxScale panFingers:panFingers];
}

- (id)initWithBase:(EGCameraIso*)base misScale:(CGFloat)misScale maxScale:(CGFloat)maxScale panFingers:(CGFloat)panFingers {
    self = [super init];
    if(self) {
        _base = base;
        _misScale = misScale;
        _maxScale = maxScale;
        _panFingers = panFingers;
        __scale = 1.0;
        __camera = _base;
        __startScale = 1.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCameraIsoMove_type = [ODClassType classTypeWithCls:[EGCameraIsoMove class]];
    _EGCameraIsoMove_cameraChangedNotification = [CNNotificationHandle notificationHandleWithName:@"cameraChangedNotification"];
}

- (EGCameraIso*)camera {
    return __camera;
}

- (CGFloat)scale {
    return __scale;
}

- (void)setScale:(CGFloat)scale {
    CGFloat s = floatMinB(floatMaxB(scale, _misScale), _maxScale);
    if(!(eqf(s, __scale))) {
        __scale = s;
        __camera = [EGCameraIso cameraIsoWithTilesOnScreen:geVec2DivF(_base.tilesOnScreen, s) zReserve:_base.zReserve / s center:__camera.center];
        [_EGCameraIsoMove_cameraChangedNotification postData:self];
    }
}

- (GEVec2)center {
    return __camera.center;
}

- (void)setCenter:(GEVec2)center {
    GEVec2 c = ((__scale <= 1) ? [_base naturalCenter] : geQuadClosestPointForVec2([self centerBounds], center));
    if(!(GEVec2Eq(c, __camera.center))) {
        __camera = [EGCameraIso cameraIsoWithTilesOnScreen:[self camera].tilesOnScreen zReserve:[self camera].zReserve center:c];
        [_EGCameraIsoMove_cameraChangedNotification postData:self];
    }
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers recognizersWithItems:(@[[EGRecognizer applyTp:[EGPinch pinch] began:^BOOL(id<EGEvent> event) {
    __startScale = __scale;
    return YES;
} changed:^void(id<EGEvent> event) {
    [self setScale:__startScale * ((EGPinchParameter*)([event param])).scale];
    [self setCenter:[event location]];
} ended:^void(id<EGEvent> event) {
}], [EGRecognizer applyTp:[EGPan panWithFingers:((NSUInteger)(_panFingers))] began:^BOOL(id<EGEvent> event) {
    __startPan = [event location];
    return YES;
} changed:^void(id<EGEvent> event) {
    [self setCenter:geVec2SubVec2(geVec2AddVec2(__camera.center, __startPan), [event location])];
} ended:^void(id<EGEvent> event) {
}]])];
}

- (GEQuad)centerBounds {
    GEVec2 o = [_base naturalCenter];
    if(__scale < 1) {
        return geRectStripQuad(GERectMake(o, GEVec2Make(0.0, 0.0)));
    } else {
        GEVec2 size = geVec2SubVec2(_base.tilesOnScreen, geVec2DivF(_base.tilesOnScreen, __scale));
        GEVec2 s2 = geVec2DivI(size, 2);
        GERect rect = GERectMake(geVec2SubVec2(o, geVec2DivI(size, 2)), size);
        return GEQuadMake(geVec2AddVec2(rect.p, GEVec2Make(-s2.x, s2.y)), geVec2AddVec2(geRectPh(rect), GEVec2Make(s2.x, s2.y)), geVec2AddVec2(geRectPhw(rect), GEVec2Make(s2.x, -s2.y)), geVec2AddVec2(geRectPw(rect), GEVec2Make(-s2.x, -s2.y)));
    }
}

- (BOOL)isProcessorActive {
    return !([[EGDirector current] isPaused]);
}

- (ODClassType*)type {
    return [EGCameraIsoMove type];
}

+ (CNNotificationHandle*)cameraChangedNotification {
    return _EGCameraIsoMove_cameraChangedNotification;
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
    return [self.base isEqual:o.base] && eqf(self.misScale, o.misScale) && eqf(self.maxScale, o.maxScale) && eqf(self.panFingers, o.panFingers);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.base hash];
    hash = hash * 31 + floatHash(self.misScale);
    hash = hash * 31 + floatHash(self.maxScale);
    hash = hash * 31 + floatHash(self.panFingers);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"base=%@", self.base];
    [description appendFormat:@", misScale=%f", self.misScale];
    [description appendFormat:@", maxScale=%f", self.maxScale];
    [description appendFormat:@", panFingers=%f", self.panFingers];
    [description appendString:@">"];
    return description;
}

@end


