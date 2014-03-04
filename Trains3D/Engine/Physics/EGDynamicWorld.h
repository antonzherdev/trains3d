#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
#import "EGCollision.h"

@protocol EGCollisionShape;
@class GEMat4;

@class EGDynamicWorld;
@class EGRigidBody;

@interface EGDynamicWorld : EGPhysicsWorld<EGUpdatable>
@property (nonatomic, readonly) GEVec3 gravity;

+ (id)dynamicWorldWithGravity:(GEVec3)gravity;
- (id)initWithGravity:(GEVec3)gravity;
- (ODClassType*)type;
- (void)addBody:(EGRigidBody*)body;
- (BOOL)removeBody:(EGRigidBody*)body;
+ (ODClassType*)type;
- (id <CNIterable>)collisions;
- (id <CNIterable>)newCollisions;
@end


@interface EGRigidBody : NSObject<EGPhysicsBody>
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) id<EGCollisionShape> shape;
@property (nonatomic, readonly) BOOL isKinematic;
@property (nonatomic, readonly) float mass;
@property (nonatomic, readonly) BOOL isDynamic;
@property (nonatomic, readonly) BOOL isStatic;
@property (nonatomic, readonly) VoidRef obj;
@property(nonatomic) float friction;
@property(nonatomic) float bounciness;
@property(nonatomic) GEVec3 angularVelocity;

+ (id)rigidBodyWithData:(id)data shape:(id<EGCollisionShape>)shape isKinematic:(BOOL)isKinematic mass:(float)mass;
- (id)initWithData:(id)data shape:(id<EGCollisionShape>)shape isKinematic:(BOOL)isKinematic mass:(float)mass;
- (ODClassType*)type;
+ (EGRigidBody*)kinematicData:(id)data shape:(id<EGCollisionShape>)shape;
+ (EGRigidBody*)dynamicData:(id)data shape:(id<EGCollisionShape>)shape mass:(float)mass;
+ (EGRigidBody*)staticalData:(id)data shape:(id<EGCollisionShape>)shape;
- (GEMat4 *)matrix;
- (void)setMatrix:(GEMat4 *)matrix;
- (GEVec3)velocity;
- (void)setVelocity:(GEVec3)velocity;
+ (ODClassType*)type;
@end


