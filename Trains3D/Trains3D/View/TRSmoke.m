#import "TRSmoke.h"

#import "CNData.h"
#import "EG.h"
#import "EGShader.h"
#import "EGTexture.h"
#import "EGMatrix.h"
#import "EGSurface.h"
#import "EGMesh.h"
#import "TRTrain.h"
#import "TRRailPoint.h"
#import "EGMaterial.h"
@implementation TRSmoke{
    __weak TRTrain* _train;
    TRCar* _engine;
    EGVec3 _tubePos;
    CGFloat _emitTime;
}
static CGFloat _TRSmoke_zSpeed = 0.1;
static CGFloat _TRSmoke_emitEvery = 0.005;
static ODClassType* _TRSmoke_type;
@synthesize train = _train;

+ (id)smokeWithTrain:(TRTrain*)train {
    return [[TRSmoke alloc] initWithTrain:train];
}

- (id)initWithTrain:(TRTrain*)train {
    self = [super init];
    if(self) {
        _train = train;
        _engine = ((TRCar*)([[_train.cars head] get]));
        _tubePos = ((TREngineType*)([_engine.carType.engineType get])).tubePos;
        _emitTime = 0.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSmoke_type = [ODClassType classTypeWithCls:[TRSmoke class]];
}

- (void)generateParticlesWithDelta:(CGFloat)delta {
    _emitTime += delta;
    while(_emitTime > _TRSmoke_emitEvery) {
        _emitTime -= _TRSmoke_emitEvery;
        [self emitParticle];
    }
}

- (TRSmokeParticle*)generateParticle {
    EGVec2 fPos = (([_train isBack]) ? _engine.tail.point : _engine.head.point);
    EGVec2 bPos = (([_train isBack]) ? _engine.head.point : _engine.tail.point);
    EGVec2 delta = egVec2Sub(bPos, fPos);
    EGVec2 tubeXY = egVec2Add(fPos, egVec2Set(delta, _tubePos.x));
    EGVec3 emitterPos = egVec3Apply(tubeXY, _tubePos.z);
    TRSmokeParticle* p = [TRSmokeParticle smokeParticleWithTexture:((NSInteger)(randomMax(3)))];
    p.position = EGVec3Make(emitterPos.x + randomFloatGap(-0.01, 0.01), emitterPos.y + randomFloatGap(-0.01, 0.01), emitterPos.z);
    randomFloat();
    EGVec3 s = egVec3Apply(egVec2Set((([_train isBack]) ? egVec2Sub(fPos, bPos) : delta), ((float)(_train.speedFloat))), ((float)(_TRSmoke_zSpeed)));
    p.speed = EGVec3Make(-s.x * randomPercents(0.6), -s.y * randomPercents(0.6), s.z * randomPercents(0.6));
    return p;
}

- (ODClassType*)type {
    return [TRSmoke type];
}

+ (ODClassType*)type {
    return _TRSmoke_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSmoke* o = ((TRSmoke*)(other));
    return [self.train isEqual:o.train];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.train hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"train=%@", self.train];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSmokeParticle{
    NSInteger _texture;
    EGVec3 _position;
    EGVec3 _speed;
    CGFloat _time;
}
static NSInteger _TRSmokeParticle_lifeTime = 4;
static NSInteger _TRSmokeParticle_dragCoefficient = 1;
static CGFloat _TRSmokeParticle_particleSize = 0.03;
static ODClassType* _TRSmokeParticle_type;
@synthesize texture = _texture;
@synthesize position = _position;
@synthesize speed = _speed;
@synthesize time = _time;

+ (id)smokeParticleWithTexture:(NSInteger)texture {
    return [[TRSmokeParticle alloc] initWithTexture:texture];
}

- (id)initWithTexture:(NSInteger)texture {
    self = [super init];
    if(self) {
        _texture = texture;
        _time = 0.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSmokeParticle_type = [ODClassType classTypeWithCls:[TRSmokeParticle class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    EGVec3 a = egVec3Mul(_speed, ((float)(-_TRSmokeParticle_dragCoefficient)));
    _speed = egVec3Add(_speed, egVec3Mul(a, ((float)(delta))));
    _position = egVec3Add(_position, egVec3Mul(_speed, ((float)(delta))));
    _time += delta;
}

- (BOOL)isLive {
    return _time < _TRSmokeParticle_lifeTime;
}

- (void)writeToArray:(CNMutablePArray*)array {
    float tx = ((float)(((_texture >= 2) ? 0.5 : 0)));
    float ty = ((float)(((_texture == 1 || _texture == 3) ? 0.5 : 0)));
    [array writeItem:voidRef(TRSmokeBufferDataMake(_position, EGVec2Make(((float)(-_TRSmokeParticle_particleSize)), ((float)(-_TRSmokeParticle_particleSize))), EGVec2Make(tx, ty), ((float)(_time))))];
    [array writeItem:voidRef(TRSmokeBufferDataMake(_position, EGVec2Make(((float)(_TRSmokeParticle_particleSize)), ((float)(-_TRSmokeParticle_particleSize))), EGVec2Make(tx + 0.5, ty), ((float)(_time))))];
    [array writeItem:voidRef(TRSmokeBufferDataMake(_position, EGVec2Make(((float)(_TRSmokeParticle_particleSize)), ((float)(_TRSmokeParticle_particleSize))), EGVec2Make(tx + 0.5, ty + 0.5), ((float)(_time))))];
    [array writeItem:voidRef(TRSmokeBufferDataMake(_position, EGVec2Make(((float)(-_TRSmokeParticle_particleSize)), ((float)(_TRSmokeParticle_particleSize))), EGVec2Make(tx, ty + 0.5), ((float)(_time))))];
}

- (ODClassType*)type {
    return [TRSmokeParticle type];
}

+ (NSInteger)lifeTime {
    return _TRSmokeParticle_lifeTime;
}

+ (NSInteger)dragCoefficient {
    return _TRSmokeParticle_dragCoefficient;
}

+ (CGFloat)particleSize {
    return _TRSmokeParticle_particleSize;
}

+ (ODClassType*)type {
    return _TRSmokeParticle_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSmokeParticle* o = ((TRSmokeParticle*)(other));
    return self.texture == o.texture;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.texture;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%li", self.texture];
    [description appendString:@">"];
    return description;
}

@end


ODPType* trSmokeBufferDataType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[TRSmokeBufferDataWrap class] name:@"TRSmokeBufferData" size:sizeof(TRSmokeBufferData) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRSmokeBufferData, ((TRSmokeBufferData*)(data))[i]);
    }];
    return _ret;
}
@implementation TRSmokeBufferDataWrap{
    TRSmokeBufferData _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRSmokeBufferData)value {
    return [[TRSmokeBufferDataWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRSmokeBufferData)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return TRSmokeBufferDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSmokeBufferDataWrap* o = ((TRSmokeBufferDataWrap*)(other));
    return TRSmokeBufferDataEq(_value, o.value);
}

- (NSUInteger)hash {
    return TRSmokeBufferDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



@implementation TRSmokeView{
    TRSmokeShader* _shader;
    EGSimpleMaterial* _material;
}
static ODClassType* _TRSmokeView_type;
@synthesize shader = _shader;
@synthesize material = _material;

+ (id)smokeView {
    return [[TRSmokeView alloc] init];
}

- (id)init {
    self = [super initWithDtp:trSmokeBufferDataType()];
    if(self) {
        _shader = TRSmokeShader.instance;
        _material = [EGSimpleMaterial simpleMaterialWithColor:[EGColorSource applyTexture:[EG textureForFile:@"Smoke.png"]]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSmokeView_type = [ODClassType classTypeWithCls:[TRSmokeView class]];
}

- (NSUInteger)vertexCount {
    return 4;
}

- (ODClassType*)type {
    return [TRSmokeView type];
}

+ (ODClassType*)type {
    return _TRSmokeView_type;
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


@implementation TRSmokeShader{
    EGShaderAttribute* _lifeSlot;
}
static NSString* _TRSmokeShader_vertex;
static NSString* _TRSmokeShader_fragment;
static TRSmokeShader* _TRSmokeShader_instance;
static ODClassType* _TRSmokeShader_type;
@synthesize lifeSlot = _lifeSlot;

+ (id)smokeShader {
    return [[TRSmokeShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[EGShaderProgram applyVertex:_TRSmokeShader_vertex fragment:_TRSmokeShader_fragment] texture:YES];
    if(self) _lifeSlot = [[self program] attributeForName:@"vertexLife"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSmokeShader_type = [ODClassType classTypeWithCls:[TRSmokeShader class]];
    _TRSmokeShader_vertex = [TRSmokeShader vertexTextWithTexture:YES parameters:@"attribute float vertexLife;\n"
        "varying float life;" code:@"life = vertexLife;"];
    _TRSmokeShader_fragment = [TRSmokeShader fragmentTextWithTexture:YES parameters:@"varying float life;" code:@"gl_FragColor.w *= min(0.7, 2.8 - 0.7*life);"];
    _TRSmokeShader_instance = [TRSmokeShader smokeShader];
}

- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer material:(EGSimpleMaterial*)material {
    [super loadVertexBuffer:vertexBuffer material:material];
    [_lifeSlot setFromBufferWithStride:vertexBuffer.stride valuesCount:1 valuesType:GL_FLOAT shift:((NSUInteger)(7 * 4))];
}

- (ODClassType*)type {
    return [TRSmokeShader type];
}

+ (NSString*)vertex {
    return _TRSmokeShader_vertex;
}

+ (NSString*)fragment {
    return _TRSmokeShader_fragment;
}

+ (TRSmokeShader*)instance {
    return _TRSmokeShader_instance;
}

+ (ODClassType*)type {
    return _TRSmokeShader_type;
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


