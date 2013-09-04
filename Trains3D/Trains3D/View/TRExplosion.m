#import "TRExplosion.h"

@implementation TRExplosion{
    EGVec3 _position;
    CGFloat _size;
    TRExplosionFlame* _flame;
}
static ODClassType* _TRExplosion_type;
@synthesize position = _position;
@synthesize size = _size;

+ (id)explosionWithPosition:(EGVec3)position size:(CGFloat)size {
    return [[TRExplosion alloc] initWithPosition:position size:size];
}

- (id)initWithPosition:(EGVec3)position size:(CGFloat)size {
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
    return EGVec3Eq(self.position, o.position) && eqf(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec3Hash(self.position);
    hash = hash * 31 + floatHash(self.size);
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
    CGFloat _size;
    id<CNSeq> _particles;
    CGFloat _time;
}
static id<CNSeq> _TRExplosionFlame_uvs;
static ODClassType* _TRExplosionFlame_type;
@synthesize position = _position;
@synthesize size = _size;
@synthesize particles = _particles;

+ (id)explosionFlameWithPosition:(EGVec3)position size:(CGFloat)size {
    return [[TRExplosionFlame alloc] initWithPosition:position size:size];
}

- (id)initWithPosition:(EGVec3)position size:(CGFloat)size {
    self = [super init];
    if(self) {
        _position = position;
        _size = size;
        _particles = [[[intRange(4) chain] map:^id(id _) {
            return wrap(TRExplosionFlameParticle, [self generateParticle]);
        }] toArray];
        _time = 0.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRExplosionFlame_type = [ODClassType classTypeWithCls:[TRExplosionFlame class]];
    _TRExplosionFlame_uvs = (@[wrap(EGVec2, EGVec2Make(0.0, 0.0)), wrap(EGVec2, EGVec2Make(0.25, 0.0)), wrap(EGVec2, EGVec2Make(0.0, 0.25)), wrap(EGVec2, EGVec2Make(0.25, 0.25))]);
}

- (TRExplosionFlameParticle)generateParticle {
    return TRExplosionFlameParticleMake(_position, EGVec2Make(0.0, 0.0), [_TRExplosionFlame_uvs randomItem]);
}

- (void)updateWithDelta:(CGFloat)delta {
    _time += delta;
    if(_time < 1) {
    }
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
    return EGVec3Eq(self.position, o.position) && eqf(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec3Hash(self.position);
    hash = hash * 31 + floatHash(self.size);
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


ODPType* trExplosionFlameParticleType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[TRExplosionFlameParticleWrap class] name:@"TRExplosionFlameParticle" size:sizeof(TRExplosionFlameParticle) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRExplosionFlameParticle, ((TRExplosionFlameParticle*)(data))[i]);
    }];
    return _ret;
}
@implementation TRExplosionFlameParticleWrap{
    TRExplosionFlameParticle _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRExplosionFlameParticle)value {
    return [[TRExplosionFlameParticleWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRExplosionFlameParticle)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return TRExplosionFlameParticleDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRExplosionFlameParticleWrap* o = ((TRExplosionFlameParticleWrap*)(other));
    return TRExplosionFlameParticleEq(_value, o.value);
}

- (NSUInteger)hash {
    return TRExplosionFlameParticleHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



