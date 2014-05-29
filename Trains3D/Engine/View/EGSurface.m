#import "EGSurface.h"

#import "EGTexture.h"
#import "EGContext.h"
#import "GL.h"
#import "EGDirector.h"
@implementation EGSurface
static CNClassType* _EGSurface_type;
@synthesize size = _size;

+ (instancetype)surfaceWithSize:(GEVec2i)size {
    return [[EGSurface alloc] initWithSize:size];
}

- (instancetype)initWithSize:(GEVec2i)size {
    self = [super init];
    if(self) _size = size;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSurface class]) _EGSurface_type = [CNClassType classTypeWithCls:[EGSurface class]];
}

- (void)applyDraw:(void(^)())draw {
    [self bind];
    draw();
    [self unbind];
}

- (void)bind {
    @throw @"Method bind is abstract";
}

- (void)unbind {
    @throw @"Method unbind is abstract";
}

- (int)frameBuffer {
    @throw @"Method frameBuffer is abstract";
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Surface(%@)", geVec2iDescription(_size)];
}

- (CNClassType*)type {
    return [EGSurface type];
}

+ (CNClassType*)type {
    return _EGSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGSurfaceRenderTarget
static CNClassType* _EGSurfaceRenderTarget_type;
@synthesize size = _size;

+ (instancetype)surfaceRenderTargetWithSize:(GEVec2i)size {
    return [[EGSurfaceRenderTarget alloc] initWithSize:size];
}

- (instancetype)initWithSize:(GEVec2i)size {
    self = [super init];
    if(self) _size = size;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSurfaceRenderTarget class]) _EGSurfaceRenderTarget_type = [CNClassType classTypeWithCls:[EGSurfaceRenderTarget class]];
}

- (void)link {
    @throw @"Method link is abstract";
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SurfaceRenderTarget(%@)", geVec2iDescription(_size)];
}

- (CNClassType*)type {
    return [EGSurfaceRenderTarget type];
}

+ (CNClassType*)type {
    return _EGSurfaceRenderTarget_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGSurfaceRenderTargetTexture
static CNClassType* _EGSurfaceRenderTargetTexture_type;
@synthesize texture = _texture;

+ (instancetype)surfaceRenderTargetTextureWithTexture:(EGTexture*)texture size:(GEVec2i)size {
    return [[EGSurfaceRenderTargetTexture alloc] initWithTexture:texture size:size];
}

- (instancetype)initWithTexture:(EGTexture*)texture size:(GEVec2i)size {
    self = [super initWithSize:size];
    if(self) _texture = texture;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSurfaceRenderTargetTexture class]) _EGSurfaceRenderTargetTexture_type = [CNClassType classTypeWithCls:[EGSurfaceRenderTargetTexture class]];
}

+ (EGSurfaceRenderTargetTexture*)applySize:(GEVec2i)size {
    EGEmptyTexture* t = [EGEmptyTexture emptyTextureWithSize:geVec2ApplyVec2i(size)];
    [EGGlobal.context bindTextureTexture:t];
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, ((int)(GL_CLAMP_TO_EDGE)));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, ((int)(GL_CLAMP_TO_EDGE)));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, ((int)(GL_NEAREST)));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, ((int)(GL_NEAREST)));
    glTexImage2D(GL_TEXTURE_2D, 0, ((int)(GL_RGBA)), ((int)(size.x)), ((int)(size.y)), 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    return [EGSurfaceRenderTargetTexture surfaceRenderTargetTextureWithTexture:t size:size];
}

- (void)link {
    egFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, [_texture id], 0);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SurfaceRenderTargetTexture(%@)", _texture];
}

- (CNClassType*)type {
    return [EGSurfaceRenderTargetTexture type];
}

+ (CNClassType*)type {
    return _EGSurfaceRenderTargetTexture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGSurfaceRenderTargetRenderBuffer
static CNClassType* _EGSurfaceRenderTargetRenderBuffer_type;
@synthesize renderBuffer = _renderBuffer;

+ (instancetype)surfaceRenderTargetRenderBufferWithRenderBuffer:(unsigned int)renderBuffer size:(GEVec2i)size {
    return [[EGSurfaceRenderTargetRenderBuffer alloc] initWithRenderBuffer:renderBuffer size:size];
}

- (instancetype)initWithRenderBuffer:(unsigned int)renderBuffer size:(GEVec2i)size {
    self = [super initWithSize:size];
    if(self) _renderBuffer = renderBuffer;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSurfaceRenderTargetRenderBuffer class]) _EGSurfaceRenderTargetRenderBuffer_type = [CNClassType classTypeWithCls:[EGSurfaceRenderTargetRenderBuffer class]];
}

