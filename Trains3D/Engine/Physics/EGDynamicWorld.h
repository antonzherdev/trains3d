#import "objd.h"
#import "EGVec.h"
#import "EGTypes.h"

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
- (void)addBody:(EGRigidBody *)body;
- (void)removeBody:(EGRigidBody *)body;
+ (ODClassType*)type;
@end


@interface EGRigidBody : NSObject
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) id<EGCollisionShape> shape;
@property (nonatomic, readonly) BOOL isKinematic;
@property (nonatomic, readonly) float mass;
@property (nonatomic, readonly) VoidRef obj;

+ (id)rigidBodyWithData:(id)data shape:(id <EGCollisionShape>)shape isKinematic:(BOOL)isKinematic mass:(float)mass;
- (id)initWithData:(id)data shape:(id<EGCollisionShape>)shape isKinematic:(BOOL)isKinematic mass:(float)mass;
- (ODClassType*)type;
- (EGMatrix*)matrix;
- (void)setMatrix:(EGMatrix*)matrix;
+ (ODClassType*)type;
- (EGVec3)velocity;
- (void)setVelocity:(EGVec3)vec3;
@end


