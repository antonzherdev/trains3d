#import "EGCameraIso.h"
#import "EGMapIso.h"

static inline CGRect calculateViewportSize(EGMapSize tilesOnScreen, CGSize viewSize) {
    CGFloat ww = tilesOnScreen.width + tilesOnScreen.height;
    CGFloat tileSize = MIN(viewSize.width / ww, 2*viewSize.height/ ww);
    CGFloat viewportWidth = tileSize * ww;
    CGFloat viewportHeight = tileSize * ww / 2;
    return CGRectMake((viewSize.width - viewportWidth)/2, (viewSize.height - viewportHeight)/2,
            viewportWidth, viewportHeight);
}

@implementation EGCameraIso{
    EGMapSize _tilesOnScreen;
    CGPoint _center;
}
@synthesize tilesOnScreen = _tilesOnScreen;
@synthesize center = _center;

+ (id)cameraIsoWithTilesOnScreen:(EGMapSize)tilesOnScreen center:(CGPoint)center {
    return [[EGCameraIso alloc] initWithTilesOnScreen:tilesOnScreen center:center];
}

- (id)initWithTilesOnScreen:(EGMapSize)tilesOnScreen center:(CGPoint)center {
    self = [super init];
    if(self) {
        _tilesOnScreen = tilesOnScreen;
        _center = center;
    }
    
    return self;
}

- (void)focusForViewSize:(CGSize)viewSize {
    CGRect vps = calculateViewportSize(_tilesOnScreen, viewSize);
    glViewport(vps.origin.x, vps.origin.y, vps.size.width, vps.size.height);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    CGFloat ww = _tilesOnScreen.width + _tilesOnScreen.height;
    glOrtho(-ISO, ISO*ww - ISO, -ISO*_tilesOnScreen.width/2, ISO*_tilesOnScreen.height/2, 0.0f, 1000.0f);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    glTranslatef(0 ,0 ,-100);
    glRotatef(30, 1, 0, 0);
    glRotatef(-45.0f, 0, 1, 0);
    glRotatef(-90, 1, 0, 0);
    glTranslatef((GLfloat) -_center.x,0, (GLfloat) -_center.y);
}

- (CGPoint)translateViewPoint:(CGPoint)viewPoint withViewSize:(CGSize)viewSize {
    CGRect vps = calculateViewportSize(_tilesOnScreen, viewSize);
    CGFloat x = viewPoint.x - vps.origin.x;
    CGFloat y = viewPoint.y - vps.origin.y;
    CGFloat vw = vps.size.width;
    CGFloat vh = vps.size.height;
    CGFloat ww2 = ((CGFloat)_tilesOnScreen.width + _tilesOnScreen.height)/2;
    CGFloat tw = _tilesOnScreen.width;
    return CGPointMake((x/vw - y/vh)*ww2 + tw/2 - 0.5 + _center.x, (x/vw + y/vh)*ww2 - tw/2 - 0.5 + _center.y);
}


@end


