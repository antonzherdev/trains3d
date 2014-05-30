#import "TRSmoke.h"

#import "TRWeather.h"
#import "TRLevel.h"
#import "CNFuture.h"
@implementation TRSmoke
static CGFloat _TRSmoke_dragCoefficient = 0.5;
static CGFloat _TRSmoke_zSpeed = 0.1;
static float _TRSmoke_particleSize = 0.03;
static GEQuad _TRSmoke_modelQuad;
static GEQuadrant _TRSmoke_textureQuadrant;
static GEVec4 _TRSmoke_defColor;
static CNClassType* _TRSmoke_type;
@synthesize train = _train;

+ (instancetype)smokeWithTrain:(TRTrain*)train {
    return [[TRSmoke alloc] initWithTrain:train];
}

- (instancetype)initWithTrain:(TRTrain*)train {
    self = [super initWithParticleType:trSmokeParticleType() maxCount:202];
    if(self) {
        _train = train;
        _trainType = train.trainType;
        _speed = train.speedFloat;
        _engineCarType = ((TRCarTypeR)([nonnil([train.carTypes head]) ordinal] + 1));
        _weather = train.level.weather;
        _tubePos = ((TREngineType*)(nonnil([TRCarType value:_engineCarType].engineType))).tubePos;
        _emitEvery = ((_trainType == TRTrainType_fast) ? 0.005 : 0.01);
        _lifeLength = ((_trainType == TRTrainType_fast) ? 1 : 2);
        _emitTime = 0.0;
        _tubeSize = ((TREngineType*)(nonnil([TRCarType value:_engineCarType].engineType))).tubeSize;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSmoke class]) {
        _TRSmoke_type = [CNClassType classTypeWithCls:[TRSmoke class]];
        _TRSmoke_modelQuad = geQuadApplySize(_TRSmoke_particleSize);
        _TRSmoke_textureQuadrant = geQuadQuadrant(geQuadIdentity());
        _TRSmoke_defColor = geVec4ApplyF(0.0);
    }
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [self lockAndOnSuccessFuture:[_train state] f:^id(TRTrainState* state) {
        {
            NSInteger __il__0i = 0;
            TRSmokeParticle* __il__0p = self.particles;
            while(__il__0i < self.maxCount) {
                if(*(((char*)(__il__0p))) != 0) {
                    BOOL __il__0ch = ({
                        GEVec3 a = geVec3MulK(__il__0p->speed, ((float)(-_TRSmoke_dragCoefficient)));
                        __il__0p->speed = geVec3AddVec3(__il__0p->speed, (geVec3MulK(a, ((float)(delta)))));
                        __il__0p->billboard.position = geVec3AddVec3(__il__0p->billboard.position, (geVec3MulK((geVec3AddVec3(__il__0p->speed, (geVec3ApplyVec2Z([_weather wind], 0.0)))), ((float)(delta)))));
                        __il__0p->lifeTime += ((float)(delta));
                        float pt = __il__0p->lifeTime / _lifeLength;
                        if(pt <= 0.05) {
                            __il__0p->billboard.color = geVec4ApplyF(((CGFloat)(6 * pt)));
                        } else {
                            if(pt >= 0.75) __il__0p->billboard.color = geVec4ApplyF((floatMaxB(-0.3 * (pt - 0.75) / 0.25 + 0.3, 0.0)));
                        }
                        pt < 1;
                    });
                    if(!(__il__0ch)) {
                        *(((char*)(__il__0p))) = 0;
                        __lifeCount--;
                        __nextInvalidRef = __il__0p;
                        __nextInvalidNumber = __il__0i;
                    }
                }
                __il__0i++;
                __il__0p++;
            }
        }
        if([((TRTrainState*)(state)) isDying]) return nil;
        _emitTime += delta;
        if(_emitTime > _emitEvery) {
            TRLiveTrainState* ts = ((TRLiveTrainState*)(state));
            TRLiveCarState* pos = ((TRLiveCarState*)(nonnil([ts.carStates head])));
            GEVec2 fPos = pos.head.point;
            GEVec2 bPos = pos.tail.point;
            GEVec2 d = geVec2SubVec2(bPos, fPos);
            GEVec2 tubeXY = geVec2AddVec2(fPos, (geVec2SetLength(d, _tubePos.x)));
            GEVec3 emitterPos = geVec3ApplyVec2Z(tubeXY, _tubePos.z);
            while(_emitTime > _emitEvery) {
                _emitTime -= _emitEvery;
                if(__lifeCount < self.maxCount) {
                    TRSmokeParticle* __il__3t_7_1p = __nextInvalidRef;
                    BOOL __il__3t_7_1round = NO;
                    while(*(((char*)(__il__3t_7_1p))) != 0) {
                        __nextInvalidNumber++;
                        if(__nextInvalidNumber >= self.maxCount) {
                            if(__il__3t_7_1round) return nil;
                            __il__3t_7_1round = YES;
                            __nextInvalidNumber = 0;
                            __il__3t_7_1p = self.particles;
                        } else {
                            __il__3t_7_1p++;
                        }
                    }
                    *(((char*)(__il__3t_7_1p))) = 1;
                    {
                        __il__3t_7_1p->billboard.color = _TRSmoke_defColor;
                        __il__3t_7_1p->billboard.position = GEVec3Make((emitterPos.x + _tubeSize * cnFloatRndMinMax(-0.01, 0.01)), (emitterPos.y + _tubeSize * cnFloatRndMinMax(-0.01, 0.01)), emitterPos.z);
                        __il__3t_7_1p->billboard.model = _TRSmoke_modelQuad;
                        __il__3t_7_1p->billboard.uv = geQuadrantRndQuad(_TRSmoke_textureQuadrant);
                        __il__3t_7_1p->lifeTime = 0.0;
                        if(_trainType == TRTrainType_fast) {
                            GEVec2 v = geVec2MulF4((geVec2SetLength((((ts.isBack) ? geVec2SubVec2(fPos, bPos) : d)), (((float)(floatMaxB((_speed + cnFloat4RndMinMax(-0.5, 0.05)), 0.0)))))), -1.0);
                            __il__3t_7_1p->speed = geVec3ApplyVec2Z((geVec2AddVec2(v, (geVec2SetLength((GEVec2Make(-v.y, v.x)), (cnFloat4RndMinMax(-0.02, 0.02)))))), (((float)(floatNoisePercents(_TRSmoke_zSpeed, 0.1)))));
                        } else {
                            GEVec3 s = geVec3ApplyVec2Z((geVec2SetLength((((ts.isBack) ? geVec2SubVec2(fPos, bPos) : d)), ((float)(_speed)))), ((float)(_TRSmoke_zSpeed)));
                            __il__3t_7_1p->speed = GEVec3Make((-float4NoisePercents(s.x, 0.3)), (-float4NoisePercents(s.y, 0.3)), (float4NoisePercents(s.z, 0.3)));
                        }
                    }
                    __nextInvalidRef = __il__3t_7_1p;
                    __lifeCount++;
                }
            }
        }
        return nil;
    }];
}

