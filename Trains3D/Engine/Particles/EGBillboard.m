#import "EGBillboard.h"

#import "EGContext.h"
#import "EGShadow.h"
#import "EGMesh.h"
#import "GL.h"
#import "EGTexture.h"
#import "EGSprite.h"
#import "GEMat4.h"
@implementation EGBillboardShaderSystem
static ODClassType* _EGBillboardShaderSystem_type;

+ (void)initialize {
    [super initialize];
    _EGBillboardShaderSystem_type = [ODClassType classTypeWithCls:[EGBillboardShaderSystem class]];
}

+ (EGBillboardShader*)shaderForParam:(EGColorSource*)param {
    if([EGGlobal.context.renderTarget isKindOfClass:[EGShadowRenderTarget class]]) {
        if([EGShadowShaderSystem isColorShaderForParam:param]) return [EGBillboardShader instanceForColorShadow];
        else return [EGBillboardShader instanceForTextureShadow];
    } else {
        if([param.texture isEmpty]) return [EGBillboardShader instanceForColor];
        else return [EGBillboardShader instanceForTexture];
    }
}

- (ODClassType*)type {
    return [EGBillboardShaderSystem type];
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
    BOOL _shadow;
    NSString* _parameters;
    NSString* _code;
}
static ODClassType* _EGBillboardShaderBuilder_type;
@synthesize texture = _texture;
@synthesize shadow = _shadow;
@synthesize parameters = _parameters;
@synthesize code = _code;

+ (id)billboardShaderBuilderWithTexture:(BOOL)texture shadow:(BOOL)shadow parameters:(NSString*)parameters code:(NSString*)code {
    return [[EGBillboardShaderBuilder alloc] initWithTexture:texture shadow:shadow parameters:parameters code:code];
}

