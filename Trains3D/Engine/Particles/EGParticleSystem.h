#import "objd.h"
#import "CNActor.h"
@class CNFuture;
@class EGMappedBufferData;

@class EGParticleSystem;
@class EGParticleSystemIndexArray_impl;
@class EGFixedParticleSystem;
@class EGEmissiveParticleSystem;
@protocol EGParticleSystemIndexArray;

@interface EGParticleSystem : CNActor {
@protected
    CNPType* _particleType;
    unsigned int _maxCount;
    void* _particles;
}
@property (nonatomic, readonly) CNPType* particleType;
@property (nonatomic, readonly) unsigned int maxCount;
@property (nonatomic, readonly) void* particles;

+ (instancetype)particleSystemWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount;
- (instancetype)initWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount;
- (CNClassType*)type;
- (unsigned int)vertexCount;
- (unsigned int)particleSize;
- (void)dealloc;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (void)doUpdateWithDelta:(CGFloat)delta;
- (CNFuture*)writeToArray:(EGMappedBufferData*)array;
- (unsigned int)doWriteToArray:(void*)array;
- (NSString*)description;
+ (CNClassType*)type;
@end


@protocol EGParticleSystemIndexArray<NSObject>
- (unsigned int)indexCount;
- (unsigned int)maxCount;
- (unsigned int*)createIndexArray;
- (NSString*)description;
@end


@interface EGParticleSystemIndexArray_impl : NSObject<EGParticleSystemIndexArray>
+ (instancetype)particleSystemIndexArray_impl;
- (instancetype)init;
@end


@interface EGFixedParticleSystem : EGParticleSystem
+ (instancetype)fixedParticleSystemWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount;
- (instancetype)initWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
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

+ (instancetype)emissiveParticleSystemWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount;
- (instancetype)initWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


