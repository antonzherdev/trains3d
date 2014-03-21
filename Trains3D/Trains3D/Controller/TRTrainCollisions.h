#import "objd.h"
#import "ATActor.h"
#import "TRRailPoint.h"
#import "GEVec.h"
@class TRLevel;
@class TRForest;
@class TRCity;
@class TRTrain;
@class TRTrainState;
@class TRTree;
@class EGPhysicsWorld;
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
@class TRLiveTrainState;
@class GEMat4;
@class TRDieCarState;
@class EGDynamicCollision;

@class TRTrainCollisions;
@class TRBaseTrainsCollisionWorld;
@class TRTrainsCollisionWorld;
@class TRCarsCollision;
@class TRTrainsDynamicWorld;

@interface TRTrainCollisions : ATActor {
@private
    __weak TRLevel* _level;
    TRTrainsCollisionWorld* _collisionsWorld;
    TRTrainsDynamicWorld* _dynamicWorld;
    id<CNImSeq> __trains;
    CNNotificationObserver* _cutDownObs;
}
@property (nonatomic, readonly, weak) TRLevel* level;

+ (instancetype)trainCollisionsWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (CNFuture*)addCity:(TRCity*)city;
- (CNFuture*)removeTrain:(TRTrain*)train;
- (CNFuture*)addTrain:(TRTrain*)train;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (CNFuture*)detect;
- (CNFuture*)dieTrain:(TRTrain*)train;
- (void)_init;
+ (ODClassType*)type;
@end


@interface TRBaseTrainsCollisionWorld : NSObject
+ (instancetype)baseTrainsCollisionWorld;
- (instancetype)init;
- (ODClassType*)type;
- (EGPhysicsWorld*)world;
- (TRLevel*)level;
- (void)addTrain:(TRTrain*)train state:(TRTrainState*)state;
- (void)removeTrain:(TRTrain*)train;
- (void)updateWithStates:(id<CNImSeq>)states delta:(CGFloat)delta;
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
- (void)addTrain:(TRTrain*)train state:(TRTrainState*)state;
- (void)updateWithStates:(id<CNImSeq>)states delta:(CGFloat)delta;
- (id<CNImSeq>)detectStates:(id<CNImSeq>)states;
+ (ODClassType*)type;
@end


@interface TRCarsCollision : NSObject {
@private
    id<CNImSeq> _trains;
    TRRailPoint _railPoint;
}
@property (nonatomic, readonly) id<CNImSeq> trains;
@property (nonatomic, readonly) TRRailPoint railPoint;

+ (instancetype)carsCollisionWithTrains:(id<CNImSeq>)trains railPoint:(TRRailPoint)railPoint;
- (instancetype)initWithTrains:(id<CNImSeq>)trains railPoint:(TRRailPoint)railPoint;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRTrainsDynamicWorld : TRBaseTrainsCollisionWorld {
@private
    __weak TRLevel* _level;
    EGDynamicWorld* _world;
    NSInteger __workCounter;
    NSMutableArray* __dyingTrains;
}
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) EGDynamicWorld* world;

+ (instancetype)trainsDynamicWorldWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)_init;
- (void)addTrees:(id<CNIterable>)trees;
- (void)cutDownTree:(TRTree*)tree;
- (void)addCity:(TRCity*)city;
- (void)addTrain:(TRTrain*)train state:(TRTrainState*)state;
- (void)dieTrain:(TRTrain*)train state:(TRLiveTrainState*)state;
- (void)removeTrain:(TRTrain*)train;
- (void)updateWithStates:(id<CNImSeq>)states delta:(CGFloat)delta;
+ (CNNotificationHandle*)carsCollisionNotification;
+ (CNNotificationHandle*)carAndGroundCollisionNotification;
+ (ODClassType*)type;
@end


