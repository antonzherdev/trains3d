#import "TRSnowView.h"

#import "TRWeather.h"
#import "EGTexture.h"
#import "EGContext.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "EGIndex.h"
#import "GL.h"
@implementation TRSnowView
static ODClassType* _TRSnowView_type;
@synthesize weather = _weather;
@synthesize strength = _strength;
@synthesize system = _system;
@synthesize view = _view;

+ (instancetype)snowViewWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    return [[TRSnowView alloc] initWithWeather:weather strength:strength];
}

- (instancetype)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    self = [super init];
    if(self) {
        _weather = weather;
        _strength = strength;
        _system = [TRSnowParticleSystem snowParticleSystemWithWeather:_weather strength:_strength];
        _view = [TRSnowSystemView snowSystemViewWithSystem:_system];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSnowView class]) _TRSnowView_type = [ODClassType classTypeWithCls:[TRSnowView class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_system updateWithDelta:delta];
}

- (void)complete {
    [_view prepare];
}

- (void)draw {
    [_view draw];
}

- (ODClassType*)type {
    return [TRSnowView type];
}

+ (ODClassType*)type {
    return _TRSnowView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSnowView* o = ((TRSnowView*)(other));
    return [self.weather isEqual:o.weather] && eqf(self.strength, o.strength);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.weather hash];
    hash = hash * 31 + floatHash(self.strength);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"weather=%@", self.weather];
    [description appendFormat:@", strength=%f", self.strength];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSnowParticleSystem
static ODClassType* _TRSnowParticleSystem_type;
@synthesize weather = _weather;
@synthesize strength = _strength;
@synthesize particles = _particles;

+ (instancetype)snowParticleSystemWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    return [[TRSnowParticleSystem alloc] initWithWeather:weather strength:strength];
}

- (instancetype)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    self = [super init];
    if(self) {
        _weather = weather;
        _strength = strength;
        _particles = [[[intTo(0, ((NSInteger)(2000 * _strength))) chain] map:^TRSnowParticle*(id _) {
            return [TRSnowParticle snowParticleWithWeather:_weather];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSnowParticleSystem class]) _TRSnowParticleSystem_type = [ODClassType classTypeWithCls:[TRSnowParticleSystem class]];
}

- (ODClassType*)type {
    return [TRSnowParticleSystem type];
}

+ (ODClassType*)type {
    return _TRSnowParticleSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSnowParticleSystem* o = ((TRSnowParticleSystem*)(other));
    return [self.weather isEqual:o.weather] && eqf(self.strength, o.strength);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.weather hash];
    hash = hash * 31 + floatHash(self.strength);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"weather=%@", self.weather];
    [description appendFormat:@", strength=%f", self.strength];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSnowParticle
static GEQuadrant _TRSnowParticle_textureQuadrant;
static ODClassType* _TRSnowParticle_type;
@synthesize weather = _weather;

+ (instancetype)snowParticleWithWeather:(TRWeather*)weather {
    return [[TRSnowParticle alloc] initWithWeather:weather];
}

- (instancetype)initWithWeather:(TRWeather*)weather {
    self = [super init];
    if(self) {
        _weather = weather;
        _position = geVec2MulI(geVec2Rnd(), 2);
        _size = odFloatRndMinMax(0.004, 0.01);
        _windVar = GEVec2Make((((float)(odFloatRndMinMax(0.8, 1.2)))), (((float)(odFloatRndMinMax(0.8, 1.2)))));
        _urge = GEVec2Make((((float)(odFloatRndMinMax(-0.03, 0.03)))), (((float)(odFloatRndMinMax(-0.02, 0.02)))));
        _uv = geQuadrantRndQuad(_TRSnowParticle_textureQuadrant);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSnowParticle class]) {
        _TRSnowParticle_type = [ODClassType classTypeWithCls:[TRSnowParticle class]];
        _TRSnowParticle_textureQuadrant = geQuadQuadrant(geQuadIdentity());
    }
}

- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array {
    return cnVoidRefArrayWriteTpItem((cnVoidRefArrayWriteTpItem((cnVoidRefArrayWriteTpItem((cnVoidRefArrayWriteTpItem(array, TRSnowData, (TRSnowDataMake(_position, _uv.p0)))), TRSnowData, (TRSnowDataMake((GEVec2Make(_position.x + _size, _position.y)), _uv.p1)))), TRSnowData, (TRSnowDataMake((GEVec2Make(_position.x + _size, _position.y + _size)), _uv.p2)))), TRSnowData, (TRSnowDataMake((GEVec2Make(_position.x, _position.y + _size)), _uv.p3)));
}

- (GEVec2)vec {
    GEVec2 w = [_weather wind];
    return geVec2AddVec2((geVec2MulVec2((GEVec2Make((w.x + w.y) * 0.3, -float4Abs(w.y - w.x) * 0.3 - 0.05)), _windVar)), _urge);
}

- (void)updateWithDelta:(CGFloat)delta {
    _position = geVec2AddVec2(_position, (geVec2MulF([self vec], delta)));
    if(_position.y < -1.0) _position = GEVec2Make(((float)(odFloatRnd() * 2 - 1)), (((float)(odFloatRndMinMax(1.5, 1.1)))));
    if(_position.x > 1.0) _position = GEVec2Make(-1.0, _position.y);
    if(_position.x < -1.0) _position = GEVec2Make(1.0, _position.y);
}

