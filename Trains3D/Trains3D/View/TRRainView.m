#import "TRRainView.h"

#import "TRWeather.h"
#import "EGContext.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "EGIndex.h"
#import "GL.h"
@implementation TRRainView{
    TRWeather* _weather;
    CGFloat _strength;
    TRRainParticleSystem* _system;
    TRRainSystemView* _view;
}
static ODClassType* _TRRainView_type;
@synthesize weather = _weather;
@synthesize strength = _strength;
@synthesize system = _system;
@synthesize view = _view;

+ (instancetype)rainViewWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    return [[TRRainView alloc] initWithWeather:weather strength:strength];
}

- (instancetype)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    self = [super init];
    if(self) {
        _weather = weather;
        _strength = strength;
        _system = [TRRainParticleSystem rainParticleSystemWithWeather:_weather strength:_strength];
        _view = [TRRainSystemView rainSystemViewWithSystem:_system];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRainView class]) _TRRainView_type = [ODClassType classTypeWithCls:[TRRainView class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_system updateWithDelta:delta];
}

- (void)draw {
    [_view draw];
}

- (ODClassType*)type {
    return [TRRainView type];
}

+ (ODClassType*)type {
    return _TRRainView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRainView* o = ((TRRainView*)(other));
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


@implementation TRRainParticleSystem{
    TRWeather* _weather;
    CGFloat _strength;
    id<CNSeq> _particles;
}
static ODClassType* _TRRainParticleSystem_type;
@synthesize weather = _weather;
@synthesize strength = _strength;
@synthesize particles = _particles;

+ (instancetype)rainParticleSystemWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    return [[TRRainParticleSystem alloc] initWithWeather:weather strength:strength];
}

- (instancetype)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    self = [super init];
    __weak TRRainParticleSystem* _weakSelf = self;
    if(self) {
        _weather = weather;
        _strength = strength;
        _particles = [[[intTo(0, ((NSInteger)(2000 * _strength))) chain] map:^TRRainParticle*(id _) {
            return [TRRainParticle rainParticleWithWeather:_weakSelf.weather];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRainParticleSystem class]) _TRRainParticleSystem_type = [ODClassType classTypeWithCls:[TRRainParticleSystem class]];
}

- (ODClassType*)type {
    return [TRRainParticleSystem type];
}

+ (ODClassType*)type {
    return _TRRainParticleSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRainParticleSystem* o = ((TRRainParticleSystem*)(other));
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


@implementation TRRainParticle{
    TRWeather* _weather;
    GEVec2 _position;
    CGFloat _alpha;
}
static ODClassType* _TRRainParticle_type;
@synthesize weather = _weather;

+ (instancetype)rainParticleWithWeather:(TRWeather*)weather {
    return [[TRRainParticle alloc] initWithWeather:weather];
}

- (instancetype)initWithWeather:(TRWeather*)weather {
    self = [super init];
    if(self) {
        _weather = weather;
        _position = geVec2MulI(geVec2Rnd(), 2);
        _alpha = odFloatRndMinMax(0.1, 0.4) * EGGlobal.context.scale;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRainParticle class]) _TRRainParticle_type = [ODClassType classTypeWithCls:[TRRainParticle class]];
}

- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array {
    return cnVoidRefArrayWriteTpItem((cnVoidRefArrayWriteTpItem(array, TRRainData, (TRRainDataMake(_position, ((float)(_alpha)))))), TRRainData, (TRRainDataMake((geVec2AddVec2(_position, [self vec])), ((float)(_alpha)))));
}

- (GEVec2)vec {
    GEVec2 w = [_weather wind];
    return GEVec2Make((w.x + w.y) * 0.1, -float4Abs(w.y - w.x) * 0.3 - 0.05);
}

- (void)updateWithDelta:(CGFloat)delta {
    _position = geVec2AddVec2(_position, (geVec2MulI((geVec2MulF([self vec], delta)), 10)));
    if(_position.y < -1.0) _position = GEVec2Make(((float)(odFloatRnd() * 2 - 1)), (((float)(odFloatRndMinMax(1.5, 1.1)))));
    if(_position.x > 1.0) _position = GEVec2Make(-1.0, _position.y);
    if(_position.x < -1.0) _position = GEVec2Make(1.0, _position.y);
}

- (ODClassType*)type {
    return [TRRainParticle type];
}

+ (ODClassType*)type {
    return _TRRainParticle_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRainParticle* o = ((TRRainParticle*)(other));
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


NSString* TRRainDataDescription(TRRainData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRRainData: "];
    [description appendFormat:@"position=%@", GEVec2Description(self.position)];
    [description appendFormat:@", alpha=%f", self.alpha];
    [description appendString:@">"];
    return description;
}
ODPType* trRainDataType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[TRRainDataWrap class] name:@"TRRainData" size:sizeof(TRRainData) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRRainData, ((TRRainData*)(data))[i]);
    }];
    return _ret;
}
@implementation TRRainDataWrap{
    TRRainData _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRRainData)value {
    return [[TRRainDataWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRRainData)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return TRRainDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRainDataWrap* o = ((TRRainDataWrap*)(other));
    return TRRainDataEq(_value, o.value);
}

- (NSUInteger)hash {
    return TRRainDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



@implementation TRRainSystemView
static EGVertexBufferDesc* _TRRainSystemView_vbDesc;
static ODClassType* _TRRainSystemView_type;

+ (instancetype)rainSystemViewWithSystem:(TRRainParticleSystem*)system {
    return [[TRRainSystemView alloc] initWithSystem:system];
}

- (instancetype)initWithSystem:(TRRainParticleSystem*)system {
    self = [super initWithSystem:system vbDesc:TRRainSystemView.vbDesc maxCount:[system.particles count] shader:TRRainShader.instance material:nil blendFunc:EGBlendFunction.standard];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRainSystemView class]) {
        _TRRainSystemView_type = [ODClassType classTypeWithCls:[TRRainSystemView class]];
        _TRRainSystemView_vbDesc = [EGVertexBufferDesc vertexBufferDescWithDataType:trRainDataType() position:0 uv:-1 normal:-1 color:((int)(2 * 4)) model:-1];
    }
}

