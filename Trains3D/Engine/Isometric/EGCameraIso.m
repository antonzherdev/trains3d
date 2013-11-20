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
    CGFloat _isoWW2;
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
        _isoWW2 = (_ww * _EGCameraIso_ISO) / 2;
        _yReserve = _zReserve * 0.612372;
        _viewportRatio = (2 * _ww) / (_yReserve * 2 + _ww);
        _matrixModel = [EGMatrixModel applyM:_EGCameraIso_m w:_EGCameraIso_w c:[[[[GEMat4 identity] translateX:((float)(-_isoWW2 + _EGCameraIso_ISO)) y:((float)(-(_EGCameraIso_ISO * (_tilesOnScreen.y - _tilesOnScreen.x)) / 4 + _isoWW2 / 2)) z:-1000.0] rotateAngle:30.0 x:1.0 y:0.0 z:0.0] rotateAngle:-45.0 x:0.0 y:1.0 z:0.0] p:[GEMat4 orthoLeft:((float)(-_isoWW2)) right:((float)(_isoWW2)) bottom:0.0 top:((float)(((_ww + 2 * _yReserve) * _EGCameraIso_ISO) / 2)) zNear:0.0 zFar:2000.0]];
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

- (NSUInteger)cullFace {
    return ((NSUInteger)(GL_FRONT));
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
    CGFloat __scale;
    EGCameraIso* __camera;
    CGFloat __startScale;
}
static ODClassType* _EGCameraIsoMove_type;
@synthesize base = _base;
@synthesize misScale = _misScale;
@synthesize maxScale = _maxScale;

+ (id)cameraIsoMoveWithBase:(EGCameraIso*)base misScale:(CGFloat)misScale maxScale:(CGFloat)maxScale {
    return [[EGCameraIsoMove alloc] initWithBase:base misScale:misScale maxScale:maxScale];
}

- (id)initWithBase:(EGCameraIso*)base misScale:(CGFloat)misScale maxScale:(CGFloat)maxScale {
    self = [super init];
    if(self) {
        _base = base;
        _misScale = misScale;
        _maxScale = maxScale;
        __scale = 1.0;
        __camera = _base;
        __startScale = 1.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCameraIsoMove_type = [ODClassType classTypeWithCls:[EGCameraIsoMove class]];
}

- (EGCameraIso*)camera {
    return __camera;
}

- (void)setScale:(CGFloat)scale {
    CGFloat s = floatMinB(floatMaxB(scale, _misScale), _maxScale);
    if(!(eqf(s, __scale))) {
        __scale = s;
        __camera = [EGCameraIso cameraIsoWithTilesOnScreen:geVec2DivF(_base.tilesOnScreen, s) zReserve:_base.zReserve center:__camera.center];
    }
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGPinch pinch] began:^BOOL(id<EGEvent> event) {
        __startScale = __scale;
        return YES;
    } changed:^void(id<EGEvent> event) {
        [self setScale:__startScale * ((EGPinchParameter*)([event param])).scale];
    } ended:^void(id<EGEvent> event) {
    }]];
}

- (BOOL)isProcessorActive {
    return !([[EGDirector current] isPaused]);
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
    return [self.base isEqual:o.base] && eqf(self.misScale, o.misScale) && eqf(self.maxScale, o.maxScale);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.base hash];
    hash = hash * 31 + floatHash(self.misScale);
    hash = hash * 31 + floatHash(self.maxScale);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"base=%@", self.base];
    [description appendFormat:@", misScale=%f", self.misScale];
    [description appendFormat:@", maxScale=%f", self.maxScale];
    [description appendString:@">"];
    return description;
}

@end


