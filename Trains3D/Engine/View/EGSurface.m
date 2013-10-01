#import "EGSurface.h"

#import "EGTexture.h"
#import "EGMesh.h"
#import "EGContext.h"
@implementation EGSurface{
    GEVec2i _size;
}
static ODClassType* _EGSurface_type;
@synthesize size = _size;

+ (id)surfaceWithSize:(GEVec2i)size {
    return [[EGSurface alloc] initWithSize:size];
}

- (id)initWithSize:(GEVec2i)size {
    self = [super init];
    if(self) {
        _size = size;
        [self _init];
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

- (void)_init {
    if(_size.x <= 0 || _size.y <= 0) @throw @"Invalid surface size";
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
    return GEVec2iEq(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%@", GEVec2iDescription(self.size)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSimpleSurface{
    BOOL _depth;
    BOOL _multisampling;
    GLuint _frameBuffer;
    GLuint _depthRenderBuffer;
    id _depthTexture;
    EGTexture* _texture;
}
static ODClassType* _EGSimpleSurface_type;
@synthesize depth = _depth;
@synthesize multisampling = _multisampling;
@synthesize frameBuffer = _frameBuffer;
@synthesize texture = _texture;

+ (id)simpleSurfaceWithSize:(GEVec2i)size depth:(BOOL)depth multisampling:(BOOL)multisampling {
    return [[EGSimpleSurface alloc] initWithSize:size depth:depth multisampling:multisampling];
}

- (id)initWithSize:(GEVec2i)size depth:(BOOL)depth multisampling:(BOOL)multisampling {
    self = [super initWithSize:size];
    if(self) {
        _depth = depth;
        _multisampling = multisampling;
        _frameBuffer = egGenFrameBuffer();
        _depthRenderBuffer = ((_depth && !(_multisampling)) ? egGenRenderBuffer() : 0);
        _depthTexture = ((_depth && _multisampling) ? [CNOption applyValue:[EGTexture texture]] : [CNOption none]);
        _texture = ^EGTexture*() {
            EGTexture* t = [EGTexture texture];
            glGetError();
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            unsigned int tg = ((_multisampling) ? GL_TEXTURE_2D_MULTISAMPLE : GL_TEXTURE_2D);
            glBindTexture(tg, t.id);
            if(_multisampling) {
                glTexImage2DMultisample(tg, 4, GL_RGBA, self.size.x, self.size.y, GL_FALSE);
            } else {
                glTexParameteri(tg, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
                glTexParameteri(tg, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
                glTexParameteri(tg, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
                glTexParameteri(tg, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
                glTexImage2D(tg, 0, GL_RGBA, self.size.x, self.size.y, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
            }
            if(glGetError() != 0) {
                NSString* e = [NSString stringWithFormat:@"Error in texture creation for surface with size %lix%li", self.size.x, self.size.y];
                @throw e;
            }
            glFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, t.id, 0);
            NSInteger status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer color attachment: %li", status];
            if(_depth) {
                if(_multisampling) {
                    glBindTexture(tg, ((EGTexture*)([_depthTexture get])).id);
                    glTexImage2DMultisample(tg, 4, GL_DEPTH_COMPONENT24, self.size.x, self.size.y, GL_FALSE);
                    glFramebufferTexture(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, ((EGTexture*)([_depthTexture get])).id, 0);
                } else {
                    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
                    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT, self.size.x, self.size.y);
                    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
                }
                NSInteger status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
                if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer depth attachment: %li", status];
            }
            glBindTexture(tg, 0);
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
    if(_depth) egDeleteRenderBuffer(_depthRenderBuffer);
}

- (void)bind {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glViewport(0, 0, self.size.x, self.size.y);
}

- (void)unbind {
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
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
    return GEVec2iEq(self.size, o.size) && self.depth == o.depth && self.multisampling == o.multisampling;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.size);
    hash = hash * 31 + self.depth;
    hash = hash * 31 + self.multisampling;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%@", GEVec2iDescription(self.size)];
    [description appendFormat:@", depth=%d", self.depth];
    [description appendFormat:@", multisampling=%d", self.multisampling];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGPairSurface{
    BOOL _depth;
    EGSimpleSurface* _multisampling;
    EGSimpleSurface* _simple;
}
static ODClassType* _EGPairSurface_type;
@synthesize depth = _depth;
@synthesize multisampling = _multisampling;
@synthesize simple = _simple;

+ (id)pairSurfaceWithSize:(GEVec2i)size depth:(BOOL)depth {
    return [[EGPairSurface alloc] initWithSize:size depth:depth];
}

- (id)initWithSize:(GEVec2i)size depth:(BOOL)depth {
    self = [super initWithSize:size];
    if(self) {
        _depth = depth;
        _multisampling = [EGSimpleSurface simpleSurfaceWithSize:self.size depth:_depth multisampling:YES];
        _simple = [EGSimpleSurface simpleSurfaceWithSize:self.size depth:NO multisampling:NO];
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


@implementation EGViewportSurfaceShaderParam{
    EGTexture* _texture;
    float _z;
}
static ODClassType* _EGViewportSurfaceShaderParam_type;
@synthesize texture = _texture;
@synthesize z = _z;

+ (id)viewportSurfaceShaderParamWithTexture:(EGTexture*)texture z:(float)z {
    return [[EGViewportSurfaceShaderParam alloc] initWithTexture:texture z:z];
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
    _EGViewportSurfaceShaderParam_type = [ODClassType classTypeWithCls:[EGViewportSurfaceShaderParam class]];
}

- (ODClassType*)type {
    return [EGViewportSurfaceShaderParam type];
}

+ (ODClassType*)type {
    return _EGViewportSurfaceShaderParam_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGViewportSurfaceShaderParam* o = ((EGViewportSurfaceShaderParam*)(other));
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


@implementation EGViewportSurfaceShader{
    EGShaderAttribute* _positionSlot;
    EGShaderUniform* _zUniform;
}
static NSString* _EGViewportSurfaceShader_vertex = @"#version 150\n"
    "in vec2 position;\n"
    "uniform float z;\n"
    "out vec2 UV;\n"
    "\n"
    "void main(void) {\n"
    "   gl_Position = vec4(2.0*position.x - 1.0, 2.0*position.y - 1.0, z, 1);\n"
    "   UV = position;\n"
    "}";
static NSString* _EGViewportSurfaceShader_fragment = @"#version 150\n"
    "in vec2 UV;\n"
    "\n"
    "uniform sampler2D texture;\n"
    "out vec4 outColor;\n"
    "\n"
    "void main(void) {\n"
    "   outColor = texture(texture, UV);\n"
    "}";
static ODClassType* _EGViewportSurfaceShader_type;
@synthesize positionSlot = _positionSlot;
@synthesize zUniform = _zUniform;

+ (id)viewportSurfaceShader {
    return [[EGViewportSurfaceShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[EGShaderProgram applyVertex:_EGViewportSurfaceShader_vertex fragment:_EGViewportSurfaceShader_fragment]];
    if(self) {
        _positionSlot = [self.program attributeForName:@"position"];
        _zUniform = [self.program uniformForName:@"z"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGViewportSurfaceShader_type = [ODClassType classTypeWithCls:[EGViewportSurfaceShader class]];
}

- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGViewportSurfaceShaderParam*)param {
    [param.texture bind];
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
    [_zUniform setF4:param.z];
}

- (void)unloadParam:(EGViewportSurfaceShaderParam*)param {
    [EGTexture unbind];
    [_positionSlot unbind];
}

- (ODClassType*)type {
    return [EGViewportSurfaceShader type];
}

+ (NSString*)vertex {
    return _EGViewportSurfaceShader_vertex;
}

+ (NSString*)fragment {
    return _EGViewportSurfaceShader_fragment;
}

+ (ODClassType*)type {
    return _EGViewportSurfaceShader_type;
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


@implementation EGBaseViewportSurface{
    id __surface;
    NSInteger _redrawCounter;
}
static CNLazy* _EGBaseViewportSurface__lazy_fullScreenMesh;
static ODClassType* _EGBaseViewportSurface_type;

+ (id)baseViewportSurface {
    return [[EGBaseViewportSurface alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        __surface = [CNOption none];
        _redrawCounter = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBaseViewportSurface_type = [ODClassType classTypeWithCls:[EGBaseViewportSurface class]];
    _EGBaseViewportSurface__lazy_fullScreenMesh = [CNLazy lazyWithF:^EGMesh*() {
        return [EGMesh vec2VertexData:[ arrs(GEVec2, 4) {GEVec2Make(0.0, 0.0), GEVec2Make(1.0, 0.0), GEVec2Make(1.0, 1.0), GEVec2Make(0.0, 1.0)}] indexData:[ arrui4(6) {0, 1, 2, 2, 3, 0}]];
    }];
}

+ (EGMesh*)fullScreenMesh {
    return ((EGMesh*)([_EGBaseViewportSurface__lazy_fullScreenMesh get]));
}

- (id)surface {
    return __surface;
}

- (void)maybeRecreateSurface {
    if([self needRedraw]) __surface = [CNOption applyValue:[self createSurface]];
}

- (EGSurface*)createSurface {
    @throw @"Method createSurface is abstract";
}

- (BOOL)needRedraw {
    return [__surface isEmpty] || !(GEVec2iEq(((EGSurface*)([__surface get])).size, [EGGlobal.context viewport].size));
}

- (void)bind {
    [self maybeRecreateSurface];
    [((EGSurface*)([__surface get])) bind];
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
    if(nr || _redrawCounter > 0) _redrawCounter++;
    if((force && !(nr)) || _redrawCounter > 10 || [__surface isEmpty]) {
        [self applyDraw:draw];
        _redrawCounter = 0;
    }
}

- (void)unbind {
    [((EGSurface*)([__surface get])) unbind];
}

- (ODClassType*)type {
    return [EGBaseViewportSurface type];
}

+ (ODClassType*)type {
    return _EGBaseViewportSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
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
    if(_multisampling) return [EGPairSurface pairSurfaceWithSize:[EGGlobal.context viewport].size depth:_depth];
    else return [EGSimpleSurface simpleSurfaceWithSize:[EGGlobal.context viewport].size depth:_depth multisampling:NO];
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


