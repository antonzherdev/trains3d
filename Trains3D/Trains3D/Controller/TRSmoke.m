#import "TRSmoke.h"

#import "TRTrain.h"
#import "TRCar.h"
#import "TRWeather.h"
@implementation TRSmokeActor{
    TRSmoke* _smoke;
    id __viewData;
}
static ODClassType* _TRSmokeActor_type;
@synthesize smoke = _smoke;
@synthesize _viewData = __viewData;

+ (instancetype)smokeActorWithSmoke:(TRSmoke*)smoke {
    return [[TRSmokeActor alloc] initWithSmoke:smoke];
}

- (instancetype)initWithSmoke:(TRSmoke*)smoke {
    self = [super init];
    if(self) _smoke = smoke;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSmokeActor class]) _TRSmokeActor_type = [ODClassType classTypeWithCls:[TRSmokeActor class]];
}

- (CNFuture*)viewDataCreator:(id(^)(TRSmoke*))creator {
    __weak TRSmokeActor* _weakSelf = self;
    return [self promptF:^id() {
        if(_weakSelf._viewData == nil) _weakSelf._viewData = creator(_weakSelf.smoke);
        return ((id)(_weakSelf._viewData));
    }];
}

- (CNFuture*)updateWithDelta:(CGFloat)delta trainState:(TRTrainState*)trainState {
    __weak TRSmokeActor* _weakSelf = self;
    return [self futureF:^id() {
        _weakSelf.smoke._trainState = trainState;
        [_weakSelf.smoke updateWithDelta:delta];
        return nil;
    }];
}

- (ODClassType*)type {
    return [TRSmokeActor type];
}

+ (ODClassType*)type {
    return _TRSmokeActor_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSmokeActor* o = ((TRSmokeActor*)(other));
    return [self.smoke isEqual:o.smoke];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.smoke hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"smoke=%@", self.smoke];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSmoke{
    TRTrainType* _trainType;
    CGFloat _speed;
    TRCarType* _engineCarType;
    __weak TRWeather* _weather;
    GEVec3 _tubePos;
    CGFloat _emitEvery;
    NSInteger _lifeLength;
    CGFloat _emitTime;
    CGFloat _tubeSize;
    TRTrainState* __trainState;
}
static CGFloat _TRSmoke_zSpeed = 0.1;
static float _TRSmoke_particleSize = 0.03;
static GEQuad _TRSmoke_modelQuad;
static GEQuadrant _TRSmoke_textureQuadrant;
static GEVec4 _TRSmoke_defColor;
static ODClassType* _TRSmoke_type;
@synthesize trainType = _trainType;
@synthesize speed = _speed;
@synthesize engineCarType = _engineCarType;
@synthesize weather = _weather;
@synthesize _trainState = __trainState;

+ (instancetype)smokeWithTrainType:(TRTrainType*)trainType speed:(CGFloat)speed engineCarType:(TRCarType*)engineCarType weather:(TRWeather*)weather {
    return [[TRSmoke alloc] initWithTrainType:trainType speed:speed engineCarType:engineCarType weather:weather];
}

- (instancetype)initWithTrainType:(TRTrainType*)trainType speed:(CGFloat)speed engineCarType:(TRCarType*)engineCarType weather:(TRWeather*)weather {
    self = [super init];
    if(self) {
        _trainType = trainType;
        _speed = speed;
        _engineCarType = engineCarType;
        _weather = weather;
        _tubePos = ((TREngineType*)([_engineCarType.engineType get])).tubePos;
        _emitEvery = ((_trainType == TRTrainType.fast) ? 0.005 : 0.01);
        _lifeLength = ((_trainType == TRTrainType.fast) ? 1 : 2);
        _emitTime = 0.0;
        _tubeSize = ((TREngineType*)([_engineCarType.engineType get])).tubeSize;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSmoke class]) {
        _TRSmoke_type = [ODClassType classTypeWithCls:[TRSmoke class]];
        _TRSmoke_modelQuad = geQuadApplySize(_TRSmoke_particleSize);
        _TRSmoke_textureQuadrant = geQuadQuadrant(geQuadIdentity());
        _TRSmoke_defColor = geVec4ApplyF(0.0);
    }
}

- (void)generateParticlesWithDelta:(CGFloat)delta {
    if([__trainState isDying]) return ;
    _emitTime += delta;
    while(_emitTime > _emitEvery) {
        _emitTime -= _emitEvery;
        [self emitParticle];
    }
}

