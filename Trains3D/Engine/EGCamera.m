#import "EGCamera.h"

static const double ISO = 0.70710676908493/2;

@implementation EGCamera

+ (id)camera {
    return [[EGCamera alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)startDraw {
    @throw @"Method startDraw is abstact";
}

- (void)reshapeWithSize:(CGSize)size {
    @throw @"Method reshapeWith is abstact";
}

@end


@implementation EGIsometricCamera{
    CGPoint _center;
    CGSize _tilesOnScreen;
}
@synthesize center = _center;
@synthesize tilesOnScreen = _tilesOnScreen;

+ (id)isometricCameraWithCenter:(CGPoint)center tilesOnScreen:(CGSize)tilesOnScreen {
    return [[EGIsometricCamera alloc] initWithCenter:center tilesOnScreen:tilesOnScreen];
}

- (id)initWithCenter:(CGPoint)center tilesOnScreen:(CGSize)tilesOnScreen {
    self = [super init];
    if(self) {
        _center = center;
        _tilesOnScreen = tilesOnScreen;
    }
    
    return self;
}

- (void)startDraw {
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    glTranslatef(0 ,0 ,-100);
    glRotatef(30, 1, 0, 0);
    glRotatef(-45.0f, 0, 1, 0);
    glTranslatef((GLfloat) -_center.x,0, (GLfloat) -_center.y);
}

- (void)reshapeWithSize:(CGSize)size {
    CGFloat w1 = _tilesOnScreen.width + 1;
    CGFloat h1 = _tilesOnScreen.height + 1;
    CGFloat tileSize = MIN(size.width / w1, 2*size.height/ h1);
    CGFloat viewportWidth = tileSize * w1;
    CGFloat viewportHeight = tileSize * h1 / 2;
    glViewport((GLint) ((size.width - viewportWidth)/2), (GLint) ((size.height - viewportHeight)/2), 
            (GLsizei) viewportWidth, (GLsizei) viewportHeight);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    double ow = ISO * w1;
    double oh = (ISO * h1)/2;
    glOrtho(-ow, ow, -oh, oh, 0.0f, 1000.0f);
}

@end


