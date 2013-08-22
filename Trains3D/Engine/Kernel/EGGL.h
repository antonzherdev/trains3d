#import <GLUT/glut.h>
#import "EGTypes.h"

@class EGMatrix;

static inline void egRotate(float angle, float x, float y, float z) {
    glRotatef(angle, x, y, z);
}

static inline void egScale (float x, float y, float z) {
    glScalef(x, y, z);
}

static inline void egTranslate(float x, float y, float z) {
    glTranslatef(x, y, z);
}

static inline void egColor3(float red, float green, float blue) {
    glColor3f(red, green, blue);
}

static inline void egColor4(float red, float green, float blue, float alpha) {
    glColor4f(red, green, blue, alpha);
}

static inline void egVertex2(float x, float y) {
    glVertex2f(x, y);
}
static inline void egVertex3(float x, float y, float z) {
    glVertex3f(x, y, z);
}
static inline void egNormal3(float x, float y, float z) {
    glNormal3f(x, y, z);
}

static inline void egTexCoord2 (float s, float t) {
    glTexCoord2f(s, t);
}

static inline void egClear() {
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

static inline void egViewport(EGRectI rect) {
    glViewport((GLint)rect.x, (GLint)rect.y, (GLsizei)rect.width, (GLsizei)rect.height);
}

static inline void egRect (float x1, float y1, float x2, float y2) {
    glRectf(x1, y1, x2, y2);
}

static inline void egAmbientColor(float r, float g, float b) {
    GLfloat ambientColor[] = {(GLfloat) r, (GLfloat) g, (GLfloat) b, 1.0f};
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambientColor);
}

static inline void egLightColor(GLenum light, float r, float g, float b) {
    GLfloat lightColor0[] = {(GLfloat) r, (GLfloat) g, (GLfloat) b, 1.0f};
    glLightfv(light, GL_DIFFUSE, lightColor0);
}

static inline void egLightPosition(GLenum light, float x, float y, float z) {
    GLfloat lightPosition[] = {(GLfloat) x, (GLfloat) y, (GLfloat) z, 1.0f};
    glLightfv(light, GL_POSITION, lightPosition);
}

static inline void egLightDirection(GLenum light, float x, float y, float z) {
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

static inline void egMaterial(GLenum face, GLenum tp, float value) {
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

static inline GLint egGetAttribLocation(GLuint program, NSString* name) {
    return glGetAttribLocation(program, [name cStringUsingEncoding:NSUTF8StringEncoding]);
}

static inline GLint egGetUniformLocation(GLuint program, NSString* name) {
    return glGetUniformLocation(program, [name cStringUsingEncoding:NSUTF8StringEncoding]);
}

static inline void egVertexAttribPointer (GLuint index, NSUInteger size, GLenum type, GLboolean normalized, NSUInteger stride, NSUInteger pointer) {
    glVertexAttribPointer(index, size, type, normalized, stride, (GLvoid const *) pointer);
}

EGMatrix* egModelViewProjectionMatrix();