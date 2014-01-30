#import "GL.h"
#import "EGPlatformPlat.h"
#import <ImageIO/ImageIO.h>


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
        return ((NSUInteger) pVersion[18] - '0')*100 + (pVersion[20] - '0') *10 + (pVersion[21] == 0 ? 0 : pVersion[21]  - '0');
    }
    return ((NSUInteger) pVersion[0] - '0')*100 + (pVersion[2] - '0') *10 + pVersion[3]  - '0';
}

GEVec2 egLoadTextureFromFile(GLuint target, NSString* file, GLenum magFilter, GLenum minFilter) {
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:file];
    CGImageSourceRef myImageSourceRef = CGImageSourceCreateWithURL(url, NULL);
    CGImageRef myImageRef = CGImageSourceCreateImageAtIndex (myImageSourceRef, 0, NULL);

    size_t width = CGImageGetWidth(myImageRef);
    size_t height = CGImageGetHeight(myImageRef);
    CGRect rect = {{0, 0}, {width, height}};
    void * myData = calloc(width * 4, height);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef myBitmapContext = CGBitmapContextCreate (myData,
            width, height, 8,
            width*4, space,
            kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);


    GEVec2 size = GEVec2Make(width, height);
    CGContextSetBlendMode(myBitmapContext, kCGBlendModeCopy);
    CGContextDrawImage(myBitmapContext, rect, myImageRef);
    egLoadTextureFromData(target, magFilter, minFilter, size, myData);

    CGContextRelease(myBitmapContext);
    CFRelease(myImageSourceRef);
    CFRelease(myImageRef);
    CFRelease(space);
    free(myData);
    egCheckError();
    return size;

}

void egLoadTextureFromData(GLuint target, GLenum magFilter, GLenum minFilter, GEVec2 size, void *myData) {
    glBindTexture(GL_TEXTURE_2D, target);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magFilter);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)size.x, (GLsizei)size.y, 0, GL_BGRA, GL_UNSIGNED_BYTE, myData);
    if(minFilter == GL_LINEAR_MIPMAP_LINEAR || minFilter == GL_LINEAR_MIPMAP_NEAREST
            || minFilter == GL_NEAREST_MIPMAP_LINEAR || minFilter == GL_NEAREST_MIPMAP_NEAREST)
    {
        glGenerateMipmap(GL_TEXTURE_2D);
    }
    glBindTexture(GL_TEXTURE_2D, 0);
}

