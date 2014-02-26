#import "objd.h"
#import "ATTypedActor.h"
#import "TRRailPoint.h"
#import "GEVec.h"
@class TRLevel;
@class EGCollisionWorld;
@class TRTrainActor;
@class TRCar;
@class EGCollision;
@class EGCollisionBody;
@class TRCarPosition;
@class EGContact;
@class EGMapSso;
@class EGDynamicWorld;
@class EGCollisionPlane;
@class EGRigidBody;
@class TRForest;
@class TRTree;
@class TRCity;
@class EGDynamicCollision;

@class TRTrainsCollisionWorld;
@class TRCarsCollision;
@class TRTrainsDynamicWorld;

@interface TRTrainsCollisionWorld : ATTypedActor
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) EGCollisionWorld* world;

+ (instancetype)trainsCollisionWorldWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)addTrain:(TRTrainActor*)train;
- (void)removeTrain:(TRTrainActor*)train;
- (CNFuture*)detect;
- (CNFuture*)_detect;
+ (ODClassType*)type;
@end


@interface TRCarsCollision : NSObject
@property (nonatomic, readonly) CNPair* cars;
@property (nonatomic, readonly) TRRailPoint railPoint;

+ (instancetype)carsCollisionWithCars:(CNPair*)cars railPoint:(TRRailPoint)railPoint;
- (instancetype)initWithCars:(CNPair*)cars railPoint:(TRRailPoint)railPoint;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRTrainsDynamicWorld : ATTypedActor
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) EGDynamicWorld* world;
@property (nonatomic, readonly) CNNotificationObserver* cutDownObs;
@property (nonatomic) NSInteger workCounter;

+ (instancetype)trainsDynamicWorldWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)addCity:(TRCity*)city;
- (void)addTrain:(TRTrainActor*)train;
- (void)dieTrain:(TRTrainActor*)train;
- (void)removeTrain:(TRTrainActor*)train;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (CNFuture*)_updateWithDelta:(CGFloat)delta;
+ (CNNotificationHandle*)carsCollisionNotification;
+ (CNNotificationHandle*)carAndGroundCollisionNotification;
+ (ODClassType*)type;
@end


