#import "TRSnowView.h"

#import "TRWeather.h"
#import "EGContext.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "EGIndex.h"
#import "GL.h"
@implementation TRSnowView{
    TRWeather* _weather;
    CGFloat _strength;
    TRSnowParticleSystem* _system;
    TRSnowSystemView* _view;
}
static ODClassType* _TRSnowView_type;
@synthesize weather = _weather;
@synthesize strength = _strength;
@synthesize system = _system;
@synthesize view = _view;

+ (id)snowViewWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    return [[TRSnowView alloc] initWithWeather:weather strength:strength];
}

- (id)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
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
    _TRSnowView_type = [ODClassType classTypeWithCls:[TRSnowView class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_system updateWithDelta:delta];
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


@implementation TRSnowParticleSystem{
    TRWeather* _weather;
    CGFloat _strength;
    id<CNSeq> _particles;
}
static ODClassType* _TRSnowParticleSystem_type;
@synthesize weather = _weather;
@synthesize strength = _strength;
@synthesize particles = _particles;

+ (id)snowParticleSystemWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    return [[TRSnowParticleSystem alloc] initWithWeather:weather strength:strength];
}

- (id)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    self = [super init];
    __weak TRSnowParticleSystem* _weakSelf = self;
    if(self) {
        _weather = weather;
        _strength = strength;
        _particles = [[[intTo(0, ((NSInteger)(2000 * _strength))) chain] map:^TRSnowParticle*(id _) {
            return [TRSnowParticle snowParticleWithWeather:_weakSelf.weather];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSnowParticleSystem_type = [ODClassType classTypeWithCls:[TRSnowParticleSystem class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    [[self particles] forEach:^void(id _) {
        [_ updateWithDelta:delta];
    }];
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


@implementation TRSnowParticle{
    TRWeather* _weather;
    GEVec2 _position;
    CGFloat _alpha;
}
static ODClassType* _TRSnowParticle_type;
@synthesize weather = _weather;

+ (id)snowParticleWithWeather:(TRWeather*)weather {
    return [[TRSnowParticle alloc] initWithWeather:weather];
}

- (id)initWithWeather:(TRWeather*)weather {
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
    _TRSnowParticle_type = [ODClassType classTypeWithCls:[TRSnowParticle class]];
}

- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array {
    return cnVoidRefArrayWriteTpItem(cnVoidRefArrayWriteTpItem(array, TRSnowData, TRSnowDataMake(_position, ((float)(_alpha)))), TRSnowData, TRSnowDataMake(geVec2AddVec2(_position, [self vec]), ((float)(_alpha))));
}

- (GEVec2)vec {
    GEVec2 w = [_weather wind];
    return GEVec2Make((w.x + w.y) * 0.1, -float4Abs(w.y - w.x) * 0.3 - 0.05);
}

- (void)updateWithDelta:(CGFloat)delta {
    _position = geVec2AddVec2(_position, geVec2MulI(geVec2MulF([self vec], delta), 10));
    if(_position.y < -1.0) _position = GEVec2Make(((float)(odFloatRnd() * 2 - 1)), ((float)(odFloatRndMinMax(1.5, 1.1))));
}

- (ODClassType*)type {
    return [TRSnowParticle type];
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
    [description appendFormat:@", alpha=%f", self.alpha];
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

+ (id)snowSystemViewWithSystem:(TRSnowParticleSystem*)system {
    return [[TRSnowSystemView alloc] initWithSystem:system];
}

- (id)initWithSystem:(TRSnowParticleSystem*)system {
    self = [super initWithSystem:system vbDesc:TRSnowSystemView.vbDesc maxCount:[system.particles count] shader:TRSnowShader.instance material:nil blendFunc:EGBlendFunction.standard];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSnowSystemView_type = [ODClassType classTypeWithCls:[TRSnowSystemView class]];
    _TRSnowSystemView_vbDesc = [EGVertexBufferDesc vertexBufferDescWithDataType:trSnowDataType() position:0 uv:-1 normal:-1 color:((int)(2 * 4)) model:-1];
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


@implementation TRSnowShaderText{
    NSString* _fragment;
}
static ODClassType* _TRSnowShaderText_type;
@synthesize fragment = _fragment;

+ (id)snowShaderText {
    return [[TRSnowShaderText alloc] init];
}

- (id)init {
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
    _TRSnowShaderText_type = [ODClassType classTypeWithCls:[TRSnowShaderText class]];
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


@implementation TRSnowShader{
    EGShaderAttribute* _positionSlot;
    EGShaderAttribute* _alphaSlot;
}
static TRSnowShader* _TRSnowShader_instance;
static ODClassType* _TRSnowShader_type;
@synthesize positionSlot = _positionSlot;
@synthesize alphaSlot = _alphaSlot;

+ (id)snowShader {
    return [[TRSnowShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[[TRSnowShaderText snowShaderText] program]];
    if(self) {
        _positionSlot = [self attributeForName:@"position"];
        _alphaSlot = [self attributeForName:@"alpha"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSnowShader_type = [ODClassType classTypeWithCls:[TRSnowShader class]];
    _TRSnowShader_instance = [TRSnowShader snowShader];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_alphaSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:1 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.color))];
}

- (void)loadUniformsParam:(NSObject*)param {
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


