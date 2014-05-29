#import "EGParticleSystem.h"

#import "CNFuture.h"
#import "EGBuffer.h"
@implementation EGParticleSystem
static CNClassType* _EGParticleSystem_type;
@synthesize particleType = _particleType;
@synthesize maxCount = _maxCount;
@synthesize particles = _particles;

+ (instancetype)particleSystemWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount {
    return [[EGParticleSystem alloc] initWithParticleType:particleType maxCount:maxCount];
}

- (instancetype)initWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount {
    self = [super init];
    if(self) {
        _particleType = particleType;
        _maxCount = maxCount;
        _particles = cnPointerApplyBytesCount(((NSUInteger)([self particleSize])), ((NSUInteger)(maxCount)));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGParticleSystem class]) _EGParticleSystem_type = [CNClassType classTypeWithCls:[EGParticleSystem class]];
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

- (NSString*)description {
    return [NSString stringWithFormat:@"ParticleSystem(%@, %u)", _particleType, _maxCount];
}

- (CNClassType*)type {
    return [EGParticleSystem type];
}

+ (CNClassType*)type {
    return _EGParticleSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGParticleSystemIndexArray_impl

+ (instancetype)particleSystemIndexArray_impl {
    return [[EGParticleSystemIndexArray_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (unsigned int)indexCount {
    @throw @"Method indexCount is abstract";
}

- (unsigned int)maxCount {
    @throw @"Method maxCount is abstract";
}

- (unsigned int*)createIndexArray {
    @throw @"Method createIndexArray is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGFixedParticleSystem
static CNClassType* _EGFixedParticleSystem_type;

+ (instancetype)fixedParticleSystemWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount {
    return [[EGFixedParticleSystem alloc] initWithParticleType:particleType maxCount:maxCount];
}

- (instancetype)initWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount {
    self = [super initWithParticleType:particleType maxCount:maxCount];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFixedParticleSystem class]) _EGFixedParticleSystem_type = [CNClassType classTypeWithCls:[EGFixedParticleSystem class]];
}

- (void)forParticlesBy:(void(^)(void*))by {
    NSInteger i = 0;
    void* p = self.particles;
    while(i < self.maxCount) {
        by(p);
        i++;
        p++;
    }
}

- (unsigned int)writeParticlesArray:(void*)array by:(void*(^)(void*, void*))by {
    NSInteger i = 0;
    void* p = self.particles;
    void* a = array;
    while(i < self.maxCount) {
        a = by(a, p);
        i++;
        p++;
    }
    return self.maxCount;
}

- (NSString*)description {
    return @"FixedParticleSystem";
}

- (CNClassType*)type {
    return [EGFixedParticleSystem type];
}

+ (CNClassType*)type {
    return _EGFixedParticleSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGEmissiveParticleSystem
static CNClassType* _EGEmissiveParticleSystem_type;
@synthesize _lifeCount = __lifeCount;
@synthesize _particleSize = __particleSize;
@synthesize _nextInvalidNumber = __nextInvalidNumber;
@synthesize _nextInvalidRef = __nextInvalidRef;

+ (instancetype)emissiveParticleSystemWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount {
    return [[EGEmissiveParticleSystem alloc] initWithParticleType:particleType maxCount:maxCount];
}

- (instancetype)initWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount {
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
    if(self == [EGEmissiveParticleSystem class]) _EGEmissiveParticleSystem_type = [CNClassType classTypeWithCls:[EGEmissiveParticleSystem class]];
}

- (void)updateParticlesBy:(BOOL(^)(void*))by {
    NSInteger i = 0;
    void* p = self.particles;
    while(i < self.maxCount) {
        if(*(((char*)(p))) != 0) {
            BOOL ch = by(p);
            if(!(ch)) {
                *(((char*)(p))) = 0;
                __lifeCount--;
                __nextInvalidRef = p;
                __nextInvalidNumber = i;
            }
        }
        i++;
        p++;
    }
}

- (void)emitBy:(void(^)(void*))by {
    if(__lifeCount < self.maxCount) {
        void* p = __nextInvalidRef;
        BOOL round = NO;
        while(*(((char*)(p))) != 0) {
            __nextInvalidNumber++;
            if(__nextInvalidNumber >= self.maxCount) {
                if(round) return ;
                round = YES;
                __nextInvalidNumber = 0;
                p = self.particles;
            } else {
                p++;
            }
        }
        *(((char*)(p))) = 1;
        by(p);
        __nextInvalidRef = p;
        __lifeCount++;
    }
}

- (unsigned int)writeParticlesArray:(void*)array by:(void*(^)(void*, void*))by {
    NSInteger i = 0;
    void* p = self.particles;
    void* a = array;
    while(i < self.maxCount) {
        if(*(((char*)(p))) != 0) a = by(a, p);
        i++;
        p++;
    }
    return ((unsigned int)(__lifeCount));
}

- (NSString*)description {
    return @"EmissiveParticleSystem";
}

- (CNClassType*)type {
    return [EGEmissiveParticleSystem type];
}

+ (CNClassType*)type {
    return _EGEmissiveParticleSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

