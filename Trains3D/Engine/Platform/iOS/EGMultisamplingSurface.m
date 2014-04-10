#import "EGMultisamplingSurface.h"

#import "EGTexture.h"
#import "EGContext.h"
#import "EGMesh.h"
#import "EGVertexArray.h"

@implementation EGFirstMultisamplingSurface {
    BOOL _depth;
    GLuint _frameBuffer;
    GLuint _renderBuffer;
    GLuint _depthRenderBuffer;
}
static ODClassType* _EGFirstMultisamplingSurface_type;
@synthesize depth = _depth;
@synthesize frameBuffer = _frameBuffer;

+ (id)firstMultisamplingSurfaceWithSize:(GEVec2i)size depth:(BOOL)depth {
    return [[EGFirstMultisamplingSurface alloc] initWithSize:size depth:depth];
}

- (id)initWithSize:(GEVec2i)size depth:(BOOL)depth {
    self = [super initWithSize:size];
    if(self) {
        _depth = depth;
        _frameBuffer = egGenFrameBuffer();
        _renderBuffer = egGenRenderBuffer();
        _depthRenderBuffer = ((_depth) ? egGenRenderBuffer() : 0);
        glGenFramebuffers(1, &_frameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);

        [[EGGlobal context] bindRenderBufferId:_renderBuffer];
        glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_RGBA8_OES, self.size.x, self.size.y);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);

        egCheckError();
        NSInteger status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer color attachment: %ld", (long)status];
        if(depth) {
            glGenRenderbuffers(1, &_depthRenderBuffer);
            [[EGGlobal context] bindRenderBufferId:_depthRenderBuffer];
            glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_DEPTH_COMPONENT16,  self.size.x, self.size.y);
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
            egCheckError();
            status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer depth attachment: %ld", (long)status];
        }
    }

    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFirstMultisamplingSurface_type = [ODClassType classTypeWithCls:[EGFirstMultisamplingSurface class]];
}

- (void)dealloc {
    egDeleteFrameBuffer(_frameBuffer);
    [[EGGlobal context] deleteRenderBufferId:_renderBuffer];
    if(_depth) [[EGGlobal context] deleteRenderBufferId:_depthRenderBuffer];
}

- (void)bind {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    [EGGlobal.context setViewport:geRectIApplyXYWidthHeight(0.0, 0.0, ((float)(self.size.x)), ((float)(self.size.y)))];
}

- (void)unbind {
}

- (ODClassType*)type {
    return [EGFirstMultisamplingSurface type];
}

+ (ODClassType*)type {
    return _EGFirstMultisamplingSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGFirstMultisamplingSurface * o = ((EGFirstMultisamplingSurface *)(other));
    return GEVec2iEq(self.size, o.size) && self.depth == o.depth;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.size);
    hash = hash * 31 + self.depth;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%@", GEVec2iDescription(self.size)];
    [description appendFormat:@", depth=%d", self.depth];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMultisamplingSurface{
    BOOL _depth;
    EGFirstMultisamplingSurface * _multisampling;
    EGSimpleSurface* _simple;
}
static ODClassType* _EGMultisamplingSurface_type;
@synthesize depth = _depth;

+ (id)multisamplingSurfaceWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth{
    return [[EGMultisamplingSurface alloc] initWithRenderTarget:renderTarget depth:depth];
}

- (id)initWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth {
    self = [super initWithRenderTarget:renderTarget];
    if(self) {
        _depth = depth;
        _multisampling = [EGFirstMultisamplingSurface firstMultisamplingSurfaceWithSize:self.size depth:_depth];
        _simple = [EGSimpleSurface simpleSurfaceWithRenderTarget:renderTarget depth:NO];
    }

    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMultisamplingSurface_type = [ODClassType classTypeWithCls:[EGMultisamplingSurface class]];
}

- (void)bind {
    [_multisampling bind];
}

- (void)unbind {
//    glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, _multisampling.frameBuffer);
    glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, _simple.frameBuffer);
    glResolveMultisampleFramebufferAPPLE();
    const GLenum discards[]  = {GL_COLOR_ATTACHMENT0, GL_DEPTH_ATTACHMENT};
    glDiscardFramebufferEXT(GL_READ_FRAMEBUFFER_APPLE, 2, discards);
    [_multisampling unbind];
