#import "objd.h"
#import "EGTypes.h"
#import "EGVec.h"
@class EGCollisionWorld;
@class TRTrain;
@class TRCar;
@class EGCollision;
@class EGCollisionBody;
@class TRCarPosition;
@class TRRailPoint;
@class EGDynamicWorld;
@class EGCollisionPlane;
@class EGRigidBody;

@class TRCollisionWorld;
@class TRCollision;
@class TRDynamicWorld;

@interface TRCollisionWorld : NSObject
+ (id)collisionWorld;
- (id)init;
- (ODClassType*)type;
- (void)addTrain:(TRTrain*)train;
- (void)removeTrain:(TRTrain*)train;
- (id<CNSeq>)detect;
+ (ODClassType*)type;
@end


@interface TRCollision : NSObject
@property (nonatomic, readonly) CNPair* cars;
@property (nonatomic, readonly) TRRailPoint* railPoint;

+ (id)collisionWithCars:(CNPair*)cars railPoint:(TRRailPoint*)railPoint;
- (id)initWithCars:(CNPair*)cars railPoint:(TRRailPoint*)railPoint;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRDynamicWorld : NSObject<EGController>
+ (id)dynamicWorld;
- (id)init;
- (ODClassType*)type;
- (void)addTrain:(TRTrain*)train;
- (void)removeTrain:(TRTrain*)train;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


