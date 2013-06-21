#import "EGTexture.h"
#import <OpenGL/glu.h>

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

- (void)dealloc {
    glDeleteTextures(1, &_id);
}


+ (EGTexture*)loadFromFile:(NSString*)file {
    file = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: file];

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
            kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);
    CGContextSetBlendMode(myBitmapContext, kCGBlendModeCopy);
    CGContextDrawImage(myBitmapContext, rect, myImageRef);
    CGContextRelease(myBitmapContext);
    glPixelStorei(GL_UNPACK_ROW_LENGTH, width);
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glGenTextures(1, &id);
    glBindTexture(GL_TEXTURE_RECTANGLE_ARB, id);
    gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA, width, height, GL_BGRA_EXT, GL_UNSIGNED_BYTE, myData);
    glTexParameteri   ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri   ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR );

    free(myData);
    return [EGTexture textureWithId:id size:CGSizeMake(width, height)];
}

- (void)bind {
    glBindTexture( GL_TEXTURE_2D, _id);
}

@end


