#import "TRExplosion.h"

#import "EGProgress.h"
#import "EGContext.h"
@implementation TRExplosion{
    GEVec3 _position;
    float _size;
    TRExplosionFlame* _flame;
}
static ODType* _TRExplosion_type;
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
        _flame = [[TRExplosionFlame explosionFlameWithPosition:_position size:_size] init];
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
    [_flame init];
}

- (ODClassType*)type {
    return [TRExplosion type];
}

+ (ODType*)type {
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
static ODType* _TRExplosionFlame_type;
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

- (TRExplosionFlame*)init {
    [intRange(4) forEach:^void(id _) {
        [self emitParticle];
    }];
    return self;
}

- (ODClassType*)type {
    return [TRExplosionFlame type];
}

+ (ODType*)type {
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
static ODType* _TRExplosionFlameParticle_type;
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
            return ^void(float _) {
                ^void(float _) {
                    ^void(float _) {
                        [^id(float _) {
                            return [[EGProgress gapT1:0.0 t2:0.1](_) map:^id(id _) {
                                return numf4([EGProgress progressF4:0.0 f42:_weakSelf.size](unumf4(_)));
                            }];
                        }(_) forEach:^void(id _) {
                            ^void(float _) {
                                _weakSelf.model = geQuadAddVec2(geQuadApplySize(_), _weakSelf.startShift);
                            }(unumf4(_));
                        }];
                    }(_);
                    ^void(float _) {
                        [^id(float _) {
                            return [[EGProgress gapT1:0.1 t2:1.0](_) map:^id(id _) {
                                return wrap(GEVec2, [EGProgress progressVec2:_weakSelf.startShift vec22:_weakSelf.shift](unumf4(_)));
                            }];
                        }(_) forEach:^void(id _) {
                            ^void(GEVec2 _) {
                                _weakSelf.model = geQuadAddVec2(bigQuad, _);
                            }(uwrap(GEVec2, _));
                        }];
                    }(_);
                }(_);
                ^void(float _) {
                    [^id(float _) {
                        return [[EGProgress gapT1:0.05 t2:1.0](_) map:^id(id _) {
                            return wrap(GEVec4, [EGProgress progressVec4:[TRExplosionFlameParticle startColor] vec42:GEVec4Make(0.0, 0.0, 0.0, 0.0)](unumf4(_)));
                        }];
                    }(_) forEach:^void(id _) {
                        ^void(GEVec4 _) {
                            _weakSelf.color = _;
                        }(uwrap(GEVec4, _));
                    }];
                }(_);
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
    GEVec2 startShift = geVec2MulValue([EGProgress randomVec2], size * 0.2);
    TRExplosionFlameParticle* ret = [TRExplosionFlameParticle explosionFlameParticleWithSize:size startShift:startShift shift:geVec2AddVec2(startShift, geVec2MulValue([EGProgress randomVec2], size * 0.2))];
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

+ (ODType*)type {
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
    EGSimpleMaterial* _material;
    EGBillboardParticleSystemView* _view;
}
static ODType* _TRExplosionView_type;
@synthesize material = _material;
@synthesize view = _view;

+ (id)explosionView {
    return [[TRExplosionView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _material = [EGSimpleMaterial simpleMaterialWithColor:[EGColorSource applyTexture:[EGGlobal textureForFile:@"Explosion.png"]]];
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

+ (ODType*)type {
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


