#import "EGSurface.h"

#import "EGTexture.h"
@implementation EGSurface{
    NSUInteger _width;
    NSUInteger _height;
    GLuint _frameBuffer;
    EGTexture* _texture;
}
static ODClassType* _EGSurface_type;
@synthesize width = _width;
@synthesize height = _height;

+ (id)surfaceWithWidth:(NSUInteger)width height:(NSUInteger)height {
    return [[EGSurface alloc] initWithWidth:width height:height];
}

- (id)initWithWidth:(NSUInteger)width height:(NSUInteger)height {
    self = [super init];
    if(self) {
        _width = width;
        _height = height;
        _frameBuffer = egGenFrameBuffer();
        _texture = [EGTexture texture];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSurface_type = [ODClassType classTypeWithCls:[EGSurface class]];
}

- (void)init {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glBindTexture(GL_TEXTURE_2D, _texture.id);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _width, _height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _texture.id, 0);
    glBindTexture(GL_TEXTURE_2D, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

- (void)dealloc {
    egDeleteFrameBuffer(_frameBuffer);
}

- (void)applyDraw:(void(^)())draw {
    [self bind];
    ((void(^)())(draw))();
    [self unbind];
}

- (void)bind {
    glPushAttrib(GL_VIEWPORT_BIT);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glViewport(0, 0, _width, _height);
}

- (void)unbind {
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glPopAttrib();
}

- (void)draw {
}

- (ODClassType*)type {
    return [EGSurface type];
}

+ (ODClassType*)type {
    return _EGSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSurface* o = ((EGSurface*)(other));
    return self.width == o.width && self.height == o.height;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.width;
    hash = hash * 31 + self.height;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"width=%li", self.width];
    [description appendFormat:@", height=%li", self.height];
    [description appendString:@">"];
    return description;
}

@end


