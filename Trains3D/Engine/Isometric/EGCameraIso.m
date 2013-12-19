#import "EGCameraIso.h"

#import "EGMapIso.h"
#import "GEMat4.h"
#import "EGContext.h"
#import "GL.h"
#import "EGDirector.h"
@implementation EGCameraIso{
    GEVec2 _tilesOnScreen;
    float _yReserve;
    CGFloat _viewportRatio;
    GEVec2 _center;
    CGFloat _ww;
    EGMatrixModel* _matrixModel;
}
static CGFloat _EGCameraIso_ISO;
static GEMat4* _EGCameraIso_m;
static GEMat4* _EGCameraIso_w;
static ODClassType* _EGCameraIso_type;
@synthesize tilesOnScreen = _tilesOnScreen;
@synthesize yReserve = _yReserve;
@synthesize viewportRatio = _viewportRatio;
@synthesize center = _center;
@synthesize matrixModel = _matrixModel;

+ (id)cameraIsoWithTilesOnScreen:(GEVec2)tilesOnScreen yReserve:(float)yReserve viewportRatio:(CGFloat)viewportRatio center:(GEVec2)center {
    return [[EGCameraIso alloc] initWithTilesOnScreen:tilesOnScreen yReserve:yReserve viewportRatio:viewportRatio center:center];
}

