#import "objd.h"
#import "ATActor.h"
#import "TRRailPoint.h"
#import "GEVec.h"
@class EGPhysicsWorld;
@class TRLevel;
@class TRTrain;
@class TRTrainState;
@class TRCarState;
@protocol EGPhysicsBody;
@class EGCollisionWorld;
@class TRCarType;
@class EGCollisionBody;
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

@interface TRBaseTrainsCollisionWorld : ATActor {
@private
    NSMutableArray* __trains;
}
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
- (CNFuture*)updateF:(CNFuture*(^)(id<CNImSeq>))f;
- (void)updateMatrixStates:(id<CNImSeq>)states;
+ (ODClassType*)type;
@end


@interface TRTrainsCollisionWorld : TRBaseTrainsCollisionWorld {
@private
    __weak TRLevel* _level;
    EGCollisionWorld* _world;
}
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) EGCollisionWorld* world;

+ (instancetype)trainsCollisionWorldWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (CNFuture*)addTrain:(TRTrain*)train state:(TRTrainState*)state;
- (CNFuture*)detect;
- (CNFuture*)_detectStates:(id<CNImSeq>)states;
+ (ODClassType*)type;
@end


@interface TRCarsCollision : NSObject {
@private
    id<CNSet> _trains;
    TRRailPoint _railPoint;
}
@property (nonatomic, readonly) id<CNSet> trains;
@property (nonatomic, readonly) TRRailPoint railPoint;

+ (instancetype)carsCollisionWithTrains:(id<CNSet>)trains railPoint:(TRRailPoint)railPoint;
- (instancetype)initWithTrains:(id<CNSet>)trains railPoint:(TRRailPoint)railPoint;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRTrainsDynamicWorld : TRBaseTrainsCollisionWorld {
@private
    __weak TRLevel* _level;
    EGDynamicWorld* _world;
    CNNotificationObserver* _cutDownObs;
    NSInteger __workCounter;
    NSMutableArray* __dyingTrains;
}
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) EGDynamicWorld* world;
@property (nonatomic) NSInteger _workCounter;
@property (nonatomic, readonly) NSMutableArray* _dyingTrains;

+ (instancetype)trainsDynamicWorldWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (CNFuture*)addTrees:(id<CNIterable>)trees;
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


