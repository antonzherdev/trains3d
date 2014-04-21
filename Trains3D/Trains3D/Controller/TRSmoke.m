#import "TRSmoke.h"

#import "TRTrain.h"
#import "TRCar.h"
#import "TRWeather.h"
#import "TRLevel.h"
@implementation TRSmoke
static CGFloat _TRSmoke_dragCoefficient = 0.5;
static CGFloat _TRSmoke_zSpeed = 0.1;
static float _TRSmoke_particleSize = 0.03;
static GEQuad _TRSmoke_modelQuad;
static GEQuadrant _TRSmoke_textureQuadrant;
static GEVec4 _TRSmoke_defColor;
static ODClassType* _TRSmoke_type;
@synthesize train = _train;

+ (instancetype)smokeWithTrain:(TRTrain*)train {
    return [[TRSmoke alloc] initWithTrain:train];
}

- (instancetype)initWithTrain:(TRTrain*)train {
    self = [super initWithParticleType:trSmokeParticleType() maxCount:202];
    if(self) {
        _train = train;
        _trainType = _train.trainType;
        _speed = _train.speedFloat;
        _engineCarType = ((TRCarType*)(nonnil([_train.carTypes head])));
        _weather = _train.level.weather;
        _tubePos = ((TREngineType*)(nonnil(_engineCarType.engineType))).tubePos;
        _emitEvery = ((_trainType == TRTrainType.fast) ? 0.005 : 0.01);
        _lifeLength = ((_trainType == TRTrainType.fast) ? 1 : 2);
        _emitTime = 0.0;
        _tubeSize = ((TREngineType*)(nonnil(_engineCarType.engineType))).tubeSize;
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

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [self lockAndOnSuccessFuture:[_train state] f:^id(TRTrainState* state) {
        {
            NSInteger __inline__0_i = 0;
            TRSmokeParticle* __inline__0_p = self.particles;
            while(__inline__0_i < self.maxCount) {
                if(*(((char*)(__inline__0_p))) != 0) {
                    BOOL __inline__0_ch = ({
                        GEVec3 a = geVec3MulK(__inline__0_p->speed, ((float)(-_TRSmoke_dragCoefficient)));
                        __inline__0_p->speed = geVec3AddVec3(__inline__0_p->speed, (geVec3MulK(a, ((float)(delta)))));
                        __inline__0_p->billboard.position = geVec3AddVec3(__inline__0_p->billboard.position, (geVec3MulK((geVec3AddVec3(__inline__0_p->speed, (geVec3ApplyVec2Z([_weather wind], 0.0)))), ((float)(delta)))));
                        __inline__0_p->lifeTime += ((float)(delta));
                        float pt = __inline__0_p->lifeTime / _lifeLength;
                        if(pt <= 0.05) {
                            __inline__0_p->billboard.color = geVec4ApplyF(((CGFloat)(6 * pt)));
                        } else {
                            if(pt >= 0.75) __inline__0_p->billboard.color = geVec4ApplyF((floatMaxB(-0.3 * (pt - 0.75) / 0.25 + 0.3, 0.0)));
                        }
                        pt < 1;
                    });
                    if(!(__inline__0_ch)) {
                        *(((char*)(__inline__0_p))) = 0;
                        __lifeCount--;
                        __nextInvalidRef = __inline__0_p;
                        __nextInvalidNumber = __inline__0_i;
                    }
                }
                __inline__0_i++;
                __inline__0_p++;
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
                    TRSmokeParticle* __inline__3_7_1_p = __nextInvalidRef;
                    BOOL __inline__3_7_1_round = NO;
                    while(*(((char*)(__inline__3_7_1_p))) != 0) {
                        __nextInvalidNumber++;
                        if(__nextInvalidNumber >= self.maxCount) {
                            if(__inline__3_7_1_round) return nil;
                            __inline__3_7_1_round = YES;
                            __nextInvalidNumber = 0;
                            __inline__3_7_1_p = self.particles;
                        } else {
                            __inline__3_7_1_p++;
                        }
                    }
                    *(((char*)(__inline__3_7_1_p))) = 1;
                    {
                        __inline__3_7_1_p->billboard.color = _TRSmoke_defColor;
                        __inline__3_7_1_p->billboard.position = GEVec3Make((emitterPos.x + _tubeSize * odFloatRndMinMax(-0.01, 0.01)), (emitterPos.y + _tubeSize * odFloatRndMinMax(-0.01, 0.01)), emitterPos.z);
                        __inline__3_7_1_p->billboard.model = _TRSmoke_modelQuad;
                        __inline__3_7_1_p->billboard.uv = geQuadrantRndQuad(_TRSmoke_textureQuadrant);
                        __inline__3_7_1_p->lifeTime = 0.0;
                        if(_trainType == TRTrainType.fast) {
                            GEVec2 v = geVec2MulF4((geVec2SetLength((((ts.isBack) ? geVec2SubVec2(fPos, bPos) : d)), (((float)(floatMaxB((_speed + odFloat4RndMinMax(-0.5, 0.05)), 0.0)))))), -1.0);
                            __inline__3_7_1_p->speed = geVec3ApplyVec2Z((geVec2AddVec2(v, (geVec2SetLength((GEVec2Make(-v.y, v.x)), (odFloat4RndMinMax(-0.02, 0.02)))))), (((float)(floatNoisePercents(_TRSmoke_zSpeed, 0.1)))));
                        } else {
                            GEVec3 s = geVec3ApplyVec2Z((geVec2SetLength((((ts.isBack) ? geVec2SubVec2(fPos, bPos) : d)), ((float)(_speed)))), ((float)(_TRSmoke_zSpeed)));
                            __inline__3_7_1_p->speed = GEVec3Make((-float4NoisePercents(s.x, 0.3)), (-float4NoisePercents(s.y, 0.3)), (float4NoisePercents(s.z, 0.3)));
                        }
                    }
                    __nextInvalidRef = __inline__3_7_1_p;
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
    NSInteger __inline__0_i = 0;
    TRSmokeParticle* __inline__0_p = self.particles;
    EGBillboardBufferData* __inline__0_a = array;
    while(__inline__0_i < self.maxCount) {
        if(*(((char*)(__inline__0_p))) != 0) __inline__0_a = ({
            EGBillboardParticle __tmp_0self = __inline__0_p->billboard;
            ({
                EGBillboardBufferData* __inline__0_pp = __inline__0_a;
                __inline__0_pp->position = __tmp_0self.position;
                __inline__0_pp->model = __tmp_0self.model.p0;
                __inline__0_pp->color = __tmp_0self.color;
                __inline__0_pp->uv = __tmp_0self.uv.p0;
                __inline__0_pp++;
                __inline__0_pp->position = __tmp_0self.position;
                __inline__0_pp->model = __tmp_0self.model.p1;
                __inline__0_pp->color = __tmp_0self.color;
                __inline__0_pp->uv = __tmp_0self.uv.p1;
                __inline__0_pp++;
                __inline__0_pp->position = __tmp_0self.position;
                __inline__0_pp->model = __tmp_0self.model.p2;
                __inline__0_pp->color = __tmp_0self.color;
                __inline__0_pp->uv = __tmp_0self.uv.p2;
                __inline__0_pp++;
                __inline__0_pp->position = __tmp_0self.position;
                __inline__0_pp->model = __tmp_0self.model.p3;
                __inline__0_pp->color = __tmp_0self.color;
                __inline__0_pp->uv = __tmp_0self.uv.p3;
                __inline__0_pp + 1;
            });
        });
        __inline__0_i++;
        __inline__0_p++;
    }
    return ((unsigned int)(__lifeCount));
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

- (ODClassType*)type {
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


NSString* TRSmokeParticleDescription(TRSmokeParticle self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRSmokeParticle: "];
    [description appendFormat:@"life=%d", self.life];
    [description appendFormat:@", speed=%@", GEVec3Description(self.speed)];
    [description appendFormat:@", billboard=%@", EGBillboardParticleDescription(self.billboard)];
    [description appendFormat:@", lifeTime=%f", self.lifeTime];
    [description appendString:@">"];
    return description;
}
ODPType* trSmokeParticleType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[TRSmokeParticleWrap class] name:@"TRSmokeParticle" size:sizeof(TRSmokeParticle) wrap:^id(void* data, NSUInteger i) {
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
    return TRSmokeParticleDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSmokeParticleWrap* o = ((TRSmokeParticleWrap*)(other));
    return TRSmokeParticleEq(_value, o.value);
}

- (NSUInteger)hash {
    return TRSmokeParticleHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



