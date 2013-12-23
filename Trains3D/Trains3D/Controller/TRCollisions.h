#import "objd.h"
#import "TRCar.h"
#import "TRRailPoint.h"
#import "GEVec.h"
#import "EGScene.h"
@class EGMapSso;
@class EGCollisionWorld;
@class TRTrain;
@class EGCollision;
@class EGCollisionBody;
@class EGContact;
@class TRLevel;
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

@interface TRTrainsCollisionWorld : NSObject
@property (nonatomic, readonly) EGMapSso* map;

+ (id)trainsCollisionWorldWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (ODClassType*)type;
- (void)addTrain:(TRTrain*)train;
- (void)removeTrain:(TRTrain*)train;
- (id<CNSeq>)detect;
+ (ODClassType*)type;
@end


@interface TRCarsCollision : NSObject
@property (nonatomic, readonly) CNPair* cars;
@property (nonatomic, readonly) TRRailPoint railPoint;

+ (id)carsCollisionWithCars:(CNPair*)cars railPoint:(TRRailPoint)railPoint;
- (id)initWithCars:(CNPair*)cars railPoint:(TRRailPoint)railPoint;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRTrainsDynamicWorld : NSObject<EGUpdatable>
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) EGDynamicWorld* world;
@property (nonatomic, readonly) CNNotificationObserver* cutDownObs;

+ (id)trainsDynamicWorldWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)addCity:(TRCity*)city;
- (void)addTrain:(TRTrain*)train;
- (void)dieTrain:(TRTrain*)train;
- (void)removeTrain:(TRTrain*)train;
- (void)updateWithDelta:(CGFloat)delta;
+ (CNNotificationHandle*)carsCollisionNotification;
+ (CNNotificationHandle*)carAndGroundCollisionNotification;
+ (ODClassType*)type;
@end


