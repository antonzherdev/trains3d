#import "EGMultisamplingSurface.h"

#import "EGTexture.h"
#import "EGContext.h"
#import "EGMesh.h"

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

        glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
        glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_RGBA8_OES, self.size.x, self.size.y);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);

        egCheckError();
        NSInteger status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer color attachment: %ld", (long)status];
        if(depth) {
            glGenRenderbuffers(1, &_depthRenderBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
            glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_DEPTH_COMPONENT16,  self.size.x, self.size.y);
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
            egCheckError();
            status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer depth attachment: %ld", (long)status];
        }
        [EGGlobal.context restoreDefaultFramebuffer];
    }

    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFirstMultisamplingSurface_type = [ODClassType classTypeWithCls:[EGFirstMultisamplingSurface class]];
}

- (void)dealloc {
    egDeleteFrameBuffer(_frameBuffer);
    egDeleteRenderBuffer(_renderBuffer);
    if(_depth)egDeleteRenderBuffer(_depthRenderBuffer);
}

- (void)bind {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    [EGGlobal.context pushViewport];
    [EGGlobal.context setViewport:geRectIApplyXYWidthHeight(0.0, 0.0, ((float)(self.size.x)), ((float)(self.size.y)))];
}

- (void)unbind {
    [EGGlobal.context restoreDefaultFramebuffer];
    [EGGlobal.context popViewport];
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
    GLint _defaultDrawFBO;
    GLint _defaultReadFBO;
}
static ODClassType* _EGMultisamplingSurface_type;
@synthesize depth = _depth;

+ (id)multisamplingSurfaceWithSize:(GEVec2i)size depth:(BOOL)depth {
    return [[EGMultisamplingSurface alloc] initWithSize:size depth:depth];
}

- (id)initWithSize:(GEVec2i)size depth:(BOOL)depth {
    self = [super initWithSize:size];
    if(self) {
        _depth = depth;
        _multisampling = [EGFirstMultisamplingSurface firstMultisamplingSurfaceWithSize:self.size depth:_depth];
        _simple = [EGSimpleSurface simpleSurfaceWithSize:self.size depth:NO];
    }

    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMultisamplingSurface_type = [ODClassType classTypeWithCls:[EGMultisamplingSurface class]];
}

- (void)bind {
    glGetIntegerv(GL_DRAW_FRAMEBUFFER_BINDING_APPLE, &_defaultDrawFBO);
    glGetIntegerv(GL_READ_FRAMEBUFFER_BINDING_APPLE, &_defaultReadFBO);
    [_multisampling bind];
}

- (void)unbind {
    [_multisampling unbind];
    glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, _simple.frameBuffer);
    glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, _multisampling.frameBuffer);
    glResolveMultisampleFramebufferAPPLE();
    glFlush();
    const GLenum discards[]  = {GL_COLOR_ATTACHMENT0, GL_DEPTH_ATTACHMENT};
    glDiscardFramebufferEXT(GL_READ_FRAMEBUFFER_APPLE, 2, discards);
//    const GLenum discards2[]  = {GL_COLOR_ATTACHMENT0};
//    glDiscardFramebufferEXT(GL_DRAW_FRAMEBUFFER_APPLE, 1, discards2);
    glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, (GLuint) _defaultDrawFBO);
    glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, (GLuint) _defaultReadFBO);
    egCheckError();
}

- (GLint)frameBuffer {
    return _simple.frameBuffer;
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

+ (id)viewportSurfaceWithDepth:(BOOL)depth multisampling:(BOOL)multisampling {
    return [[EGViewportSurface alloc] initWithDepth:depth multisampling:multisampling];
}

- (id)initWithDepth:(BOOL)depth multisampling:(BOOL)multisampling {
    self = [super init];
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

- (EGSurface*)createSurface {
    if(_multisampling) return [EGMultisamplingSurface multisamplingSurfaceWithSize:[EGGlobal.context viewport].size depth:_depth];
    else return [EGSimpleSurface simpleSurfaceWithSize:[EGGlobal.context viewport].size depth:_depth];
}

- (void)drawWithZ:(float)z {
    [EGGlobal.context.cullFace disabledF:^void() {
        [[EGViewportSurface fullScreenVao] drawParam:[EGViewportSurfaceShaderParam viewportSurfaceShaderParamWithTexture:[self texture] z:z]];
    }];
}

- (EGTexture*)texture {
    EGSurface* __case__ = ((EGSurface*)([[self surface] get]));
    BOOL __incomplete__ = YES;
    EGTexture* __result__;
    if(__incomplete__) {
        BOOL __ok__ = YES;
        EGSimpleSurface* i;
        if([__case__ isKindOfClass:[EGSimpleSurface class]]) i = ((EGSimpleSurface*)(__case__));
        else __ok__ = NO;
        if(__ok__) {
            __result__ = i.texture;
            __incomplete__ = NO;
        }
    }
    if(__incomplete__) {
        BOOL __ok__ = YES;
        EGMultisamplingSurface* i;
        if([__case__ isKindOfClass:[EGMultisamplingSurface class]]) i = ((EGMultisamplingSurface*)(__case__));
        else __ok__ = NO;
        if(__ok__) {
            __result__ = [i texture];
            __incomplete__ = NO;
        }
    }
    if(__incomplete__) @throw @"Case incomplete";
    return __result__;
}

- (void)draw {
    if([[self surface] isEmpty]) return ;
    [EGGlobal.context.depthTest disabledF:^void() {
        [EGGlobal.context.cullFace disabledF:^void() {
            [[EGViewportSurface fullScreenVao] drawParam:[EGViewportSurfaceShaderParam viewportSurfaceShaderParamWithTexture:[self texture] z:0.0]];
        }];
    }];
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

