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

+ (id)collisionWithBodies:(CNPair*)bodies contacts:(id<CNSeq>)contacts;
- (id)initWithBodies:(CNPair*)bodies contacts:(id<CNSeq>)contacts;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGDynamicCollision : NSObject
@property (nonatomic, readonly) CNPair* bodies;
@property (nonatomic, readonly) id<CNSeq> contacts;

+ (id)dynamicCollisionWithBodies:(CNPair*)bodies contacts:(id<CNSeq>)contacts;
- (id)initWithBodies:(CNPair*)bodies contacts:(id<CNSeq>)contacts;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGCrossPoint : NSObject
@property (nonatomic, readonly) EGCollisionBody* body;
@property (nonatomic, readonly) GEVec3 point;

+ (id)crossPointWithBody:(EGCollisionBody*)body point:(GEVec3)point;
- (id)initWithBody:(EGCollisionBody*)body point:(GEVec3)point;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGContact : NSObject
@property (nonatomic, readonly) GEVec3 a;
@property (nonatomic, readonly) GEVec3 b;

+ (id)contactWithA:(GEVec3)a b:(GEVec3)b;
- (id)initWithA:(GEVec3)a b:(GEVec3)b;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGIndexFunFilteredIterable : NSObject<CNIterable>
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) id(^f)(NSUInteger);

+ (id)indexFunFilteredIterableWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (id)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (ODClassType*)type;
- (id<CNIterator>)iterator;
+ (ODClassType*)type;
@end


@interface EGIndexFunFilteredIterator : NSObject<CNIterator>
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) id(^f)(NSUInteger);

+ (id)indexFunFilteredIteratorWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (id)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (ODClassType*)type;
- (BOOL)hasNext;
- (id)next;
+ (ODClassType*)type;
@end


