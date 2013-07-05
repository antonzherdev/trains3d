#import "EGTexture.h"
#import "EGContext.h"
#import <OpenGL/glu.h>

@implementation EGTexture{
    BOOL _loaded;
    GLuint _id;
    CGSize _size;
    NSString * _file;
}
@synthesize file = _file;

- (id)initWithFile:(NSString *)file {
    self = [super init];
    if (self) {
        _file = file;
        _loaded = NO;
    }

    return self;
}

+ (id)textureWithFile:(NSString *)file {
    return [[self alloc] initWithFile:file];
}


- (void)dealloc {
    glDeleteTextures(1, &_id);
}


- (void)load {
    NSString* file = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: _file];

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
    CGContextSetBlendMode(myBitmapContext, kCGBlendModeCopy);
    CGContextDrawImage(myBitmapContext, rect, myImageRef);
    CGContextRelease(myBitmapContext);
    glPixelStorei(GL_UNPACK_ROW_LENGTH, width);
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glGenTextures(1, &_id);
    glBindTexture(GL_TEXTURE_RECTANGLE_ARB, _id);
    gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA, width, height, GL_BGRA_EXT, GL_UNSIGNED_BYTE, myData);
    glTexParameteri   ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri   ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR );

    _size = CGSizeMake(width, height);

    free(myData);
    _loaded = YES;
}

- (void)bind {
    if(!_loaded) [self load];
    glBindTexture( GL_TEXTURE_2D, _id);
}

- (void)with:(void (^)())f {
    if(!_loaded) [self load];
    glBindTexture( GL_TEXTURE_2D, _id);
    glEnable( GL_TEXTURE_2D );
    @try {
        f();
    } @finally {
        glDisable(GL_TEXTURE_2D);
    }
}


- (CGSize) size {
    if(!_loaded) [self load];
    return _size;
}

@end


