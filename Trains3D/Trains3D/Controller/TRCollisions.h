#import "objd.h"
#import "EGTypes.h"
#import "GEVec.h"
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
@class TRCarsCollision;
@class TRDynamicWorld;

@interface TRCollisionWorld : NSObject
+ (id)collisionWorld;
- (id)init;
- (ODClassType*)type;
- (void)addTrain:(TRTrain*)train;
- (void)removeTrain:(TRTrain*)train;
- (id<CNSeq>)detect;
+ (ODType*)type;
@end


@interface TRCarsCollision : NSObject
@property (nonatomic, readonly) CNPair* cars;
@property (nonatomic, readonly) TRRailPoint* railPoint;

+ (id)carsCollisionWithCars:(CNPair*)cars railPoint:(TRRailPoint*)railPoint;
- (id)initWithCars:(CNPair*)cars railPoint:(TRRailPoint*)railPoint;
- (ODClassType*)type;
+ (ODType*)type;
@end


@interface TRDynamicWorld : NSObject<EGController>
+ (id)dynamicWorld;
- (id)init;
- (ODClassType*)type;
- (void)addTrain:(TRTrain*)train;
- (void)dieTrain:(TRTrain*)train;
- (void)removeTrain:(TRTrain*)train;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODType*)type;
@end


