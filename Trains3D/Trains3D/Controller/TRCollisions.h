#import "objd.h"
#import "EGScene.h"
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

@class TRTrainsCollisionWorld;
@class TRCarsCollision;
@class TRTrainsDynamicWorld;

@interface TRTrainsCollisionWorld : NSObject
+ (id)trainsCollisionWorld;
- (id)init;
- (ODClassType*)type;
- (void)addTrain:(TRTrain*)train;
- (void)removeTrain:(TRTrain*)train;
- (id<CNSeq>)detect;
+ (ODClassType*)type;
@end


@interface TRCarsCollision : NSObject
@property (nonatomic, readonly) CNPair* cars;
@property (nonatomic, readonly) TRRailPoint* railPoint;

+ (id)carsCollisionWithCars:(CNPair*)cars railPoint:(TRRailPoint*)railPoint;
- (id)initWithCars:(CNPair*)cars railPoint:(TRRailPoint*)railPoint;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRTrainsDynamicWorld : NSObject<EGController>
+ (id)trainsDynamicWorld;
- (id)init;
- (ODClassType*)type;
- (void)addTrain:(TRTrain*)train;
- (void)dieTrain:(TRTrain*)train;
- (void)removeTrain:(TRTrain*)train;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


