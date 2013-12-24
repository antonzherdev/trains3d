#import "EGBillboard.h"

#import "EGContext.h"
#import "EGShadow.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "GL.h"
#import "EGIndex.h"
#import "EGSprite.h"
#import "GEMat4.h"
@implementation EGBillboardShaderSystem
static EGBillboardShaderSystem* _EGBillboardShaderSystem_instance;
static ODClassType* _EGBillboardShaderSystem_type;

+ (id)billboardShaderSystem {
    return [[EGBillboardShaderSystem alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboardShaderSystem_type = [ODClassType classTypeWithCls:[EGBillboardShaderSystem class]];
    _EGBillboardShaderSystem_instance = [EGBillboardShaderSystem billboardShaderSystem];
}

- (EGBillboardShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget {
    if([renderTarget isKindOfClass:[EGShadowRenderTarget class]]) {
        if([EGShadowShaderSystem isColorShaderForParam:param]) {
            return [EGBillboardShader instanceForColorShadow];
        } else {
            if(param.alphaTestLevel > -0.1) return [EGBillboardShader instanceForAlphaShadow];
            else return [EGBillboardShader instanceForTextureShadow];
        }
    } else {
        if([param.texture isEmpty]) {
            return [EGBillboardShader instanceForColor];
        } else {
            if(param.alphaTestLevel > -0.1) return [EGBillboardShader instanceForAlpha];
            else return [EGBillboardShader instanceForTexture];
        }
    }
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


@implementation EGBillboardShaderBuilder{
    BOOL _texture;
    BOOL _alpha;
    BOOL _shadow;
    NSString* _parameters;
    NSString* _code;
}
static ODClassType* _EGBillboardShaderBuilder_type;
@synthesize texture = _texture;
@synthesize alpha = _alpha;
@synthesize shadow = _shadow;
@synthesize parameters = _parameters;
@synthesize code = _code;

+ (id)billboardShaderBuilderWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow parameters:(NSString*)parameters code:(NSString*)code {
    return [[EGBillboardShaderBuilder alloc] initWithTexture:texture alpha:alpha shadow:shadow parameters:parameters code:code];
}

- (id)initWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow parameters:(NSString*)parameters code:(NSString*)code {
    self = [super init];
    if(self) {
        _texture = texture;
        _alpha = alpha;
        _shadow = shadow;
        _parameters = parameters;
        _code = code;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboardShaderBuilder_type = [ODClassType classTypeWithCls:[EGBillboardShaderBuilder class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "%@ highp vec3 position;\n"
        "%@ lowp vec2 model;\n"
        "%@\n"
        "%@ lowp vec4 vertexColor;\n"
        "\n"
        "uniform mat4 wc;\n"
        "uniform mat4 p;\n"
        "%@ vec4 fColor;\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "    highp vec4 pos = wc*vec4(position, 1);\n"
        "    pos.x += model.x;\n"
        "    pos.y += model.y;\n"
        "    gl_Position = p*pos;%@\n"
        "    fColor = vertexColor;\n"
        "    %@\n"
        "}", [self vertexHeader], [self ain], [self ain], ((_texture) ? [NSString stringWithFormat:@"%@ mediump vec2 vertexUV;\n"
        "%@ mediump vec2 UV;", [self ain], [self out]] : @""), [self ain], [self out], _parameters, ((_texture) ? @"\n"
        "    UV = vertexUV;" : @""), _code];
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
        "%@\n"
        "void main(void) {%@\n"
        "   %@\n"
        "   %@%@\n"
        "    %@\n"
        "}", [self versionString], ((_texture) ? [NSString stringWithFormat:@"%@ mediump vec2 UV;\n"
        "uniform lowp sampler2D txt;", [self in]] : @""), [self in], ((_shadow && [self version] > 100) ? @"out float depth;" : [NSString stringWithFormat:@"%@", [self fragColorDeclaration]]), _parameters, ((_shadow && !([self isFragColorDeclared])) ? @"\n"
        "    lowp vec4 fragColor;" : @""), ((_texture) ? [NSString stringWithFormat:@"    %@ = fColor * color * %@(txt, UV);\n"
        "   ", [self fragColor], [self texture2D]] : [NSString stringWithFormat:@"    %@ = fColor * color;\n"
        "   ", [self fragColor]]), ((_alpha) ? [NSString stringWithFormat:@"    if(%@.a < alphaTestLevel) {\n"
        "        discard;\n"
        "    }\n"
        "   ", [self fragColor]] : @""), ((_shadow && [self version] > 100) ? @"\n"
        "    depth = gl_FragCoord.z;" : @""), _code];
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
    return self.texture == o.texture && self.alpha == o.alpha && self.shadow == o.shadow && [self.parameters isEqual:o.parameters] && [self.code isEqual:o.code];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.texture;
    hash = hash * 31 + self.alpha;
    hash = hash * 31 + self.shadow;
    hash = hash * 31 + [self.parameters hash];
    hash = hash * 31 + [self.code hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%d", self.texture];
    [description appendFormat:@", alpha=%d", self.alpha];
    [description appendFormat:@", shadow=%d", self.shadow];
    [description appendFormat:@", parameters=%@", self.parameters];
    [description appendFormat:@", code=%@", self.code];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBillboardShader{
    BOOL _texture;
    BOOL _alpha;
    BOOL _shadow;
    EGShaderAttribute* _positionSlot;
    EGShaderAttribute* _modelSlot;
    id _uvSlot;
    EGShaderAttribute* _colorSlot;
    EGShaderUniformVec4* _colorUniform;
    id _alphaTestLevelUniform;
    EGShaderUniformMat4* _wcUniform;
    EGShaderUniformMat4* _pUniform;
}
static CNLazy* _EGBillboardShader__lazy_instanceForColor;
static CNLazy* _EGBillboardShader__lazy_instanceForTexture;
static CNLazy* _EGBillboardShader__lazy_instanceForAlpha;
static CNLazy* _EGBillboardShader__lazy_instanceForColorShadow;
static CNLazy* _EGBillboardShader__lazy_instanceForTextureShadow;
static CNLazy* _EGBillboardShader__lazy_instanceForAlphaShadow;
static ODClassType* _EGBillboardShader_type;
@synthesize texture = _texture;
@synthesize alpha = _alpha;
@synthesize shadow = _shadow;
@synthesize positionSlot = _positionSlot;
@synthesize modelSlot = _modelSlot;
@synthesize uvSlot = _uvSlot;
@synthesize colorSlot = _colorSlot;
@synthesize colorUniform = _colorUniform;
@synthesize alphaTestLevelUniform = _alphaTestLevelUniform;
@synthesize wcUniform = _wcUniform;
@synthesize pUniform = _pUniform;

+ (id)billboardShaderWithProgram:(EGShaderProgram*)program texture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow {
    return [[EGBillboardShader alloc] initWithProgram:program texture:texture alpha:alpha shadow:shadow];
}

- (id)initWithProgram:(EGShaderProgram*)program texture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow {
    self = [super initWithProgram:program];
    if(self) {
        _texture = texture;
        _alpha = alpha;
        _shadow = shadow;
        _positionSlot = [self attributeForName:@"position"];
        _modelSlot = [self attributeForName:@"model"];
        _uvSlot = ((_texture) ? [CNOption applyValue:[self attributeForName:@"vertexUV"]] : [CNOption none]);
        _colorSlot = [self attributeForName:@"vertexColor"];
        _colorUniform = [self uniformVec4Name:@"color"];
        _alphaTestLevelUniform = ((_alpha) ? [CNOption applyValue:[self uniformF4Name:@"alphaTestLevel"]] : [CNOption none]);
        _wcUniform = [self uniformMat4Name:@"wc"];
        _pUniform = [self uniformMat4Name:@"p"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboardShader_type = [ODClassType classTypeWithCls:[EGBillboardShader class]];
    _EGBillboardShader__lazy_instanceForColor = [CNLazy lazyWithF:^EGBillboardShader*() {
        return [EGBillboardShader billboardShaderWithProgram:[[EGBillboardShaderBuilder billboardShaderBuilderWithTexture:NO alpha:NO shadow:NO parameters:@"" code:@""] program] texture:NO alpha:NO shadow:NO];
    }];
    _EGBillboardShader__lazy_instanceForTexture = [CNLazy lazyWithF:^EGBillboardShader*() {
        return [EGBillboardShader billboardShaderWithProgram:[[EGBillboardShaderBuilder billboardShaderBuilderWithTexture:YES alpha:NO shadow:NO parameters:@"" code:@""] program] texture:YES alpha:NO shadow:NO];
    }];
    _EGBillboardShader__lazy_instanceForAlpha = [CNLazy lazyWithF:^EGBillboardShader*() {
        return [EGBillboardShader billboardShaderWithProgram:[[EGBillboardShaderBuilder billboardShaderBuilderWithTexture:YES alpha:YES shadow:NO parameters:@"" code:@""] program] texture:YES alpha:YES shadow:NO];
    }];
    _EGBillboardShader__lazy_instanceForColorShadow = [CNLazy lazyWithF:^EGBillboardShader*() {
        return [EGBillboardShader billboardShaderWithProgram:[[EGBillboardShaderBuilder billboardShaderBuilderWithTexture:NO alpha:NO shadow:YES parameters:@"" code:@""] program] texture:NO alpha:NO shadow:YES];
    }];
    _EGBillboardShader__lazy_instanceForTextureShadow = [CNLazy lazyWithF:^EGBillboardShader*() {
        return [EGBillboardShader billboardShaderWithProgram:[[EGBillboardShaderBuilder billboardShaderBuilderWithTexture:YES alpha:NO shadow:YES parameters:@"" code:@""] program] texture:YES alpha:NO shadow:YES];
    }];
    _EGBillboardShader__lazy_instanceForAlphaShadow = [CNLazy lazyWithF:^EGBillboardShader*() {
        return [EGBillboardShader billboardShaderWithProgram:[[EGBillboardShaderBuilder billboardShaderBuilderWithTexture:YES alpha:YES shadow:YES parameters:@"" code:@""] program] texture:YES alpha:YES shadow:YES];
    }];
}

+ (EGBillboardShader*)instanceForColor {
    return [_EGBillboardShader__lazy_instanceForColor get];
}

+ (EGBillboardShader*)instanceForTexture {
    return [_EGBillboardShader__lazy_instanceForTexture get];
}

+ (EGBillboardShader*)instanceForAlpha {
    return [_EGBillboardShader__lazy_instanceForAlpha get];
}

+ (EGBillboardShader*)instanceForColorShadow {
    return [_EGBillboardShader__lazy_instanceForColorShadow get];
}

+ (EGBillboardShader*)instanceForTextureShadow {
    return [_EGBillboardShader__lazy_instanceForTextureShadow get];
}

+ (EGBillboardShader*)instanceForAlphaShadow {
    return [_EGBillboardShader__lazy_instanceForAlphaShadow get];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_modelSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
    [_colorSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:4 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.color))];
    if(_texture) [_uvSlot forEach:^void(EGShaderAttribute* _) {
        [((EGShaderAttribute*)(_)) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
    }];
}

- (void)loadUniformsParam:(EGColorSource*)param {
    [_wcUniform applyMatrix:[EGGlobal.matrix.value wc]];
    [_pUniform applyMatrix:EGGlobal.matrix.value.p];
    if(_alpha) [((EGShaderUniformF4*)([_alphaTestLevelUniform get])) applyF4:param.alphaTestLevel];
    if(_texture) [EGGlobal.context bindTextureTexture:[param.texture get]];
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
    return [self.program isEqual:o.program] && self.texture == o.texture && self.alpha == o.alpha && self.shadow == o.shadow;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.program hash];
    hash = hash * 31 + self.texture;
    hash = hash * 31 + self.alpha;
    hash = hash * 31 + self.shadow;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"program=%@", self.program];
    [description appendFormat:@", texture=%d", self.texture];
    [description appendFormat:@", alpha=%d", self.alpha];
    [description appendFormat:@", shadow=%d", self.shadow];
    [description appendString:@">"];
    return description;
}

@end


NSString* EGBillboardBufferDataDescription(EGBillboardBufferData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGBillboardBufferData: "];
    [description appendFormat:@"position=%@", GEVec3Description(self.position)];
    [description appendFormat:@", model=%@", GEVec2Description(self.model)];
    [description appendFormat:@", color=%@", GEVec4Description(self.color)];
    [description appendFormat:@", uv=%@", GEVec2Description(self.uv)];
    [description appendString:@">"];
    return description;
}
ODPType* egBillboardBufferDataType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGBillboardBufferDataWrap class] name:@"EGBillboardBufferData" size:sizeof(EGBillboardBufferData) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGBillboardBufferData, ((EGBillboardBufferData*)(data))[i]);
    }];
    return _ret;
}
@implementation EGBillboardBufferDataWrap{
    EGBillboardBufferData _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGBillboardBufferData)value {
    return [[EGBillboardBufferDataWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGBillboardBufferData)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGBillboardBufferDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBillboardBufferDataWrap* o = ((EGBillboardBufferDataWrap*)(other));
    return EGBillboardBufferDataEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGBillboardBufferDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



@implementation EGEmissiveBillboardParticleSystem
static ODClassType* _EGEmissiveBillboardParticleSystem_type;

+ (id)emissiveBillboardParticleSystem {
    return [[EGEmissiveBillboardParticleSystem alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEmissiveBillboardParticleSystem_type = [ODClassType classTypeWithCls:[EGEmissiveBillboardParticleSystem class]];
}

- (ODClassType*)type {
    return [EGEmissiveBillboardParticleSystem type];
}

+ (ODClassType*)type {
    return _EGEmissiveBillboardParticleSystem_type;
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


@implementation EGBillboardParticleSystemView
static ODClassType* _EGBillboardParticleSystemView_type;

+ (id)billboardParticleSystemViewWithSystem:(id<EGParticleSystem>)system maxCount:(NSUInteger)maxCount material:(EGColorSource*)material blendFunc:(EGBlendFunction*)blendFunc {
    return [[EGBillboardParticleSystemView alloc] initWithSystem:system maxCount:maxCount material:material blendFunc:blendFunc];
}

- (id)initWithSystem:(id<EGParticleSystem>)system maxCount:(NSUInteger)maxCount material:(EGColorSource*)material blendFunc:(EGBlendFunction*)blendFunc {
    self = [super initWithSystem:system vbDesc:EGBillboard.vbDesc maxCount:maxCount shader:[EGBillboardShaderSystem.instance shaderForParam:material] material:material blendFunc:blendFunc];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboardParticleSystemView_type = [ODClassType classTypeWithCls:[EGBillboardParticleSystemView class]];
}

+ (EGBillboardParticleSystemView*)applySystem:(id<EGParticleSystem>)system maxCount:(NSUInteger)maxCount material:(EGColorSource*)material {
    return [EGBillboardParticleSystemView billboardParticleSystemViewWithSystem:system maxCount:maxCount material:material blendFunc:EGBlendFunction.standard];
}

- (NSUInteger)vertexCount {
    return 4;
}

- (NSUInteger)indexCount {
    return 6;
}

- (CNVoidRefArray)writeIndexesToIndexPointer:(CNVoidRefArray)indexPointer i:(unsigned int)i {
    return cnVoidRefArrayWriteUInt4(cnVoidRefArrayWriteUInt4(cnVoidRefArrayWriteUInt4(cnVoidRefArrayWriteUInt4(cnVoidRefArrayWriteUInt4(cnVoidRefArrayWriteUInt4(indexPointer, i), i + 1), i + 2), i + 2), i), i + 3);
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
    return [self.system isEqual:o.system] && self.maxCount == o.maxCount && [self.material isEqual:o.material] && [self.blendFunc isEqual:o.blendFunc];
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


@implementation EGBillboard{
    EGColorSource* _material;
    GEVec3 _position;
    GERect _rect;
}
static EGVertexBufferDesc* _EGBillboard_vbDesc;
static ODClassType* _EGBillboard_type;
@synthesize material = _material;
@synthesize position = _position;
@synthesize rect = _rect;

+ (id)billboard {
    return [[EGBillboard alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _position = GEVec3Make(0.0, 0.0, 0.0);
        _rect = geRectApplyXYWidthHeight(0.0, 0.0, 0.0, 0.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboard_type = [ODClassType classTypeWithCls:[EGBillboard class]];
    _EGBillboard_vbDesc = [EGVertexBufferDesc vertexBufferDescWithDataType:egBillboardBufferDataType() position:0 uv:((int)(9 * 4)) normal:-1 color:((int)(5 * 4)) model:((int)(3 * 4))];
}

- (void)draw {
    [EGD2D drawSpriteMaterial:_material at:_position quad:geRectStripQuad(_rect) uv:geRectUpsideDownStripQuad([_material uv])];
}

+ (EGBillboard*)applyMaterial:(EGColorSource*)material {
    EGBillboard* ret = [EGBillboard billboard];
    ret.material = material;
    return ret;
}

- (BOOL)containsVec2:(GEVec2)vec2 {
    GEVec4 pp = [[EGGlobal.matrix.value wc] mulVec4:geVec4ApplyVec3W(_position, 1.0)];
    return geRectContainsVec2([EGGlobal.matrix.value.p mulRect:geRectAddVec2(_rect, geVec4Xy(pp)) z:pp.z], vec2);
}

- (ODClassType*)type {
    return [EGBillboard type];
}

+ (EGVertexBufferDesc*)vbDesc {
    return _EGBillboard_vbDesc;
}

+ (ODClassType*)type {
    return _EGBillboard_type;
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


