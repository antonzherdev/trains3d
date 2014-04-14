#import "objd.h"
#import "ATActor.h"

@class EGParticleSystem2;
@class EGEmissiveParticleSystem2;

@interface EGParticleSystem2 : ATActor {
@protected
    unsigned int _maxCount;
    void* _particles;
}
@property (nonatomic, readonly) unsigned int maxCount;
@property (nonatomic, readonly) void* particles;

+ (instancetype)particleSystem2WithMaxCount:(unsigned int)maxCount;
- (instancetype)initWithMaxCount:(unsigned int)maxCount;
- (ODClassType*)type;
- (unsigned int)vertexCount;
- (unsigned int)indexCount;
- (unsigned int*)createIndexArray;
- (unsigned int*)createIndexArrayMaxCount:(unsigned int)maxCount;
- (ODPType*)particleType;
- (unsigned int)particleSize;
- (void)dealloc;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (void)doUpdateWithDelta:(CGFloat)delta;
- (CNFuture*)writeToArray:(void*)array;
- (void)doWriteToArray:(void*)array;
- (CNFuture*)count;
+ (ODClassType*)type;
@end


@interface EGEmissiveParticleSystem2 : EGParticleSystem2 {
@protected
    NSInteger __lifeCount;
    unsigned int __particleSize;
    NSInteger __nextInvalidNumber;
    void* __nextInvalidRef;
}
@property (nonatomic, readonly) NSInteger _lifeCount;
@property (nonatomic, readonly) unsigned int _particleSize;
@property (nonatomic) NSInteger _nextInvalidNumber;
@property (nonatomic) void* _nextInvalidRef;

+ (instancetype)emissiveParticleSystem2WithMaxCount:(unsigned int)maxCount;
- (instancetype)initWithMaxCount:(unsigned int)maxCount;
- (ODClassType*)type;
- (CNFuture*)count;
+ (ODClassType*)type;
@end


