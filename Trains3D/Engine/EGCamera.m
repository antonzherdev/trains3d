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

+ (void)isometricFocusWithViewSize:(CGSize)viewSize tilesOnScreen:(CGSize)tilesOnScreen center:(CGPoint)center {
    CGFloat w1 = tilesOnScreen.width + 1;
    CGFloat h1 = tilesOnScreen.height + 1;
    CGFloat tileSize = MIN(viewSize.width / w1, 2*viewSize.height/ h1);
    CGFloat viewportWidth = tileSize * w1;
    CGFloat viewportHeight = tileSize * h1 / 2;
    glViewport((GLint) ((viewSize.width - viewportWidth)/2), (GLint) ((viewSize.height - viewportHeight)/2),
            (GLsizei) viewportWidth, (GLsizei) viewportHeight);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    double ow = ISO * w1;
    double oh = (ISO * h1)/2;
    glOrtho(-ow, ow, -oh, oh, 0.0f, 1000.0f);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    glTranslatef(0 ,0 ,-100);
    glRotatef(30, 1, 0, 0);
    glRotatef(-45.0f, 0, 1, 0);
    glTranslatef((GLfloat) -center.x,0, (GLfloat) -center.y);

}

@end


