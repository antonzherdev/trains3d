#import <GLUT/glut.h>
#import "EGTypes.h"

@class EGMatrix;

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

static inline void egColor4(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
    glColor4d(red, green, blue, alpha);
}

static inline void egVertex2(CGFloat x, CGFloat y) {
    glVertex2d(x, y);
}
static inline void egVertex3(CGFloat x, CGFloat y, CGFloat z) {
    glVertex3d(x, y, z);
}
static inline void egNormal3(CGFloat x, CGFloat y, CGFloat z) {
    glNormal3d(x, y, z);
}

static inline void egTexCoord2 (CGFloat s, CGFloat t) {
    glTexCoord2d(s, t);
}

static inline void egClear() {
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

static inline void egViewport(EGRectI rect) {
    glViewport(rect.x, rect.y, rect.width, rect.height);
}

static inline void egRect (CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2) {
    glRectd(x1, y1, x2, y2);
}

static inline void egAmbientColor(double r, double g, double b) {
    GLfloat ambientColor[] = {(GLfloat) r, (GLfloat) g, (GLfloat) b, 1.0f};
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambientColor);
}

static inline void egLightColor(GLenum light, double r, double g, double b) {
    GLfloat lightColor0[] = {(GLfloat) r, (GLfloat) g, (GLfloat) b, 1.0f};
    glLightfv(light, GL_DIFFUSE, lightColor0);
}

static inline void egLightPosition(GLenum light, double x, double y, double z) {
    GLfloat lightPosition[] = {(GLfloat) x, (GLfloat) y, (GLfloat) z, 1.0f};
    glLightfv(light, GL_POSITION, lightPosition);
}

static inline void egLightDirection(GLenum light, double x, double y, double z) {
    GLfloat lightPosition[] = {(GLfloat) x, (GLfloat) y, (GLfloat) z, 0.0f};
    glLightfv(light, GL_POSITION, lightPosition);
}

static inline void egMaterialColor(GLenum face, GLenum tp, EGColor color) {
    GLfloat mat[4];
    mat[0] = (GLfloat) color.r;
    mat[1] = (GLfloat) color.g;
    mat[2] = (GLfloat) color.b;
    mat[3] = (GLfloat) color.a;
    glMaterialfv(face, tp, mat);
}

static inline void egMaterial(GLenum face, GLenum tp, double value) {
    glMaterialf(face, tp, (GLfloat) value);
}

id egGetProgramError(GLuint program);
void egShaderSource(GLuint shader, NSString* source);
id egGetShaderError(GLuint shader);

static inline BOOL GLuintEq(GLuint a, GLuint b) {
    return a == b;
}

static inline NSUInteger GLuintHash(GLuint x) {
    return x;
}

static inline NSString *GLuintDescription(GLuint x) {
    return [NSString stringWithFormat:@"%d", x];
}

static inline BOOL GLenumEq(GLenum a, GLenum b) {
    return a == b;
}

static inline NSUInteger GLenumHash(GLenum x) {
    return x;
}

static inline NSString *GLenumDescription(GLenum x) {
    return [NSString stringWithFormat:@"%d", x];
}

static inline GLuint egGenBuffer() {
    GLuint buffer;
    glGenBuffers(1, &buffer);
    return buffer;
}

static inline void egDeleteBuffer(GLuint handle) {
    glDeleteBuffers(1, &handle);
}

static inline GLuint egGetAttribLocation(GLuint program, NSString* name) {
    glGetAttribLocation(program, [name cStringUsingEncoding:NSUTF8StringEncoding]);
}

static inline void egVertexAttribPointer (GLuint index, NSUInteger size, GLenum type, GLboolean normalized, NSUInteger stride, NSUInteger pointer) {
    glVertexAttribPointer(index, size, type, normalized, stride, (GLvoid const *) pointer);
}

EGMatrix* egModelViewProjectionMatrix();