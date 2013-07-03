#import "EGCamera.h"
#import "EGMap.h"

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
    CGFloat ww = _tilesOnScreen.width + _tilesOnScreen.height;
    CGFloat tileSize = MIN(viewSize.width / ww, 2*viewSize.height/ ww);
    CGFloat viewportWidth = tileSize * ww;
    CGFloat viewportHeight = tileSize * ww / 2;
    glViewport((GLint) ((viewSize.width - viewportWidth)/2), (GLint) ((viewSize.height - viewportHeight)/2),
            (GLsizei) viewportWidth, (GLsizei) viewportHeight);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(-ISO, ISO*ww - ISO, -ISO*_tilesOnScreen.width/2, ISO*_tilesOnScreen.height/2, 0.0f, 1000.0f);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    glTranslatef(0 ,0 ,-100);
    glRotatef(30, 1, 0, 0);
    glRotatef(-45.0f, 0, 1, 0);
    glRotatef(-90, 1, 0, 0);
    glTranslatef((GLfloat) -_center.x,0, (GLfloat) -_center.y);
}

- (CGPoint)translateViewPoint:(CGPoint)viewPoint withViewSize:(CGSize)withViewSize {
    return viewPoint;
}


@end


