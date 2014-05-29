#import "objd.h"
#import "GEVec.h"
@class CNChain;
@class EGCollisionBody;
@protocol EGCollisionShape;
@class GEMat4;

@class EGCollision;
@class EGDynamicCollision;
@class EGCrossPoint;
@class EGContact;
@class EGIndexFunFilteredIterable;
@class EGIndexFunFilteredIterator;
@class EGPhysicsBody_impl;
@class EGPhysicsWorld;
@protocol EGPhysicsBody;

@interface EGCollision : NSObject {
@protected
    CNPair* _bodies;
    id<CNIterable> _contacts;
}
@property (nonatomic, readonly) CNPair* bodies;
@property (nonatomic, readonly) id<CNIterable> contacts;

+ (instancetype)collisionWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts;
- (instancetype)initWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGDynamicCollision : NSObject {
@protected
    CNPair* _bodies;
    id<CNIterable> _contacts;
}
@property (nonatomic, readonly) CNPair* bodies;
@property (nonatomic, readonly) id<CNIterable> contacts;

+ (instancetype)dynamicCollisionWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts;
- (instancetype)initWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts;
- (CNClassType*)type;
- (float)impulse;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGCrossPoint : NSObject {
@protected
    EGCollisionBody* _body;
    GEVec3 _point;
}
@property (nonatomic, readonly) EGCollisionBody* body;
@property (nonatomic, readonly) GEVec3 point;

+ (instancetype)crossPointWithBody:(EGCollisionBody*)body point:(GEVec3)point;
- (instancetype)initWithBody:(EGCollisionBody*)body point:(GEVec3)point;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGContact : NSObject {
@protected
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
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGIndexFunFilteredIterable : CNImIterable_impl {
@protected
    NSUInteger _maxCount;
    id(^_f)(NSUInteger);
}
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) id(^f)(NSUInteger);

+ (instancetype)indexFunFilteredIterableWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (instancetype)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (CNClassType*)type;
- (id<CNIterator>)iterator;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGIndexFunFilteredIterator : CNIterator_impl {
@protected
    NSUInteger _maxCount;
    id(^_f)(NSUInteger);
    NSUInteger _i;
    id __next;
}
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) id(^f)(NSUInteger);

+ (instancetype)indexFunFilteredIteratorWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (instancetype)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (CNClassType*)type;
- (BOOL)hasNext;
- (id)next;
- (NSString*)description;
+ (CNClassType*)type;
@end


@protocol EGPhysicsBody<NSObject>
- (id)data;
- (id<EGCollisionShape>)shape;
- (BOOL)isKinematic;
- (GEMat4*)matrix;
- (void)setMatrix:(GEMat4*)matrix;
- (NSString*)description;
@end


@interface EGPhysicsBody_impl : NSObject<EGPhysicsBody>
+ (instancetype)physicsBody_impl;
- (instancetype)init;
@end


@interface EGPhysicsWorld : NSObject {
@protected
    CNMHashMap* __bodiesMap;
    NSArray* __bodies;
}
+ (instancetype)physicsWorld;
- (instancetype)init;
- (CNClassType*)type;
- (void)addBody:(id<EGPhysicsBody>)body;
- (void)_addBody:(id<EGPhysicsBody>)body;
- (void)removeBody:(id<EGPhysicsBody>)body;
- (BOOL)removeItem:(id)item;
- (void)_removeBody:(id<EGPhysicsBody>)body;
- (id<EGPhysicsBody>)bodyForItem:(id)item;
- (void)clear;
- (id<CNIterable>)bodies;
- (NSString*)description;
+ (CNClassType*)type;
@end


