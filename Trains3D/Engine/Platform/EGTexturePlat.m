#import "GL.h"
#import "EGTexturePlat.h"
#import "EGContext.h"
#import "EGTexture.h"
#import <ImageIO/ImageIO.h>

GEVec2 egLoadTextureFromFile(GLuint target, NSString* file, EGTextureFilter* filter) {
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

    CGContextRelease(myBitmapContext);
    CFRelease(myImageSourceRef);
    CFRelease(myImageRef);
    CFRelease(space);

    egLoadTextureFromData(target, filter, size, myData);
    free(myData);
    egCheckError();
    return size;

}

void egLoadTextureFromData(GLuint target, EGTextureFilter* filter, GEVec2 size, void *myData) {
    unsigned int magFilter = filter.magFilter;
    unsigned int minFilter = filter.minFilter;
    [[EGGlobal context] bindTextureTextureId:target];
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magFilter);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)size.x, (GLsizei)size.y, 0, GL_BGRA, GL_UNSIGNED_BYTE, myData);
    if(minFilter == GL_LINEAR_MIPMAP_LINEAR || minFilter == GL_LINEAR_MIPMAP_NEAREST
            || minFilter == GL_NEAREST_MIPMAP_LINEAR || minFilter == GL_NEAREST_MIPMAP_NEAREST)
    {
        glGenerateMipmap(GL_TEXTURE_2D);
    }
}

void egSaveTextureToFile(GLuint source, NSString* file) {
#if TARGET_OS_IPHONE
#else
    [[EGGlobal context] bindTextureTextureId:source];
    GLfloat width;
    GLfloat height;
    glGetTexLevelParameterfv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, &width);
    glGetTexLevelParameterfv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, &height);
    GLint format;
    glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_INTERNAL_FORMAT, &format);
    BOOL depth = format == GL_DEPTH_COMPONENT32F || format == GL_DEPTH_COMPONENT16 || format == GL_DEPTH_COMPONENT24 || format == GL_DEPTH_COMPONENT32;
    void * data = calloc((size_t) width*4, (size_t) height);

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
#endif
}

void egInitShadowTexture(GEVec2i size) {
#if TARGET_OS_IPHONE
    glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, size.x, size.y, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_SHORT, 0);
#else
    glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT16, (GLsizei)size.x, (GLsizei)size.y,
            0, GL_DEPTH_COMPONENT, GL_FLOAT, 0);
#endif
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    if([[EGGlobal settings] shadowType] == [EGShadowType shadow2d]) {
#if TARGET_OS_IPHONE
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC_EXT, GL_LEQUAL);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_MODE_EXT, GL_COMPARE_REF_TO_TEXTURE_EXT);
#else
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC, GL_LEQUAL);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);
#endif
    }
}