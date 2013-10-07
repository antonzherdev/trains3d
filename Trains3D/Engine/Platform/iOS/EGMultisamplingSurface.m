#import "EGMultisamplingSurface.h"

#import "EGTexture.h"
#import "EGContext.h"

@implementation EGFirstMultisamplingSurface {
    BOOL _depth;
    GLuint _frameBuffer;
    GLuint _depthRenderBuffer;
    EGTexture* _texture;
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
        _depthRenderBuffer = ((_depth) ? egGenRenderBuffer() : 0);
        _texture = ^EGTexture*() {
            EGTexture* t = [EGTexture texture];
            glGetError();
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            glBindTexture(GL_TEXTURE_2D, t.id);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, self.size.x, self.size.y, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
            if(glGetError() != 0) {
                NSString* e = [NSString stringWithFormat:@"Error in texture creation for surface with size %lix%li", self.size.x, self.size.y];
                @throw e;
            }
            glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, t.id, 0);
            NSInteger status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer color attachment: %li", status];
            if(_depth) {
                glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
                glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT, self.size.x, self.size.y);
                glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
                NSInteger status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
                if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer depth attachment: %li", status];
            }
            glBindTexture(GL_TEXTURE_2D, 0);
            glBindFramebuffer(GL_FRAMEBUFFER, 0);
            return t;
        }();
    }

    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFirstMultisamplingSurface_type = [ODClassType classTypeWithCls:[EGFirstMultisamplingSurface class]];
}

- (void)dealloc {
    egDeleteFrameBuffer(_frameBuffer);
}

- (void)bind {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glViewport(0, 0, self.size.x, self.size.y);
}

- (void)unbind {
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
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
    GLuint _frameBuffer;
    GLuint _depthRenderBuffer;
    EGTexture* _texture;
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
        _frameBuffer = egGenFrameBuffer();
        _depthRenderBuffer = ((_depth) ? egGenRenderBuffer() : 0);
        _texture = ^EGTexture*() {
            EGTexture* t = [EGTexture texture];
            glGetError();
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            glBindTexture(GL_TEXTURE_2D, t.id);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, self.size.x, self.size.y, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
            if(glGetError() != 0) {
                NSString* e = [NSString stringWithFormat:@"Error in texture creation for surface with size %lix%li", self.size.x, self.size.y];
                @throw e;
            }
            glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, t.id, 0);
            NSInteger status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer color attachment: %li", status];
            if(_depth) {
                glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
                glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.size.x, self.size.y);
                glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
                status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
                if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer depth attachment: %li", status];
            }
            glBindTexture(GL_TEXTURE_2D, 0);
            glBindFramebuffer(GL_FRAMEBUFFER, 0);
            return t;
        }();
    }
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMultisamplingSurface_type = [ODClassType classTypeWithCls:[EGMultisamplingSurface class]];
}

- (void)bind {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glViewport(0, 0, self.size.x, self.size.y);
}

- (void)unbind {
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

- (GLint)frameBuffer {
    return _frameBuffer;
}

- (EGTexture *)texture {
    return _texture;
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
    CNLazy* __lazy_shader;
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
        __lazy_shader = [CNLazy lazyWithF:^EGViewportSurfaceShader*() {
            return [EGViewportSurfaceShader viewportSurfaceShader];
        }];
    }

    return self;
}

+ (void)initialize {
    [super initialize];
    _EGViewportSurface_type = [ODClassType classTypeWithCls:[EGViewportSurface class]];
}

- (EGViewportSurfaceShader*)shader {
    return ((EGViewportSurfaceShader*)([__lazy_shader get]));
}

- (EGSurface*)createSurface {
    if(_multisampling) return [EGMultisamplingSurface multisamplingSurfaceWithSize:[EGGlobal.context viewport].size depth:_depth];
    else return [EGSimpleSurface simpleSurfaceWithSize:[EGGlobal.context viewport].size depth:_depth];
}

- (void)drawWithZ:(float)z {
    glDisable(GL_CULL_FACE);
    [[self shader] drawParam:[EGViewportSurfaceShaderParam viewportSurfaceShaderParamWithTexture:[self texture] z:z] mesh:[EGViewportSurface fullScreenMesh]];
    glEnable(GL_CULL_FACE);
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
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    [[self shader] drawParam:[EGViewportSurfaceShaderParam viewportSurfaceShaderParamWithTexture:[self texture] z:0.0] mesh:[EGViewportSurface fullScreenMesh]];
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
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
