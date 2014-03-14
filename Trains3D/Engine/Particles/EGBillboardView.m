#import "EGBillboardView.h"

#import "EGContext.h"
#import "EGShadow.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "GL.h"
#import "EGMatrixModel.h"
#import "EGSprite.h"
#import "EGParticleSystem.h"
#import "EGIndex.h"
@implementation EGBillboardShaderSystem
static EGBillboardShaderSystem* _EGBillboardShaderSystem_instance;
static ODClassType* _EGBillboardShaderSystem_type;

+ (instancetype)billboardShaderSystem {
    return [[EGBillboardShaderSystem alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _map = [NSMutableDictionary mutableDictionary];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBillboardShaderSystem class]) {
        _EGBillboardShaderSystem_type = [ODClassType classTypeWithCls:[EGBillboardShaderSystem class]];
        _EGBillboardShaderSystem_instance = [EGBillboardShaderSystem billboardShaderSystem];
    }
}

- (EGBillboardShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget {
    EGBillboardShaderKey* key = [EGBillboardShaderKey billboardShaderKeyWithTexture:([renderTarget isKindOfClass:[EGShadowRenderTarget class]] && !([EGShadowShaderSystem isColorShaderForParam:param])) || [param.texture isDefined] alpha:param.alphaTestLevel > -0.1 shadow:[renderTarget isKindOfClass:[EGShadowRenderTarget class]] modelSpace:EGBillboardShaderSpace.camera];
    return [_map objectForKey:key orUpdateWith:^EGBillboardShader*() {
        return [key shader];
    }];
}

- (EGBillboardShader*)shaderForKey:(EGBillboardShaderKey*)key {
    return [_map objectForKey:key orUpdateWith:^EGBillboardShader*() {
        return [key shader];
    }];
}

- (ODClassType*)type {
    return [EGBillboardShaderSystem type];
}

+ (EGBillboardShaderSystem*)instance {
    return _EGBillboardShaderSystem_instance;
}

+ (ODClassType*)type {
    return _EGBillboardShaderSystem_type;
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


@implementation EGBillboardShaderSpace
static EGBillboardShaderSpace* _EGBillboardShaderSpace_camera;
static EGBillboardShaderSpace* _EGBillboardShaderSpace_projection;
static NSArray* _EGBillboardShaderSpace_values;

+ (instancetype)billboardShaderSpaceWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[EGBillboardShaderSpace alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboardShaderSpace_camera = [EGBillboardShaderSpace billboardShaderSpaceWithOrdinal:0 name:@"camera"];
    _EGBillboardShaderSpace_projection = [EGBillboardShaderSpace billboardShaderSpaceWithOrdinal:1 name:@"projection"];
    _EGBillboardShaderSpace_values = (@[_EGBillboardShaderSpace_camera, _EGBillboardShaderSpace_projection]);
}

+ (EGBillboardShaderSpace*)camera {
    return _EGBillboardShaderSpace_camera;
}

+ (EGBillboardShaderSpace*)projection {
    return _EGBillboardShaderSpace_projection;
}

+ (NSArray*)values {
    return _EGBillboardShaderSpace_values;
}

@end


@implementation EGBillboardShaderKey
static ODClassType* _EGBillboardShaderKey_type;
@synthesize texture = _texture;
@synthesize alpha = _alpha;
@synthesize shadow = _shadow;
@synthesize modelSpace = _modelSpace;

+ (instancetype)billboardShaderKeyWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow modelSpace:(EGBillboardShaderSpace*)modelSpace {
    return [[EGBillboardShaderKey alloc] initWithTexture:texture alpha:alpha shadow:shadow modelSpace:modelSpace];
}

- (instancetype)initWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow modelSpace:(EGBillboardShaderSpace*)modelSpace {
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
    if(self == [EGBillboardShaderKey class]) _EGBillboardShaderKey_type = [ODClassType classTypeWithCls:[EGBillboardShaderKey class]];
}

- (EGBillboardShader*)shader {
    return [EGBillboardShader billboardShaderWithKey:self program:[[EGBillboardShaderBuilder billboardShaderBuilderWithKey:self] program]];
}

- (ODClassType*)type {
    return [EGBillboardShaderKey type];
}

+ (ODClassType*)type {
    return _EGBillboardShaderKey_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBillboardShaderKey* o = ((EGBillboardShaderKey*)(other));
    return self.texture == o.texture && self.alpha == o.alpha && self.shadow == o.shadow && self.modelSpace == o.modelSpace;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.texture;
    hash = hash * 31 + self.alpha;
    hash = hash * 31 + self.shadow;
    hash = hash * 31 + [self.modelSpace ordinal];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%d", self.texture];
    [description appendFormat:@", alpha=%d", self.alpha];
    [description appendFormat:@", shadow=%d", self.shadow];
    [description appendFormat:@", modelSpace=%@", self.modelSpace];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBillboardShaderBuilder
static ODClassType* _EGBillboardShaderBuilder_type;
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
    if(self == [EGBillboardShaderBuilder class]) _EGBillboardShaderBuilder_type = [ODClassType classTypeWithCls:[EGBillboardShaderBuilder class]];
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
        "%@ mediump vec2 UV;", [self ain], [self out]] : @""), [self ain], ((_key.modelSpace == EGBillboardShaderSpace.camera) ? @"uniform mat4 wc;\n"
        "uniform mat4 p;" : @"uniform mat4 wcp;"), [self out], ((_key.modelSpace == EGBillboardShaderSpace.camera) ? @"    highp vec4 pos = wc*vec4(position, 1);\n"
        "    pos.x += model.x;\n"
        "    pos.y += model.y;\n"
        "    gl_Position = p*pos;\n"
        "   " : @"    gl_Position = wcp*vec4(position.xy + model, position.z, 1);\n"
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
    return [EGBillboardShaderBuilder type];
}

+ (ODClassType*)type {
    return _EGBillboardShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBillboardShaderBuilder* o = ((EGBillboardShaderBuilder*)(other));
    return [self.key isEqual:o.key];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.key hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"key=%@", self.key];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBillboardShader
static ODClassType* _EGBillboardShader_type;
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
        _uvSlot = ((_key.texture) ? [CNOption applyValue:[self attributeForName:@"vertexUV"]] : [CNOption none]);
        _colorSlot = [self attributeForName:@"vertexColor"];
        _colorUniform = [self uniformVec4Name:@"color"];
        _alphaTestLevelUniform = ((_key.alpha) ? [CNOption applyValue:[self uniformF4Name:@"alphaTestLevel"]] : [CNOption none]);
        _wcUniform = ((_key.modelSpace == EGBillboardShaderSpace.camera) ? [CNOption applyValue:[self uniformMat4Name:@"wc"]] : [CNOption none]);
        _pUniform = ((_key.modelSpace == EGBillboardShaderSpace.camera) ? [CNOption applyValue:[self uniformMat4Name:@"p"]] : [CNOption none]);
        _wcpUniform = ((_key.modelSpace == EGBillboardShaderSpace.projection) ? [CNOption applyValue:[self uniformMat4Name:@"wcp"]] : [CNOption none]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBillboardShader class]) _EGBillboardShader_type = [ODClassType classTypeWithCls:[EGBillboardShader class]];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_modelSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
    [_colorSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:4 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.color))];
    if(_key.texture) [_uvSlot forEach:^void(EGShaderAttribute* _) {
        [((EGShaderAttribute*)(_)) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
    }];
}

