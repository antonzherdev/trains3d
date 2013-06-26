#import <GLUT/glut.h>
#import "EGText.h"

void egTextGlutDraw(NSString* text, void* font, CGPoint position) {
    glRasterPos2f((GLfloat) position.x, (GLfloat) position.y);
    int len, i;
    len = (int)[text length];
    char const *s = [text UTF8String];
    for (i = 0; i < len; i++) {
        glutBitmapCharacter(font, s[i]);
    }

}


