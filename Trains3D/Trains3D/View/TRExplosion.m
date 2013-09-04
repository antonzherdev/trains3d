#import "TRExplosion.h"

@implementation TRExplosion{
    EGVec3 _position;
}
static ODClassType* _TRExplosion_type;
@synthesize position = _position;

+ (id)explosionWithPosition:(EGVec3)position {
    return [[TRExplosion alloc] initWithPosition:position];
}

- (id)initWithPosition:(EGVec3)position {
    self = [super init];
    if(self) _position = position;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRExplosion_type = [ODClassType classTypeWithCls:[TRExplosion class]];
}

- (void)updateWithDelta:(CGFloat)delta {
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
    return EGVec3Eq(self.position, o.position);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec3Hash(self.position);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"position=%@", EGVec3Description(self.position)];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRExplosionFlame{
    EGVec3 _position;
}
static ODClassType* _TRExplosionFlame_type;
@synthesize position = _position;

+ (id)explosionFlameWithPosition:(EGVec3)position {
    return [[TRExplosionFlame alloc] initWithPosition:position];
}

- (id)initWithPosition:(EGVec3)position {
    self = [super init];
    if(self) _position = position;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRExplosionFlame_type = [ODClassType classTypeWithCls:[TRExplosionFlame class]];
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
    return EGVec3Eq(self.position, o.position);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec3Hash(self.position);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"position=%@", EGVec3Description(self.position)];
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