- (void)loadUniformsParam:(EGColorSource*)param {
    if(_key.modelSpace == EGBillboardShaderSpace.camera) {
        [((EGShaderUniformMat4*)([_wcUniform get])) applyMatrix:[[EGGlobal.matrix value] wc]];
        [((EGShaderUniformMat4*)([_pUniform get])) applyMatrix:[[EGGlobal.matrix value] p]];
    } else {
        [((EGShaderUniformMat4*)([_wcpUniform get])) applyMatrix:[[EGGlobal.matrix value] wcp]];
    }
    if(_key.alpha) [((EGShaderUniformF4*)([_alphaTestLevelUniform get])) applyF4:param.alphaTestLevel];
    if(_key.texture) [EGGlobal.context bindTextureTexture:[param.texture get]];
    [_colorUniform applyVec4:param.color];
}

- (ODClassType*)type {
    return [EGBillboardShader type];
}

+ (ODClassType*)type {
    return _EGBillboardShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBillboardShader* o = ((EGBillboardShader*)(other));
    return [self.key isEqual:o.key] && [self.program isEqual:o.program];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.key hash];
    hash = hash * 31 + [self.program hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"key=%@", self.key];
    [description appendFormat:@", program=%@", self.program];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBillboardParticleSystemView
static ODClassType* _EGBillboardParticleSystemView_type;

