#import "EGCamera.h"

void egCameraIsoFocus(CGSize viewSize, EGMapSize mapSize, CGPoint center) {
    CGFloat ww = mapSize.width + mapSize.height;
    CGFloat tileSize = MIN(viewSize.width / ww, 2*viewSize.height/ ww);
    CGFloat viewportWidth = tileSize * ww;
    CGFloat viewportHeight = tileSize * ww / 2;
    glViewport((GLint) ((viewSize.width - viewportWidth)/2), (GLint) ((viewSize.height - viewportHeight)/2),
            (GLsizei) viewportWidth, (GLsizei) viewportHeight);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    double ow = ISO * ww;
    double oh = (ISO * ww)/4;
    glOrtho(-ISO, ow - ISO, -oh, oh, 0.0f, 1000.0f);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    glTranslatef(0 ,0 ,-100);
    glRotatef(30, 1, 0, 0);
    glRotatef(-45.0f, 0, 1, 0);
    glRotatef(-90, 1, 0, 0);
    glTranslatef((GLfloat) -center.x,0, (GLfloat) -center.y);
}

