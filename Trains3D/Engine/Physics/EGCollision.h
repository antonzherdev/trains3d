#import "objd.h"
#import "GEVec.h"
@class EGCollisionBody;
@protocol EGCollisionShape;
@class GEMat4;

@class EGCollision;
@class EGDynamicCollision;
@class EGCrossPoint;
@class EGContact;
@class EGIndexFunFilteredIterable;
@class EGIndexFunFilteredIterator;
@class EGPhysicsWorld;
@protocol EGPhysicsBody;

@interface EGCollision : NSObject {
@private
    CNPair* _bodies;
    id<CNImSeq> _contacts;
}
@property (nonatomic, readonly) CNPair* bodies;
@property (nonatomic, readonly) id<CNImSeq> contacts;

+ (instancetype)collisionWithBodies:(CNPair*)bodies contacts:(id<CNImSeq>)contacts;
- (instancetype)initWithBodies:(CNPair*)bodies contacts:(id<CNImSeq>)contacts;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGDynamicCollision : NSObject {
@private
    CNPair* _bodies;
    id<CNImSeq> _contacts;
}
@property (nonatomic, readonly) CNPair* bodies;
@property (nonatomic, readonly) id<CNImSeq> contacts;

+ (instancetype)dynamicCollisionWithBodies:(CNPair*)bodies contacts:(id<CNImSeq>)contacts;
- (instancetype)initWithBodies:(CNPair*)bodies contacts:(id<CNImSeq>)contacts;
- (ODClassType*)type;
- (float)impulse;
+ (ODClassType*)type;
@end


@interface EGCrossPoint : NSObject {
@private
    EGCollisionBody* _body;
    GEVec3 _point;
}
@property (nonatomic, readonly) EGCollisionBody* body;
@property (nonatomic, readonly) GEVec3 point;

+ (instancetype)crossPointWithBody:(EGCollisionBody*)body point:(GEVec3)point;
- (instancetype)initWithBody:(EGCollisionBody*)body point:(GEVec3)point;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGContact : NSObject {
@private
    GEVec3 _a;
    GEVec3 _b;
    float _distance;
    float _impulse;
    unsigned int _lifeTime;
}
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


@interface EGIndexFunFilteredIterable : NSObject<CNImIterable> {
@private
    NSUInteger _maxCount;
    id(^_f)(NSUInteger);
}
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) id(^f)(NSUInteger);

+ (instancetype)indexFunFilteredIterableWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (instancetype)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (ODClassType*)type;
- (id<CNIterator>)iterator;
+ (ODClassType*)type;
@end


@interface EGIndexFunFilteredIterator : NSObject<CNIterator> {
@private
    NSUInteger _maxCount;
    id(^_f)(NSUInteger);
    NSUInteger _i;
    id __next;
}
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) id(^f)(NSUInteger);

+ (instancetype)indexFunFilteredIteratorWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (instancetype)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (ODClassType*)type;
- (BOOL)hasNext;
- (id)next;
+ (ODClassType*)type;
@end


@protocol EGPhysicsBody<NSObject>
- (id)data;
- (id<EGCollisionShape>)shape;
- (BOOL)isKinematic;
- (GEMat4*)matrix;
- (void)setMatrix:(GEMat4*)matrix;
@end


@interface EGPhysicsWorld : NSObject {
@private
    NSMutableDictionary* __bodiesMap;
    id<CNImSeq> __bodies;
}
+ (instancetype)physicsWorld;
- (instancetype)init;
- (ODClassType*)type;
- (void)addBody:(id<EGPhysicsBody>)body;
- (void)_addBody:(id<EGPhysicsBody>)body;
- (void)removeBody:(id<EGPhysicsBody>)body;
- (BOOL)removeItem:(id)item;
- (void)_removeBody:(id<EGPhysicsBody>)body;
- (id)bodyForItem:(id)item;
- (void)clear;
- (id<CNIterable>)bodies;
+ (ODClassType*)type;
@end


