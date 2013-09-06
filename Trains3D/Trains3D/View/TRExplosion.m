#import "TRExplosion.h"

#import "EGParticleSystem.h"
@implementation TRExplosion{
    EGVec3 _position;
    float _size;
    TRExplosionFlame* _flame;
}
static ODClassType* _TRExplosion_type;
@synthesize position = _position;
@synthesize size = _size;

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
    id<CNSeq> _particles;
}
static id<CNSeq> _TRExplosionFlame_uvs = (@[wrap(EGVec2, {0.0, 0.0}), wrap(EGVec2, {((float)(0.25)), 0.0}), wrap(EGVec2, {0.0, ((float)(0.25))}), wrap(EGVec2, {((float)(0.25)), ((float)(0.25))})]);
static ODClassType* _TRExplosionFlame_type;
@synthesize position = _position;
@synthesize size = _size;
@synthesize particles = _particles;

+ (id)explosionFlameWithPosition:(EGVec3)position size:(float)size {
    return [[TRExplosionFlame alloc] initWithPosition:position size:size];
}

- (id)initWithPosition:(EGVec3)position size:(float)size {
    self = [super init];
    if(self) {
        _position = position;
        _size = size;
        _particles = [[[intRange(4) chain] map:^EGBillboardParticle*(id _) {
            return self.generateParticle;
        }] toArray];
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
    [intRange(5) forEach:^void(id _) {
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


@implementation TRExplosionFlameParticle
static ODClassType* _TRExplosionFlameParticle_type;

+ (id)explosionFlameParticle {
    return [[TRExplosionFlameParticle alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRExplosionFlameParticle_type = [ODClassType classTypeWithCls:[TRExplosionFlameParticle class]];
}

+ (TRExplosionFlameParticle*)applyPosition:(EGVec3)position size:(float)size {
    TRExplosionFlameParticle* ret = [TRExplosionFlameParticle explosionFlameParticle];
    ret.position = position;
    ret.color = EGVec4Make(1.0, ((float)(0.5)), 0.0, ((float)(0.7)));
    return self;
}

- (ODClassType*)type {
    return [TRExplosionFlameParticle type];
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


