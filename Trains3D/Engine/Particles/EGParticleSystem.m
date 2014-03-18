#import "EGParticleSystem.h"

@implementation EGParticleSystem
static ODClassType* _EGParticleSystem_type;
@synthesize _lastWriteCount = __lastWriteCount;

+ (instancetype)particleSystem {
    return [[EGParticleSystem alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) __lastWriteCount = 0;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGParticleSystem class]) _EGParticleSystem_type = [ODClassType classTypeWithCls:[EGParticleSystem class]];
}

- (id<CNSeq>)particles {
    @throw @"Method particles is abstract";
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [self futureF:^id() {
        [self doUpdateWithDelta:delta];
        return nil;
    }];
}

- (void)doUpdateWithDelta:(CGFloat)delta {
    [[self particles] forEach:^void(id<EGParticle> p) {
        [p updateWithDelta:delta];
    }];
}

- (CNFuture*)lastWriteCount {
    return [self promptF:^id() {
        return numui(__lastWriteCount);
    }];
}

- (CNFuture*)writeToMaxCount:(NSUInteger)maxCount array:(CNVoidRefArray)array {
    return [self futureF:^id() {
        [self doWriteToMaxCount:maxCount array:array];
        return nil;
    }];
}

- (void)doWriteToMaxCount:(NSUInteger)maxCount array:(CNVoidRefArray)array {
    __block CNVoidRefArray p = array;
    __block NSUInteger i = 0;
    [[self particles] goOn:^BOOL(id particle) {
        if(i < maxCount) {
            p = [particle writeToArray:p];
            i++;
            return YES;
        } else {
            return NO;
        }
    }];
    __lastWriteCount = i;
}

- (ODClassType*)type {
    return [EGParticleSystem type];
}

+ (ODClassType*)type {
    return _EGParticleSystem_type;
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


@implementation EGEmissiveParticleSystem
static ODClassType* _EGEmissiveParticleSystem_type;
@synthesize _particles = __particles;

+ (instancetype)emissiveParticleSystem {
    return [[EGEmissiveParticleSystem alloc] init];
}

- (instancetype)init {
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

- (void)doUpdateWithDelta:(CGFloat)delta {
    [self generateParticlesWithDelta:delta];
    [__particles mutableFilterBy:^BOOL(id p) {
        [((id<EGParticle>)(p)) updateWithDelta:delta];
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


@implementation EGEmittedParticle
static ODClassType* _EGEmittedParticle_type;
@synthesize lifeLength = _lifeLength;

+ (instancetype)emittedParticleWithLifeLength:(float)lifeLength {
    return [[EGEmittedParticle alloc] initWithLifeLength:lifeLength];
}

- (instancetype)initWithLifeLength:(float)lifeLength {
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


