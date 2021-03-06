#import "objd.h"
#import "CNActor.h"
#import "TRCar.h"
#import "TRRailPoint.h"
#import "PGVec.h"
@class TRLevel;
@class CNObserver;
@class TRForest;
@class CNSignal;
@class CNFuture;
@class TRCity;
@class TRTrain;
@class TRLiveTrainState;
@class CNChain;
@class TRDieTrainState;
@class TRTree;
@class PGPhysicsWorld;
@class TRTrainState;
@protocol PGPhysicsBody;
@class PGCollisionWorld;
@class PGCollisionBody;
@class PGCollision;
@class CNSortBuilder;
@class PGContact;
@class PGMapSso;
@class PGDynamicWorld;
@class PGCollisionPlane;
@class PGRigidBody;
@class PGMat4;
@class PGDynamicCollision;

@class TRTrainCollisions;
@class TRBaseTrainsCollisionWorld;
@class TRTrainsCollisionWorld;
@class TRCarsCollision;
@class TRTrainsDynamicWorld;

@interface TRTrainCollisions : CNActor {
@public
    __weak TRLevel* _level;
    TRTrainsCollisionWorld* _collisionsWorld;
    TRTrainsDynamicWorld* _dynamicWorld;
    NSArray* __trains;
    CNObserver* _cutDownObs;
    CNObserver* _forestRestoredObs;
}
@property (nonatomic, readonly, weak) TRLevel* level;

+ (instancetype)trainCollisionsWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
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
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRBaseTrainsCollisionWorld : NSObject
+ (instancetype)baseTrainsCollisionWorld;
- (instancetype)init;
- (CNClassType*)type;
- (PGPhysicsWorld*)world;
- (TRLevel*)level;
- (void)addTrain:(TRTrain*)train state:(TRTrainState*)state;
- (void)removeTrain:(TRTrain*)train;
- (void)updateWithStates:(NSArray*)states delta:(CGFloat)delta;
- (void)updateMatrixStates:(NSArray*)states;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRTrainsCollisionWorld : TRBaseTrainsCollisionWorld {
@public
    __weak TRLevel* _level;
    PGCollisionWorld* _world;
}
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) PGCollisionWorld* world;

+ (instancetype)trainsCollisionWorldWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (void)addTrain:(TRTrain*)train state:(TRTrainState*)state;
- (void)updateWithStates:(NSArray*)states delta:(CGFloat)delta;
- (NSArray*)detectStates:(NSArray*)states;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRCarsCollision : NSObject {
@public
    NSArray* _trains;
    TRRailPoint _railPoint;
}
@property (nonatomic, readonly) NSArray* trains;
@property (nonatomic, readonly) TRRailPoint railPoint;

+ (instancetype)carsCollisionWithTrains:(NSArray*)trains railPoint:(TRRailPoint)railPoint;
- (instancetype)initWithTrains:(NSArray*)trains railPoint:(TRRailPoint)railPoint;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRTrainsDynamicWorld : TRBaseTrainsCollisionWorld {
@public
    __weak TRLevel* _level;
    PGDynamicWorld* _world;
    NSInteger __workCounter;
    CNMArray* __dyingTrains;
}
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) PGDynamicWorld* world;

+ (instancetype)trainsDynamicWorldWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
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
- (NSString*)description;
+ (CNSignal*)carsCollision;
+ (CNSignal*)carAndGroundCollision;
+ (CNClassType*)type;
@end


