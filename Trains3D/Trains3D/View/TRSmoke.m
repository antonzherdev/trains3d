#import "TRSmoke.h"

#import "TRTrain.h"
#import "TRWeather.h"
#import "TRCar.h"
#import "TRRailPoint.h"
#import "EGProgress.h"
#import "GL.h"
#import "EGContext.h"
#import "EGMaterial.h"
@implementation TRSmoke{
    __weak TRTrain* _train;
    __weak TRWeather* _weather;
    TRCar* _engine;
    GEVec3 _tubePos;
    CGFloat _emitTime;
}
static CGFloat _TRSmoke_zSpeed = 0.1;
static CGFloat _TRSmoke_emitEvery = 0.01;
static float _TRSmoke_particleSize = 0.03;
static GEQuad _TRSmoke_modelQuad;
static GEQuadrant _TRSmoke_textureQuadrant;
static GEVec4 _TRSmoke_defColor = (GEVec4){0.3, 0.3, 0.3, 0.3};
static ODClassType* _TRSmoke_type;
@synthesize train = _train;
@synthesize weather = _weather;

+ (id)smokeWithTrain:(TRTrain*)train weather:(TRWeather*)weather {
    return [[TRSmoke alloc] initWithTrain:train weather:weather];
}

- (id)initWithTrain:(TRTrain*)train weather:(TRWeather*)weather {
    self = [super init];
    if(self) {
        _train = train;
        _weather = weather;
        _engine = ((TRCar*)([[_train cars] head]));
        _tubePos = ((TREngineType*)([_engine.carType.engineType get])).tubePos;
        _emitTime = 0.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSmoke_type = [ODClassType classTypeWithCls:[TRSmoke class]];
    _TRSmoke_modelQuad = geQuadApplySize(_TRSmoke_particleSize);
    _TRSmoke_textureQuadrant = geQuadQuadrant(geQuadIdentity());
}

- (void)generateParticlesWithDelta:(CGFloat)delta {
    if(_train.isDying) return ;
    _emitTime += delta;
    while(_emitTime > _TRSmoke_emitEvery) {
        _emitTime -= _TRSmoke_emitEvery;
        [self emitParticle];
    }
}

- (TRSmokeParticle*)generateParticle {
    TRCarPosition* pos = [_engine position];
    GEVec2 fPos = pos.head.point;
    GEVec2 bPos = pos.tail.point;
    GEVec2 delta = geVec2SubVec2(bPos, fPos);
    GEVec2 tubeXY = geVec2AddVec2(fPos, geVec2SetLength(delta, _tubePos.x));
    GEVec3 emitterPos = geVec3ApplyVec2Z(tubeXY, _tubePos.z);
    TRSmokeParticle* p = [TRSmokeParticle smokeParticleWithWeather:_weather];
    p.color = _TRSmoke_defColor;
    p.position = GEVec3Make(emitterPos.x + odFloatRndMinMax(-0.01, 0.01), emitterPos.y + odFloatRndMinMax(-0.01, 0.01), emitterPos.z);
    p.model = _TRSmoke_modelQuad;
    p.uv = geQuadrantRndQuad(_TRSmoke_textureQuadrant);
    GEVec3 s = geVec3ApplyVec2Z(geVec2SetLength((([_train isBack]) ? geVec2SubVec2(fPos, bPos) : delta), ((float)(_train.speedFloat))), ((float)(_TRSmoke_zSpeed)));
    p.speed = GEVec3Make(((float)(-float4NoisePercents(s.x, 0.3))), ((float)(-float4NoisePercents(s.y, 0.3))), ((float)(float4NoisePercents(s.z, 0.3))));
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
    return [self.train isEqual:o.train] && [self.weather isEqual:o.weather];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.train hash];
    hash = hash * 31 + [self.weather hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"train=%@", self.train];
    [description appendFormat:@", weather=%@", self.weather];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSmokeParticle{
    __weak TRWeather* _weather;
    GEVec3 _speed;
    void(^_animation)(float);
}
static CGFloat _TRSmokeParticle_dragCoefficient = 0.5;
static ODClassType* _TRSmokeParticle_type;
@synthesize weather = _weather;
@synthesize speed = _speed;
@synthesize animation = _animation;

+ (id)smokeParticleWithWeather:(TRWeather*)weather {
    return [[TRSmokeParticle alloc] initWithWeather:weather];
}

- (id)initWithWeather:(TRWeather*)weather {
    self = [super initWithLifeLength:2.0];
    __weak TRSmokeParticle* _weakSelf = self;
    if(self) {
        _weather = weather;
        _animation = ^id() {
            float(^__l)(float) = [EGProgress progressF4:0.3 f42:0.0];
            void(^__r)(float) = ^void(float _) {
                _weakSelf.color = GEVec4Make(_, _, _, _);
            };
            return ^void(float _) {
                __r(__l(_));
            };
        }();
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSmokeParticle_type = [ODClassType classTypeWithCls:[TRSmokeParticle class]];
}

- (void)updateT:(float)t dt:(float)dt {
    GEVec3 a = geVec3MulK(_speed, ((float)(-_TRSmokeParticle_dragCoefficient)));
    _speed = geVec3AddVec3(_speed, geVec3MulK(a, dt));
    self.position = geVec3AddVec3(self.position, geVec3MulK(geVec3AddVec3(_speed, geVec3ApplyVec2Z([_weather wind], 0.0)), dt));
    if(t > 1.5) _animation((t - 1.5) / 0.5);
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


@implementation TRSmokeView{
    TRSmoke* _system;
}
static ODClassType* _TRSmokeView_type;
@synthesize system = _system;

+ (id)smokeViewWithSystem:(TRSmoke*)system {
    return [[TRSmokeView alloc] initWithSystem:system];
}

- (id)initWithSystem:(TRSmoke*)system {
    self = [super initWithSystem:system maxCount:200 material:[EGColorSource applyTexture:[EGGlobal textureForFile:@"Smoke.png" magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_NEAREST]] blendFunc:EGBlendFunction.premultiplied];
    if(self) _system = system;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSmokeView_type = [ODClassType classTypeWithCls:[TRSmokeView class]];
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
    TRSmokeView* o = ((TRSmokeView*)(other));
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