- (void)doUpdateWithDelta:(CGFloat)delta {
}

- (unsigned int)doWriteToArray:(EGBillboardBufferData*)array {
    NSInteger __il__0i = 0;
    TRSmokeParticle* __il__0p = self.particles;
    EGBillboardBufferData* __il__0a = array;
    while(__il__0i < self.maxCount) {
        if(*(((char*)(__il__0p))) != 0) __il__0a = ({
            EGBillboardParticle __tmp__il__0self = __il__0p->billboard;
            ({
                EGBillboardBufferData* __il__0pp = __il__0a;
                __il__0pp->position = __tmp__il__0self.position;
                __il__0pp->model = __tmp__il__0self.model.p0;
                __il__0pp->color = __tmp__il__0self.color;
                __il__0pp->uv = __tmp__il__0self.uv.p0;
                __il__0pp++;
                __il__0pp->position = __tmp__il__0self.position;
                __il__0pp->model = __tmp__il__0self.model.p1;
                __il__0pp->color = __tmp__il__0self.color;
                __il__0pp->uv = __tmp__il__0self.uv.p1;
                __il__0pp++;
                __il__0pp->position = __tmp__il__0self.position;
                __il__0pp->model = __tmp__il__0self.model.p2;
                __il__0pp->color = __tmp__il__0self.color;
                __il__0pp->uv = __tmp__il__0self.uv.p2;
                __il__0pp++;
                __il__0pp->position = __tmp__il__0self.position;
                __il__0pp->model = __tmp__il__0self.model.p3;
                __il__0pp->color = __tmp__il__0self.color;
                __il__0pp->uv = __tmp__il__0self.uv.p3;
                __il__0pp + 1;
            });
        });
        __il__0i++;
        __il__0p++;
    }
    return ((unsigned int)(__lifeCount));
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Smoke(%@)", _train];
}

- (unsigned int)vertexCount {
    return 4;
}

- (NSUInteger)indexCount {
    return 6;
}

- (unsigned int*)createIndexArray {
    unsigned int* indexPointer = cnPointerApplyBytesCount(4, [self indexCount] * [self maxCount]);
    unsigned int* ia = indexPointer;
    NSInteger i = 0;
    unsigned int j = 0;
    while(i < [self maxCount]) {
        *(ia + 0) = j;
        *(ia + 1) = j + 1;
        *(ia + 2) = j + 2;
        *(ia + 3) = j + 2;
        *(ia + 4) = j;
        *(ia + 5) = j + 3;
        ia += 6;
        i++;
        j += 4;
    }
    return indexPointer;
}

- (CNClassType*)type {
    return [TRSmoke type];
}

+ (CGFloat)dragCoefficient {
    return _TRSmoke_dragCoefficient;
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

+ (CNClassType*)type {
    return _TRSmoke_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

NSString* trSmokeParticleDescription(TRSmokeParticle self) {
    return [NSString stringWithFormat:@"SmokeParticle(%d, %@, %@)", self.life, geVec3Description(self.speed), egBillboardParticleDescription(self.billboard)];
}
BOOL trSmokeParticleIsEqualTo(TRSmokeParticle self, TRSmokeParticle to) {
    return self.life == to.life && geVec3IsEqualTo(self.speed, to.speed) && egBillboardParticleIsEqualTo(self.billboard, to.billboard);
}
NSUInteger trSmokeParticleHash(TRSmokeParticle self) {
    NSUInteger hash = 0;
    hash = hash * 31 + self.life;
    hash = hash * 31 + geVec3Hash(self.speed);
    hash = hash * 31 + egBillboardParticleHash(self.billboard);
    return hash;
}
CNPType* trSmokeParticleType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[TRSmokeParticleWrap class] name:@"TRSmokeParticle" size:sizeof(TRSmokeParticle) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRSmokeParticle, ((TRSmokeParticle*)(data))[i]);
    }];
    return _ret;
}
@implementation TRSmokeParticleWrap{
    TRSmokeParticle _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRSmokeParticle)value {
    return [[TRSmokeParticleWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRSmokeParticle)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return trSmokeParticleDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSmokeParticleWrap* o = ((TRSmokeParticleWrap*)(other));
    return trSmokeParticleIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return trSmokeParticleHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


