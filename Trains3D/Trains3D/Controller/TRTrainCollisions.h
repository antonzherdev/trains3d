#import "objd.h"
#import "ATActor.h"
#import "TRRailPoint.h"
#import "GEVec.h"
@class TRLevel;
@class ATObserver;
@class TRForest;
@class ATSignal;
@class TRCity;
@class TRTrain;
@class TRLiveTrainState;
@class TRDieTrainState;
@class TRTree;
@class EGPhysicsWorld;
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
@class GEMat4;
@class TRDieCarState;
@class EGDynamicCollision;

@class TRTrainCollisions;
@class TRBaseTrainsCollisionWorld;
@class TRTrainsCollisionWorld;
@class TRCarsCollision;
@class TRTrainsDynamicWorld;

@interface TRTrainCollisions : ATActor {
@protected
    __weak TRLevel* _level;
    TRTrainsCollisionWorld* _collisionsWorld;
    TRTrainsDynamicWorld* _dynamicWorld;
    NSArray* __trains;
    ATObserver* _cutDownObs;
    ATObserver* _forestRestoredObs;
}
@property (nonatomic, readonly, weak) TRLevel* level;

+ (instancetype)trainCollisionsWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (CNFuture*)addCity:(TRCity*)city;
- (CNFuture*)removeCity:(TRCity*)city;
- (CNFuture*)removeTrain:(TRTrain*)train;
- (CNFuture*)addTrain:(TRTrain*)train state:(TRLiveTrainState*)state;
- (CNFuture*)addTrain:(TRTrain*)train;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (CNFuture*)detect;
- (CNFuture*)dieTrain:(TRTrain*)train liveState:(TRLiveTrainState*)liveState wasCollision:(BOOL)wasCollision;
- (CNFuture*)dieTrain:(TRTrain*)train dieState:(TRDieTrainState*)dieState;
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
- (void)updateWithStates:(NSArray*)states delta:(CGFloat)delta;
- (void)updateMatrixStates:(NSArray*)states;
+ (ODClassType*)type;
@end


@interface TRTrainsCollisionWorld : TRBaseTrainsCollisionWorld {
@protected
    __weak TRLevel* _level;
    EGCollisionWorld* _world;
}
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) EGCollisionWorld* world;

+ (instancetype)trainsCollisionWorldWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)addTrain:(TRTrain*)train state:(TRTrainState*)state;
- (void)updateWithStates:(NSArray*)states delta:(CGFloat)delta;
- (NSArray*)detectStates:(NSArray*)states;
+ (ODClassType*)type;
@end


@interface TRCarsCollision : NSObject {
@protected
    NSArray* _trains;
    TRRailPoint _railPoint;
}
@property (nonatomic, readonly) NSArray* trains;
@property (nonatomic, readonly) TRRailPoint railPoint;

+ (instancetype)carsCollisionWithTrains:(NSArray*)trains railPoint:(TRRailPoint)railPoint;
- (instancetype)initWithTrains:(NSArray*)trains railPoint:(TRRailPoint)railPoint;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRTrainsDynamicWorld : TRBaseTrainsCollisionWorld {
@protected
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
- (void)restoreTrees:(id<CNIterable>)trees;
- (void)cutDownTree:(TRTree*)tree;
- (void)addCity:(TRCity*)city;
- (void)addTrain:(TRTrain*)train state:(TRTrainState*)state;
- (void)dieTrain:(TRTrain*)train liveState:(TRLiveTrainState*)liveState wasCollision:(BOOL)wasCollision;
- (void)dieTrain:(TRTrain*)train dieState:(TRDieTrainState*)dieState;
- (void)removeCity:(TRCity*)city;
- (void)removeTrain:(TRTrain*)train;
- (void)updateWithStates:(NSArray*)states delta:(CGFloat)delta;
+ (CNNotificationHandle*)carsCollisionNotification;
+ (CNNotificationHandle*)carAndGroundCollisionNotification;
+ (ODClassType*)type;
@end


