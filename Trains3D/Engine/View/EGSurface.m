#import "EGSurface.h"

#import "EGTexture.h"
#import "EGContext.h"
#import "GL.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "EGMesh.h"
#import "EGIndex.h"
#import "EGVertexArray.h"
@implementation EGSurface{
    GEVec2i _size;
}
static ODClassType* _EGSurface_type;
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
    if(self == [EGSurface class]) _EGSurface_type = [ODClassType classTypeWithCls:[EGSurface class]];
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

- (int)frameBuffer {
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


@implementation EGSurfaceRenderTarget{
    GEVec2i _size;
}
static ODClassType* _EGSurfaceRenderTarget_type;
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
    if(self == [EGSurfaceRenderTarget class]) _EGSurfaceRenderTarget_type = [ODClassType classTypeWithCls:[EGSurfaceRenderTarget class]];
}

- (void)link {
    @throw @"Method link is abstract";
}

- (ODClassType*)type {
    return [EGSurfaceRenderTarget type];
}

+ (ODClassType*)type {
    return _EGSurfaceRenderTarget_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSurfaceRenderTarget* o = ((EGSurfaceRenderTarget*)(other));
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


@implementation EGSurfaceRenderTargetTexture{
    EGTexture* _texture;
}
static ODClassType* _EGSurfaceRenderTargetTexture_type;
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
    if(self == [EGSurfaceRenderTargetTexture class]) _EGSurfaceRenderTargetTexture_type = [ODClassType classTypeWithCls:[EGSurfaceRenderTargetTexture class]];
}

+ (EGSurfaceRenderTargetTexture*)applySize:(GEVec2i)size {
    EGEmptyTexture* t = [EGEmptyTexture emptyTextureWithSize:geVec2ApplyVec2i(size)];
    [EGGlobal.context bindTextureTexture:t];
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, ((int)(GL_CLAMP_TO_EDGE)));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, ((int)(GL_CLAMP_TO_EDGE)));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, ((int)(GL_NEAREST)));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, ((int)(GL_NEAREST)));
    glTexImage2D(GL_TEXTURE_2D, 0, ((int)(GL_RGBA)), ((int)(size.x)), ((int)(size.y)), 0, GL_RGBA, GL_UNSIGNED_BYTE, cnVoidRefApplyI(0));
    return [EGSurfaceRenderTargetTexture surfaceRenderTargetTextureWithTexture:t size:size];
}

- (void)link {
    egFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, [_texture id], 0);
}

- (ODClassType*)type {
    return [EGSurfaceRenderTargetTexture type];
}

+ (ODClassType*)type {
    return _EGSurfaceRenderTargetTexture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSurfaceRenderTargetTexture* o = ((EGSurfaceRenderTargetTexture*)(other));
    return [self.texture isEqual:o.texture] && GEVec2iEq(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.texture hash];
    hash = hash * 31 + GEVec2iHash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%@", self.texture];
    [description appendFormat:@", size=%@", GEVec2iDescription(self.size)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSurfaceRenderTargetRenderBuffer{
    unsigned int _renderBuffer;
}
static ODClassType* _EGSurfaceRenderTargetRenderBuffer_type;
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
    if(self == [EGSurfaceRenderTargetRenderBuffer class]) _EGSurfaceRenderTargetRenderBuffer_type = [ODClassType classTypeWithCls:[EGSurfaceRenderTargetRenderBuffer class]];
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

- (ODClassType*)type {
    return [EGSurfaceRenderTargetRenderBuffer type];
}

+ (ODClassType*)type {
    return _EGSurfaceRenderTargetRenderBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSurfaceRenderTargetRenderBuffer* o = ((EGSurfaceRenderTargetRenderBuffer*)(other));
    return self.renderBuffer == o.renderBuffer && GEVec2iEq(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.renderBuffer;
    hash = hash * 31 + GEVec2iHash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"renderBuffer=%u", self.renderBuffer];
    [description appendFormat:@", size=%@", GEVec2iDescription(self.size)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGRenderTargetSurface{
    EGSurfaceRenderTarget* _renderTarget;
}
static ODClassType* _EGRenderTargetSurface_type;
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
    if(self == [EGRenderTargetSurface class]) _EGRenderTargetSurface_type = [ODClassType classTypeWithCls:[EGRenderTargetSurface class]];
}

- (EGTexture*)texture {
    return ((EGSurfaceRenderTargetTexture*)(_renderTarget)).texture;
}

- (unsigned int)renderBuffer {
    return ((EGSurfaceRenderTargetRenderBuffer*)(_renderTarget)).renderBuffer;
}

- (ODClassType*)type {
    return [EGRenderTargetSurface type];
}

+ (ODClassType*)type {
    return _EGRenderTargetSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGRenderTargetSurface* o = ((EGRenderTargetSurface*)(other));
    return [self.renderTarget isEqual:o.renderTarget];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.renderTarget hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"renderTarget=%@", self.renderTarget];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSimpleSurface{
    BOOL _depth;
    unsigned int _frameBuffer;
    unsigned int _depthRenderBuffer;
}
static ODClassType* _EGSimpleSurface_type;
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
        _depthRenderBuffer = ((_depth) ? egGenRenderBuffer() : 0);
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSimpleSurface class]) _EGSimpleSurface_type = [ODClassType classTypeWithCls:[EGSimpleSurface class]];
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
    egDeleteFrameBuffer(_frameBuffer);
    if(_depth) [EGGlobal.context deleteRenderBufferId:_depthRenderBuffer];
}

