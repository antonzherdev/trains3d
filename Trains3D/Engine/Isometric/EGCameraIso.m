#import "EGCameraIso.h"

#import "EGMapIso.h"
#import "EGContext.h"
#import "GEMat4.h"
#import "GL.h"
@implementation EGCameraIso{
    GEVec2i _tilesOnScreen;
    GEVec2 _center;
    EGMatrixModel* _matrixModel;
}
static CGFloat _EGCameraIso_ISO;
static ODClassType* _EGCameraIso_type;
@synthesize tilesOnScreen = _tilesOnScreen;
@synthesize center = _center;

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
            return [EGMatrixModel applyM:[[GEMat4 identity] rotateAngle:90.0 x:1.0 y:0.0 z:0.0] w:[[GEMat4 identity] rotateAngle:-90.0 x:1.0 y:0.0 z:0.0] c:[[[[GEMat4 identity] translateX:((float)(-isoWW2 + _EGCameraIso_ISO)) y:((float)(-_EGCameraIso_ISO * (_tilesOnScreen.y - _tilesOnScreen.x) / 4 + isoWW4)) z:-1000.0] rotateAngle:30.0 x:1.0 y:0.0 z:0.0] rotateAngle:-45.0 x:0.0 y:1.0 z:0.0] p:[GEMat4 orthoLeft:((float)(-isoWW2)) right:((float)(isoWW2)) bottom:0.0 top:((float)(isoWW2)) zNear:0.0 zFar:2000.0]];
        }();
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCameraIso_type = [ODClassType classTypeWithCls:[EGCameraIso class]];
    _EGCameraIso_ISO = EGMapSso.ISO;
}

- (GERecti)viewportWithViewSize:(GEVec2)viewSize {
    NSInteger ww = _tilesOnScreen.x + _tilesOnScreen.y;
    CGFloat tileSize = min(((CGFloat)(viewSize.x / ww)), ((CGFloat)(2 * viewSize.y / ww)));
    CGFloat viewportWidth = tileSize * ww;
    CGFloat viewportHeight = tileSize * ww / 2;
    return geRectiMoveToCenterForSize(geRectiApplyXYWidthHeight(0.0, 0.0, ((float)(viewportWidth)), ((float)(viewportHeight))), viewSize);
}

- (void)focusForViewSize:(GEVec2)viewSize {
    EGGlobal.matrix.value = _matrixModel;
    glCullFace(GL_FRONT);
}

- (GEVec2)translateWithViewSize:(GEVec2)viewSize viewPoint:(GEVec2)viewPoint {
    GERecti vps = [self viewportWithViewSize:viewSize];
    float x = viewPoint.x - geRectiX(vps);
    float y = viewPoint.y - geRectiY(vps);
    NSInteger vw = vps.size.x;
    NSInteger vh = vps.size.y;
    CGFloat ww2 = (_tilesOnScreen.x + _tilesOnScreen.y) / 2.0;
    CGFloat tw = ((CGFloat)(_tilesOnScreen.x));
    return GEVec2Make((x / vw - y / vh) * ww2 + tw / 2 - 0.5 + _center.x, (x / vw + y / vh) * ww2 - tw / 2 - 0.5 + _center.y);
}

- (ODClassType*)type {
    return [EGCameraIso type];
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


