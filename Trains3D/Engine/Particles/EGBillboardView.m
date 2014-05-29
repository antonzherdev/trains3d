#import "EGBillboardView.h"

#import "EGContext.h"
#import "EGShadow.h"
#import "EGMaterial.h"
#import "EGTexture.h"
#import "EGVertex.h"
#import "GL.h"
#import "EGMatrixModel.h"
#import "EGSprite.h"
#import "EGParticleSystem.h"
@implementation EGBillboardShaderSystem
static EGBillboardShaderSystem* _EGBillboardShaderSystem_cameraSpace;
static EGBillboardShaderSystem* _EGBillboardShaderSystem_projectionSpace;
static CNMHashMap* _EGBillboardShaderSystem_map;
static CNClassType* _EGBillboardShaderSystem_type;
@synthesize space = _space;

+ (instancetype)billboardShaderSystemWithSpace:(EGBillboardShaderSpaceR)space {
    return [[EGBillboardShaderSystem alloc] initWithSpace:space];
}

- (instancetype)initWithSpace:(EGBillboardShaderSpaceR)space {
    self = [super init];
    if(self) _space = space;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBillboardShaderSystem class]) {
        _EGBillboardShaderSystem_type = [CNClassType classTypeWithCls:[EGBillboardShaderSystem class]];
        _EGBillboardShaderSystem_cameraSpace = [EGBillboardShaderSystem billboardShaderSystemWithSpace:EGBillboardShaderSpace_camera];
        _EGBillboardShaderSystem_projectionSpace = [EGBillboardShaderSystem billboardShaderSystemWithSpace:EGBillboardShaderSpace_projection];
        _EGBillboardShaderSystem_map = [CNMHashMap hashMap];
    }
}