- (ODClassType*)type {
    return [TRSnowParticle type];
}

+ (GEQuadrant)textureQuadrant {
    return _TRSnowParticle_textureQuadrant;
}

+ (ODClassType*)type {
    return _TRSnowParticle_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSnowParticle* o = ((TRSnowParticle*)(other));
    return [self.weather isEqual:o.weather];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.weather hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"weather=%@", self.weather];
    [description appendString:@">"];
    return description;
}

@end


NSString* TRSnowDataDescription(TRSnowData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRSnowData: "];
    [description appendFormat:@"position=%@", GEVec2Description(self.position)];
    [description appendFormat:@", uv=%@", GEVec2Description(self.uv)];
    [description appendString:@">"];
    return description;
}
ODPType* trSnowDataType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[TRSnowDataWrap class] name:@"TRSnowData" size:sizeof(TRSnowData) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRSnowData, ((TRSnowData*)(data))[i]);
    }];
    return _ret;
}
@implementation TRSnowDataWrap{
    TRSnowData _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRSnowData)value {
    return [[TRSnowDataWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRSnowData)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return TRSnowDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSnowDataWrap* o = ((TRSnowDataWrap*)(other));
    return TRSnowDataEq(_value, o.value);
}

- (NSUInteger)hash {
    return TRSnowDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



@implementation TRSnowSystemView
static EGVertexBufferDesc* _TRSnowSystemView_vbDesc;
static ODClassType* _TRSnowSystemView_type;

+ (instancetype)snowSystemViewWithSystem:(TRSnowParticleSystem*)system {
    return [[TRSnowSystemView alloc] initWithSystem:system];
}

- (instancetype)initWithSystem:(TRSnowParticleSystem*)system {
    self = [super initWithSystem:system vbDesc:TRSnowSystemView.vbDesc maxCount:[system.particles count] shader:TRSnowShader.instance material:[EGGlobal compressedTextureForFile:@"Snowflake" filter:EGTextureFilter.mipmapNearest] blendFunc:EGBlendFunction.premultiplied];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSnowSystemView class]) {
        _TRSnowSystemView_type = [ODClassType classTypeWithCls:[TRSnowSystemView class]];
        _TRSnowSystemView_vbDesc = [EGVertexBufferDesc vertexBufferDescWithDataType:trSnowDataType() position:0 uv:((int)(2 * 4)) normal:-1 color:-1 model:-1];
    }
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
    return [TRSnowSystemView type];
}

+ (EGVertexBufferDesc*)vbDesc {
    return _TRSnowSystemView_vbDesc;
}

+ (ODClassType*)type {
    return _TRSnowSystemView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSnowSystemView* o = ((TRSnowSystemView*)(other));
    return [self.system isEqual:o.system];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.system hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"system=%@", self.system];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSnowShaderText
static ODClassType* _TRSnowShaderText_type;
@synthesize fragment = _fragment;

+ (instancetype)snowShaderText {
    return [[TRSnowShaderText alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _fragment = [NSString stringWithFormat:@"%@\n"
        "%@ mediump vec2 fuv;\n"
        "uniform lowp sampler2D txt;\n"
        "\n"
        "void main(void) {\n"
        "   %@ = %@(txt, fuv);\n"
        "}", [self fragmentHeader], [self in], [self fragColor], [self texture2D]];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSnowShaderText class]) _TRSnowShaderText_type = [ODClassType classTypeWithCls:[TRSnowShaderText class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "%@ highp vec2 position;\n"
        "%@ mediump vec2 uv;\n"
        "%@ mediump vec2 fuv;\n"
        "\n"
        "void main(void) {\n"
        "   gl_Position = vec4(position.x, position.y, 0, 1);\n"
        "   fuv = uv;\n"
        "}", [self vertexHeader], [self ain], [self ain], [self out]];
}

- (EGShaderProgram*)program {
    return [EGShaderProgram applyName:@"Snow" vertex:[self vertex] fragment:_fragment];
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
    return [TRSnowShaderText type];
}

+ (ODClassType*)type {
    return _TRSnowShaderText_type;
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


@implementation TRSnowShader
static TRSnowShader* _TRSnowShader_instance;
static ODClassType* _TRSnowShader_type;
@synthesize positionSlot = _positionSlot;
@synthesize uvSlot = _uvSlot;

+ (instancetype)snowShader {
    return [[TRSnowShader alloc] init];
}

- (instancetype)init {
    self = [super initWithProgram:[[TRSnowShaderText snowShaderText] program]];
    if(self) {
        _positionSlot = [self attributeForName:@"position"];
        _uvSlot = [self attributeForName:@"uv"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSnowShader class]) {
        _TRSnowShader_type = [ODClassType classTypeWithCls:[TRSnowShader class]];
        _TRSnowShader_instance = [TRSnowShader snowShader];
    }
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_uvSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
}

- (void)loadUniformsParam:(EGTexture*)param {
    [EGGlobal.context bindTextureTexture:param];
}

- (ODClassType*)type {
    return [TRSnowShader type];
}

+ (TRSnowShader*)instance {
    return _TRSnowShader_instance;
}

+ (ODClassType*)type {
    return _TRSnowShader_type;
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