- (TRSmokeParticle*)generateParticle {
    TRLiveTrainState* ts = ((TRLiveTrainState*)(__trainState));
    TRLiveCarState* pos = [ts.carStates head];
    GEVec2 fPos = pos.head.point;
    GEVec2 bPos = pos.tail.point;
    GEVec2 delta = geVec2SubVec2(bPos, fPos);
    GEVec2 tubeXY = geVec2AddVec2(fPos, (geVec2SetLength(delta, _tubePos.x)));
    GEVec3 emitterPos = geVec3ApplyVec2Z(tubeXY, _tubePos.z);
    TRSmokeParticle* p = [TRSmokeParticle smokeParticleWithLifeLength:((float)(_lifeLength)) weather:_weather];
    p.color = _TRSmoke_defColor;
    p.position = GEVec3Make((emitterPos.x + _tubeSize * odFloatRndMinMax(-0.01, 0.01)), (emitterPos.y + _tubeSize * odFloatRndMinMax(-0.01, 0.01)), emitterPos.z);
    p.model = _TRSmoke_modelQuad;
    p.uv = geQuadrantRndQuad(_TRSmoke_textureQuadrant);
    if(_trainType == TRTrainType.fast) {
        GEVec2 v = geVec2MulI((geVec2SetLength((((ts.isBack) ? geVec2SubVec2(fPos, bPos) : delta)), (((float)(floatMaxB((_speed + odFloat4RndMinMax(-0.5, 0.05)), 0.0)))))), -1);
        p.speed = geVec3ApplyVec2Z((geVec2AddVec2(v, (geVec2SetLength((GEVec2Make(-v.y, v.x)), (odFloat4RndMinMax(-0.02, 0.02)))))), (((float)(floatNoisePercents(_TRSmoke_zSpeed, 0.1)))));
    } else {
        GEVec3 s = geVec3ApplyVec2Z((geVec2SetLength((((ts.isBack) ? geVec2SubVec2(fPos, bPos) : delta)), ((float)(_speed)))), ((float)(_TRSmoke_zSpeed)));
        p.speed = GEVec3Make((-float4NoisePercents(s.x, 0.3)), (-float4NoisePercents(s.y, 0.3)), (float4NoisePercents(s.z, 0.3)));
    }
    return p;
}

- (ODClassType*)type {
    return [TRSmoke type];
}

+ (float)particleSize {
    return _TRSmoke_particleSize;
}

+ (GEQuad)modelQuad {
    return _TRSmoke_modelQuad;
}

+ (GEQuadrant)textureQuadrant {
    return _TRSmoke_textureQuadrant;
}

+ (GEVec4)defColor {
    return _TRSmoke_defColor;
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
    return self.trainType == o.trainType && eqf(self.speed, o.speed) && self.engineCarType == o.engineCarType && [self.weather isEqual:o.weather];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.trainType ordinal];
    hash = hash * 31 + floatHash(self.speed);
    hash = hash * 31 + [self.engineCarType ordinal];
    hash = hash * 31 + [self.weather hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"trainType=%@", self.trainType];
    [description appendFormat:@", speed=%f", self.speed];
    [description appendFormat:@", engineCarType=%@", self.engineCarType];
    [description appendFormat:@", weather=%@", self.weather];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSmokeParticle{
    __weak TRWeather* _weather;
    GEVec3 _speed;
    GEVec3 _position;
    GEQuad _uv;
    GEQuad _model;
    GEVec4 _color;
}
static CGFloat _TRSmokeParticle_dragCoefficient = 0.5;
static ODClassType* _TRSmokeParticle_type;
@synthesize weather = _weather;
@synthesize speed = _speed;
@synthesize position = _position;
@synthesize uv = _uv;
@synthesize model = _model;
@synthesize color = _color;

+ (instancetype)smokeParticleWithLifeLength:(float)lifeLength weather:(TRWeather*)weather {
    return [[TRSmokeParticle alloc] initWithLifeLength:lifeLength weather:weather];
}

- (instancetype)initWithLifeLength:(float)lifeLength weather:(TRWeather*)weather {
    self = [super initWithLifeLength:lifeLength];
    if(self) _weather = weather;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSmokeParticle class]) _TRSmokeParticle_type = [ODClassType classTypeWithCls:[TRSmokeParticle class]];
}

- (void)updateT:(float)t dt:(float)dt {
    GEVec3 a = geVec3MulK(_speed, ((float)(-_TRSmokeParticle_dragCoefficient)));
    _speed = geVec3AddVec3(_speed, (geVec3MulK(a, dt)));
    self.position = geVec3AddVec3(self.position, (geVec3MulK((geVec3AddVec3(_speed, (geVec3ApplyVec2Z([_weather wind], 0.0)))), dt)));
    float pt = t / self.lifeLength;
    if(pt <= 0.05) {
        self.color = geVec4ApplyF4(6 * pt);
    } else {
        if(pt >= 0.75) self.color = geVec4ApplyF((floatMaxB(-0.3 * (pt - 0.75) / 0.25 + 0.3, 0.0)));
    }
}

- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array {
    return cnVoidRefArrayWriteTpItem((cnVoidRefArrayWriteTpItem((cnVoidRefArrayWriteTpItem((cnVoidRefArrayWriteTpItem(array, EGBillboardBufferData, (EGBillboardBufferDataMake(_position, _model.p0, _color, _uv.p0)))), EGBillboardBufferData, (EGBillboardBufferDataMake(_position, _model.p1, _color, _uv.p1)))), EGBillboardBufferData, (EGBillboardBufferDataMake(_position, _model.p2, _color, _uv.p2)))), EGBillboardBufferData, (EGBillboardBufferDataMake(_position, _model.p3, _color, _uv.p3)));
}

- (ODClassType*)type {
    return [TRSmokeParticle type];
}

+ (CGFloat)dragCoefficient {
    return _TRSmokeParticle_dragCoefficient;
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
    return eqf4(self.lifeLength, o.lifeLength) && [self.weather isEqual:o.weather];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.lifeLength);
    hash = hash * 31 + [self.weather hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"lifeLength=%f", self.lifeLength];
    [description appendFormat:@", weather=%@", self.weather];
    [description appendString:@">"];
    return description;
}

@end


