#import <GLUT/glut.h>
#import "EGTypes.h"
#import "GEVec.h"

@class GEMat4;

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


static inline void egClear() {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

static inline void egViewport(GERecti rect) {
    glViewport((GLint)rect.origin.x, (GLint)rect.origin.y, (GLsizei)rect.size.x, (GLsizei)rect.size.y);
}


static inline void egUniformColor(GLuint location, EGColor color ) {
    glUniform4f(location, (GLfloat) color.r, (GLfloat) color.g, (GLfloat) color.b, (GLfloat) color.a);
}
static inline void egUniformVec3(GLuint location, GEVec3 vec3 ) {
    glUniform3f(location, (GLfloat) vec3.x, (GLfloat) vec3.y, (GLfloat) vec3.z);
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

static inline BOOL GLintEq(GLint a, GLint b) {
    return a == b;
}

static inline NSUInteger GLintHash(GLint x) {
    return (NSUInteger) x;
}

static inline NSString *GLintDescription(GLint x) {
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

static inline GLuint egGenFrameBuffer() {
    GLuint buffer;
    glGenFramebuffers(1, &buffer);
    return buffer;
}

static inline void egDeleteFrameBuffer(GLuint handle) {
    glDeleteFramebuffers(1, &handle);
}

static inline GLuint egGenRenderBuffer() {
    GLuint buffer;
    glGenRenderbuffers(1, &buffer);
    return buffer;
}

static inline void egDeleteRenderBuffer(GLuint handle) {
    glDeleteRenderbuffers(1, &handle);
}

static inline GLuint egGenTexture() {
    GLuint buffer;
    glGenTextures(1, &buffer);
    return buffer;
}

static inline void egDeleteTexture(GLuint handle) {
    glDeleteTextures(1, &handle);
}

static inline GLint egGetAttribLocation(GLuint program, NSString* name) {
    return glGetAttribLocation(program, [name cStringUsingEncoding:NSUTF8StringEncoding]);
}

static inline GLint egGetUniformLocation(GLuint program, NSString* name) {
    return glGetUniformLocation(program, [name cStringUsingEncoding:NSUTF8StringEncoding]);
}

static inline void egVertexAttribPointer (GLuint index, NSUInteger size, GLenum type, GLboolean normalized, NSUInteger stride, NSUInteger pointer) {
    glVertexAttribPointer(index, (GLint)size, type, normalized, (GLsizei)stride, (GLvoid const *) pointer);
}

static inline void egColor(EGColor self) {
    egColor4(self.r, self.g, self.b, self.a);
}


#define egJasModel(NAME) [EGMesh \
    applyDataType: egMeshDataType()\
    vertexData:[arrp(float, numf4, NAME ## _vertexcount*8) NAME ## _vertex] \
    indexData: [arrp(unsigned int, numui4, NAME ## _polygoncount*3) NAME ## _index]]

GEVec2 egLoadTextureFromFile(GLuint target, NSString* file);