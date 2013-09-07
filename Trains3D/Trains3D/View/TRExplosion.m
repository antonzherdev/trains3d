#import "TRExplosion.h"

#import "EG.h"
#import "EGSchedule.h"
#import "EGProgress.h"
#import "EGParticleSystem.h"
#import "EGMatrix.h"
@implementation TRExplosion{
    EGVec3 _position;
    float _size;
    TRExplosionFlame* _flame;
}
static ODClassType* _TRExplosion_type;
@synthesize position = _position;
@synthesize size = _size;
@synthesize flame = _flame;

+ (id)explosionWithPosition:(EGVec3)position size:(float)size {
    return [[TRExplosion alloc] initWithPosition:position size:size];
}

- (id)initWithPosition:(EGVec3)position size:(float)size {
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
    return EGVec3Eq(self.position, o.position) && eqf4(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec3Hash(self.position);
    hash = hash * 31 + float4Hash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"position=%@", EGVec3Description(self.position)];
    [description appendFormat:@", size=%f", self.size];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRExplosionFlame{
    EGVec3 _position;
    float _size;
}
static ODClassType* _TRExplosionFlame_type;
@synthesize position = _position;
@synthesize size = _size;

+ (id)explosionFlameWithPosition:(EGVec3)position size:(float)size {
    return [[TRExplosionFlame alloc] initWithPosition:position size:size];
}

- (id)initWithPosition:(EGVec3)position size:(float)size {
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
        self.emitParticle;
    }];
    return self;
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
    return EGVec3Eq(self.position, o.position) && eqf4(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec3Hash(self.position);
    hash = hash * 31 + float4Hash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"position=%@", EGVec3Description(self.position)];
    [description appendFormat:@", size=%f", self.size];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRExplosionFlameParticle{
    float _size;
    EGVec2 _shift;
    EGVec4 _startColor;
}
static EGQuadrant _TRExplosionFlameParticle_textureQuadrant;
static ODClassType* _TRExplosionFlameParticle_type;
@synthesize size = _size;
@synthesize shift = _shift;
@synthesize startColor = _startColor;

+ (id)explosionFlameParticleWithSize:(float)size shift:(EGVec2)shift {
    return [[TRExplosionFlameParticle alloc] initWithSize:size shift:shift];
}

- (id)initWithSize:(float)size shift:(EGVec2)shift {
    self = [super initWithLifeLength:1.0];
    if(self) {
        _size = size;
        _shift = shift;
        _startColor = EGVec4Make(1.0, 0.7, 0.0, 0.5);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRExplosionFlameParticle_type = [ODClassType classTypeWithCls:[TRExplosionFlameParticle class]];
    _TRExplosionFlameParticle_textureQuadrant = egQuadQuadrant(egQuadMulValue(egQuadIdentity(), 0.5));
}

+ (TRExplosionFlameParticle*)applyPosition:(EGVec3)position size:(float)size {
    TRExplosionFlameParticle* ret = [TRExplosionFlameParticle explosionFlameParticleWithSize:size shift:EGVec2Make(((float)(randomFloatGap(0.0, 0.1 * size))), ((float)(randomFloatGap(0.0, 0.1 * size))))];
    ret.position = position;
    ret.color = EGVec4Make(1.0, 0.7, 0.0, 0.5);
    ret.uv = egQuadrantRandomQuad(_TRExplosionFlameParticle_textureQuadrant);
    ret.model = egQuadApplySize(0.0);
    return ret;
}

- (void)updateT:(float)t dt:(float)dt {
    if(t < 1) self.model = egQuadApplySize(_size * t);
}

- (ODClassType*)type {
    return [TRExplosionFlameParticle type];
}

+ (EGQuadrant)textureQuadrant {
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
    return eqf4(self.size, o.size) && EGVec2Eq(self.shift, o.shift);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.size);
    hash = hash * 31 + EGVec2Hash(self.shift);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%f", self.size];
    [description appendFormat:@", shift=%@", EGVec2Description(self.shift)];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRExplosionView{
    EGSimpleMaterial* _material;
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
        _material = [EGSimpleMaterial simpleMaterialWithColor:[EGColorSource applyTexture:[EG textureForFile:@"Explosion.png"]]];
        _view = [EGBillboardParticleSystemView billboardParticleSystemViewWithMaterial:_material blendFunc:egBlendFunctionPremultiplied()];
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


