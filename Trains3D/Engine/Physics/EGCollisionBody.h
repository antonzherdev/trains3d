#import "objd.h"
#import "GEVec.h"
#import "EGCollision.h"

@class GEMat4;

@class EGCollisionBody;
@class EGCollisionBox;
@class EGCollisionBox2d;
@class EGCollisionPlane;
@protocol EGCollisionShape;

@interface EGCollisionBody : NSObject <EGPhysicsBody>
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) id<EGCollisionShape> shape;
@property (nonatomic, readonly) BOOL isKinematic;
@property (nonatomic, readonly) VoidRef obj;

+ (id)collisionBodyWithData:(id)data shape:(id<EGCollisionShape>)shape isKinematic:(BOOL)isKinematic;
- (id)initWithData:(id)data shape:(id<EGCollisionShape>)shape isKinematic:(BOOL)isKinematic;
- (CNClassType*)type;
- (GEMat4 *)matrix;
- (void)setMatrix:(GEMat4 *)matrix;
- (void)translateX:(float)x y:(float)y z:(float)z;
- (void)rotateAngle:(float)angle x:(float)x y:(float)y z:(float)z;
+ (CNClassType*)type;
@end


@protocol EGCollisionShape<NSObject>
- (VoidRef)shape;
@end


@interface EGCollisionBox : NSObject<EGCollisionShape>
@property (nonatomic, readonly) GEVec3 size;

+ (id)collisionBoxWithSize:(GEVec3)size;
- (id)initWithSize:(GEVec3)size;
- (CNClassType*)type;
+ (EGCollisionBox*)applyX:(float)x y:(float)y z:(float)z;
+ (CNClassType*)type;
@end


@interface EGCollisionBox2d : NSObject<EGCollisionShape>
@property (nonatomic, readonly) GEVec2 size;

+ (id)collisionBox2dWithSize:(GEVec2)size;
- (id)initWithSize:(GEVec2)size;
- (CNClassType*)type;
+ (EGCollisionBox2d*)applyX:(float)x y:(float)y;
+ (CNClassType*)type;
@end


@interface EGCollisionPlane : NSObject<EGCollisionShape>
@property (nonatomic, readonly) GEVec3 normal;
@property (nonatomic, readonly) float distance;

+ (id)collisionPlaneWithNormal:(GEVec3)normal distance:(float)distance;
- (id)initWithNormal:(GEVec3)normal distance:(float)distance;
- (CNClassType*)type;
+ (CNClassType*)type;
@end


