#import "TRPrecipitationView.h"

#import "TRWeather.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "EGIndex.h"
@implementation TRPrecipitationView
static ODClassType* _TRPrecipitationView_type;

+ (id)precipitationView {
    return [[TRPrecipitationView alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRPrecipitationView_type = [ODClassType classTypeWithCls:[TRPrecipitationView class]];
}

+ (TRPrecipitationView*)applyPrecipitation:(TRPrecipitation*)precipitation {
    if(precipitation.tp == TRPrecipitationType.rain) return [TRRainView rainViewWithStrength:precipitation.strength];
    else @throw @"Unknown precipitation type";
}

- (void)draw {
    @throw @"Method draw is abstract";
}

- (void)updateWithDelta:(CGFloat)delta {
    @throw @"Method updateWith is abstract";
}

- (ODClassType*)type {
    return [TRPrecipitationView type];
}

+ (ODClassType*)type {
    return _TRPrecipitationView_type;
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


@implementation TRRainView{
    CGFloat _strength;
    TRRainParticleSystem* _system;
    TRRainSystemView* _view;
}
static ODClassType* _TRRainView_type;
@synthesize strength = _strength;
@synthesize system = _system;
@synthesize view = _view;

+ (id)rainViewWithStrength:(CGFloat)strength {
    return [[TRRainView alloc] initWithStrength:strength];
}

- (id)initWithStrength:(CGFloat)strength {
    self = [super init];
    if(self) {
        _strength = strength;
        _system = [TRRainParticleSystem rainParticleSystemWithStrength:_strength];
        _view = [TRRainSystemView rainSystemViewWithSystem:_system];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRainView_type = [ODClassType classTypeWithCls:[TRRainView class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_system updateWithDelta:delta];
}

- (void)draw {
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
    return eqf(self.strength, o.strength);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.strength);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"strength=%f", self.strength];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRainParticleSystem{
    CGFloat _strength;
    id<CNSeq> _particles;
}
static ODClassType* _TRRainParticleSystem_type;
@synthesize strength = _strength;
@synthesize particles = _particles;

+ (id)rainParticleSystemWithStrength:(CGFloat)strength {
    return [[TRRainParticleSystem alloc] initWithStrength:strength];
}

- (id)initWithStrength:(CGFloat)strength {
    self = [super init];
    if(self) {
        _strength = strength;
        _particles = [[[intTo(0, ((NSInteger)(100 * _strength))) chain] map:^TRRainParticle*(id _) {
            return [TRRainParticle rainParticle];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRainParticleSystem_type = [ODClassType classTypeWithCls:[TRRainParticleSystem class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    [[self particles] forEach:^void(id _) {
        [_ updateWithDelta:delta];
    }];
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
    return eqf(self.strength, o.strength);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.strength);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"strength=%f", self.strength];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRainParticle{
    GEVec2 _position;
}
static ODClassType* _TRRainParticle_type;

+ (id)rainParticle {
    return [[TRRainParticle alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _position = geVec2Rnd();
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRainParticle_type = [ODClassType classTypeWithCls:[TRRainParticle class]];
}

- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array {
    cnVoidRefArrayWriteTpItem(array, TRRainData, TRRainDataMake(_position));
    return cnVoidRefArrayWriteTpItem(array, TRRainData, TRRainDataMake(geVec2AddVec2(_position, GEVec2Make(0.0, 0.1))));
}

- (void)updateWithDelta:(CGFloat)delta {
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


NSString* TRRainDataDescription(TRRainData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRRainData: "];
    [description appendFormat:@"position=%@", GEVec2Description(self.position)];
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

+ (id)rainSystemViewWithSystem:(TRRainParticleSystem*)system {
    return [[TRRainSystemView alloc] initWithSystem:system];
}

- (id)initWithSystem:(TRRainParticleSystem*)system {
    self = [super initWithSystem:system vbDesc:TRRainSystemView.vbDesc maxCount:[system.particles count] shader:TRRainShader.instance material:nil blendFunc:EGBlendFunction.standard];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRainSystemView_type = [ODClassType classTypeWithCls:[TRRainSystemView class]];
    _TRRainSystemView_vbDesc = [EGVertexBufferDesc vertexBufferDescWithDataType:trRainDataType() position:-1 uv:-1 normal:-1 color:-1 model:-1];
}

- (NSUInteger)vertexCount {
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


@implementation TRRainShader
static TRRainShader* _TRRainShader_instance;
static ODClassType* _TRRainShader_type;

+ (id)rainShader {
    return [[TRRainShader alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRainShader_type = [ODClassType classTypeWithCls:[TRRainShader class]];
    _TRRainShader_instance = [TRRainShader rainShader];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
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


