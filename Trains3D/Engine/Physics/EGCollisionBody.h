#import "objd.h"
#import "GEVec.h"
@class GEMat4;

@class EGCollisionBody;
@class EGCollisionBox;
@class EGCollisionBox2d;
@class EGCollisionPlane;
@protocol EGCollisionShape;

@interface EGCollisionBody : NSObject
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) id<EGCollisionShape> shape;
@property (nonatomic, readonly) BOOL isKinematic;
@property (nonatomic, readonly) VoidRef obj;

+ (id)collisionBodyWithData:(id)data shape:(id<EGCollisionShape>)shape isKinematic:(BOOL)isKinematic;
- (id)initWithData:(id)data shape:(id<EGCollisionShape>)shape isKinematic:(BOOL)isKinematic;
- (ODClassType*)type;
- (GEMat4 *)matrix;
- (void)setMatrix:(GEMat4 *)matrix;
- (void)translateX:(float)x y:(float)y z:(float)z;
- (void)rotateAngle:(float)angle x:(float)x y:(float)y z:(float)z;
+ (ODClassType*)type;
@end


@protocol EGCollisionShape<NSObject>
- (VoidRef)shape;
@end


@interface EGCollisionBox : NSObject<EGCollisionShape>
@property (nonatomic, readonly) GEVec3 halfSize;

+ (id)collisionBoxWithHalfSize:(GEVec3)halfSize;
- (id)initWithHalfSize:(GEVec3)halfSize;
- (ODClassType*)type;
+ (EGCollisionBox*)applyX:(float)x y:(float)y z:(float)z;
+ (ODClassType*)type;
@end


@interface EGCollisionBox2d : NSObject<EGCollisionShape>
@property (nonatomic, readonly) GEVec2 halfSize;

+ (id)collisionBox2dWithHalfSize:(GEVec2)halfSize;
- (id)initWithHalfSize:(GEVec2)halfSize;
- (ODClassType*)type;
+ (EGCollisionBox2d*)applyX:(float)x y:(float)y;
+ (ODClassType*)type;
@end


@interface EGCollisionPlane : NSObject<EGCollisionShape>
@property (nonatomic, readonly) GEVec3 normal;
@property (nonatomic, readonly) float distance;

+ (id)collisionPlaneWithNormal:(GEVec3)normal distance:(float)distance;
- (id)initWithNormal:(GEVec3)normal distance:(float)distance;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


