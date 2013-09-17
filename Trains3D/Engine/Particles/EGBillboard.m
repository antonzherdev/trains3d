#import "EGBillboard.h"

#import "EGMesh.h"
#import "GL.h"
#import "EGContext.h"
#import "EGTexture.h"
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

- (EGBillboardShader*)shaderForMaterial:(EGSimpleMaterial*)material {
    EGColorSource* __case__ = material.color;
    BOOL __incomplete__ = YES;
    EGBillboardShader* __result__;
    if(__incomplete__) {
        BOOL __ok__ = YES;
        GEVec4 _;
        if([__case__ isKindOfClass:[EGColorSourceColor class]]) {
            EGColorSourceColor* __case1__ = ((EGColorSourceColor*)(__case__));
            _ = [__case1__ color];
        } else {
            __ok__ = NO;
        }
        if(__ok__) {
            __result__ = [EGBillboardShader instanceForColor];
            __incomplete__ = NO;
        }
    }
    if(__incomplete__) {
        BOOL __ok__ = YES;
        if(__ok__) {
            __result__ = [EGBillboardShader instanceForTexture];
            __incomplete__ = NO;
        }
    }
    if(__incomplete__) @throw @"Case incomplete";
    return __result__;
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


@implementation EGBillboardShader{
    BOOL _texture;
    EGShaderAttribute* _positionSlot;
    EGShaderAttribute* _modelSlot;
    id _uvSlot;
    EGShaderAttribute* _colorSlot;
    id _colorUniform;
    EGShaderUniform* _wcUniform;
    EGShaderUniform* _pUniform;
}
static CNLazy* _EGBillboardShader__lazy_instanceForColor;
static CNLazy* _EGBillboardShader__lazy_instanceForTexture;
static ODClassType* _EGBillboardShader_type;
@synthesize texture = _texture;
@synthesize positionSlot = _positionSlot;
@synthesize modelSlot = _modelSlot;
@synthesize uvSlot = _uvSlot;
@synthesize colorSlot = _colorSlot;
@synthesize colorUniform = _colorUniform;
@synthesize wcUniform = _wcUniform;
@synthesize pUniform = _pUniform;

+ (id)billboardShaderWithProgram:(EGShaderProgram*)program texture:(BOOL)texture {
    return [[EGBillboardShader alloc] initWithProgram:program texture:texture];
}

- (id)initWithProgram:(EGShaderProgram*)program texture:(BOOL)texture {
    self = [super initWithProgram:program];
    if(self) {
        _texture = texture;
        _positionSlot = [self attributeForName:@"position"];
        _modelSlot = [self attributeForName:@"model"];
        _uvSlot = ((_texture) ? [CNOption opt:[self attributeForName:@"vertexUV"]] : [CNOption none]);
        _colorSlot = [self attributeForName:@"vertexColor"];
        _colorUniform = ((_texture) ? [CNOption none] : [CNOption opt:[self uniformForName:@"color"]]);
        _wcUniform = [self uniformForName:@"wc"];
        _pUniform = [self uniformForName:@"p"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboardShader_type = [ODClassType classTypeWithCls:[EGBillboardShader class]];
    _EGBillboardShader__lazy_instanceForColor = [CNLazy lazyWithF:^EGBillboardShader*() {
        return [EGBillboardShader billboardShaderWithProgram:[EGShaderProgram applyVertex:[EGBillboardShader vertexTextWithTexture:NO parameters:@"" code:@""] fragment:[EGBillboardShader fragmentTextWithTexture:NO parameters:@"" code:@""]] texture:NO];
    }];
    _EGBillboardShader__lazy_instanceForTexture = [CNLazy lazyWithF:^EGBillboardShader*() {
        return [EGBillboardShader billboardShaderWithProgram:[EGShaderProgram applyVertex:[EGBillboardShader vertexTextWithTexture:YES parameters:@"" code:@""] fragment:[EGBillboardShader fragmentTextWithTexture:YES parameters:@"" code:@""]] texture:YES];
    }];
}

+ (EGBillboardShader*)instanceForColor {
    return [_EGBillboardShader__lazy_instanceForColor get];
}

+ (EGBillboardShader*)instanceForTexture {
    return [_EGBillboardShader__lazy_instanceForTexture get];
}

+ (NSString*)vertexTextWithTexture:(BOOL)texture parameters:(NSString*)parameters code:(NSString*)code {
    return [NSString stringWithFormat:@"attribute vec3 position;\n"
        "attribute vec2 model;%@\n"
        "attribute vec4 vertexColor;\n"
        "\n"
        "uniform mat4 wc;\n"
        "uniform mat4 p;\n"
        "%@\n"
        "varying vec4 fragColor;\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "   float size = 0.03;\n"
        "   vec4 pos = wc*vec4(position, 1);\n"
        "   pos.x += model.x;\n"
        "   pos.y += model.y;\n"
        "   gl_Position = p*pos;\n"
        "   UV = vertexUV;\n"
        "   fragColor = vertexColor;\n"
        "   %@\n"
        "}", ((texture) ? @"\n"
        "attribute vec2 vertexUV; " : @""), ((texture) ? @"\n"
        "varying vec2 UV; " : @""), parameters, code];
}

+ (NSString*)fragmentTextWithTexture:(BOOL)texture parameters:(NSString*)parameters code:(NSString*)code {
    return [NSString stringWithFormat:@"\n"
        "%@\n"
        "varying vec4 fragColor;\n"
        "\n"
        "%@\n"
        "void main(void) {%@%@\n"
        "   %@\n"
        "}", ((texture) ? @"\n"
        "varying vec2 UV;\n"
        "uniform sampler2D texture;" : @"\n"
        "uniform vec4 color;"), parameters, ((texture) ? @"\n"
        "   gl_FragColor = fragColor * texture2D(texture, UV); " : @""), ((!(texture)) ? @"\n"
        "   gl_FragColor = fragColor * color; " : @""), code];
}

- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer param:(EGSimpleMaterial*)param {
    [_positionSlot setFromBufferWithStride:[vertexBuffer stride] valuesCount:3 valuesType:GL_FLOAT shift:0];
    [_modelSlot setFromBufferWithStride:[vertexBuffer stride] valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(3 * 4))];
    [_colorSlot setFromBufferWithStride:[vertexBuffer stride] valuesCount:4 valuesType:GL_FLOAT shift:((NSUInteger)(5 * 4))];
    [_wcUniform setMatrix:[EGGlobal.matrix.value wc]];
    [_pUniform setMatrix:EGGlobal.matrix.value.p];
    if(_texture) {
        [_uvSlot forEach:^void(EGShaderAttribute* _) {
            [_ setFromBufferWithStride:[vertexBuffer stride] valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(9 * 4))];
        }];
        [((EGColorSourceTexture*)(param.color)).texture bind];
    } else {
        [((EGShaderUniform*)([_colorUniform get])) setColor:((EGColorSourceColor*)(param.color)).color];
    }
}

- (void)unloadMaterial:(EGSimpleMaterial*)material {
    if(_texture) [EGTexture unbind];
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
    return [self.program isEqual:o.program] && self.texture == o.texture;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.program hash];
    hash = hash * 31 + self.texture;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"program=%@", self.program];
    [description appendFormat:@", texture=%d", self.texture];
    [description appendString:@">"];
    return description;
}

