#import "GL.h"
#import "GEMat4.h"

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
        return [NSString stringWithCString:messages encoding:NSUTF8StringEncoding];
    }
    return [CNOption none];
}

GEVec2 egLoadTextureFromFile(GLuint target, NSString* file) {
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
    CFRelease(space);

    CGContextSetBlendMode(myBitmapContext, kCGBlendModeCopy);
    CGContextDrawImage(myBitmapContext, rect, myImageRef);
    CGContextRelease(myBitmapContext);
    glPixelStorei(GL_UNPACK_ROW_LENGTH, (GLint)width);
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glBindTexture(GL_TEXTURE_2D, target);
//    glTexParameteri   ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
//    glTexParameteri   ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_BGRA, GL_UNSIGNED_BYTE, myData);

//    glTexParameteri   ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR );
//    gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA, (GLsizei)width, (GLsizei)height, GL_BGRA_EXT, GL_UNSIGNED_BYTE, myData);

    CFRelease(myImageSourceRef);
    CFRelease(myImageRef);
    free(myData);
    return GEVec2Make(width, height);

}


void egSaveTextureToFile(GLuint source, NSString* file) {
    glBindTexture(GL_TEXTURE_2D, source);
    GLfloat width;
    GLfloat height;
    glGetTexLevelParameterfv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, &width);
    glGetTexLevelParameterfv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, &height);
    void * data = calloc((size_t) (width * 4), (size_t) height);
    glGetTexImage(GL_TEXTURE_2D, 0, GL_BGRA, GL_UNSIGNED_BYTE, data);

    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate (data,
            (size_t) width, (size_t) height, 8,
            (size_t) (width*4), space,
            kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);
    CGContextRotateCTM(bitmapContext, M_PI);
    CFRelease(space);
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:file];
    CGImageRef image = CGBitmapContextCreateImage(bitmapContext);
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);

    CFStringRef myKeys[1];
    CFTypeRef   myValues[1];
    int orientation = 4;
    CFDictionaryRef myOptions = NULL;
    myKeys[0] = kCGImagePropertyOrientation;
    myValues[0] = CFNumberCreate(NULL, kCFNumberIntType, &orientation);
    myOptions = CFDictionaryCreate( NULL, (const void **)myKeys, myValues, 1,
            &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CGImageDestinationAddImage(destination, image, myOptions);
    CFRelease(myOptions);

    NSLog(@"Saving texture to %@", url);
    if (!CGImageDestinationFinalize(destination)) {
        @throw [NSString stringWithFormat:@"Failed to write image to %@", file];
    }

    CFRelease(destination);
    CFRelease(image);
    CGContextRelease(bitmapContext);

    glBindTexture(GL_TEXTURE_2D, 0);
}