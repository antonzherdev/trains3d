#import "TRExplosion.h"

#import "EGProgress.h"
#import "EGContext.h"
@implementation TRExplosion{
    GEVec3 _position;
    float _size;
    TRExplosionFlame* _flame;
}
static ODClassType* _TRExplosion_type;
@synthesize position = _position;
@synthesize size = _size;
@synthesize flame = _flame;

+ (id)explosionWithPosition:(GEVec3)position size:(float)size {
    return [[TRExplosion alloc] initWithPosition:position size:size];
}

- (id)initWithPosition:(GEVec3)position size:(float)size {
    self = [super init];
    if(self) {
        _position = position;
        _size = size;
        _flame = [TRExplosionFlame explosionFlameWithPosition:_position size:_size];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRExplosion_type = [ODClassType classTypeWithCls:[TRExplosion class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_flame updateWithDelta:delta];
}

- (BOOL)isFinished {
    return !([_flame hasParticles]);
}

- (void)restart {
    [_flame _init];
}

- (ODClassType*)type {
    return [TRExplosion type];
}

+ (ODClassType*)type {
    return _TRExplosion_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRExplosion* o = ((TRExplosion*)(other));
    return GEVec3Eq(self.position, o.position) && eqf4(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec3Hash(self.position);
    hash = hash * 31 + float4Hash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"position=%@", GEVec3Description(self.position)];
    [description appendFormat:@", size=%f", self.size];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRExplosionFlame{
    GEVec3 _position;
    float _size;
}
static ODClassType* _TRExplosionFlame_type;
@synthesize position = _position;
@synthesize size = _size;

+ (id)explosionFlameWithPosition:(GEVec3)position size:(float)size {
    return [[TRExplosionFlame alloc] initWithPosition:position size:size];
}

- (id)initWithPosition:(GEVec3)position size:(float)size {
    self = [super init];
    if(self) {
        _position = position;
        _size = size;
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRExplosionFlame_type = [ODClassType classTypeWithCls:[TRExplosionFlame class]];
}

- (EGBillboardParticle*)generateParticle {
    return [TRExplosionFlameParticle applyPosition:_position size:_size];
}

- (void)_init {
    [intRange(4) forEach:^void(id _) {
        [self emitParticle];
    }];
}

- (ODClassType*)type {
    return [TRExplosionFlame type];
}

+ (ODClassType*)type {
    return _TRExplosionFlame_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRExplosionFlame* o = ((TRExplosionFlame*)(other));
    return GEVec3Eq(self.position, o.position) && eqf4(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec3Hash(self.position);
    hash = hash * 31 + float4Hash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"position=%@", GEVec3Description(self.position)];
    [description appendFormat:@", size=%f", self.size];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRExplosionFlameParticle{
    float _size;
    GEVec2 _startShift;
    GEVec2 _shift;
    void(^_animation)(float);
}
static GEVec4 _TRExplosionFlameParticle_startColor = {1.0, 0.4, 0.0, 0.3};
static GEQuadrant _TRExplosionFlameParticle_textureQuadrant;
static ODClassType* _TRExplosionFlameParticle_type;
@synthesize size = _size;
@synthesize startShift = _startShift;
@synthesize shift = _shift;
@synthesize animation = _animation;

+ (id)explosionFlameParticleWithSize:(float)size startShift:(GEVec2)startShift shift:(GEVec2)shift {
    return [[TRExplosionFlameParticle alloc] initWithSize:size startShift:startShift shift:shift];
}

- (id)initWithSize:(float)size startShift:(GEVec2)startShift shift:(GEVec2)shift {
    self = [super initWithLifeLength:2.0];
    __weak TRExplosionFlameParticle* _weakSelf = self;
    if(self) {
        _size = size;
        _startShift = startShift;
        _shift = shift;
        _animation = ^id() {
            GEQuad bigQuad = geQuadApplySize(_size);
            void(^__l)(float) = ^id() {
                void(^__l)(float) = ^id() {
                    id(^__l)(float) = ^id() {
                        id(^__l)(float) = [EGProgress gapT1:0.0 t2:0.1];
                        float(^__r)(float) = [EGProgress progressF4:0.0 f42:_size];
                        return ^id(float _) {
                            return [__l(_) mapF:^id(id _) {
                                return numf4(__r(unumf4(_)));
                            }];
                        };
                    }();
                    void(^__r)(float) = ^void(float _) {
                        _weakSelf.model = geQuadAddVec2(geQuadApplySize(_), _weakSelf.startShift);
                    };
                    return ^void(float _) {
                        [__l(_) forEach:^void(id _) {
                            __r(unumf4(_));
                        }];
                    };
                }();
                void(^__r)(float) = ^id() {
                    id(^__l)(float) = ^id() {
                        id(^__l)(float) = [EGProgress gapT1:0.1 t2:1.0];
                        GEVec2(^__r)(float) = [EGProgress progressVec2:_startShift vec22:_shift];
                        return ^id(float _) {
                            return [__l(_) mapF:^id(id _) {
                                return wrap(GEVec2, __r(unumf4(_)));
                            }];
                        };
                    }();
                    void(^__r)(GEVec2) = ^void(GEVec2 _) {
                        _weakSelf.model = geQuadAddVec2(bigQuad, _);
                    };
                    return ^void(float _) {
                        [__l(_) forEach:^void(id _) {
                            __r(uwrap(GEVec2, _));
                        }];
                    };
                }();
                return ^void(float _) {
                    __l(_);
                    __r(_);
                };
            }();
            void(^__r)(float) = ^id() {
                id(^__l)(float) = ^id() {
                    id(^__l)(float) = [EGProgress gapT1:0.05 t2:1.0];
                    GEVec4(^__r)(float) = [EGProgress progressVec4:_TRExplosionFlameParticle_startColor vec42:GEVec4Make(0.0, 0.0, 0.0, 0.0)];
                    return ^id(float _) {
                        return [__l(_) mapF:^id(id _) {
                            return wrap(GEVec4, __r(unumf4(_)));
                        }];
                    };
                }();
                void(^__r)(GEVec4) = ^void(GEVec4 _) {
                    _weakSelf.color = _;
                };
                return ^void(float _) {
                    [__l(_) forEach:^void(id _) {
                        __r(uwrap(GEVec4, _));
                    }];
                };
            }();
            return ^void(float _) {
                __l(_);
                __r(_);
            };
        }();
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRExplosionFlameParticle_type = [ODClassType classTypeWithCls:[TRExplosionFlameParticle class]];
    _TRExplosionFlameParticle_textureQuadrant = geQuadQuadrant(geQuadMulValue(geQuadIdentity(), 0.5));
}

+ (TRExplosionFlameParticle*)applyPosition:(GEVec3)position size:(float)size {
    GEVec2 startShift = geVec2MulF4([EGProgress randomVec2], size * 0.2);
    TRExplosionFlameParticle* ret = [TRExplosionFlameParticle explosionFlameParticleWithSize:size startShift:startShift shift:geVec2AddVec2(startShift, geVec2MulF4([EGProgress randomVec2], size * 0.2))];
    ret.position = position;
    ret.color = _TRExplosionFlameParticle_startColor;
    ret.uv = geQuadrantRandomQuad(_TRExplosionFlameParticle_textureQuadrant);
    ret.model = geQuadApplySize(0.0);
    return ret;
}

- (void)updateT:(float)t dt:(float)dt {
    _animation(t);
}

- (ODClassType*)type {
    return [TRExplosionFlameParticle type];
}

+ (GEVec4)startColor {
    return _TRExplosionFlameParticle_startColor;
}

+ (GEQuadrant)textureQuadrant {
    return _TRExplosionFlameParticle_textureQuadrant;
}

+ (ODClassType*)type {
    return _TRExplosionFlameParticle_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRExplosionFlameParticle* o = ((TRExplosionFlameParticle*)(other));
    return eqf4(self.size, o.size) && GEVec2Eq(self.startShift, o.startShift) && GEVec2Eq(self.shift, o.shift);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.size);
    hash = hash * 31 + GEVec2Hash(self.startShift);
    hash = hash * 31 + GEVec2Hash(self.shift);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%f", self.size];
    [description appendFormat:@", startShift=%@", GEVec2Description(self.startShift)];
    [description appendFormat:@", shift=%@", GEVec2Description(self.shift)];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRExplosionView{
    EGColorSource* _material;
    EGBillboardParticleSystemView* _view;
}
static ODClassType* _TRExplosionView_type;
@synthesize material = _material;
@synthesize view = _view;

+ (id)explosionView {
    return [[TRExplosionView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _material = [EGColorSource applyTexture:[EGGlobal textureForFile:@"Explosion.png"]];
        _view = [EGBillboardParticleSystemView billboardParticleSystemViewWithMaxCount:4 material:_material blendFunc:egBlendFunctionPremultiplied()];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRExplosionView_type = [ODClassType classTypeWithCls:[TRExplosionView class]];
}

- (void)drawExplosion:(TRExplosion*)explosion {
    [_view drawSystem:explosion.flame];
}

- (ODClassType*)type {
    return [TRExplosionView type];
}

+ (ODClassType*)type {
    return _TRExplosionView_type;
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