+ (instancetype)billboardParticleSystemViewWithSystem:(EGParticleSystem*)system maxCount:(NSUInteger)maxCount material:(EGColorSource*)material blendFunc:(EGBlendFunction*)blendFunc {
    return [[EGBillboardParticleSystemView alloc] initWithSystem:system maxCount:maxCount material:material blendFunc:blendFunc];
}

- (instancetype)initWithSystem:(EGParticleSystem*)system maxCount:(NSUInteger)maxCount material:(EGColorSource*)material blendFunc:(EGBlendFunction*)blendFunc {
    self = [super initWithSystem:system vbDesc:EGSprite.vbDesc maxCount:maxCount shader:[EGBillboardShaderSystem.instance shaderForParam:material] material:material blendFunc:blendFunc];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBillboardParticleSystemView class]) _EGBillboardParticleSystemView_type = [ODClassType classTypeWithCls:[EGBillboardParticleSystemView class]];
}

+ (EGBillboardParticleSystemView*)applySystem:(EGParticleSystem*)system maxCount:(NSUInteger)maxCount material:(EGColorSource*)material {
    return [EGBillboardParticleSystemView billboardParticleSystemViewWithSystem:system maxCount:maxCount material:material blendFunc:EGBlendFunction.standard];
}

- (NSUInteger)vertexCount {
    return 4;
}

- (NSUInteger)indexCount {
    return 6;
}

- (CNVoidRefArray)writeIndexesToIndexPointer:(CNVoidRefArray)indexPointer i:(unsigned int)i {
    return cnVoidRefArrayWriteUInt4((cnVoidRefArrayWriteUInt4((cnVoidRefArrayWriteUInt4((cnVoidRefArrayWriteUInt4((cnVoidRefArrayWriteUInt4((cnVoidRefArrayWriteUInt4(indexPointer, i)), i + 1)), i + 2)), i + 2)), i)), i + 3);
}

- (EGMutableIndexSourceGap*)indexVertexCount:(NSUInteger)vertexCount maxCount:(NSUInteger)maxCount {
    NSUInteger vc = vertexCount;
    CNVoidRefArray ia = cnVoidRefArrayApplyTpCount(oduInt4Type(), [self indexCount] * maxCount);
    __block CNVoidRefArray indexPointer = ia;
    [uintRange(maxCount) forEach:^void(id i) {
        indexPointer = [self writeIndexesToIndexPointer:indexPointer i:((unsigned int)(unumi(i) * vc))];
    }];
    EGImmutableIndexBuffer* ib = [EGIBO applyArray:ia];
    cnVoidRefArrayFree(ia);
    return [EGMutableIndexSourceGap mutableIndexSourceGapWithSource:ib];
}

- (ODClassType*)type {
    return [EGBillboardParticleSystemView type];
}

+ (ODClassType*)type {
    return _EGBillboardParticleSystemView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBillboardParticleSystemView* o = ((EGBillboardParticleSystemView*)(other));
    return self.system == o.system && self.maxCount == o.maxCount && [self.material isEqual:o.material] && [self.blendFunc isEqual:o.blendFunc];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.system hash];
    hash = hash * 31 + self.maxCount;
    hash = hash * 31 + [self.material hash];
    hash = hash * 31 + [self.blendFunc hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"system=%@", self.system];
    [description appendFormat:@", maxCount=%lu", (unsigned long)self.maxCount];
    [description appendFormat:@", material=%@", self.material];
    [description appendFormat:@", blendFunc=%@", self.blendFunc];
    [description appendString:@">"];
    return description;
}

@end