//    const GLenum discards2[]  = {GL_COLOR_ATTACHMENT0};
//    glDiscardFramebufferEXT(GL_DRAW_FRAMEBUFFER_APPLE, 1, discards2);
    egCheckError();
}

- (GLint)frameBuffer {
    return _multisampling.frameBuffer;
}

- (EGTexture*)texture {
    return _simple.texture;
}

- (ODClassType*)type {
    return [EGMultisamplingSurface type];
}

+ (ODClassType*)type {
    return _EGMultisamplingSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMultisamplingSurface* o = ((EGMultisamplingSurface*)(other));
    return GEVec2iEq(self.size, o.size) && self.depth == o.depth;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.size);
    hash = hash * 31 + self.depth;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%@", GEVec2iDescription(self.size)];
    [description appendFormat:@", depth=%d", self.depth];
    [description appendString:@">"];
    return description;
}
@end


@implementation EGViewportSurface{
    BOOL _depth;
    BOOL _multisampling;
}
static ODClassType* _EGViewportSurface_type;
@synthesize depth = _depth;
@synthesize multisampling = _multisampling;

+ (id)viewportSurfaceWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget depth:(BOOL)depth multisampling:(BOOL)multisampling {
    return [[EGViewportSurface alloc] initWithCreateRenderTarget:createRenderTarget depth:depth multisampling:multisampling];
}

- (id)initWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget depth:(BOOL)depth multisampling:(BOOL)multisampling {
    self = [super initWithCreateRenderTarget:createRenderTarget];
    if(self) {
        _depth = depth;
        _multisampling = multisampling;
    }

    return self;
}

+ (void)initialize {
    [super initialize];
    _EGViewportSurface_type = [ODClassType classTypeWithCls:[EGViewportSurface class]];
}

- (EGRenderTargetSurface*)createSurface {
    EGSurfaceRenderTarget *renderTarget = [self renderTarget];
    if(_multisampling) return [EGMultisamplingSurface multisamplingSurfaceWithRenderTarget:renderTarget depth:_depth];
    else return [EGSimpleSurface simpleSurfaceWithRenderTarget:renderTarget depth:_depth];
}

- (void)drawWithZ:(float)z {
    unsigned int old = [EGGlobal.context.cullFace disable];
    [[EGViewportSurface fullScreenVao] drawParam:[EGViewportSurfaceShaderParam viewportSurfaceShaderParamWithTexture:[self texture] z:z]];
    if(old != GL_NONE) [EGGlobal.context.cullFace setValue:old];
}

- (void)draw {
    if([self surface] == nil) return ;
    BOOL ch = [EGGlobal.context.depthTest disable];
    unsigned int old = [EGGlobal.context.cullFace disable];
    if(old != GL_NONE) [EGGlobal.context.cullFace setValue:old];
    if(ch) [[EGGlobal context].depthTest enable];
}

- (ODClassType*)type {
    return [EGViewportSurface type];
}

+ (ODClassType*)type {
    return _EGViewportSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

+ (EGViewportSurface *)toTextureDepth:(BOOL)depth multisampling:(BOOL)multisampling {
    return [EGViewportSurface viewportSurfaceWithCreateRenderTarget:^EGSurfaceRenderTarget *(GEVec2i i) {
        return [EGSurfaceRenderTargetTexture applySize:i];
    } depth:depth multisampling:multisampling];
}

+ (EGViewportSurface *)toRenderBufferDepth:(BOOL)depth multisampling:(BOOL)multisampling {
    return [EGViewportSurface viewportSurfaceWithCreateRenderTarget:^EGSurfaceRenderTarget *(GEVec2i i) {
        return [EGSurfaceRenderTargetRenderBuffer applySize:i];
    } depth:depth multisampling:multisampling];
}


- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGViewportSurface* o = ((EGViewportSurface*)(other));
    return self.depth == o.depth && self.multisampling == o.multisampling;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.depth;
    hash = hash * 31 + self.multisampling;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"depth=%d", self.depth];
    [description appendFormat:@", multisampling=%d", self.multisampling];
    [description appendString:@">"];
    return description;
}
@end

