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
    EGVec2 delta = egVec2SubVec2(bPos, fPos);
    EGVec2 tubeXY = egVec2AddVec2(fPos, egVec2SetLength(delta, _tubePos.x));
    EGVec3 emitterPos = egVec3ApplyVec2Z(tubeXY, _tubePos.z);
    TRSmokeParticle* p = [TRSmokeParticle smokeParticleWithTexture:((NSInteger)(randomMax(3)))];
    p.position = EGVec3Make(emitterPos.x + randomFloatGap(-0.01, 0.01), emitterPos.y + randomFloatGap(-0.01, 0.01), emitterPos.z);
    randomFloat();
    EGVec3 s = egVec3ApplyVec2Z(egVec2SetLength((([_train isBack]) ? egVec2SubVec2(fPos, bPos) : delta), ((float)(_train.speedFloat))), ((float)(_TRSmoke_zSpeed)));
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
}
static NSInteger _TRSmokeParticle_dragCoefficient = 1;
static float _TRSmokeParticle_particleSize = ((float)(0.03));
static EGVec4 _TRSmokeParticle_defColor = {1.0, 1.0, 1.0, ((float)(0.7))};
static ODClassType* _TRSmokeParticle_type;
@synthesize texture = _texture;
@synthesize position = _position;
@synthesize speed = _speed;

+ (id)smokeParticleWithTexture:(NSInteger)texture {
    return [[TRSmokeParticle alloc] initWithTexture:texture];
}

- (id)initWithTexture:(NSInteger)texture {
    self = [super initWithLifeLength:4.0];
    if(self) _texture = texture;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSmokeParticle_type = [ODClassType classTypeWithCls:[TRSmokeParticle class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    [super updateWithDelta:delta];
    EGVec3 a = egVec3MulK(_speed, ((float)(-_TRSmokeParticle_dragCoefficient)));
    _speed = egVec3AddV(_speed, egVec3MulK(a, ((float)(delta))));
    _position = egVec3AddV(_position, egVec3MulK(_speed, ((float)(delta))));
}

- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array {
    EGVec4 t = (([self lifeTime] < 3) ? _TRSmokeParticle_defColor : EGVec4Make(1.0, 1.0, 1.0, ((float)(2.8 - 0.7 * [self lifeTime]))));
    float tx = ((float)(((_texture >= 2) ? 0.5 : 0)));
    float ty = ((float)(((_texture == 1 || _texture == 3) ? 0.5 : 0)));
    return cnVoidRefArrayWriteTpItem(cnVoidRefArrayWriteTpItem(cnVoidRefArrayWriteTpItem(cnVoidRefArrayWriteTpItem(array, TRSmokeBufferData, TRSmokeBufferDataMake(_position, EGVec2Make(-_TRSmokeParticle_particleSize, -_TRSmokeParticle_particleSize), t, EGVec2Make(tx, ty))), TRSmokeBufferData, TRSmokeBufferDataMake(_position, EGVec2Make(_TRSmokeParticle_particleSize, -_TRSmokeParticle_particleSize), t, EGVec2Make(tx + 0.5, ty))), TRSmokeBufferData, TRSmokeBufferDataMake(_position, EGVec2Make(_TRSmokeParticle_particleSize, _TRSmokeParticle_particleSize), t, EGVec2Make(tx + 0.5, ty + 0.5))), TRSmokeBufferData, TRSmokeBufferDataMake(_position, EGVec2Make(-_TRSmokeParticle_particleSize, _TRSmokeParticle_particleSize), t, EGVec2Make(tx, ty + 0.5)));
}

- (ODClassType*)type {
    return [TRSmokeParticle type];
}

+ (NSInteger)dragCoefficient {
    return _TRSmokeParticle_dragCoefficient;
}

+ (float)particleSize {
    return _TRSmokeParticle_particleSize;
}

+ (EGVec4)defColor {
    return _TRSmokeParticle_defColor;
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
    EGBillboardShader* _shader;
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
        _shader = [EGBillboardShader instanceForTexture];
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


