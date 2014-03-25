#import "TRSmoke.h"

#import "TRTrain.h"
#import "TRCar.h"
#import "TRWeather.h"
#import "TRLevel.h"
@implementation TRSmoke
static CGFloat _TRSmoke_zSpeed = 0.1;
static float _TRSmoke_particleSize = 0.03;
static GEQuad _TRSmoke_modelQuad;
static GEQuadrant _TRSmoke_textureQuadrant;
static GEVec4 _TRSmoke_defColor;
static ODClassType* _TRSmoke_type;
@synthesize train = _train;
@synthesize _trainState = __trainState;

+ (instancetype)smokeWithTrain:(TRTrain*)train {
    return [[TRSmoke alloc] initWithTrain:train];
}

- (instancetype)initWithTrain:(TRTrain*)train {
    self = [super init];
    if(self) {
        _train = train;
        _trainType = _train.trainType;
        _speed = _train.speedFloat;
        _engineCarType = [_train.carTypes head];
        _weather = _train.level.weather;
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

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [self lockAndOnSuccessFuture:[_train state] f:^id(TRTrainState* state) {
        __trainState = state;
        [self doUpdateWithDelta:delta];
        return nil;
    }];
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"train=%@", self.train];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSmokeParticle
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"lifeLength=%f", self.lifeLength];
    [description appendFormat:@", weather=%@", self.weather];
    [description appendString:@">"];
    return description;
}

@end


