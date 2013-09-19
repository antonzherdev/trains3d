#import "EGSurface.h"

#import "EGTexture.h"
#import "EGMesh.h"
#import "EGContext.h"
@implementation EGSurface{
    BOOL _depth;
    GEVec2i _size;
}
static ODClassType* _EGSurface_type;
@synthesize depth = _depth;
@synthesize size = _size;

+ (id)surfaceWithDepth:(BOOL)depth size:(GEVec2i)size {
    return [[EGSurface alloc] initWithDepth:depth size:size];
}

- (id)initWithDepth:(BOOL)depth size:(GEVec2i)size {
    self = [super init];
    if(self) {
        _depth = depth;
        _size = size;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSurface_type = [ODClassType classTypeWithCls:[EGSurface class]];
}

- (void)applyDraw:(void(^)())draw {
    [self bind];
    ((void(^)())(draw))();
    [self unbind];
}

- (void)bind {
    @throw @"Method bind is abstract";
}

- (void)unbind {
    @throw @"Method unbind is abstract";
}

- (GLint)frameBuffer {
    @throw @"Method frameBuffer is abstract";
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
    return self.depth == o.depth && GEVec2iEq(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.depth;
    hash = hash * 31 + GEVec2iHash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"depth=%d", self.depth];
    [description appendFormat:@", size=%@", GEVec2iDescription(self.size)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSimpleSurface{
    GLuint _frameBuffer;
    GLuint _depthRenderBuffer;
    EGTexture* _texture;
}
static ODClassType* _EGSimpleSurface_type;
@synthesize frameBuffer = _frameBuffer;
@synthesize texture = _texture;

+ (id)simpleSurfaceWithDepth:(BOOL)depth size:(GEVec2i)size {
    return [[EGSimpleSurface alloc] initWithDepth:depth size:size];
}

- (id)initWithDepth:(BOOL)depth size:(GEVec2i)size {
    self = [super initWithDepth:depth size:size];
    if(self) {
        _frameBuffer = egGenFrameBuffer();
        _depthRenderBuffer = ((self.depth) ? egGenRenderBuffer() : 0);
        _texture = ^EGTexture*() {
            EGTexture* t = [EGTexture texture];
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            glBindTexture(GL_TEXTURE_2D, t.id);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, self.size.x, self.size.y, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
            glFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, t.id, 0);
            if(self.depth) {
                glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
                glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT, self.size.x, self.size.y);
                glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
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
    _EGSimpleSurface_type = [ODClassType classTypeWithCls:[EGSimpleSurface class]];
}

- (void)dealloc {
    egDeleteFrameBuffer(_frameBuffer);
    if(self.depth) egDeleteRenderBuffer(_depthRenderBuffer);
}

- (void)bind {
    glPushAttrib(GL_VIEWPORT_BIT);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glViewport(0, 0, self.size.x, self.size.y);
}

- (void)unbind {
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glPopAttrib();
}

- (ODClassType*)type {
    return [EGSimpleSurface type];
}

+ (ODClassType*)type {
    return _EGSimpleSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSimpleSurface* o = ((EGSimpleSurface*)(other));
    return self.depth == o.depth && GEVec2iEq(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.depth;
    hash = hash * 31 + GEVec2iHash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"depth=%d", self.depth];
    [description appendFormat:@", size=%@", GEVec2iDescription(self.size)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMultisamplingSurface{
    GLuint _depthRenderBuffer;
    GLuint _colorRenderBuffer;
    GLuint _frameBuffer;
}
static ODClassType* _EGMultisamplingSurface_type;
@synthesize frameBuffer = _frameBuffer;

+ (id)multisamplingSurfaceWithDepth:(BOOL)depth size:(GEVec2i)size {
    return [[EGMultisamplingSurface alloc] initWithDepth:depth size:size];
}

- (id)initWithDepth:(BOOL)depth size:(GEVec2i)size {
    self = [super initWithDepth:depth size:size];
    if(self) {
        _depthRenderBuffer = ((self.depth) ? egGenRenderBufferEXT() : 0);
        _colorRenderBuffer = egGenRenderBufferEXT();
        _frameBuffer = ^GLuint() {
            GLuint fb = egGenFrameBufferEXT();
            glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fb);
            glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, _colorRenderBuffer);
            glRenderbufferStorageMultisampleEXT(GL_RENDERBUFFER_EXT, 4, GL_RGBA8, self.size.x, self.size.y);
            glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_RENDERBUFFER_EXT, _colorRenderBuffer);
            NSInteger status = glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT);
            if(status != GL_FRAMEBUFFER_COMPLETE_EXT) @throw [NSString stringWithFormat:@"Error in frame buffer color attachment: %li", status];
            if(self.depth) {
                glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, _depthRenderBuffer);
                glRenderbufferStorageMultisampleEXT(GL_RENDERBUFFER_EXT, 4, GL_DEPTH_COMPONENT, self.size.x, self.size.y);
                glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, _depthRenderBuffer);
                NSInteger status1 = glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT);
                if(status1 != GL_FRAMEBUFFER_COMPLETE_EXT) @throw [NSString stringWithFormat:@"Error in frame buffer depth attachment: %li", status1];
            }
            glBindFramebuffer(GL_FRAMEBUFFER_EXT, 0);
            return fb;
        }();
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMultisamplingSurface_type = [ODClassType classTypeWithCls:[EGMultisamplingSurface class]];
}

