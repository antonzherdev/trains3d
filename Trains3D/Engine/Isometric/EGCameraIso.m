#import "EGCameraIso.h"

#import "EG.h"
#import "EGMapIso.h"
#import "EGContext.h"
@implementation EGCameraIso{
    EGVec2I _tilesOnScreen;
    EGVec2 _center;
    EGVec3 _eyeDirection;
}
static CGFloat _EGCameraIso_ISO;
static ODClassType* _EGCameraIso_type;
@synthesize tilesOnScreen = _tilesOnScreen;
@synthesize center = _center;
@synthesize eyeDirection = _eyeDirection;

+ (id)cameraIsoWithTilesOnScreen:(EGVec2I)tilesOnScreen center:(EGVec2)center {
    return [[EGCameraIso alloc] initWithTilesOnScreen:tilesOnScreen center:center];
}

- (id)initWithTilesOnScreen:(EGVec2I)tilesOnScreen center:(EGVec2)center {
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

- (EGRect)calculateViewportSizeWithViewSize:(EGVec2)viewSize {
    NSInteger ww = _tilesOnScreen.x + _tilesOnScreen.y;
    CGFloat tileSize = min(viewSize.x / ww, 2 * viewSize.y / ww);
    CGFloat viewportWidth = tileSize * ww;
    CGFloat viewportHeight = tileSize * ww / 2;
    return EGRectMake((viewSize.x - viewportWidth) / 2, viewportWidth, (viewSize.y - viewportHeight) / 2, viewportHeight);
}

- (void)focusForViewSize:(EGVec2)viewSize {
    EGRect vps = [self calculateViewportSizeWithViewSize:viewSize];
    glViewport(vps.x, vps.y, vps.width, vps.height);
    EGMutableMatrix* mm = [EG modelMatrix];
    [mm setIdentity];
    [mm rotateAngle:90.0 x:1.0 y:0.0 z:0.0];
    EGMutableMatrix* wm = [EG worldMatrix];
    [wm setIdentity];
    [wm rotateAngle:-90.0 x:1.0 y:0.0 z:0.0];
    EGMutableMatrix* cm = [EG cameraMatrix];
    [cm setIdentity];
    CGFloat ww = ((CGFloat)(_tilesOnScreen.x + _tilesOnScreen.y));
    CGFloat isoWW2 = ww * _EGCameraIso_ISO / 2;
    CGFloat isoWW4 = isoWW2 / 2;
    [cm translateX:-isoWW2 + _EGCameraIso_ISO y:-_EGCameraIso_ISO * (_tilesOnScreen.y - _tilesOnScreen.x) / 4 z:0.0];
    [cm rotateAngle:30.0 x:1.0 y:0.0 z:0.0];
    [cm rotateAngle:-45.0 x:0.0 y:1.0 z:0.0];
    EGMutableMatrix* pm = [EG projectionMatrix];
    [pm setIdentity];
    [pm orthoLeft:-isoWW2 right:isoWW2 bottom:-isoWW4 top:isoWW4 zNear:-1000.0 zFar:1000.0];
    glCullFace(GL_FRONT);
}

- (EGVec2)translateWithViewSize:(EGVec2)viewSize viewPoint:(EGVec2)viewPoint {
    EGRect vps = [self calculateViewportSizeWithViewSize:viewSize];
    CGFloat x = viewPoint.x - vps.x;
    CGFloat y = viewPoint.y - vps.y;
    CGFloat vw = egRectSize(vps).x;
    CGFloat vh = egRectSize(vps).y;
    CGFloat ww2 = (_tilesOnScreen.x + _tilesOnScreen.y) / 2.0;
    CGFloat tw = ((CGFloat)(_tilesOnScreen.x));
    return EGVec2Make((x / vw - y / vh) * ww2 + tw / 2 - 0.5 + _center.x, (x / vw + y / vh) * ww2 - tw / 2 - 0.5 + _center.y);
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
    return EGVec2IEq(self.tilesOnScreen, o.tilesOnScreen) && EGVec2Eq(self.center, o.center);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec2IHash(self.tilesOnScreen);
    hash = hash * 31 + EGVec2Hash(self.center);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tilesOnScreen=%@", EGVec2IDescription(self.tilesOnScreen)];
    [description appendFormat:@", center=%@", EGVec2Description(self.center)];
    [description appendString:@">"];
    return description;
}

@end


