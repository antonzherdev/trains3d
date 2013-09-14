#import "TRSmoke.h"

#import "TRTrain.h"
#import "TRCar.h"
#import "TRRailPoint.h"
#import "EG.h"
@implementation TRSmoke{
    __weak TRTrain* _train;
    TRCar* _engine;
    GEVec3 _tubePos;
    CGFloat _emitTime;
}
static CGFloat _TRSmoke_zSpeed = 0.1;
static CGFloat _TRSmoke_emitEvery = 0.005;
static float _TRSmoke_particleSize = 0.03;
static GEQuad _TRSmoke_modelQuad;
static GEQuadrant _TRSmoke_textureQuadrant;
static GEVec4 _TRSmoke_defColor = {1.0, 1.0, 1.0, 0.7};
static ODClassType* _TRSmoke_type;
@synthesize train = _train;

+ (id)smokeWithTrain:(TRTrain*)train {
    return [[TRSmoke alloc] initWithTrain:train];
}

- (id)initWithTrain:(TRTrain*)train {
    self = [super init];
    if(self) {
        _train = train;
        _engine = ((TRCar*)([[[_train cars] head] get]));
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
    TRSmokeParticle* p = [TRSmokeParticle smokeParticle];
    p.color = _TRSmoke_defColor;
    p.position = GEVec3Make(emitterPos.x + randomFloatGap(-0.01, 0.01), emitterPos.y + randomFloatGap(-0.01, 0.01), emitterPos.z);
    p.model = _TRSmoke_modelQuad;
    p.uv = geQuadrantRandomQuad(_TRSmoke_textureQuadrant);
    GEVec3 s = geVec3ApplyVec2Z(geVec2SetLength((([_train isBack]) ? geVec2SubVec2(fPos, bPos) : delta), ((float)(_train.speedFloat))), ((float)(_TRSmoke_zSpeed)));
    p.speed = GEVec3Make(-s.x * randomPercents(0.6), -s.y * randomPercents(0.6), s.z * randomPercents(0.6));
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
    GEVec3 _speed;
}
static NSInteger _TRSmokeParticle_dragCoefficient = 1;
static ODClassType* _TRSmokeParticle_type;
@synthesize speed = _speed;

+ (id)smokeParticle {
    return [[TRSmokeParticle alloc] init];
}

- (id)init {
    self = [super initWithLifeLength:4.0];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSmokeParticle_type = [ODClassType classTypeWithCls:[TRSmokeParticle class]];
}

- (void)updateT:(float)t dt:(float)dt {
    GEVec3 a = geVec3MulK(_speed, ((float)(-_TRSmokeParticle_dragCoefficient)));
    _speed = geVec3AddV(_speed, geVec3MulK(a, dt));
    self.position = geVec3AddV(self.position, geVec3MulK(_speed, dt));
    if([self lifeTime] > 3) self.color = GEVec4Make(1.0, 1.0, 1.0, ((float)(2.8 - 0.7 * [self lifeTime])));
}

- (ODClassType*)type {
    return [TRSmokeParticle type];
}

+ (NSInteger)dragCoefficient {
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
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSmokeView
static ODClassType* _TRSmokeView_type;

+ (id)smokeView {
    return [[TRSmokeView alloc] init];
}

- (id)init {
    self = [super initWithMaterial:[EGSimpleMaterial simpleMaterialWithColor:[EGColorSource applyTexture:[EG textureForFile:@"Smoke.png"]]] blendFunc:egBlendFunctionStandard()];
    
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