- (NSUInteger)vertexCount {
    return 2;
}

- (NSUInteger)indexCount {
    return 2;
}

- (id<EGIndexSource>)indexVertexCount:(NSUInteger)vertexCount maxCount:(NSUInteger)maxCount {
    return EGEmptyIndexSource.lines;
}

- (ODClassType*)type {
    return [TRRainSystemView type];
}

+ (EGVertexBufferDesc*)vbDesc {
    return _TRRainSystemView_vbDesc;
}

+ (ODClassType*)type {
    return _TRRainSystemView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRainSystemView* o = ((TRRainSystemView*)(other));
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


@implementation TRRainShaderText{
    NSString* _fragment;
}
static ODClassType* _TRRainShaderText_type;
@synthesize fragment = _fragment;

+ (instancetype)rainShaderText {
    return [[TRRainShaderText alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _fragment = [NSString stringWithFormat:@"%@\n"
        "%@ lowp float fAlpha;\n"
        "\n"
        "void main(void) {\n"
        "   %@ = vec4(0.7, 0.7, 0.7, fAlpha);\n"
        "}", [self fragmentHeader], [self in], [self fragColor]];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRainShaderText class]) _TRRainShaderText_type = [ODClassType classTypeWithCls:[TRRainShaderText class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "%@ highp vec2 position;\n"
        "%@ lowp float alpha;\n"
        "%@ lowp float fAlpha;\n"
        "\n"
        "void main(void) {\n"
        "   gl_Position = vec4(position.x, position.y, 0, 1);\n"
        "   fAlpha = alpha;\n"
        "}", [self vertexHeader], [self ain], [self ain], [self out]];
}

- (EGShaderProgram*)program {
    return [EGShaderProgram applyName:@"Rain" vertex:[self vertex] fragment:_fragment];
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
    return [TRRainShaderText type];
}

+ (ODClassType*)type {
    return _TRRainShaderText_type;
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


@implementation TRRainShader{
    EGShaderAttribute* _positionSlot;
    EGShaderAttribute* _alphaSlot;
}
static TRRainShader* _TRRainShader_instance;
static ODClassType* _TRRainShader_type;
@synthesize positionSlot = _positionSlot;
@synthesize alphaSlot = _alphaSlot;

+ (instancetype)rainShader {
    return [[TRRainShader alloc] init];
}

- (instancetype)init {
    self = [super initWithProgram:[[TRRainShaderText rainShaderText] program]];
    if(self) {
        _positionSlot = [self attributeForName:@"position"];
        _alphaSlot = [self attributeForName:@"alpha"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRainShader class]) {
        _TRRainShader_type = [ODClassType classTypeWithCls:[TRRainShader class]];
        _TRRainShader_instance = [TRRainShader rainShader];
    }
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_alphaSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:1 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.color))];
}

- (void)loadUniformsParam:(NSObject*)param {
}

- (ODClassType*)type {
    return [TRRainShader type];
}

+ (TRRainShader*)instance {
    return _TRRainShader_instance;
}

+ (ODClassType*)type {
    return _TRRainShader_type;
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


