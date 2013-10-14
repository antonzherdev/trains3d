#import "GL.h"


void egSaveTextureToFile(GLuint source, NSString* file) {
    glBindTexture(GL_TEXTURE_2D, source);
    GLfloat width;
    GLfloat height;
    glGetTexLevelParameterfv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, &width);
    glGetTexLevelParameterfv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, &height);
    GLint format;
    glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_INTERNAL_FORMAT, &format);
    BOOL depth = format == GL_DEPTH_COMPONENT32F || format == GL_DEPTH_COMPONENT16 || format == GL_DEPTH_COMPONENT24 || format == GL_DEPTH_COMPONENT32;
    void * data = depth ? calloc((size_t) width*4, (size_t) height) : calloc((size_t) width*4, (size_t) height);

    if(depth) {
        glGetTexImage(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, GL_FLOAT, data);
        unsigned char*dt = data;
        for(int y = 0; y < height; y++)
            for(int x = 0; x < width; x++) {
                unsigned char v = (unsigned char) (255 * (*(float*)dt));
                *dt = v;
                dt++;
                *dt = v;
                dt++;
                *dt = v;
                dt++;
                *dt = 0xff;
                dt++;
            }
    } else {
        glGetTexImage(GL_TEXTURE_2D, 0, GL_BGRA, GL_UNSIGNED_BYTE, data);
    }

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
