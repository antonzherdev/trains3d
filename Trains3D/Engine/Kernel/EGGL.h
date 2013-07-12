#import <GLUT/glut.h>


static inline void egRotate(CGFloat angle, CGFloat x, CGFloat y, CGFloat z) {
    glRotated(angle, x, y, z);
}

static inline void egScale (CGFloat x, CGFloat y, CGFloat z) {
    glScaled(x, y, z);
}

static inline void egTranslate(CGFloat x, CGFloat y, CGFloat z) {
    glTranslated(x, y, z);
}

static inline void egColor3(CGFloat red, CGFloat green, CGFloat blue) {
    glColor3d(red, green, blue);
}

static inline void egVertex2(CGFloat x, CGFloat y) {
    glVertex2d(x, y);
}
static inline void egVertex3(CGFloat x, CGFloat y, CGFloat z) {
    glVertex3d(x, y, z);
}

static inline void egTexCoord2 (CGFloat s, CGFloat t) {
    glTexCoord2d(s, t);
}

static inline void egClear() {
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}