- (void)dealloc {
    egDeleteFrameBufferEXT(_frameBuffer);
    egDeleteFrameBufferEXT(_colorRenderBuffer);
    if(self.depth) egDeleteRenderBufferEXT(_depthRenderBuffer);
}

- (void)bind {
    glPushAttrib(GL_VIEWPORT_BIT);
    glBindFramebufferEXT(GL_DRAW_FRAMEBUFFER_EXT, _frameBuffer);
    glViewport(0, 0, self.size.x, self.size.y);
}

- (void)unbind {
    glBindFramebufferEXT(GL_DRAW_FRAMEBUFFER_EXT, 0);
    glPopAttrib();
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
    return self.depth == o.depth && GEVec2iEq(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.depth;
    hash = hash * 31 + GEVec2iHash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"depth=%d", self.depth];
    [description appendFormat:@", size=%@", GEVec2iDescription(self.size)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGPairSurface{
    EGMultisamplingSurface* _multisampling;
    EGSimpleSurface* _simple;
}
static ODClassType* _EGPairSurface_type;
@synthesize multisampling = _multisampling;
@synthesize simple = _simple;

+ (id)pairSurfaceWithDepth:(BOOL)depth size:(GEVec2i)size {
    return [[EGPairSurface alloc] initWithDepth:depth size:size];
}

- (id)initWithDepth:(BOOL)depth size:(GEVec2i)size {
    self = [super initWithDepth:depth size:size];
    if(self) {
        _multisampling = [EGMultisamplingSurface multisamplingSurfaceWithDepth:self.depth size:self.size];
        _simple = [EGSimpleSurface simpleSurfaceWithDepth:NO size:self.size];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGPairSurface_type = [ODClassType classTypeWithCls:[EGPairSurface class]];
}

- (void)bind {
    [_multisampling bind];
}

- (void)unbind {
    [_multisampling unbind];
    glBindFramebufferEXT(GL_READ_FRAMEBUFFER_EXT, _multisampling.frameBuffer);
    glBindFramebufferEXT(GL_DRAW_FRAMEBUFFER_EXT, _simple.frameBuffer);
    GEVec2i s = self.size;
    glBlitFramebufferEXT(0, 0, s.x, s.y, 0, 0, s.x, s.y, GL_COLOR_BUFFER_BIT, GL_NEAREST);
    glBindFramebufferEXT(GL_READ_FRAMEBUFFER_EXT, 0);
    glBindFramebufferEXT(GL_DRAW_FRAMEBUFFER_EXT, 0);
}

- (GLint)frameBuffer {
    return _simple.frameBuffer;
}

- (EGTexture*)texture {
    return _simple.texture;
}

- (ODClassType*)type {
    return [EGPairSurface type];
}

+ (ODClassType*)type {
    return _EGPairSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGPairSurface* o = ((EGPairSurface*)(other));
    return self.depth == o.depth && GEVec2iEq(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.depth;
    hash = hash * 31 + GEVec2iHash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"depth=%d", self.depth];
    [description appendFormat:@", size=%@", GEVec2iDescription(self.size)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGFullScreenSurfaceShaderParam{
    EGTexture* _texture;
    float _z;
}
static ODClassType* _EGFullScreenSurfaceShaderParam_type;
@synthesize texture = _texture;
@synthesize z = _z;

+ (id)fullScreenSurfaceShaderParamWithTexture:(EGTexture*)texture z:(float)z {
    return [[EGFullScreenSurfaceShaderParam alloc] initWithTexture:texture z:z];
}

- (id)initWithTexture:(EGTexture*)texture z:(float)z {
    self = [super init];
    if(self) {
        _texture = texture;
        _z = z;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFullScreenSurfaceShaderParam_type = [ODClassType classTypeWithCls:[EGFullScreenSurfaceShaderParam class]];
}

- (ODClassType*)type {
    return [EGFullScreenSurfaceShaderParam type];
}

+ (ODClassType*)type {
    return _EGFullScreenSurfaceShaderParam_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGFullScreenSurfaceShaderParam* o = ((EGFullScreenSurfaceShaderParam*)(other));
    return [self.texture isEqual:o.texture] && eqf4(self.z, o.z);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.texture hash];
    hash = hash * 31 + float4Hash(self.z);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%@", self.texture];
    [description appendFormat:@", z=%f", self.z];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGFullScreenSurfaceShader{
    EGShaderAttribute* _positionSlot;
    EGShaderUniform* _zUniform;
}
static NSString* _EGFullScreenSurfaceShader_vertex = @"attribute vec2 position;\n"
    "uniform float z;\n"
    "varying vec2 UV;\n"
    "\n"
    "void main(void) {\n"
    "   gl_Position = vec4(2.0*position.x - 1.0, 2.0*position.y - 1.0, z, 1);\n"
    "   UV = position;\n"
    "}";
static NSString* _EGFullScreenSurfaceShader_fragment = @"varying vec2 UV;\n"
    "\n"
    "uniform sampler2D texture;\n"
    "\n"
    "void main(void) {\n"
    "   gl_FragColor = texture2D(texture, UV);\n"
    "}";
static ODClassType* _EGFullScreenSurfaceShader_type;
@synthesize positionSlot = _positionSlot;
@synthesize zUniform = _zUniform;

+ (id)fullScreenSurfaceShader {
    return [[EGFullScreenSurfaceShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[EGShaderProgram applyVertex:_EGFullScreenSurfaceShader_vertex fragment:_EGFullScreenSurfaceShader_fragment]];
    if(self) {
        _positionSlot = [self.program attributeForName:@"position"];
        _zUniform = [self.program uniformForName:@"z"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFullScreenSurfaceShader_type = [ODClassType classTypeWithCls:[EGFullScreenSurfaceShader class]];
}

- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer param:(EGFullScreenSurfaceShaderParam*)param {
    [param.texture bind];
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vertexBuffer stride])) valuesCount:2 valuesType:GL_FLOAT shift:0];
    [_zUniform setF4:param.z];
}

- (void)unloadParam:(EGFullScreenSurfaceShaderParam*)param {
    [EGTexture unbind];
}

- (ODClassType*)type {
    return [EGFullScreenSurfaceShader type];
}

+ (NSString*)vertex {
    return _EGFullScreenSurfaceShader_vertex;
}

+ (NSString*)fragment {
    return _EGFullScreenSurfaceShader_fragment;
}

+ (ODClassType*)type {
    return _EGFullScreenSurfaceShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGFullScreenSurface{
    BOOL _depth;
    BOOL _multisampling;
    id _surface;
    NSInteger _redrawCounter;
    CNLazy* __lazy_fullScreenMesh;
    CNLazy* __lazy_shader;
}
static ODClassType* _EGFullScreenSurface_type;
@synthesize depth = _depth;
@synthesize multisampling = _multisampling;

+ (id)fullScreenSurfaceWithDepth:(BOOL)depth multisampling:(BOOL)multisampling {
    return [[EGFullScreenSurface alloc] initWithDepth:depth multisampling:multisampling];
}

- (id)initWithDepth:(BOOL)depth multisampling:(BOOL)multisampling {
    self = [super init];
    if(self) {
        _depth = depth;
        _multisampling = multisampling;
        _surface = [CNOption none];
        _redrawCounter = 0;
        __lazy_fullScreenMesh = [CNLazy lazyWithF:^EGMesh*() {
            return [EGMesh vec2VertexData:[ arrs(GEVec2, 4) {GEVec2Make(0.0, 0.0), GEVec2Make(1.0, 0.0), GEVec2Make(1.0, 1.0), GEVec2Make(0.0, 1.0)}] indexData:[ arrui4(6) {0, 1, 2, 2, 3, 0}]];
        }];
        __lazy_shader = [CNLazy lazyWithF:^EGFullScreenSurfaceShader*() {
            return [EGFullScreenSurfaceShader fullScreenSurfaceShader];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFullScreenSurface_type = [ODClassType classTypeWithCls:[EGFullScreenSurface class]];
}

- (EGMesh*)fullScreenMesh {
    return [__lazy_fullScreenMesh get];
}

- (EGFullScreenSurfaceShader*)shader {
    return [__lazy_shader get];
}

- (void)maybeRecreateSurface {
    if([self needRedraw]) _surface = ((_multisampling) ? [CNOption opt:[EGPairSurface pairSurfaceWithDepth:_depth size:[EGGlobal.context viewport].size]] : [CNOption opt:[EGSimpleSurface simpleSurfaceWithDepth:_depth size:[EGGlobal.context viewport].size]]);
}

- (BOOL)needRedraw {
    return [_surface isEmpty] || !(GEVec2iEq(((EGSurface*)([_surface get])).size, [EGGlobal.context viewport].size));
}

- (void)bind {
    [self maybeRecreateSurface];
    [((EGSurface*)([_surface get])) bind];
}

- (void)applyDraw:(void(^)())draw {
    [self bind];
    ((void(^)())(draw))();
    [self unbind];
}

- (void)maybeDraw:(void(^)())draw {
    [self maybeForce:NO draw:draw];
}

- (void)maybeForce:(BOOL)force draw:(void(^)())draw {
    BOOL nr = [self needRedraw];
    if(nr) _redrawCounter++;
    if(force || (nr && _redrawCounter > 10)) {
        [self applyDraw:draw];
        _redrawCounter = 0;
    }
}

- (void)unbind {
    [((EGSurface*)([_surface get])) unbind];
}

- (void)drawWithZ:(float)z {
    glDisable(GL_CULL_FACE);
    [[self shader] drawParam:[EGFullScreenSurfaceShaderParam fullScreenSurfaceShaderParamWithTexture:[self texture] z:z] mesh:[self fullScreenMesh]];
    glEnable(GL_CULL_FACE);
}

- (EGTexture*)texture {
    EGSurface* __case__ = ((EGSurface*)([_surface get]));
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
        EGPairSurface* i;
        if([__case__ isKindOfClass:[EGPairSurface class]]) i = ((EGPairSurface*)(__case__));
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
    if([_surface isEmpty]) return ;
    if(_redrawCounter > 0) {
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_CULL_FACE);
        [[self shader] drawParam:[EGFullScreenSurfaceShaderParam fullScreenSurfaceShaderParamWithTexture:[self texture] z:0.0] mesh:[self fullScreenMesh]];
        glEnable(GL_CULL_FACE);
        glEnable(GL_DEPTH_TEST);
    } else {
        glBindFramebuffer(GL_READ_FRAMEBUFFER, [((EGSurface*)([_surface get])) frameBuffer]);
        GEVec2i s = ((EGSurface*)([_surface get])).size;
        GERecti v = [EGGlobal.context viewport];
        glBlitFramebuffer(0, 0, s.x, s.y, geRectiX(v), geRectiY(v), geRectiX2(v), geRectiY2(v), GL_COLOR_BUFFER_BIT, GL_NEAREST);
        glBindFramebuffer(GL_READ_FRAMEBUFFER, 0);
    }
}

- (ODClassType*)type {
    return [EGFullScreenSurface type];
}

+ (ODClassType*)type {
    return _EGFullScreenSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGFullScreenSurface* o = ((EGFullScreenSurface*)(other));
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