- (void)bind {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    [EGGlobal.context setViewport:geRectIApplyXYWidthHeight(0.0, 0.0, ((float)(self.size.x)), ((float)(self.size.y)))];
}

- (void)unbind {
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
    return [self.renderTarget isEqual:o.renderTarget] && self.depth == o.depth;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.renderTarget hash];
    hash = hash * 31 + self.depth;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"renderTarget=%@", self.renderTarget];
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

+ (instancetype)viewportSurfaceShaderParamWithTexture:(EGTexture*)texture z:(float)z {
    return [[EGViewportSurfaceShaderParam alloc] initWithTexture:texture z:z];
}

- (instancetype)initWithTexture:(EGTexture*)texture z:(float)z {
    self = [super init];
    if(self) {
        _texture = texture;
        _z = z;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGViewportSurfaceShaderParam class]) _EGViewportSurfaceShaderParam_type = [ODClassType classTypeWithCls:[EGViewportSurfaceShaderParam class]];
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


@implementation EGViewportShaderBuilder
static ODClassType* _EGViewportShaderBuilder_type;

+ (instancetype)viewportShaderBuilder {
    return [[EGViewportShaderBuilder alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGViewportShaderBuilder class]) _EGViewportShaderBuilder_type = [ODClassType classTypeWithCls:[EGViewportShaderBuilder class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "\n"
        "%@ highp vec2 position;\n"
        "uniform lowp float z;\n"
        "%@ mediump vec2 UV;\n"
        "\n"
        "void main(void) {\n"
        "   gl_Position = vec4(2.0*position.x - 1.0, 2.0*position.y - 1.0, z, 1);\n"
        "   UV = position;\n"
        "}", [self vertexHeader], [self ain], [self out]];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"%@\n"
        "%@ mediump vec2 UV;\n"
        "\n"
        "uniform lowp sampler2D txt;\n"
        "\n"
        "void main(void) {\n"
        "    %@ = %@(txt, UV);\n"
        "}", [self fragmentHeader], [self in], [self fragColor], [self texture2D]];
}

- (EGShaderProgram*)program {
    return [EGShaderProgram applyName:@"Viewport" vertex:[self vertex] fragment:[self fragment]];
}

- (NSString*)versionString {
    return [NSString stringWithFormat:@"#version %ld", (long)[self version]];
}

- (NSString*)vertexHeader {
    return [NSString stringWithFormat:@"#version %ld", (long)[self version]];
}

- (NSString*)fragmentHeader {
    return [NSString stringWithFormat:@"#version %ld\n"
        "%@", (long)[self version], [self fragColorDeclaration]];
}

- (NSString*)fragColorDeclaration {
    if([self isFragColorDeclared]) return @"";
    else return @"out lowp vec4 fragColor;";
}

- (BOOL)isFragColorDeclared {
    return EGShaderProgram.version < 110;
}

- (NSInteger)version {
    return EGShaderProgram.version;
}

- (NSString*)ain {
    if([self version] < 150) return @"attribute";
    else return @"in";
}

- (NSString*)in {
    if([self version] < 150) return @"varying";
    else return @"in";
}

- (NSString*)out {
    if([self version] < 150) return @"varying";
    else return @"out";
}

- (NSString*)fragColor {
    if([self version] > 100) return @"fragColor";
    else return @"gl_FragColor";
}

- (NSString*)texture2D {
    if([self version] > 100) return @"texture";
    else return @"texture2D";
}

- (NSString*)shadowExt {
    if([self version] == 100 && [EGGlobal.settings shadowType] == EGShadowType.shadow2d) return @"#extension GL_EXT_shadow_samplers : require";
    else return @"";
}

- (NSString*)sampler2DShadow {
    if([EGGlobal.settings shadowType] == EGShadowType.shadow2d) return @"sampler2DShadow";
    else return @"sampler2D";
}

- (NSString*)shadow2DTexture:(NSString*)texture vec3:(NSString*)vec3 {
    if([EGGlobal.settings shadowType] == EGShadowType.shadow2d) return [NSString stringWithFormat:@"%@(%@, %@)", [self shadow2DEXT], texture, vec3];
    else return [NSString stringWithFormat:@"(%@(%@, %@.xy).x < %@.z ? 0.0 : 1.0)", [self texture2D], texture, vec3, vec3];
}

- (NSString*)blendMode:(EGBlendMode*)mode a:(NSString*)a b:(NSString*)b {
    return mode.blend(a, b);
}

- (NSString*)shadow2DEXT {
    if([self version] == 100) return @"shadow2DEXT";
    else return @"texture";
}

- (ODClassType*)type {
    return [EGViewportShaderBuilder type];
}

