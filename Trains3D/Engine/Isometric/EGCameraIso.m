#import "EGCameraIso.h"

#import "EG.h"
#import "EGGL.h"
#import "EGMapIso.h"
#import "EGContext.h"
@implementation EGCameraIso{
    EGSizeI _tilesOnScreen;
    EGPoint _center;
}
static CGFloat _ISO;
@synthesize tilesOnScreen = _tilesOnScreen;
@synthesize center = _center;

+ (id)cameraIsoWithTilesOnScreen:(EGSizeI)tilesOnScreen center:(EGPoint)center {
    return [[EGCameraIso alloc] initWithTilesOnScreen:tilesOnScreen center:center];
}

- (id)initWithTilesOnScreen:(EGSizeI)tilesOnScreen center:(EGPoint)center {
    self = [super init];
    if(self) {
        _tilesOnScreen = tilesOnScreen;
        _center = center;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _ISO = EGMapSso.ISO;
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
    glViewport(((NSInteger)(vps.x)), ((NSInteger)(vps.y)), ((NSInteger)(vps.width)), ((NSInteger)(vps.height)));
    glMatrixMode(GL_PROJECTION);
    EGMutableMatrix* pm = [EG projectionMatrix];
    [pm setIdentity];
    CGFloat ww = ((CGFloat)(_tilesOnScreen.width + _tilesOnScreen.height));
    [pm orthoLeft:-_ISO right:_ISO * ww - _ISO bottom:-_ISO * _tilesOnScreen.width / 2 top:_ISO * _tilesOnScreen.height / 2 zNear:0.0 zFar:1000.0];
    glMatrixMode(GL_MODELVIEW);
    EGMutableMatrix* mm = [EG modelMatrix];
    [mm translateX:((CGFloat)(0)) y:((CGFloat)(0)) z:((CGFloat)(-100))];
    [mm rotateAngle:((CGFloat)(30)) x:((CGFloat)(1)) y:((CGFloat)(0)) z:((CGFloat)(0))];
    [mm rotateAngle:-45.0 x:((CGFloat)(0)) y:((CGFloat)(1)) z:((CGFloat)(0))];
    [mm rotateAngle:((CGFloat)(-90)) x:((CGFloat)(1)) y:((CGFloat)(0)) z:((CGFloat)(0))];
    [mm translateX:-_center.x y:((CGFloat)(0)) z:-_center.y];
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


