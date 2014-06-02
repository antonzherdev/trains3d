#import "TRRainView.h"

#import "TRWeather.h"
#import "EGDirector.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "EGIndex.h"
#import "GL.h"
@implementation TRRainView
static CNClassType* _TRRainView_type;
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
        _system = [TRRainParticleSystem rainParticleSystemWithWeather:weather strength:strength];
        _view = [TRRainSystemView rainSystemViewWithSystem:_system];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRainView class]) _TRRainView_type = [CNClassType classTypeWithCls:[TRRainView class]];
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

- (NSString*)description {
    return [NSString stringWithFormat:@"RainView(%@, %f)", _weather, _strength];
}

- (CNClassType*)type {
    return [TRRainView type];
}

+ (CNClassType*)type {
    return _TRRainView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRRainParticleSystem
static CNClassType* _TRRainParticleSystem_type;
@synthesize weather = _weather;
@synthesize strength = _strength;

+ (instancetype)rainParticleSystemWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    return [[TRRainParticleSystem alloc] initWithWeather:weather strength:strength];
}

- (instancetype)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    self = [super initWithParticleType:trRainParticleType() maxCount:((unsigned int)(2000 * strength))];
    if(self) {
        _weather = weather;
        _strength = strength;
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRainParticleSystem class]) _TRRainParticleSystem_type = [CNClassType classTypeWithCls:[TRRainParticleSystem class]];
}

- (NSUInteger)vertexCount {
    return 2;
}

- (void)_init {
    NSInteger __il__0i = 0;
    TRRainParticle* __il__0p = self.particles;
    while(__il__0i < self.maxCount) {
        {
            __il__0p->position = geVec2MulI(geVec2Rnd(), 2);
            __il__0p->alpha = ((float)(cnFloatRndMinMax(0.1, 0.4) * [[EGDirector current] scale]));
        }
        __il__0i++;
        __il__0p++;
    }
}

- (void)doUpdateWithDelta:(CGFloat)delta {
    GEVec2 w = [_weather wind];
    GEVec2 vec = GEVec2Make((w.x + w.y) * 0.1, -float4Abs(w.y - w.x) * 0.3 - 0.05);
    {
        NSInteger __il__2i = 0;
        TRRainParticle* __il__2p = self.particles;
        while(__il__2i < self.maxCount) {
            {
                __il__2p->position = geVec2AddVec2(__il__2p->position, (geVec2MulI((geVec2MulF(vec, delta)), 10)));
                if(__il__2p->position.y < -1.0) __il__2p->position = GEVec2Make(((float)(cnFloatRnd() * 2 - 1)), (((float)(cnFloatRndMinMax(1.5, 1.1)))));
                if(__il__2p->position.x > 1.0) __il__2p->position = GEVec2Make(-1.0, __il__2p->position.y);
                if(__il__2p->position.x < -1.0) __il__2p->position = GEVec2Make(1.0, __il__2p->position.y);
            }
            __il__2i++;
            __il__2p++;
        }
    }
}

