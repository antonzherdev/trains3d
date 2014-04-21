#import "objd.h"
#import "ATActor.h"

@class EGParticleSystem;
@class EGFixedParticleSystem;
@class EGEmissiveParticleSystem;
@protocol EGParticleSystemIndexArray;

@interface EGParticleSystem : ATActor {
@protected
    ODPType* _particleType;
    unsigned int _maxCount;
    void* _particles;
}
@property (nonatomic, readonly) ODPType* particleType;
@property (nonatomic, readonly) unsigned int maxCount;
@property (nonatomic, readonly) void* particles;

+ (instancetype)particleSystemWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount;
- (instancetype)initWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount;
- (ODClassType*)type;
- (unsigned int)vertexCount;
- (unsigned int)particleSize;
- (void)dealloc;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (void)doUpdateWithDelta:(CGFloat)delta;
- (CNFuture*)writeToArray:(void*)array;
- (unsigned int)doWriteToArray:(void*)array;
+ (ODClassType*)type;
@end


@protocol EGParticleSystemIndexArray<NSObject>
- (unsigned int)indexCount;
- (unsigned int)maxCount;
- (unsigned int*)createIndexArray;
@end


@interface EGFixedParticleSystem : EGParticleSystem
+ (instancetype)fixedParticleSystemWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount;
- (instancetype)initWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGEmissiveParticleSystem : EGParticleSystem {
@protected
    NSInteger __lifeCount;
    unsigned int __particleSize;
    NSInteger __nextInvalidNumber;
    void* __nextInvalidRef;
}
@property (nonatomic) NSInteger _lifeCount;
@property (nonatomic, readonly) unsigned int _particleSize;
@property (nonatomic) NSInteger _nextInvalidNumber;
@property (nonatomic) void* _nextInvalidRef;

+ (instancetype)emissiveParticleSystemWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount;
- (instancetype)initWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


