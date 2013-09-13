#import "objd.h"
#import "EGTypes.h"
#import "EGVec.h"
@protocol EGCollisionShape;
@class EGMatrix;

@class EGDynamicWorld;
@class EGRigidBody;

@interface EGDynamicWorld : NSObject<EGController>
@property (nonatomic, readonly) EGVec3 gravity;

+ (id)dynamicWorldWithGravity:(EGVec3)gravity;
- (id)initWithGravity:(EGVec3)gravity;
- (ODClassType*)type;
- (id<CNSeq>)bodies;
- (void)addBody:(EGRigidBody*)body;
- (void)removeBody:(EGRigidBody*)body;
+ (ODClassType*)type;
@end


@interface EGRigidBody : NSObject
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) id<EGCollisionShape> shape;
@property (nonatomic, readonly) BOOL isKinematic;
@property (nonatomic, readonly) float mass;
@property (nonatomic, readonly) BOOL isDynamic;
@property (nonatomic, readonly) BOOL isStatic;
@property (nonatomic, readonly) VoidRef obj;

+ (id)rigidBodyWithData:(id)data shape:(id<EGCollisionShape>)shape isKinematic:(BOOL)isKinematic mass:(float)mass;
- (id)initWithData:(id)data shape:(id<EGCollisionShape>)shape isKinematic:(BOOL)isKinematic mass:(float)mass;
- (ODClassType*)type;
+ (EGRigidBody*)kinematicData:(id)data shape:(id<EGCollisionShape>)shape;
+ (EGRigidBody*)dynamicData:(id)data shape:(id<EGCollisionShape>)shape mass:(float)mass;
+ (EGRigidBody*)staticalData:(id)data shape:(id<EGCollisionShape>)shape;
- (EGMatrix*)matrix;
- (void)setMatrix:(EGMatrix*)matrix;
- (EGVec3)velocity;
- (void)setVelocity:(EGVec3)velocity;
+ (ODClassType*)type;
@end


