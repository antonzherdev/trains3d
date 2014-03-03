#import "objd.h"
#import "ATTypedActor.h"
#import "TRRailPoint.h"
#import "GEVec.h"
@class EGPhysicsWorld;
@class TRLevel;
@class TRTrain;
@class TRTrainState;
@class TRCarState;
@class EGCollisionBody;
@class EGCollisionWorld;
@class TRCarType;
@class EGCollision;
@class TRLiveCarState;
@class TRCar;
@class EGContact;
@class EGMapSso;
@class EGDynamicWorld;
@class EGCollisionPlane;
@class EGRigidBody;
@class TRForest;
@class TRTree;
@class TRCity;
@class TRLiveTrainState;
@class GEMat4;
@class TRDieCarState;
@class EGDynamicCollision;

@class TRBaseTrainsCollisionWorld;
@class TRTrainsCollisionWorld;
@class TRCarsCollision;
@class TRTrainsDynamicWorld;

@interface TRBaseTrainsCollisionWorld : ATTypedActor
+ (instancetype)baseTrainsCollisionWorld;
- (instancetype)init;
- (ODClassType*)type;
- (EGPhysicsWorld*)world;
- (TRLevel*)level;
- (void)addTrain:(TRTrain*)train;
- (CNFuture*)addTrain:(TRTrain*)train state:(TRTrainState*)state;
- (void)_addTrain:(TRTrain*)train state:(TRTrainState*)state;
- (CNFuture*)removeTrain:(TRTrain*)train;
- (void)_removeTrain:(TRTrain*)train;
- (CNFuture*)updateF:(CNFuture*(^)(id<CNSeq>))f;
- (void)updateMatrixStates:(id<CNSeq>)states;
+ (ODClassType*)type;
@end


@interface TRTrainsCollisionWorld : TRBaseTrainsCollisionWorld
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) EGCollisionWorld* world;

+ (instancetype)trainsCollisionWorldWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (CNFuture*)addTrain:(TRTrain*)train state:(TRTrainState*)state;
- (CNFuture*)detect;
- (CNFuture*)_detectStates:(id<CNSeq>)states;
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


@interface TRTrainsDynamicWorld : TRBaseTrainsCollisionWorld
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) EGDynamicWorld* world;
@property (nonatomic) NSInteger _workCounter;
@property (nonatomic, readonly) NSMutableArray* _dyingTrains;

+ (instancetype)trainsDynamicWorldWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (CNFuture*)cutDownTree:(TRTree*)tree;
- (CNFuture*)addCity:(TRCity*)city;
- (CNFuture*)addTrain:(TRTrain*)train state:(TRTrainState*)state;
- (void)dieTrain:(TRTrain*)train;
- (void)_removeTrain:(TRTrain*)train;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
+ (CNNotificationHandle*)carsCollisionNotification;
+ (CNNotificationHandle*)carAndGroundCollisionNotification;
+ (ODClassType*)type;
@end


