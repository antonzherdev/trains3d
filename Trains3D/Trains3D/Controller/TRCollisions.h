#import "objd.h"
#import "ATTypedActor.h"
#import "TRRailPoint.h"
#import "GEVec.h"
@class TRLevel;
@class EGCollisionWorld;
@class TRTrainActor;
@class TRCarPosition;
@class TRCarType;
@class EGCollisionBody;
@class EGCollision;
@class EGContact;
@class EGMapSso;
@class EGDynamicWorld;
@class EGCollisionPlane;
@class EGRigidBody;
@class TRForest;
@class TRTree;
@class TRCity;
@class EGDynamicCollision;
@class TRCar;

@class TRTrainsCollisionWorld;
@class TRCarsCollision;
@class TRTrainsDynamicWorld;

@interface TRTrainsCollisionWorld : ATTypedActor
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) EGCollisionWorld* world;
@property (nonatomic, readonly) NSMutableDictionary* bodies;

+ (instancetype)trainsCollisionWorldWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)addTrain:(TRTrainActor*)train;
- (void)removeTrain:(TRTrainActor*)train;
- (CNFuture*)detect;
- (CNFuture*)_detectPositionsMap:(id<CNMap>)positionsMap;
+ (ODClassType*)type;
@end


@interface TRCarsCollision : NSObject
@property (nonatomic, readonly) id<CNSet> trains;
@property (nonatomic, readonly) TRRailPoint railPoint;

+ (instancetype)carsCollisionWithTrains:(id<CNSet>)trains railPoint:(TRRailPoint)railPoint;
- (instancetype)initWithTrains:(id<CNSet>)trains railPoint:(TRRailPoint)railPoint;
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
- (void)addDynamicBodies:(id<CNSeq>)bodies;
- (void)removeTrain:(TRTrainActor*)train;
- (void)removeAliveTrainTrain:(TRTrainActor*)train;
- (void)removeDiedTrainTrain:(TRTrainActor*)train;
- (void)removeDynamicBodies:(id<CNSeq>)bodies;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (CNFuture*)_updateWithDelta:(CGFloat)delta;
+ (CNNotificationHandle*)carsCollisionNotification;
+ (CNNotificationHandle*)carAndGroundCollisionNotification;
+ (ODClassType*)type;
@end


