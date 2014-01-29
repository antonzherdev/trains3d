#import "EGSurface.h"

#import "GL.h"
#import "EGTexture.h"
#import "EGContext.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "EGMesh.h"
#import "EGIndex.h"
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

- (int)frameBuffer {
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
    unsigned int _frameBuffer;
    unsigned int _depthRenderBuffer;
    EGEmptyTexture* _texture;
}
static ODClassType* _EGSimpleSurface_type;
@synthesize depth = _depth;
@synthesize frameBuffer = _frameBuffer;
@synthesize texture = _texture;

+ (id)simpleSurfaceWithSize:(GEVec2i)size depth:(BOOL)depth {
    return [[EGSimpleSurface alloc] initWithSize:size depth:depth];
}

- (id)initWithSize:(GEVec2i)size depth:(BOOL)depth {
    self = [super initWithSize:size];
    if(self) {
        _depth = depth;
        _frameBuffer = egGenFrameBuffer();
        _depthRenderBuffer = ((_depth) ? egGenRenderBuffer() : 0);
        _texture = ^EGEmptyTexture*() {
            EGEmptyTexture* t = [EGEmptyTexture emptyTextureWithSize:geVec2ApplyVec2i(self.size)];
            glGetError();
            egFlush();
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            glBindTexture(GL_TEXTURE_2D, t.id);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, ((int)(GL_CLAMP_TO_EDGE)));
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, ((int)(GL_CLAMP_TO_EDGE)));
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, ((int)(GL_NEAREST)));
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, ((int)(GL_NEAREST)));
            glTexImage2D(GL_TEXTURE_2D, 0, ((int)(GL_RGBA)), ((int)(self.size.x)), ((int)(self.size.y)), 0, GL_RGBA, GL_UNSIGNED_BYTE, cnVoidRefApplyI(0));
            if(glGetError() != 0) {
                NSString* e = [NSString stringWithFormat:@"Error in texture creation for surface with size %ldx%ld", (long)self.size.x, (long)self.size.y];
                @throw e;
            }
            egFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, t.id, 0);
            int status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer color attachment: %d", status];
            if(_depth) {
                glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
                glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, ((int)(self.size.x)), ((int)(self.size.y)));
                glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
                int status2 = glCheckFramebufferStatus(GL_FRAMEBUFFER);
                if(status2 != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer depth attachment: %d", status];
            }
            glBindTexture(GL_TEXTURE_2D, 0);
            [EGGlobal.context restoreDefaultFramebuffer];
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
    egFlush();
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    [EGGlobal.context pushViewport];
    [EGGlobal.context setViewport:geRectIApplyXYWidthHeight(0.0, 0.0, ((float)(self.size.x)), ((float)(self.size.y)))];
}

- (void)unbind {
    [EGGlobal.context restoreDefaultFramebuffer];
    [EGGlobal.context popViewport];
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


@implementation EGViewportShaderBuilder
static ODClassType* _EGViewportShaderBuilder_type;

+ (id)viewportShaderBuilder {
    return [[EGViewportShaderBuilder alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGViewportShaderBuilder_type = [ODClassType classTypeWithCls:[EGViewportShaderBuilder class]];
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
    if([self version] == 100) return @"#extension GL_EXT_shadow_samplers : require";
    else return @"";
}

- (NSString*)shadow2D {
    if([self version] == 100) return @"shadow2DEXT";
    else return @"texture";
}

- (NSString*)blendMode:(EGBlendMode*)mode a:(NSString*)a b:(NSString*)b {
    return mode.blend(a, b);
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

+ (id)viewportSurfaceShader {
    return [[EGViewportSurfaceShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[[EGViewportShaderBuilder viewportShaderBuilder] program]];
    if(self) {
        _positionSlot = [self attributeForName:@"position"];
        _zUniform = [self uniformF4Name:@"z"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGViewportSurfaceShader_type = [ODClassType classTypeWithCls:[EGViewportSurfaceShader class]];
    _EGViewportSurfaceShader_instance = [EGViewportSurfaceShader viewportSurfaceShader];
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
    id __surface;
    NSInteger _redrawCounter;
}
static CNLazy* _EGBaseViewportSurface__lazy_fullScreenMesh;
static CNLazy* _EGBaseViewportSurface__lazy_fullScreenVao;
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
        return [EGMesh meshWithVertex:[EGVBO vec2Data:[ arrs(GEVec2, 4) {GEVec2Make(0.0, 0.0), GEVec2Make(1.0, 0.0), GEVec2Make(0.0, 1.0), GEVec2Make(1.0, 1.0)}]] index:EGEmptyIndexSource.triangleStrip];
    }];
    _EGBaseViewportSurface__lazy_fullScreenVao = [CNLazy lazyWithF:^EGVertexArray*() {
        return [[EGBaseViewportSurface fullScreenMesh] vaoShader:EGViewportSurfaceShader.instance];
    }];
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


