#import "objd.h"
#import "GEVec.h"
@class EGCollisionBody;

@class EGCollision;
@class EGDynamicCollision;
@class EGCrossPoint;
@class EGContact;
@class EGIndexFunFilteredIterable;
@class EGIndexFunFilteredIterator;

@interface EGCollision : NSObject
@property (nonatomic, readonly) CNPair* bodies;
@property (nonatomic, readonly) id<CNSeq> contacts;

+ (instancetype)collisionWithBodies:(CNPair*)bodies contacts:(id<CNSeq>)contacts;
- (instancetype)initWithBodies:(CNPair*)bodies contacts:(id<CNSeq>)contacts;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGDynamicCollision : NSObject
@property (nonatomic, readonly) CNPair* bodies;
@property (nonatomic, readonly) id<CNSeq> contacts;

+ (instancetype)dynamicCollisionWithBodies:(CNPair*)bodies contacts:(id<CNSeq>)contacts;
- (instancetype)initWithBodies:(CNPair*)bodies contacts:(id<CNSeq>)contacts;
- (ODClassType*)type;
- (float)impulse;
+ (ODClassType*)type;
@end


@interface EGCrossPoint : NSObject
@property (nonatomic, readonly) EGCollisionBody* body;
@property (nonatomic, readonly) GEVec3 point;

+ (instancetype)crossPointWithBody:(EGCollisionBody*)body point:(GEVec3)point;
- (instancetype)initWithBody:(EGCollisionBody*)body point:(GEVec3)point;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGContact : NSObject
@property (nonatomic, readonly) GEVec3 a;
@property (nonatomic, readonly) GEVec3 b;
@property (nonatomic, readonly) float distance;
@property (nonatomic, readonly) float impulse;
@property (nonatomic, readonly) unsigned int lifeTime;

+ (instancetype)contactWithA:(GEVec3)a b:(GEVec3)b distance:(float)distance impulse:(float)impulse lifeTime:(unsigned int)lifeTime;
- (instancetype)initWithA:(GEVec3)a b:(GEVec3)b distance:(float)distance impulse:(float)impulse lifeTime:(unsigned int)lifeTime;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGIndexFunFilteredIterable : NSObject<CNIterable>
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) id(^f)(NSUInteger);

+ (instancetype)indexFunFilteredIterableWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (instancetype)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (ODClassType*)type;
- (id<CNIterator>)iterator;
+ (ODClassType*)type;
@end


@interface EGIndexFunFilteredIterator : NSObject<CNIterator>
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) id(^f)(NSUInteger);

+ (instancetype)indexFunFilteredIteratorWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (instancetype)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (ODClassType*)type;
- (BOOL)hasNext;
- (id)next;
+ (ODClassType*)type;
@end


