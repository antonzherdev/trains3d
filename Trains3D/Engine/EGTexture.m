#import "EGTexture.h"

@implementation EGTexture{
    GLuint _id;
    CGSize _size;
}
@synthesize id = _id;
@synthesize size = _size;

+ (id)textureWithId:(GLuint)id size:(CGSize)size {
    return [[EGTexture alloc] initWithId:id size:size];
}

- (id)initWithId:(GLuint)id size:(CGSize)size {
    self = [super init];
    if(self) {
        _id = id;
        _size = size;
    }
    
    return self;
}

+ (EGTexture*)loadFromFile:(NSString*)file {
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:file];
    CGImageSourceRef myImageSourceRef = CGImageSourceCreateWithURL(url, NULL);
    CGImageRef myImageRef = CGImageSourceCreateImageAtIndex (myImageSourceRef, 0, NULL);
    GLuint id;
    size_t width = CGImageGetWidth(myImageRef);
    size_t height = CGImageGetHeight(myImageRef);
    CGRect rect = {{0, 0}, {width, height}};
    void * myData = calloc(width * 4, height);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef myBitmapContext = CGBitmapContextCreate (myData,
            width, height, 8,
            width*4, space,
            kCGBitmapByteOrder32Host |
                    kCGImageAlphaPremultipliedFirst);
    CGContextSetBlendMode(myBitmapContext, kCGBlendModeCopy);
    CGContextDrawImage(myBitmapContext, rect, myImageRef);
    CGContextRelease(myBitmapContext);
    glPixelStorei(GL_UNPACK_ROW_LENGTH, width);
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glGenTextures(1, &id);
    glBindTexture(GL_TEXTURE_RECTANGLE_ARB, id);
    glTexParameteri(GL_TEXTURE_RECTANGLE_ARB,
            GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGBA8, width, height,
            0, GL_BGRA_EXT, GL_UNSIGNED_INT_8_8_8_8_REV, myData);
    free(myData);
    return [EGTexture textureWithId:id size:CGSizeMake(width, height)];
}

@end