+ (ODClassType*)type {
    return _EGViewportShaderBuilder_type;
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


@implementation EGViewportSurfaceShader{
    EGShaderAttribute* _positionSlot;
    EGShaderUniformF4* _zUniform;
}
static EGViewportSurfaceShader* _EGViewportSurfaceShader_instance;
static ODClassType* _EGViewportSurfaceShader_type;
@synthesize positionSlot = _positionSlot;
@synthesize zUniform = _zUniform;

+ (instancetype)viewportSurfaceShader {
    return [[EGViewportSurfaceShader alloc] init];
}

- (instancetype)init {
    self = [super initWithProgram:[[EGViewportShaderBuilder viewportShaderBuilder] program]];
    if(self) {
        _positionSlot = [self attributeForName:@"position"];
        _zUniform = [self uniformF4Name:@"z"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGViewportSurfaceShader class]) {
        _EGViewportSurfaceShader_type = [ODClassType classTypeWithCls:[EGViewportSurfaceShader class]];
        _EGViewportSurfaceShader_instance = [EGViewportSurfaceShader viewportSurfaceShader];
    }
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
}

- (void)loadUniformsParam:(EGViewportSurfaceShaderParam*)param {
    [EGGlobal.context bindTextureTexture:param.texture];
    [_zUniform applyF4:param.z];
}

- (ODClassType*)type {
    return [EGViewportSurfaceShader type];
}

+ (EGViewportSurfaceShader*)instance {
    return _EGViewportSurfaceShader_instance;
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
    EGSurfaceRenderTarget*(^_createRenderTarget)(GEVec2i);
    id __surface;
    id __renderTarget;
}
static CNLazy* _EGBaseViewportSurface__lazy_fullScreenMesh;
static CNLazy* _EGBaseViewportSurface__lazy_fullScreenVao;
static ODClassType* _EGBaseViewportSurface_type;
@synthesize createRenderTarget = _createRenderTarget;

+ (instancetype)baseViewportSurfaceWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget {
    return [[EGBaseViewportSurface alloc] initWithCreateRenderTarget:createRenderTarget];
}

- (instancetype)initWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget {
    self = [super init];
    if(self) {
        _createRenderTarget = [createRenderTarget copy];
        __surface = [CNOption none];
        __renderTarget = [CNOption none];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBaseViewportSurface class]) {
        _EGBaseViewportSurface_type = [ODClassType classTypeWithCls:[EGBaseViewportSurface class]];
        _EGBaseViewportSurface__lazy_fullScreenMesh = [CNLazy lazyWithF:^EGMesh*() {
            return [EGMesh meshWithVertex:[EGVBO vec2Data:[ arrs(GEVec2, 4) {GEVec2Make(0.0, 0.0), GEVec2Make(1.0, 0.0), GEVec2Make(0.0, 1.0), GEVec2Make(1.0, 1.0)}]] index:EGEmptyIndexSource.triangleStrip];
        }];
        _EGBaseViewportSurface__lazy_fullScreenVao = [CNLazy lazyWithF:^EGVertexArray*() {
            return [[EGBaseViewportSurface fullScreenMesh] vaoShader:EGViewportSurfaceShader.instance];
        }];
    }
}

+ (EGMesh*)fullScreenMesh {
    return [_EGBaseViewportSurface__lazy_fullScreenMesh get];
}

+ (EGVertexArray*)fullScreenVao {
    return [_EGBaseViewportSurface__lazy_fullScreenVao get];
}

- (id)surface {
    return __surface;
}

- (EGSurfaceRenderTarget*)renderTarget {
    if([__renderTarget isEmpty] || !(GEVec2iEq(((EGSurfaceRenderTarget*)([__renderTarget get])).size, EGGlobal.context.viewSize))) {
        __renderTarget = [CNOption applyValue:_createRenderTarget(EGGlobal.context.viewSize)];
        return [__renderTarget get];
    } else {
        return [__renderTarget get];
    }
}

- (void)maybeRecreateSurface {
    if([self needRedraw]) __surface = [CNOption applyValue:[self createSurface]];
}

- (EGRenderTargetSurface*)createSurface {
    @throw @"Method createSurface is abstract";
}

- (EGTexture*)texture {
    return ((EGSurfaceRenderTargetTexture*)([self renderTarget])).texture;
}

- (unsigned int)renderBuffer {
    return ((EGSurfaceRenderTargetRenderBuffer*)([self renderTarget])).renderBuffer;
}

- (BOOL)needRedraw {
    return [__surface isEmpty] || !(GEVec2iEq(((EGRenderTargetSurface*)([__surface get])).size, EGGlobal.context.viewSize));
}

- (void)bind {
    [self maybeRecreateSurface];
    [((EGRenderTargetSurface*)([__surface get])) bind];
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
    if(force || [self needRedraw] || [__surface isEmpty]) [self applyDraw:draw];
}

- (void)unbind {
    [((EGRenderTargetSurface*)([__surface get])) unbind];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBaseViewportSurface* o = ((EGBaseViewportSurface*)(other));
    return [self.createRenderTarget isEqual:o.createRenderTarget];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.createRenderTarget hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


