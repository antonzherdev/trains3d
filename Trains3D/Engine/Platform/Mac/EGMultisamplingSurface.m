#import "EGMultisamplingSurface.h"

#import "EGTexture.h"
#import "EGContext.h"

@implementation EGFirstMultisamplingSurface {
    BOOL _depth;
    GLuint _frameBuffer;
    id _depthTexture;
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
        _depthTexture = ((_depth) ? [CNOption applyValue:[EGTexture texture]] : [CNOption none]);
        _texture = ^EGTexture*() {
            EGTexture* t = [EGTexture texture];
            glGetError();
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            glBindTexture(GL_TEXTURE_2D_MULTISAMPLE, t.id);
            glTexImage2DMultisample(GL_TEXTURE_2D_MULTISAMPLE, 4, GL_RGBA, self.size.x, self.size.y, GL_FALSE);
            if(glGetError() != 0) {
                NSString* e = [NSString stringWithFormat:@"Error in texture creation for surface with size %lix%li", self.size.x, self.size.y];
                @throw e;
            }
            glFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, t.id, 0);
            NSInteger status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer color attachment: %li", status];
            if(_depth) {
                glBindTexture(GL_TEXTURE_2D_MULTISAMPLE, ((EGTexture*)([_depthTexture get])).id);
                glTexImage2DMultisample(GL_TEXTURE_2D_MULTISAMPLE, 4, GL_DEPTH_COMPONENT24, self.size.x, self.size.y, GL_FALSE);
                glFramebufferTexture(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, ((EGTexture*)([_depthTexture get])).id, 0);
                NSInteger status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
                if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer depth attachment: %li", status];
            }
            glBindTexture(GL_TEXTURE_2D_MULTISAMPLE, 0);
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
    [EGGlobal.context pushViewport];
    [EGGlobal.context setViewport:geRectIApplyXYWidthHeight(0.0, 0.0, ((float)(self.size.x)), ((float)(self.size.y)))];
}

- (void)unbind {
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
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
    [_multisampling bind];
}

- (void)unbind {
    [_multisampling unbind];
    glBindFramebuffer(GL_READ_FRAMEBUFFER, _multisampling.frameBuffer);
    glBindFramebuffer(GL_DRAW_FRAMEBUFFER, _simple.frameBuffer);
    GEVec2i s = self.size;
    glBlitFramebuffer(0, 0, s.x, s.y, 0, 0, s.x, s.y, GL_COLOR_BUFFER_BIT, GL_NEAREST);
    glBindFramebuffer(GL_READ_FRAMEBUFFER, 0);
    glBindFramebuffer(GL_DRAW_FRAMEBUFFER, 0);
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
    EGViewportSurfaceShader* _shader;
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
        _shader = [EGViewportSurfaceShader instance];
    }

    return self;
}

+ (void)initialize {
    [super initialize];
    _EGViewportSurface_type = [ODClassType classTypeWithCls:[EGViewportSurface class]];
}

- (EGViewportSurfaceShader*)shader {
    return _shader;
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
    if([self needRedraw]) {
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_CULL_FACE);
        [[self shader] drawParam:[EGViewportSurfaceShaderParam viewportSurfaceShaderParamWithTexture:[self texture] z:0.0] mesh:[EGViewportSurface fullScreenMesh]];
        glEnable(GL_CULL_FACE);
        glEnable(GL_DEPTH_TEST);
    } else {
        glBindFramebuffer(GL_READ_FRAMEBUFFER, [((EGSurface*)([[self surface] get])) frameBuffer]);
        GEVec2i s = ((EGSurface*)([[self surface] get])).size;
        GERectI v = [EGGlobal.context viewport];
        glBlitFramebuffer(0, 0, s.x, s.y, geRectIX(v), geRectIY(v), geRectIX2(v), geRectIY2(v), GL_COLOR_BUFFER_BIT, GL_NEAREST);
        glBindFramebuffer(GL_READ_FRAMEBUFFER, 0);
    }
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