- (id)initWithTexture:(BOOL)texture shadow:(BOOL)shadow parameters:(NSString*)parameters code:(NSString*)code {
    self = [super init];
    if(self) {
        _texture = texture;
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
        "}", [self vertexHeader], [self ain], [self ain], ((_texture) ? [NSString stringWithFormat:@"\n"
        "%@ mediump vec2 vertexUV;\n"
        "%@ mediump vec2 UV;\n", [self ain], [self out]] : @""), [self ain], [self out], _parameters, ((_texture) ? @"\n"
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
        "    if(%@.a < alphaTestLevel) {\n"
        "        discard;\n"
        "    }%@\n"
        "    %@\n"
        "}", [self versionString], ((_texture) ? [NSString stringWithFormat:@"\n"
        "%@ mediump vec2 UV;\n"
        "uniform lowp sampler2D texture;\n", [self in]] : @""), [self in], ((_shadow) ? @"\n"
        "out float depth;\n" : [NSString stringWithFormat:@"\n"
        "%@\n", [self fragColorDeclaration]]), _parameters, ((_shadow && !([self isFragColorDeclared])) ? @"\n"
        "    lowp vec4 fragColor;" : @""), ((_texture) ? [NSString stringWithFormat:@"\n"
        "    %@ = fColor * color * %@(texture, UV);\n"
        "   ", [self fragColor], [self texture2D]] : [NSString stringWithFormat:@"\n"
        "    %@ = fColor * color;\n"
        "   ", [self fragColor]]), [self fragColor], ((_shadow) ? @"\n"
        "    depth = gl_FragCoord.z;" : @""), _code];
}

- (EGShaderProgram*)program {
    return [EGShaderProgram applyVertex:[self vertex] fragment:[self fragment]];
}

- (NSString*)versionString {
    return [NSString stringWithFormat:@"#version %li", [self version]];
}

- (NSString*)vertexHeader {
    return [NSString stringWithFormat:@"#version %li", [self version]];
}

- (NSString*)fragmentHeader {
    return [NSString stringWithFormat:@"#version %li\n"
        "%@", [self version], [self fragColorDeclaration]];
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
    return self.texture == o.texture && self.shadow == o.shadow && [self.parameters isEqual:o.parameters] && [self.code isEqual:o.code];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.texture;
    hash = hash * 31 + self.shadow;
    hash = hash * 31 + [self.parameters hash];
    hash = hash * 31 + [self.code hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%d", self.texture];
    [description appendFormat:@", shadow=%d", self.shadow];
    [description appendFormat:@", parameters=%@", self.parameters];
    [description appendFormat:@", code=%@", self.code];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBillboardShader{
    BOOL _texture;
    BOOL _shadow;
    EGShaderAttribute* _positionSlot;
    EGShaderAttribute* _modelSlot;
    id _uvSlot;
    EGShaderAttribute* _colorSlot;
    EGShaderUniform* _colorUniform;
    EGShaderUniform* _alphaTestLevelUniform;
    EGShaderUniform* _wcUniform;
    EGShaderUniform* _pUniform;
}
static CNLazy* _EGBillboardShader__lazy_instanceForColor;
static CNLazy* _EGBillboardShader__lazy_instanceForTexture;
static CNLazy* _EGBillboardShader__lazy_instanceForColorShadow;
static CNLazy* _EGBillboardShader__lazy_instanceForTextureShadow;
static ODClassType* _EGBillboardShader_type;
@synthesize texture = _texture;
@synthesize shadow = _shadow;
@synthesize positionSlot = _positionSlot;
@synthesize modelSlot = _modelSlot;
@synthesize uvSlot = _uvSlot;
@synthesize colorSlot = _colorSlot;
@synthesize colorUniform = _colorUniform;
@synthesize alphaTestLevelUniform = _alphaTestLevelUniform;
@synthesize wcUniform = _wcUniform;
@synthesize pUniform = _pUniform;

+ (id)billboardShaderWithProgram:(EGShaderProgram*)program texture:(BOOL)texture shadow:(BOOL)shadow {
    return [[EGBillboardShader alloc] initWithProgram:program texture:texture shadow:shadow];
}

- (id)initWithProgram:(EGShaderProgram*)program texture:(BOOL)texture shadow:(BOOL)shadow {
    self = [super initWithProgram:program];
    if(self) {
        _texture = texture;
        _shadow = shadow;
        _positionSlot = [self attributeForName:@"position"];
        _modelSlot = [self attributeForName:@"model"];
        _uvSlot = ((_texture) ? [CNOption applyValue:[self attributeForName:@"vertexUV"]] : [CNOption none]);
        _colorSlot = [self attributeForName:@"vertexColor"];
        _colorUniform = [self uniformForName:@"color"];
        _alphaTestLevelUniform = [self uniformForName:@"alphaTestLevel"];
        _wcUniform = [self uniformForName:@"wc"];
        _pUniform = [self uniformForName:@"p"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboardShader_type = [ODClassType classTypeWithCls:[EGBillboardShader class]];
    _EGBillboardShader__lazy_instanceForColor = [CNLazy lazyWithF:^EGBillboardShader*() {
        return [EGBillboardShader billboardShaderWithProgram:[[EGBillboardShaderBuilder billboardShaderBuilderWithTexture:NO shadow:NO parameters:@"" code:@""] program] texture:NO shadow:NO];
    }];
    _EGBillboardShader__lazy_instanceForTexture = [CNLazy lazyWithF:^EGBillboardShader*() {
        return [EGBillboardShader billboardShaderWithProgram:[[EGBillboardShaderBuilder billboardShaderBuilderWithTexture:YES shadow:NO parameters:@"" code:@""] program] texture:YES shadow:NO];
    }];
    _EGBillboardShader__lazy_instanceForColorShadow = [CNLazy lazyWithF:^EGBillboardShader*() {
        return [EGBillboardShader billboardShaderWithProgram:[[EGBillboardShaderBuilder billboardShaderBuilderWithTexture:NO shadow:YES parameters:@"" code:@""] program] texture:NO shadow:YES];
    }];
    _EGBillboardShader__lazy_instanceForTextureShadow = [CNLazy lazyWithF:^EGBillboardShader*() {
        return [EGBillboardShader billboardShaderWithProgram:[[EGBillboardShaderBuilder billboardShaderBuilderWithTexture:YES shadow:YES parameters:@"" code:@""] program] texture:YES shadow:YES];
    }];
}

+ (EGBillboardShader*)instanceForColor {
    return ((EGBillboardShader*)([_EGBillboardShader__lazy_instanceForColor get]));
}

+ (EGBillboardShader*)instanceForTexture {
    return ((EGBillboardShader*)([_EGBillboardShader__lazy_instanceForTexture get]));
}

+ (EGBillboardShader*)instanceForColorShadow {
    return ((EGBillboardShader*)([_EGBillboardShader__lazy_instanceForColorShadow get]));
}

+ (EGBillboardShader*)instanceForTextureShadow {
    return ((EGBillboardShader*)([_EGBillboardShader__lazy_instanceForTextureShadow get]));
}

- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGColorSource*)param {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_modelSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
    [_colorSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:4 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.color))];
    [_wcUniform setMatrix:[EGGlobal.matrix.value wc]];
    [_pUniform setMatrix:EGGlobal.matrix.value.p];
    [_alphaTestLevelUniform setF4:param.alphaTestLevel];
    if(_texture) {
        [_uvSlot forEach:^void(EGShaderAttribute* _) {
            [_ setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
        }];
        [((EGTexture*)([param.texture get])) bind];
    }
    [_colorUniform setVec4:param.color];
}

- (void)unloadParam:(EGColorSource*)param {
    if(_texture) [EGTexture unbind];
    [_positionSlot unbind];
    [_modelSlot unbind];
    [_colorSlot unbind];
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
    return [self.program isEqual:o.program] && self.texture == o.texture && self.shadow == o.shadow;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.program hash];
    hash = hash * 31 + self.texture;
    hash = hash * 31 + self.shadow;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"program=%@", self.program];
    [description appendFormat:@", texture=%d", self.texture];
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



@implementation EGBillboardParticleSystem
static ODClassType* _EGBillboardParticleSystem_type;

+ (id)billboardParticleSystem {
    return [[EGBillboardParticleSystem alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboardParticleSystem_type = [ODClassType classTypeWithCls:[EGBillboardParticleSystem class]];
}

- (ODClassType*)type {
    return [EGBillboardParticleSystem type];
}

+ (ODClassType*)type {
    return _EGBillboardParticleSystem_type;
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


@implementation EGBillboardParticle{
    GEVec3 _position;
    GEQuad _uv;
    GEQuad _model;
    GEVec4 _color;
}
static ODClassType* _EGBillboardParticle_type;
@synthesize position = _position;
@synthesize uv = _uv;
@synthesize model = _model;
@synthesize color = _color;

+ (id)billboardParticleWithLifeLength:(float)lifeLength {
    return [[EGBillboardParticle alloc] initWithLifeLength:lifeLength];
}

- (id)initWithLifeLength:(float)lifeLength {
    self = [super initWithLifeLength:lifeLength];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboardParticle_type = [ODClassType classTypeWithCls:[EGBillboardParticle class]];
}

- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array {
    return cnVoidRefArrayWriteTpItem(cnVoidRefArrayWriteTpItem(cnVoidRefArrayWriteTpItem(cnVoidRefArrayWriteTpItem(array, EGBillboardBufferData, EGBillboardBufferDataMake(_position, _model.p[0], _color, _uv.p[0])), EGBillboardBufferData, EGBillboardBufferDataMake(_position, _model.p[1], _color, _uv.p[1])), EGBillboardBufferData, EGBillboardBufferDataMake(_position, _model.p[2], _color, _uv.p[2])), EGBillboardBufferData, EGBillboardBufferDataMake(_position, _model.p[3], _color, _uv.p[3]));
}

- (ODClassType*)type {
    return [EGBillboardParticle type];
}

+ (ODClassType*)type {
    return _EGBillboardParticle_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"lifeLength=%f", self.lifeLength];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBillboardParticleSystemView{
    EGColorSource* _material;
    EGShader* _shader;
}
static ODClassType* _EGBillboardParticleSystemView_type;
@synthesize material = _material;
@synthesize shader = _shader;

+ (id)billboardParticleSystemViewWithMaxCount:(NSUInteger)maxCount material:(EGColorSource*)material blendFunc:(EGBlendFunction)blendFunc {
    return [[EGBillboardParticleSystemView alloc] initWithMaxCount:maxCount material:material blendFunc:blendFunc];
}

- (id)initWithMaxCount:(NSUInteger)maxCount material:(EGColorSource*)material blendFunc:(EGBlendFunction)blendFunc {
    self = [super initWithVbDesc:EGBillboard.vbDesc maxCount:maxCount blendFunc:blendFunc];
    if(self) {
        _material = material;
        _shader = [EGBillboardShaderSystem shaderForParam:_material];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboardParticleSystemView_type = [ODClassType classTypeWithCls:[EGBillboardParticleSystemView class]];
}

+ (EGBillboardParticleSystemView*)applyMaxCount:(NSUInteger)maxCount material:(EGColorSource*)material {
    return [EGBillboardParticleSystemView billboardParticleSystemViewWithMaxCount:maxCount material:material blendFunc:egBlendFunctionStandard()];
}

- (NSUInteger)vertexCount {
    return 4;
}

- (CNVoidRefArray)writeIndexesToIndexPointer:(CNVoidRefArray)indexPointer i:(unsigned int)i {
    return cnVoidRefArrayWriteUInt4(cnVoidRefArrayWriteUInt4(cnVoidRefArrayWriteUInt4(cnVoidRefArrayWriteUInt4(cnVoidRefArrayWriteUInt4(cnVoidRefArrayWriteUInt4(indexPointer, i), i + 1), i + 2), i + 2), i), i + 3);
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
    return self.maxCount == o.maxCount && [self.material isEqual:o.material] && EGBlendFunctionEq(self.blendFunc, o.blendFunc);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.maxCount;
    hash = hash * 31 + [self.material hash];
    hash = hash * 31 + EGBlendFunctionHash(self.blendFunc);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"maxCount=%li", self.maxCount];
    [description appendFormat:@", material=%@", self.material];
    [description appendFormat:@", blendFunc=%@", EGBlendFunctionDescription(self.blendFunc)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBillboard{
    EGColorSource* _material;
    GERect _uv;
    GEVec3 _position;
    GERect _rect;
}
static EGVertexBufferDesc* _EGBillboard_vbDesc;
static ODClassType* _EGBillboard_type;
@synthesize material = _material;
@synthesize uv = _uv;
@synthesize position = _position;
@synthesize rect = _rect;

+ (id)billboard {
    return [[EGBillboard alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _uv = geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0);
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
    [EGD2D drawSpriteMaterial:_material at:_position quad:geRectQuad(_rect) uv:geRectQuad(_uv)];
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


