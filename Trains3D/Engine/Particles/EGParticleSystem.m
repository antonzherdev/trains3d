#import "EGParticleSystem.h"

@implementation EGEmissiveParticleSystem{
    NSMutableArray* __particles;
}
static ODClassType* _EGEmissiveParticleSystem_type;

+ (id)emissiveParticleSystem {
    return [[EGEmissiveParticleSystem alloc] init];
}

- (id)init {
    self = [super init];
    if(self) __particles = [NSMutableArray mutableArray];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGEmissiveParticleSystem class]) _EGEmissiveParticleSystem_type = [ODClassType classTypeWithCls:[EGEmissiveParticleSystem class]];
}

- (id<CNSeq>)particles {
    return __particles;
}

- (id)generateParticle {
    @throw @"Method generateParticle is abstract";
}

- (void)generateParticlesWithDelta:(CGFloat)delta {
}

- (void)emitParticle {
    [__particles appendItem:[self generateParticle]];
}

- (void)updateWithDelta:(CGFloat)delta {
    [self generateParticlesWithDelta:delta];
    [__particles mutableFilterBy:^BOOL(id p) {
        [p updateWithDelta:delta];
        return [p isLive];
    }];
}

- (BOOL)hasParticles {
    return !([__particles isEmpty]);
}

- (ODClassType*)type {
    return [EGEmissiveParticleSystem type];
}

+ (ODClassType*)type {
    return _EGEmissiveParticleSystem_type;
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


@implementation EGEmittedParticle{
    float _lifeLength;
    float __lifeTime;
}
static ODClassType* _EGEmittedParticle_type;
@synthesize lifeLength = _lifeLength;

+ (id)emittedParticleWithLifeLength:(float)lifeLength {
    return [[EGEmittedParticle alloc] initWithLifeLength:lifeLength];
}

- (id)initWithLifeLength:(float)lifeLength {
    self = [super init];
    if(self) _lifeLength = lifeLength;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGEmittedParticle class]) _EGEmittedParticle_type = [ODClassType classTypeWithCls:[EGEmittedParticle class]];
}

- (float)lifeTime {
    return __lifeTime;
}

- (BOOL)isLive {
    return __lifeTime <= _lifeLength;
}

- (void)updateWithDelta:(CGFloat)delta {
    __lifeTime += ((float)(delta));
    [self updateT:__lifeTime dt:((float)(delta))];
}

- (void)updateT:(float)t dt:(float)dt {
    @throw @"Method update is abstract";
}

- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array {
    @throw @"Method writeTo is abstract";
}

- (ODClassType*)type {
    return [EGEmittedParticle type];
}

+ (ODClassType*)type {
    return _EGEmittedParticle_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGEmittedParticle* o = ((EGEmittedParticle*)(other));
    return eqf4(self.lifeLength, o.lifeLength);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.lifeLength);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"lifeLength=%f", self.lifeLength];
    [description appendString:@">"];
    return description;
}

@end