@end


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
    return cnVoidRefArrayWriteTpItem(cnVoidRefArrayWriteTpItem(cnVoidRefArrayWriteTpItem(cnVoidRefArrayWriteTpItem(array, EGBillboardBufferData, EGBillboardBufferDataMake(_position, _model.p1, _color, _uv.p1)), EGBillboardBufferData, EGBillboardBufferDataMake(_position, _model.p2, _color, _uv.p2)), EGBillboardBufferData, EGBillboardBufferDataMake(_position, _model.p3, _color, _uv.p3)), EGBillboardBufferData, EGBillboardBufferDataMake(_position, _model.p4, _color, _uv.p4));
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
    EGSimpleMaterial* _material;
    EGShader* _shader;
}
static ODClassType* _EGBillboardParticleSystemView_type;
@synthesize material = _material;
@synthesize shader = _shader;

+ (id)billboardParticleSystemViewWithMaxCount:(NSUInteger)maxCount material:(EGSimpleMaterial*)material blendFunc:(EGBlendFunction)blendFunc {
    return [[EGBillboardParticleSystemView alloc] initWithMaxCount:maxCount material:material blendFunc:blendFunc];
}

- (id)initWithMaxCount:(NSUInteger)maxCount material:(EGSimpleMaterial*)material blendFunc:(EGBlendFunction)blendFunc {
    self = [super initWithDtp:egBillboardBufferDataType() maxCount:maxCount blendFunc:blendFunc];
    if(self) {
        _material = material;
        _shader = [EGBillboardShaderSystem.instance shaderForMaterial:_material];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboardParticleSystemView_type = [ODClassType classTypeWithCls:[EGBillboardParticleSystemView class]];
}

+ (EGBillboardParticleSystemView*)applyMaxCount:(NSUInteger)maxCount material:(EGSimpleMaterial*)material {
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


