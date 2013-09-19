#import "EGCameraIso.h"

#import "EGMapIso.h"
#import "GEMat4.h"
#import "EGContext.h"
#import "GL.h"
@implementation EGCameraIso{
    GEVec2i _tilesOnScreen;
    GEVec2 _center;
    EGMatrixModel* _matrixModel;
}
static CGFloat _EGCameraIso_ISO;
static GEMat4* _EGCameraIso_m;
static GEMat4* _EGCameraIso_w;
static ODClassType* _EGCameraIso_type;
@synthesize tilesOnScreen = _tilesOnScreen;
@synthesize center = _center;
@synthesize matrixModel = _matrixModel;

+ (id)cameraIsoWithTilesOnScreen:(GEVec2i)tilesOnScreen center:(GEVec2)center {
    return [[EGCameraIso alloc] initWithTilesOnScreen:tilesOnScreen center:center];
}

- (id)initWithTilesOnScreen:(GEVec2i)tilesOnScreen center:(GEVec2)center {
    self = [super init];
    if(self) {
        _tilesOnScreen = tilesOnScreen;
        _center = center;
        _matrixModel = ^EGMatrixModel*() {
            CGFloat ww = ((CGFloat)(_tilesOnScreen.x + _tilesOnScreen.y));
            CGFloat isoWW2 = ww * _EGCameraIso_ISO / 2;
            CGFloat isoWW4 = isoWW2 / 2;
            return [EGMatrixModel applyM:_EGCameraIso_m w:_EGCameraIso_w c:[[[[GEMat4 identity] translateX:((float)(-isoWW2 + _EGCameraIso_ISO)) y:((float)(-_EGCameraIso_ISO * (_tilesOnScreen.y - _tilesOnScreen.x) / 4 + isoWW4)) z:-1000.0] rotateAngle:30.0 x:1.0 y:0.0 z:0.0] rotateAngle:-45.0 x:0.0 y:1.0 z:0.0] p:[GEMat4 orthoLeft:((float)(-isoWW2)) right:((float)(isoWW2)) bottom:0.0 top:((float)(isoWW2)) zNear:0.0 zFar:2000.0]];
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

- (GERecti)viewportWithViewSize:(GEVec2)viewSize {
    NSInteger ww = _tilesOnScreen.x + _tilesOnScreen.y;
    CGFloat tileSize = min(((CGFloat)(viewSize.x / ww)), ((CGFloat)(2 * viewSize.y / ww)));
    CGFloat viewportWidth = tileSize * ww;
    CGFloat viewportHeight = tileSize * ww / 2;
    return geRectiMoveToCenterForSize(geRectiApplyXYWidthHeight(0.0, 0.0, ((float)(viewportWidth)), ((float)(viewportHeight))), viewSize);
}

- (void)focusForViewSize:(GEVec2)viewSize {
    glCullFace(GL_FRONT);
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
    return GEVec2iEq(self.tilesOnScreen, o.tilesOnScreen) && GEVec2Eq(self.center, o.center);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.tilesOnScreen);
    hash = hash * 31 + GEVec2Hash(self.center);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tilesOnScreen=%@", GEVec2iDescription(self.tilesOnScreen)];
    [description appendFormat:@", center=%@", GEVec2Description(self.center)];
    [description appendString:@">"];
    return description;
}

@end


