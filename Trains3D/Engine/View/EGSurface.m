#import "EGSurface.h"

#import "EGTexture.h"
#import "EGMaterial.h"
#import "EGMesh.h"
#import "EGContext.h"
@implementation EGSurface{
    BOOL _depth;
    GEVec2i _size;
    GLuint _frameBuffer;
    GLuint _depthRenderBuffer;
    EGTexture* _texture;
    EGSimpleMaterial* _material;
}
static ODClassType* _EGSurface_type;
@synthesize depth = _depth;
@synthesize size = _size;
@synthesize texture = _texture;
@synthesize material = _material;

+ (id)surfaceWithDepth:(BOOL)depth size:(GEVec2i)size {
    return [[EGSurface alloc] initWithDepth:depth size:size];
}

- (id)initWithDepth:(BOOL)depth size:(GEVec2i)size {
    self = [super init];
    if(self) {
        _depth = depth;
        _size = size;
        _frameBuffer = egGenFrameBuffer();
        _depthRenderBuffer = ((_depth) ? egGenRenderBuffer() : 0);
        _texture = ^EGTexture*() {
            EGTexture* t = [EGTexture texture];
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            glBindTexture(GL_TEXTURE_2D, t.id);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _size.x, _size.y, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
            glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, t.id, 0);
            if(_depth) {
                glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
                glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT, _size.x, _size.y);
                glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
            }
            glBindTexture(GL_TEXTURE_2D, 0);
            glBindFramebuffer(GL_FRAMEBUFFER, 0);
            return t;
        }();
        _material = [EGSimpleMaterial simpleMaterialWithColor:[EGColorSource applyTexture:_texture]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSurface_type = [ODClassType classTypeWithCls:[EGSurface class]];
}

- (void)dealloc {
    egDeleteFrameBuffer(_frameBuffer);
    if(_depth) egDeleteRenderBuffer(_depthRenderBuffer);
}

- (void)applyDraw:(void(^)())draw {
    [self bind];
    ((void(^)())(draw))();
    [self unbind];
}

- (void)bind {
    glPushAttrib(GL_VIEWPORT_BIT);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glViewport(0, 0, _size.x, _size.y);
}

- (void)unbind {
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glPopAttrib();
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
    [_positionSlot setFromBufferWithStride:[vertexBuffer stride] valuesCount:2 valuesType:GL_FLOAT shift:0];
    [_zUniform setF4:param.z];
}

- (void)unloadMaterial:(EGSimpleMaterial*)material {
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
    id _surface;
    CNLazy* __lazy_fullScreenMesh;
    CNLazy* __lazy_shader;
}
static ODClassType* _EGFullScreenSurface_type;
@synthesize depth = _depth;

+ (id)fullScreenSurfaceWithDepth:(BOOL)depth {
    return [[EGFullScreenSurface alloc] initWithDepth:depth];
}

- (id)initWithDepth:(BOOL)depth {
    self = [super init];
    if(self) {
        _depth = depth;
        _surface = [CNOption none];
        __lazy_fullScreenMesh = [CNLazy lazyWithF:^EGMesh*() {
            return [EGMesh applyDataType:geVec2Type() vertexData:[ arrs(GEVec2, 4) {GEVec2Make(0.0, 0.0), GEVec2Make(1.0, 0.0), GEVec2Make(1.0, 1.0), GEVec2Make(0.0, 1.0)}] indexData:[ arrui4(6) {0, 1, 2, 2, 3, 0}]];
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
    if([self needRedraw]) _surface = [CNOption opt:[EGSurface surfaceWithDepth:_depth size:[EGGlobal.context viewport].size]];
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
    if([self needRedraw]) [self applyDraw:draw];
}

- (void)maybeForce:(BOOL)force draw:(void(^)())draw {
    if(force || [self needRedraw]) [self applyDraw:draw];
}

- (void)unbind {
    [((EGSurface*)([_surface get])) unbind];
}

- (void)drawWithZ:(float)z {
    glDisable(GL_CULL_FACE);
    [[self shader] drawParam:[EGFullScreenSurfaceShaderParam fullScreenSurfaceShaderParamWithTexture:[self texture] z:z] mesh:[self fullScreenMesh]];
    glEnable(GL_CULL_FACE);
}

- (void)draw {
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    [[self shader] drawParam:[EGFullScreenSurfaceShaderParam fullScreenSurfaceShaderParamWithTexture:[self texture] z:0.0] mesh:[self fullScreenMesh]];
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
}

- (EGTexture*)texture {
    return ((EGSurface*)([_surface get])).texture;
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
    return self.depth == o.depth;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.depth;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"depth=%d", self.depth];
    [description appendString:@">"];
    return description;
}

@end