- (id)initWithTilesOnScreen:(GEVec2)tilesOnScreen yReserve:(float)yReserve viewportRatio:(CGFloat)viewportRatio center:(GEVec2)center {
    self = [super init];
    if(self) {
        _tilesOnScreen = tilesOnScreen;
        _yReserve = yReserve;
        _viewportRatio = viewportRatio;
        _center = center;
        _ww = ((CGFloat)(_tilesOnScreen.x + _tilesOnScreen.y));
        _matrixModel = ^EGMatrixModel*() {
            CGFloat isoWW = _ww * _EGCameraIso_ISO;
            CGFloat isoWW2 = isoWW / 2;
            CGFloat as = (isoWW - _viewportRatio * _yReserve) / (isoWW * _viewportRatio);
            CGFloat angleSin = ((as > 1.0) ? 1.0 : as);
            return [EGMatrixModel applyM:_EGCameraIso_m w:_EGCameraIso_w c:^GEMat4*() {
                CGFloat ang = (asin(angleSin) * 180) / M_PI;
                GEMat4* t = [[GEMat4 identity] translateX:-_center.x y:0.0 z:_center.y];
                GEMat4* r = [[[GEMat4 identity] rotateAngle:((float)(ang)) x:1.0 y:0.0 z:0.0] rotateAngle:-45.0 x:0.0 y:1.0 z:0.0];
                return [r mulMatrix:t];
            }() p:[GEMat4 orthoLeft:((float)(-isoWW2)) right:((float)(isoWW2)) bottom:((float)(-isoWW2 * angleSin)) top:((float)(isoWW2 * angleSin + _yReserve)) zNear:-1000.0 zFar:1000.0]];
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

+ (EGCameraIso*)applyTilesOnScreen:(GEVec2)tilesOnScreen yReserve:(float)yReserve viewportRatio:(CGFloat)viewportRatio {
    return [EGCameraIso cameraIsoWithTilesOnScreen:tilesOnScreen yReserve:yReserve viewportRatio:viewportRatio center:geVec2DivF(geVec2SubVec2(tilesOnScreen, GEVec2Make(1.0, 1.0)), 2.0)];
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
    return GEVec2Eq(self.tilesOnScreen, o.tilesOnScreen) && eqf4(self.yReserve, o.yReserve) && eqf(self.viewportRatio, o.viewportRatio) && GEVec2Eq(self.center, o.center);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.tilesOnScreen);
    hash = hash * 31 + float4Hash(self.yReserve);
    hash = hash * 31 + floatHash(self.viewportRatio);
    hash = hash * 31 + GEVec2Hash(self.center);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tilesOnScreen=%@", GEVec2Description(self.tilesOnScreen)];
    [description appendFormat:@", yReserve=%f", self.yReserve];
    [description appendFormat:@", viewportRatio=%f", self.viewportRatio];
    [description appendFormat:@", center=%@", GEVec2Description(self.center)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCameraIsoMove{
    EGCameraIso* _base;
    CGFloat _misScale;
    CGFloat _maxScale;
    NSUInteger _panFingers;
    NSUInteger _tapFingers;
    CGFloat __scale;
    EGCameraIso* __currentBase;
    EGCameraIso* __camera;
    GEVec2 __startPan;
    CGFloat __startScale;
    GEVec2 __pinchLocation;
    GEVec2 __startCenter;
}
static CNNotificationHandle* _EGCameraIsoMove_cameraChangedNotification;
static ODClassType* _EGCameraIsoMove_type;
@synthesize base = _base;
@synthesize misScale = _misScale;
@synthesize maxScale = _maxScale;
@synthesize panFingers = _panFingers;
@synthesize tapFingers = _tapFingers;

+ (id)cameraIsoMoveWithBase:(EGCameraIso*)base misScale:(CGFloat)misScale maxScale:(CGFloat)maxScale panFingers:(NSUInteger)panFingers tapFingers:(NSUInteger)tapFingers {
    return [[EGCameraIsoMove alloc] initWithBase:base misScale:misScale maxScale:maxScale panFingers:panFingers tapFingers:tapFingers];
}

- (id)initWithBase:(EGCameraIso*)base misScale:(CGFloat)misScale maxScale:(CGFloat)maxScale panFingers:(NSUInteger)panFingers tapFingers:(NSUInteger)tapFingers {
    self = [super init];
    if(self) {
        _base = base;
        _misScale = misScale;
        _maxScale = maxScale;
        _panFingers = panFingers;
        _tapFingers = tapFingers;
        __scale = 1.0;
        __currentBase = _base;
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
        __camera = [EGCameraIso cameraIsoWithTilesOnScreen:geVec2DivF(__currentBase.tilesOnScreen, s) yReserve:__currentBase.yReserve / s viewportRatio:__currentBase.viewportRatio center:__camera.center];
        [_EGCameraIsoMove_cameraChangedNotification postData:self];
    }
}

- (GEVec2)center {
    return __camera.center;
}

- (void)setCenter:(GEVec2)center {
    GEVec2 c = ((__scale <= 1) ? [__currentBase naturalCenter] : ^GEVec2() {
        GEVec2 centerP = geVec4Xy([[__currentBase.matrixModel wcp] mulVec4:geVec4ApplyVec2ZW(center, 0.0, 1.0)]);
        GEVec2 cp = geRectClosestPointForVec2([self centerBounds], centerP);
        if(GEVec2Eq(cp, centerP)) {
            return center;
        } else {
            GEMat4* mat4 = [[__currentBase.matrixModel wcp] inverse];
            GEVec4 p0 = [mat4 mulVec4:GEVec4Make(cp.x, cp.y, -1.0, 1.0)];
            GEVec4 p1 = [mat4 mulVec4:GEVec4Make(cp.x, cp.y, 1.0, 1.0)];
            GELine3 line = GELine3Make(geVec4Xyz(p0), geVec3SubVec3(geVec4Xyz(p1), geVec4Xyz(p0)));
            return geVec3Xy(geLine3RPlane(line, GEPlaneMake(GEVec3Make(0.0, 0.0, 0.0), GEVec3Make(0.0, 0.0, 1.0))));
        }
    }());
    if(!(GEVec2Eq(c, __camera.center))) {
        __camera = [EGCameraIso cameraIsoWithTilesOnScreen:[self camera].tilesOnScreen yReserve:[self camera].yReserve viewportRatio:[self camera].viewportRatio center:c];
        [_EGCameraIsoMove_cameraChangedNotification postData:self];
    }
}

- (CGFloat)viewportRatio {
    return __currentBase.viewportRatio;
}

- (void)setViewportRatio:(CGFloat)viewportRatio {
    __currentBase = [EGCameraIso cameraIsoWithTilesOnScreen:__currentBase.tilesOnScreen yReserve:__currentBase.yReserve viewportRatio:viewportRatio center:__currentBase.center];
    __camera = [EGCameraIso cameraIsoWithTilesOnScreen:__camera.tilesOnScreen yReserve:__camera.yReserve viewportRatio:viewportRatio center:__camera.center];
}

- (CGFloat)yReserve {
    return ((CGFloat)(__currentBase.yReserve));
}

- (void)setYReserve:(CGFloat)yReserve {
    __currentBase = [EGCameraIso cameraIsoWithTilesOnScreen:__currentBase.tilesOnScreen yReserve:((float)(yReserve)) viewportRatio:__currentBase.viewportRatio center:__currentBase.center];
    __camera = [EGCameraIso cameraIsoWithTilesOnScreen:__camera.tilesOnScreen yReserve:((float)(yReserve)) viewportRatio:__camera.viewportRatio center:__camera.center];
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers recognizersWithItems:(@[[EGRecognizer applyTp:[EGPinch pinch] began:^BOOL(id<EGEvent> event) {
    __startScale = __scale;
    __pinchLocation = [event location];
    __startCenter = __camera.center;
    return YES;
} changed:^void(id<EGEvent> event) {
    CGFloat s = ((EGPinchParameter*)([event param])).scale;
    [self setScale:__startScale * s];
    [self setCenter:((s <= 1.0) ? __startCenter : ((s < 2.0) ? geVec2AddVec2(__startCenter, geVec2MulF(geVec2SubVec2(__pinchLocation, __startCenter), s - 1.0)) : __pinchLocation))];
} ended:^void(id<EGEvent> event) {
}], [EGRecognizer applyTp:[EGPan panWithFingers:_panFingers] began:^BOOL(id<EGEvent> event) {
    __startPan = [event location];
    return __scale > 1.0;
} changed:^void(id<EGEvent> event) {
    [self setCenter:geVec2SubVec2(geVec2AddVec2(__camera.center, __startPan), [event location])];
} ended:^void(id<EGEvent> event) {
}], [EGRecognizer applyTp:[EGTap tapWithFingers:_tapFingers taps:2] on:^BOOL(id<EGEvent> event) {
    if(!(eqf(__scale, _maxScale))) {
        GEVec2 loc = [event location];
        [self setScale:_maxScale];
        [self setCenter:loc];
    } else {
        [self setScale:1.0];
        [self setCenter:[__currentBase naturalCenter]];
    }
    return YES;
}]])];
}

- (GERect)centerBounds {
    GEVec2 sizeP = geVec2ApplyF(2 - 2 / __scale);
    return GERectMake(geVec2DivI(sizeP, -2), sizeP);
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
    return [self.base isEqual:o.base] && eqf(self.misScale, o.misScale) && eqf(self.maxScale, o.maxScale) && self.panFingers == o.panFingers && self.tapFingers == o.tapFingers;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.base hash];
    hash = hash * 31 + floatHash(self.misScale);
    hash = hash * 31 + floatHash(self.maxScale);
    hash = hash * 31 + self.panFingers;
    hash = hash * 31 + self.tapFingers;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"base=%@", self.base];
    [description appendFormat:@", misScale=%f", self.misScale];
    [description appendFormat:@", maxScale=%f", self.maxScale];
    [description appendFormat:@", panFingers=%lu", (unsigned long)self.panFingers];
    [description appendFormat:@", tapFingers=%lu", (unsigned long)self.tapFingers];
    [description appendString:@">"];
    return description;
}

@end