- (unsigned int)doWriteToArray:(TRRainData*)array {
    GEVec2 w = [_weather wind];
    GEVec2 vec = GEVec2Make((w.x + w.y) * 0.1, -float4Abs(w.y - w.x) * 0.3 - 0.05);
    {
        NSInteger __il__2i = 0;
        TRRainParticle* __il__2p = self.particles;
        TRRainData* __il__2a = array;
        while(__il__2i < self.maxCount) {
            __il__2a = ({
                TRRainData* a = __il__2a;
                a->position = __il__2p->position;
                a->alpha = __il__2p->alpha;
                a++;
                a->position = geVec2AddVec2(__il__2p->position, vec);
                a->alpha = __il__2p->alpha;
                a + 1;
            });
            __il__2i++;
            __il__2p++;
        }
        return self.maxCount;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RainParticleSystem(%@, %f)", _weather, _strength];
}

- (CNClassType*)type {
    return [TRRainParticleSystem type];
}

+ (CNClassType*)type {
    return _TRRainParticleSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

NSString* trRainParticleDescription(TRRainParticle self) {
    return [NSString stringWithFormat:@"RainParticle(%@, %f)", geVec2Description(self.position), self.alpha];
}
BOOL trRainParticleIsEqualTo(TRRainParticle self, TRRainParticle to) {
    return geVec2IsEqualTo(self.position, to.position) && eqf4(self.alpha, to.alpha);
}
NSUInteger trRainParticleHash(TRRainParticle self) {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2Hash(self.position);
    hash = hash * 31 + float4Hash(self.alpha);
    return hash;
}
CNPType* trRainParticleType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[TRRainParticleWrap class] name:@"TRRainParticle" size:sizeof(TRRainParticle) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRRainParticle, ((TRRainParticle*)(data))[i]);
    }];
    return _ret;
}
@implementation TRRainParticleWrap{
    TRRainParticle _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRRainParticle)value {
    return [[TRRainParticleWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRRainParticle)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return trRainParticleDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRainParticleWrap* o = ((TRRainParticleWrap*)(other));
    return trRainParticleIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return trRainParticleHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


NSString* trRainDataDescription(TRRainData self) {
    return [NSString stringWithFormat:@"RainData(%@, %f)", geVec2Description(self.position), self.alpha];
}
BOOL trRainDataIsEqualTo(TRRainData self, TRRainData to) {
    return geVec2IsEqualTo(self.position, to.position) && eqf4(self.alpha, to.alpha);
}
NSUInteger trRainDataHash(TRRainData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2Hash(self.position);
    hash = hash * 31 + float4Hash(self.alpha);
    return hash;
}
CNPType* trRainDataType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[TRRainDataWrap class] name:@"TRRainData" size:sizeof(TRRainData) wrap:^id(void* data, NSUInteger i) {
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
    return trRainDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRainDataWrap* o = ((TRRainDataWrap*)(other));
    return trRainDataIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return trRainDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation TRRainSystemView
static EGVertexBufferDesc* _TRRainSystemView_vbDesc;
static CNClassType* _TRRainSystemView_type;

+ (instancetype)rainSystemViewWithSystem:(TRRainParticleSystem*)system {
    return [[TRRainSystemView alloc] initWithSystem:system];
}

- (instancetype)initWithSystem:(TRRainParticleSystem*)system {
    self = [super initWithSystem:system vbDesc:TRRainSystemView.vbDesc shader:TRRainShader.instance material:nil blendFunc:EGBlendFunction.standard];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRainSystemView class]) {
        _TRRainSystemView_type = [CNClassType classTypeWithCls:[TRRainSystemView class]];
        _TRRainSystemView_vbDesc = [EGVertexBufferDesc vertexBufferDescWithDataType:trRainDataType() position:0 uv:-1 normal:-1 color:((int)(2 * 4)) model:-1];
    }
}

- (NSUInteger)indexCount {
    return 2;
}

- (id<EGIndexSource>)createIndexSource {
    return EGEmptyIndexSource.lines;
}

- (NSString*)description {
    return @"RainSystemView";
}

- (CNClassType*)type {
    return [TRRainSystemView type];
}

+ (EGVertexBufferDesc*)vbDesc {
    return _TRRainSystemView_vbDesc;
}

+ (CNClassType*)type {
    return _TRRainSystemView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRRainShaderText
static CNClassType* _TRRainShaderText_type;
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
    if(self == [TRRainShaderText class]) _TRRainShaderText_type = [CNClassType classTypeWithCls:[TRRainShaderText class]];
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

- (NSString*)description {
    return @"RainShaderText";
}

- (CNClassType*)type {
    return [TRRainShaderText type];
}

+ (CNClassType*)type {
    return _TRRainShaderText_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRRainShader
static TRRainShader* _TRRainShader_instance;
static CNClassType* _TRRainShader_type;
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
        _TRRainShader_type = [CNClassType classTypeWithCls:[TRRainShader class]];
        _TRRainShader_instance = [TRRainShader rainShader];
    }
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_alphaSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:1 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.color))];
}

- (void)loadUniformsParam:(id)param {
}

- (NSString*)description {
    return @"RainShader";
}

- (CNClassType*)type {
    return [TRRainShader type];
}

+ (TRRainShader*)instance {
    return _TRRainShader_instance;
}

+ (CNClassType*)type {
    return _TRRainShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

