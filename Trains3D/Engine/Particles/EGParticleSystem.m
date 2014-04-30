#import "EGParticleSystem.h"

#import "EGBuffer.h"
@implementation EGParticleSystem
static ODClassType* _EGParticleSystem_type;
@synthesize particleType = _particleType;
@synthesize maxCount = _maxCount;
@synthesize particles = _particles;

+ (instancetype)particleSystemWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount {
    return [[EGParticleSystem alloc] initWithParticleType:particleType maxCount:maxCount];
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
    if(self == [EGParticleSystem class]) _EGParticleSystem_type = [ODClassType classTypeWithCls:[EGParticleSystem class]];
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

- (CNFuture*)writeToArray:(EGMappedBufferData*)array {
    return [self futureF:^id() {
        unsigned int ret = 0;
        if([array beginWrite]) {
            {
                void* p = array.pointer;
                ret = [self doWriteToArray:p];
            }
            [array endWrite];
        }
        return numui4(ret);
    }];
}

- (unsigned int)doWriteToArray:(void*)array {
    @throw @"Method doWriteTo is abstract";
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
    [description appendFormat:@"particleType=%@", self.particleType];
    [description appendFormat:@", maxCount=%u", self.maxCount];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGFixedParticleSystem
static ODClassType* _EGFixedParticleSystem_type;

+ (instancetype)fixedParticleSystemWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount {
    return [[EGFixedParticleSystem alloc] initWithParticleType:particleType maxCount:maxCount];
}

- (instancetype)initWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount {
    self = [super initWithParticleType:particleType maxCount:maxCount];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFixedParticleSystem class]) _EGFixedParticleSystem_type = [ODClassType classTypeWithCls:[EGFixedParticleSystem class]];
}

- (ODClassType*)type {
    return [EGFixedParticleSystem type];
}

+ (ODClassType*)type {
    return _EGFixedParticleSystem_type;
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


@implementation EGEmissiveParticleSystem
static ODClassType* _EGEmissiveParticleSystem_type;
@synthesize _lifeCount = __lifeCount;
@synthesize _particleSize = __particleSize;
@synthesize _nextInvalidNumber = __nextInvalidNumber;
@synthesize _nextInvalidRef = __nextInvalidRef;

+ (instancetype)emissiveParticleSystemWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount {
    return [[EGEmissiveParticleSystem alloc] initWithParticleType:particleType maxCount:maxCount];
}

- (instancetype)initWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount {
    self = [super initWithParticleType:particleType maxCount:maxCount];
    if(self) {
        __lifeCount = 0;
        __particleSize = [self particleSize];
        __nextInvalidNumber = 0;
        __nextInvalidRef = self.particles;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGEmissiveParticleSystem class]) _EGEmissiveParticleSystem_type = [ODClassType classTypeWithCls:[EGEmissiveParticleSystem class]];
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"particleType=%@", self.particleType];
    [description appendFormat:@", maxCount=%u", self.maxCount];
    [description appendString:@">"];
    return description;
}

@end


