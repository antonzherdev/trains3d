#import "EGCameraIso.h"

#import "EG.h"
#import "EGMapIso.h"
#import "EGContext.h"
@implementation EGCameraIso{
    EGSizeI _tilesOnScreen;
    EGPoint _center;
    EGVec3 _eyeDirection;
}
static CGFloat _EGCameraIso_ISO;
static ODClassType* _EGCameraIso_type;
@synthesize tilesOnScreen = _tilesOnScreen;
@synthesize center = _center;
@synthesize eyeDirection = _eyeDirection;

+ (id)cameraIsoWithTilesOnScreen:(EGSizeI)tilesOnScreen center:(EGPoint)center {
    return [[EGCameraIso alloc] initWithTilesOnScreen:tilesOnScreen center:center];
}

- (id)initWithTilesOnScreen:(EGSizeI)tilesOnScreen center:(EGPoint)center {
    self = [super init];
    if(self) {
        _tilesOnScreen = tilesOnScreen;
        _center = center;
        _eyeDirection = EGVec3Make(1.0, -1.0, ((float)(0.5)));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCameraIso_type = [ODClassType classTypeWithCls:[EGCameraIso class]];
    _EGCameraIso_ISO = EGMapSso.ISO;
}

- (EGRect)calculateViewportSizeWithViewSize:(EGSize)viewSize {
    NSInteger ww = _tilesOnScreen.width + _tilesOnScreen.height;
    CGFloat tileSize = min(viewSize.width / ww, 2 * viewSize.height / ww);
    CGFloat viewportWidth = tileSize * ww;
    CGFloat viewportHeight = tileSize * ww / 2;
    return EGRectMake((viewSize.width - viewportWidth) / 2, viewportWidth, (viewSize.height - viewportHeight) / 2, viewportHeight);
}

- (void)focusForViewSize:(EGSize)viewSize {
    EGRect vps = [self calculateViewportSizeWithViewSize:viewSize];
    glViewport(vps.x, vps.y, vps.width, vps.height);
    EGMutableMatrix* mm = [EG modelMatrix];
    [mm setIdentity];
    [mm rotateAngle:90.0 x:1.0 y:0.0 z:0.0];
    EGMutableMatrix* wm = [EG worldMatrix];
    [wm setIdentity];
    [wm translateX:0.0 y:0.0 z:-100.0];
    [wm rotateAngle:30.0 x:1.0 y:0.0 z:0.0];
    [wm rotateAngle:-45.0 x:0.0 y:1.0 z:0.0];
    [wm rotateAngle:-90.0 x:1.0 y:0.0 z:0.0];
    EGMutableMatrix* cm = [EG cameraMatrix];
    [cm setIdentity];
    [cm translateX:-_center.x y:0.0 z:-_center.y];
    EGMutableMatrix* pm = [EG projectionMatrix];
    [pm setIdentity];
    CGFloat ww = ((CGFloat)(_tilesOnScreen.width + _tilesOnScreen.height));
    [pm orthoLeft:-_EGCameraIso_ISO right:_EGCameraIso_ISO * ww - _EGCameraIso_ISO bottom:-_EGCameraIso_ISO * _tilesOnScreen.width / 2 top:_EGCameraIso_ISO * _tilesOnScreen.height / 2 zNear:0.0 zFar:1000.0];
    glCullFace(GL_FRONT);
}

- (EGPoint)translateWithViewSize:(EGSize)viewSize viewPoint:(EGPoint)viewPoint {
    EGRect vps = [self calculateViewportSizeWithViewSize:viewSize];
    CGFloat x = viewPoint.x - vps.x;
    CGFloat y = viewPoint.y - vps.y;
    CGFloat vw = egRectSize(vps).width;
    CGFloat vh = egRectSize(vps).height;
    CGFloat ww2 = (_tilesOnScreen.width + _tilesOnScreen.height) / 2.0;
    CGFloat tw = ((CGFloat)(_tilesOnScreen.width));
    return EGPointMake((x / vw - y / vh) * ww2 + tw / 2 - 0.5 + _center.x, (x / vw + y / vh) * ww2 - tw / 2 - 0.5 + _center.y);
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
    return EGSizeIEq(self.tilesOnScreen, o.tilesOnScreen) && EGPointEq(self.center, o.center);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGSizeIHash(self.tilesOnScreen);
    hash = hash * 31 + EGPointHash(self.center);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tilesOnScreen=%@", EGSizeIDescription(self.tilesOnScreen)];
    [description appendFormat:@", center=%@", EGPointDescription(self.center)];
    [description appendString:@">"];
    return description;
}

@end


