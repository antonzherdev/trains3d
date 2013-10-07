#import "GL.h"

id egGetProgramError(GLuint program) {
    GLint linkSuccess;
    glGetProgramiv(program, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE)
    {
        NSLog(@"GLSL Program Error");
        GLchar messages[1024];
        glGetProgramInfoLog(program, sizeof(messages), 0, &messages[0]);
        return [NSString stringWithCString:messages encoding:NSUTF8StringEncoding];
    }
    return [CNOption none];
}

void egShaderSource(GLuint shader, NSString* source) {
    char const *s = [source cStringUsingEncoding:NSUTF8StringEncoding];
    glShaderSource(shader, 1, &s, 0);
}

id egGetShaderError(GLuint shader) {
    GLint compileSuccess;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE)
    {
        NSLog(@"GLSL Program Error");
        GLchar messages[1024];
        glGetShaderInfoLog(shader, sizeof(messages), 0, &messages[0]);
        return [CNOption someValue:[NSString stringWithCString:messages encoding:NSUTF8StringEncoding]];
    }
    return [CNOption none];
}


NSUInteger egGLSLVersion() {
    const GLubyte* pVersion = glGetString(GL_SHADING_LANGUAGE_VERSION);
    if(pVersion == nil) return 100;
    if(pVersion[0] == 'O' && pVersion[1] == 'p' && pVersion[15] == 'E') {
        return ((NSUInteger) pVersion[18] - '0')*100 + (pVersion[20] - '0') *10 + pVersion[21]  - '0';
    }
    return ((NSUInteger) pVersion[0] - '0')*100 + (pVersion[2] - '0') *10 + pVersion[3]  - '0';
}