#import "EGParticleSystem2.h"

@implementation EGParticleSystem2
static ODClassType* _EGParticleSystem2_type;
@synthesize particleType = _particleType;
@synthesize maxCount = _maxCount;
@synthesize particles = _particles;

+ (instancetype)particleSystem2WithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount {
    return [[EGParticleSystem2 alloc] initWithParticleType:particleType maxCount:maxCount];
}

- (instancetype)initWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount {
    self = [super init];
    if(self) {
        _particleType = particleType;
        _maxCount = maxCount;
        _particles = cnPointerApplyBytesCount(((NSUInteger)([self particleSize])), ((NSUInteger)(_maxCount)));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGParticleSystem2 class]) _EGParticleSystem2_type = [ODClassType classTypeWithCls:[EGParticleSystem2 class]];
}

- (unsigned int)vertexCount {
    @throw @"Method vertexCount is abstract";
}

- (unsigned int)particleSize {
    return ((unsigned int)(_particleType.size));
}

- (void)dealloc {
    cnPointerFree(_particles);
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [self futureF:^id() {
        [self doUpdateWithDelta:delta];
        return nil;
    }];
}

- (void)doUpdateWithDelta:(CGFloat)delta {
    @throw @"Method doUpdateWith is abstract";
}

- (CNFuture*)writeToArray:(void*)array {
    return [self futureF:^id() {
        [self doWriteToArray:array];
        return nil;
    }];
}

- (void)doWriteToArray:(void*)array {
    @throw @"Method doWriteTo is abstract";
}

- (CNFuture*)lastWriteCount {
    return [self promptF:^id() {
        return numui4(_maxCount);
    }];
}

- (ODClassType*)type {
    return [EGParticleSystem2 type];
}

+ (ODClassType*)type {
    return _EGParticleSystem2_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"particleType=%@", self.particleType];
    [description appendFormat:@", maxCount=%u", self.maxCount];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGFixedParticleSystem2
static ODClassType* _EGFixedParticleSystem2_type;

+ (instancetype)fixedParticleSystem2WithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount {
    return [[EGFixedParticleSystem2 alloc] initWithParticleType:particleType maxCount:maxCount];
}

- (instancetype)initWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount {
    self = [super initWithParticleType:particleType maxCount:maxCount];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFixedParticleSystem2 class]) _EGFixedParticleSystem2_type = [ODClassType classTypeWithCls:[EGFixedParticleSystem2 class]];
}

- (ODClassType*)type {
    return [EGFixedParticleSystem2 type];
}

+ (ODClassType*)type {
    return _EGFixedParticleSystem2_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"particleType=%@", self.particleType];
    [description appendFormat:@", maxCount=%u", self.maxCount];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGEmissiveParticleSystem2
static ODClassType* _EGEmissiveParticleSystem2_type;
@synthesize _lifeCount = __lifeCount;
@synthesize _particleSize = __particleSize;
@synthesize _nextInvalidNumber = __nextInvalidNumber;
@synthesize _nextInvalidRef = __nextInvalidRef;

+ (instancetype)emissiveParticleSystem2WithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount {
    return [[EGEmissiveParticleSystem2 alloc] initWithParticleType:particleType maxCount:maxCount];
}

- (instancetype)initWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount {
    self = [super initWithParticleType:particleType maxCount:maxCount];
    if(self) {
        __lastWriteCount = 0;
        __lifeCount = 0;
        __particleSize = [self particleSize];
        __nextInvalidNumber = 0;
        __nextInvalidRef = self.particles;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGEmissiveParticleSystem2 class]) _EGEmissiveParticleSystem2_type = [ODClassType classTypeWithCls:[EGEmissiveParticleSystem2 class]];
}

- (CNFuture*)lastWriteCount {
    return [self promptF:^id() {
        return numui(__lastWriteCount);
    }];
}

- (ODClassType*)type {
    return [EGEmissiveParticleSystem2 type];
}

+ (ODClassType*)type {
    return _EGEmissiveParticleSystem2_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"particleType=%@", self.particleType];
    [description appendFormat:@", maxCount=%u", self.maxCount];
    [description appendString:@">"];
    return description;
}

@end