- (EGBillboardShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget {
    EGBillboardShaderKey* key = [EGBillboardShaderKey billboardShaderKeyWithTexture:([renderTarget isKindOfClass:[EGShadowRenderTarget class]] && !([EGShadowShaderSystem isColorShaderForParam:param])) || ((EGColorSource*)(param)).texture != nil alpha:((EGColorSource*)(param)).alphaTestLevel > -0.1 shadow:[renderTarget isKindOfClass:[EGShadowRenderTarget class]] modelSpace:_space];
    return [_EGBillboardShaderSystem_map applyKey:key orUpdateWith:^EGBillboardShader*() {
        return [key shader];
    }];
}

+ (EGBillboardShader*)shaderForKey:(EGBillboardShaderKey*)key {
    return [_EGBillboardShaderSystem_map applyKey:key orUpdateWith:^EGBillboardShader*() {
        return [key shader];
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BillboardShaderSystem(%@)", EGBillboardShaderSpace_Values[_space]];
}

- (CNClassType*)type {
    return [EGBillboardShaderSystem type];
}

+ (EGBillboardShaderSystem*)cameraSpace {
    return _EGBillboardShaderSystem_cameraSpace;
}

+ (EGBillboardShaderSystem*)projectionSpace {
    return _EGBillboardShaderSystem_projectionSpace;
}

+ (CNClassType*)type {
    return _EGBillboardShaderSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGBillboardShaderSpace

+ (instancetype)billboardShaderSpaceWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[EGBillboardShaderSpace alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)load {
    [super load];
    EGBillboardShaderSpace_camera_Desc = [EGBillboardShaderSpace billboardShaderSpaceWithOrdinal:0 name:@"camera"];
    EGBillboardShaderSpace_projection_Desc = [EGBillboardShaderSpace billboardShaderSpaceWithOrdinal:1 name:@"projection"];
    EGBillboardShaderSpace_Values[0] = nil;
    EGBillboardShaderSpace_Values[1] = EGBillboardShaderSpace_camera_Desc;
    EGBillboardShaderSpace_Values[2] = EGBillboardShaderSpace_projection_Desc;
}

+ (NSArray*)values {
    return (@[EGBillboardShaderSpace_camera_Desc, EGBillboardShaderSpace_projection_Desc]);
}

@end

@implementation EGBillboardShaderKey
static CNClassType* _EGBillboardShaderKey_type;
@synthesize texture = _texture;
@synthesize alpha = _alpha;
@synthesize shadow = _shadow;
@synthesize modelSpace = _modelSpace;

+ (instancetype)billboardShaderKeyWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow modelSpace:(EGBillboardShaderSpaceR)modelSpace {
    return [[EGBillboardShaderKey alloc] initWithTexture:texture alpha:alpha shadow:shadow modelSpace:modelSpace];
}

- (instancetype)initWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow modelSpace:(EGBillboardShaderSpaceR)modelSpace {
    self = [super init];
    if(self) {
        _texture = texture;
        _alpha = alpha;
        _shadow = shadow;
        _modelSpace = modelSpace;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBillboardShaderKey class]) _EGBillboardShaderKey_type = [CNClassType classTypeWithCls:[EGBillboardShaderKey class]];
}

- (EGBillboardShader*)shader {
    return [EGBillboardShader billboardShaderWithKey:self program:[[EGBillboardShaderBuilder billboardShaderBuilderWithKey:self] program]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BillboardShaderKey(%d, %d, %d, %@)", _texture, _alpha, _shadow, EGBillboardShaderSpace_Values[_modelSpace]];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGBillboardShaderKey class]])) return NO;
    EGBillboardShaderKey* o = ((EGBillboardShaderKey*)(to));
    return _texture == o.texture && _alpha == o.alpha && _shadow == o.shadow && _modelSpace == o.modelSpace;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + _texture;
    hash = hash * 31 + _alpha;
    hash = hash * 31 + _shadow;
    hash = hash * 31 + [EGBillboardShaderSpace_Values[_modelSpace] hash];
    return hash;
}

- (CNClassType*)type {
    return [EGBillboardShaderKey type];
}

+ (CNClassType*)type {
    return _EGBillboardShaderKey_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGBillboardShaderBuilder
static CNClassType* _EGBillboardShaderBuilder_type;
@synthesize key = _key;

+ (instancetype)billboardShaderBuilderWithKey:(EGBillboardShaderKey*)key {
    return [[EGBillboardShaderBuilder alloc] initWithKey:key];
}

- (instancetype)initWithKey:(EGBillboardShaderKey*)key {
    self = [super init];
    if(self) _key = key;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBillboardShaderBuilder class]) _EGBillboardShaderBuilder_type = [CNClassType classTypeWithCls:[EGBillboardShaderBuilder class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "%@ highp vec3 position;\n"
        "%@ lowp vec2 model;\n"
        "%@\n"
        "%@ lowp vec4 vertexColor;\n"
        "%@\n"
        "%@ vec4 fColor;\n"
        "\n"
        "void main(void) {\n"
        "   %@%@\n"
        "    fColor = vertexColor;\n"
        "}", [self vertexHeader], [self ain], [self ain], ((_key.texture) ? [NSString stringWithFormat:@"%@ mediump vec2 vertexUV;\n"
        "%@ mediump vec2 UV;", [self ain], [self out]] : @""), [self ain], ((_key.modelSpace == EGBillboardShaderSpace_camera) ? @"uniform mat4 wc;\n"
        "uniform mat4 p;" : @"uniform mat4 wcp;"), [self out], ((_key.modelSpace == EGBillboardShaderSpace_camera) ? @"    highp vec4 pos = wc*vec4(position, 1);\n"
        "    pos.x += model.x;\n"
        "    pos.y += model.y;\n"
        "    gl_Position = p*pos;\n"
        "   " : @"    gl_Position = wcp*vec4(position.xy, position.z, 1);\n"
        "    gl_Position.xy += model;\n"
        "   "), ((_key.texture) ? @"\n"
        "    UV = vertexUV;" : @"")];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"%@\n"
        "\n"
        "%@\n"
        "uniform lowp vec4 color;\n"
        "uniform lowp float alphaTestLevel;\n"
        "%@ lowp vec4 fColor;\n"
        "%@\n"
        "\n"
        "void main(void) {%@\n"
        "   %@\n"
        "   %@%@\n"
        "}", [self versionString], ((_key.texture) ? [NSString stringWithFormat:@"%@ mediump vec2 UV;\n"
        "uniform lowp sampler2D txt;", [self in]] : @""), [self in], ((_key.shadow && [self version] > 100) ? @"out float depth;" : [NSString stringWithFormat:@"%@", [self fragColorDeclaration]]), ((_key.shadow && !([self isFragColorDeclared])) ? @"\n"
        "    lowp vec4 fragColor;" : @""), ((_key.texture) ? [NSString stringWithFormat:@"    %@ = fColor * color * %@(txt, UV);\n"
        "   ", [self fragColor], [self texture2D]] : [NSString stringWithFormat:@"    %@ = fColor * color;\n"
        "   ", [self fragColor]]), ((_key.alpha) ? [NSString stringWithFormat:@"    if(%@.a < alphaTestLevel) {\n"
        "        discard;\n"
        "    }\n"
        "   ", [self fragColor]] : @""), ((_key.shadow && [self version] > 100) ? @"\n"
        "    depth = gl_FragCoord.z;" : @"")];
}

- (EGShaderProgram*)program {
    return [EGShaderProgram applyName:@"Billboard" vertex:[self vertex] fragment:[self fragment]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BillboardShaderBuilder(%@)", _key];
}

- (CNClassType*)type {
    return [EGBillboardShaderBuilder type];
}

+ (CNClassType*)type {
    return _EGBillboardShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGBillboardShader
static CNClassType* _EGBillboardShader_type;
@synthesize key = _key;
@synthesize positionSlot = _positionSlot;
@synthesize modelSlot = _modelSlot;
@synthesize uvSlot = _uvSlot;
@synthesize colorSlot = _colorSlot;
@synthesize colorUniform = _colorUniform;
@synthesize alphaTestLevelUniform = _alphaTestLevelUniform;
@synthesize wcUniform = _wcUniform;
@synthesize pUniform = _pUniform;
@synthesize wcpUniform = _wcpUniform;

+ (instancetype)billboardShaderWithKey:(EGBillboardShaderKey*)key program:(EGShaderProgram*)program {
    return [[EGBillboardShader alloc] initWithKey:key program:program];
}

- (instancetype)initWithKey:(EGBillboardShaderKey*)key program:(EGShaderProgram*)program {
    self = [super initWithProgram:program];
    if(self) {
        _key = key;
        _positionSlot = [self attributeForName:@"position"];
        _modelSlot = [self attributeForName:@"model"];
        _uvSlot = ((key.texture) ? [self attributeForName:@"vertexUV"] : nil);
        _colorSlot = [self attributeForName:@"vertexColor"];
        _colorUniform = [self uniformVec4Name:@"color"];
        _alphaTestLevelUniform = ((key.alpha) ? [self uniformF4Name:@"alphaTestLevel"] : nil);
        _wcUniform = ((key.modelSpace == EGBillboardShaderSpace_camera) ? [self uniformMat4Name:@"wc"] : nil);
        _pUniform = ((key.modelSpace == EGBillboardShaderSpace_camera) ? [self uniformMat4Name:@"p"] : nil);
        _wcpUniform = ((key.modelSpace == EGBillboardShaderSpace_projection) ? [self uniformMat4Name:@"wcp"] : nil);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBillboardShader class]) _EGBillboardShader_type = [CNClassType classTypeWithCls:[EGBillboardShader class]];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_modelSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
    [_colorSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:4 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.color))];
    if(_key.texture) [((EGShaderAttribute*)(_uvSlot)) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
}

- (void)loadUniformsParam:(EGColorSource*)param {
    if(_key.modelSpace == EGBillboardShaderSpace_camera) {
        [((EGShaderUniformMat4*)(_wcUniform)) applyMatrix:[[EGGlobal.matrix value] wc]];
        [((EGShaderUniformMat4*)(_pUniform)) applyMatrix:[[EGGlobal.matrix value] p]];
    } else {
        [((EGShaderUniformMat4*)(_wcpUniform)) applyMatrix:[[EGGlobal.matrix value] wcp]];
    }
    if(_key.alpha) [((EGShaderUniformF4*)(_alphaTestLevelUniform)) applyF4:((EGColorSource*)(param)).alphaTestLevel];
    if(_key.texture) {
        EGTexture* _ = ((EGColorSource*)(param)).texture;
        if(_ != nil) [EGGlobal.context bindTextureTexture:_];
    }
    [_colorUniform applyVec4:((EGColorSource*)(param)).color];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BillboardShader(%@)", _key];
}

- (CNClassType*)type {
    return [EGBillboardShader type];
}

+ (CNClassType*)type {
    return _EGBillboardShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGBillboardParticleSystemView
static CNClassType* _EGBillboardParticleSystemView_type;

+ (instancetype)billboardParticleSystemViewWithSystem:(EGParticleSystem*)system material:(EGColorSource*)material blendFunc:(EGBlendFunction*)blendFunc {
    return [[EGBillboardParticleSystemView alloc] initWithSystem:system material:material blendFunc:blendFunc];
}

- (instancetype)initWithSystem:(EGParticleSystem*)system material:(EGColorSource*)material blendFunc:(EGBlendFunction*)blendFunc {
    self = [super initWithSystem:system vbDesc:EGSprite.vbDesc shader:[EGBillboardShaderSystem.cameraSpace shaderForParam:material] material:material blendFunc:blendFunc];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBillboardParticleSystemView class]) _EGBillboardParticleSystemView_type = [CNClassType classTypeWithCls:[EGBillboardParticleSystemView class]];
}

+ (EGBillboardParticleSystemView*)applySystem:(EGParticleSystem*)system material:(EGColorSource*)material {
    return [EGBillboardParticleSystemView billboardParticleSystemViewWithSystem:system material:material blendFunc:EGBlendFunction.standard];
}

- (NSString*)description {
    return @"BillboardParticleSystemView";
}

- (CNClassType*)type {
    return [EGBillboardParticleSystemView type];
}

+ (CNClassType*)type {
    return _EGBillboardParticleSystemView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

