#import "objd.h"
#import "ATActor.h"

@class EGParticleSystem2;
@class EGFixedParticleSystem2;
@class EGEmissiveParticleSystem2;
@protocol EGParticleSystemIndexArray;

@interface EGParticleSystem2 : ATActor {
@protected
    ODPType* _particleType;
    unsigned int _maxCount;
    void* _particles;
}
@property (nonatomic, readonly) ODPType* particleType;
@property (nonatomic, readonly) unsigned int maxCount;
@property (nonatomic, readonly) void* particles;

+ (instancetype)particleSystem2WithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount;
- (instancetype)initWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount;
- (ODClassType*)type;
- (unsigned int)vertexCount;
- (unsigned int)particleSize;
- (void)dealloc;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (void)doUpdateWithDelta:(CGFloat)delta;
- (CNFuture*)writeToArray:(void*)array;
- (void)doWriteToArray:(void*)array;
- (CNFuture*)lastWriteCount;
+ (ODClassType*)type;
@end


@protocol EGParticleSystemIndexArray<NSObject>
- (unsigned int)indexCount;
- (unsigned int)maxCount;
- (unsigned int*)createIndexArray;
@end


@interface EGFixedParticleSystem2 : EGParticleSystem2
+ (instancetype)fixedParticleSystem2WithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount;
- (instancetype)initWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGEmissiveParticleSystem2 : EGParticleSystem2 {
@protected
    NSUInteger __lastWriteCount;
    NSInteger __lifeCount;
    unsigned int __particleSize;
    NSInteger __nextInvalidNumber;
    void* __nextInvalidRef;
}
@property (nonatomic) NSInteger _lifeCount;
@property (nonatomic, readonly) unsigned int _particleSize;
@property (nonatomic) NSInteger _nextInvalidNumber;
@property (nonatomic) void* _nextInvalidRef;

+ (instancetype)emissiveParticleSystem2WithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount;
- (instancetype)initWithParticleType:(ODPType*)particleType maxCount:(unsigned int)maxCount;
- (ODClassType*)type;
- (CNFuture*)lastWriteCount;
+ (ODClassType*)type;
@end