+ (EGSurfaceRenderTargetRenderBuffer*)applySize:(GEVec2i)size {
    unsigned int buf = egGenRenderBuffer();
    [EGGlobal.context bindRenderBufferId:buf];
    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8_OES, ((int)(size.x)), ((int)(size.y)));
    return [EGSurfaceRenderTargetRenderBuffer surfaceRenderTargetRenderBufferWithRenderBuffer:buf size:size];
}

- (void)link {
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
}

- (void)dealloc {
    [EGGlobal.context deleteRenderBufferId:_renderBuffer];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SurfaceRenderTargetRenderBuffer(%u)", _renderBuffer];
}

- (CNClassType*)type {
    return [EGSurfaceRenderTargetRenderBuffer type];
}

+ (CNClassType*)type {
    return _EGSurfaceRenderTargetRenderBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGRenderTargetSurface
static CNClassType* _EGRenderTargetSurface_type;
@synthesize renderTarget = _renderTarget;

+ (instancetype)renderTargetSurfaceWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget {
    return [[EGRenderTargetSurface alloc] initWithRenderTarget:renderTarget];
}

- (instancetype)initWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget {
    self = [super initWithSize:renderTarget.size];
    if(self) _renderTarget = renderTarget;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGRenderTargetSurface class]) _EGRenderTargetSurface_type = [CNClassType classTypeWithCls:[EGRenderTargetSurface class]];
}

- (EGTexture*)texture {
    return ((EGSurfaceRenderTargetTexture*)(_renderTarget)).texture;
}

- (unsigned int)renderBuffer {
    return ((EGSurfaceRenderTargetRenderBuffer*)(_renderTarget)).renderBuffer;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RenderTargetSurface(%@)", _renderTarget];
}

- (CNClassType*)type {
    return [EGRenderTargetSurface type];
}

+ (CNClassType*)type {
    return _EGRenderTargetSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGSimpleSurface
static CNClassType* _EGSimpleSurface_type;
@synthesize depth = _depth;
@synthesize frameBuffer = _frameBuffer;

+ (instancetype)simpleSurfaceWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth {
    return [[EGSimpleSurface alloc] initWithRenderTarget:renderTarget depth:depth];
}

- (instancetype)initWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth {
    self = [super initWithRenderTarget:renderTarget];
    if(self) {
        _depth = depth;
        _frameBuffer = egGenFrameBuffer();
        _depthRenderBuffer = ((depth) ? egGenRenderBuffer() : 0);
        if([self class] == [EGSimpleSurface class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSimpleSurface class]) _EGSimpleSurface_type = [CNClassType classTypeWithCls:[EGSimpleSurface class]];
}

+ (EGSimpleSurface*)toTextureSize:(GEVec2i)size depth:(BOOL)depth {
    return [EGSimpleSurface simpleSurfaceWithRenderTarget:[EGSurfaceRenderTargetTexture applySize:size] depth:depth];
}

+ (EGSimpleSurface*)toRenderBufferSize:(GEVec2i)size depth:(BOOL)depth {
    return [EGSimpleSurface simpleSurfaceWithRenderTarget:[EGSurfaceRenderTargetRenderBuffer applySize:size] depth:depth];
}

- (void)_init {
    glGetError();
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    [self.renderTarget link];
    if(glGetError() != 0) {
        NSString* e = [NSString stringWithFormat:@"Error in texture creation for surface with size %ldx%ld", (long)self.size.x, (long)self.size.y];
        @throw e;
    }
    int status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer color attachment: %d", status];
    if(_depth) {
        [EGGlobal.context bindRenderBufferId:_depthRenderBuffer];
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, ((int)(self.size.x)), ((int)(self.size.y)));
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
        int status2 = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        if(status2 != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer depth attachment: %d", status];
    }
}

- (void)dealloc {
    unsigned int fb = _frameBuffer;
    [[EGDirector current] onGLThreadF:^void() {
        egDeleteFrameBuffer(fb);
    }];
    if(_depth) [EGGlobal.context deleteRenderBufferId:_depthRenderBuffer];
}

- (void)bind {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    [EGGlobal.context setViewport:geRectIApplyXYWidthHeight(0.0, 0.0, ((float)(self.size.x)), ((float)(self.size.y)))];
}

- (void)unbind {
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SimpleSurface(%d)", _depth];
}

- (CNClassType*)type {
    return [EGSimpleSurface type];
}

+ (CNClassType*)type {
    return _EGSimpleSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

