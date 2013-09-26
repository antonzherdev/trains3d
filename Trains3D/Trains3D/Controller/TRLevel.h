#import "objd.h"
#import "GEVec.h"
#import "EGScene.h"
@class TRScoreRules;
@class EGMapSso;
@class TRNotifications;
@class TRScore;
@class TRRailroad;
@class EGSchedule;
@class TRTrainsCollisionWorld;
@class TRTrainsDynamicWorld;
@class TRCity;
@class TRCityAngle;
@class TRRail;
@class TRTrain;
@class EGCounter;
@class TRTrainGenerator;
@class TRRailPoint;
@class TRSwitch;
@class TRCarsCollision;
@class TRCar;
@class TRTrainType;
@class TRCityColor;
@class TRCarType;

@class TRLevelRules;
@class TRLevel;
@class TRTree;

@interface TRLevelRules : NSObject
@property (nonatomic, readonly) GEVec2i mapSize;
@property (nonatomic, readonly) TRScoreRules* scoreRules;
@property (nonatomic, readonly) NSUInteger repairerSpeed;
@property (nonatomic, readonly) id<CNSeq> events;

+ (id)levelRulesWithMapSize:(GEVec2i)mapSize scoreRules:(TRScoreRules*)scoreRules repairerSpeed:(NSUInteger)repairerSpeed events:(id<CNSeq>)events;
- (id)initWithMapSize:(GEVec2i)mapSize scoreRules:(TRScoreRules*)scoreRules repairerSpeed:(NSUInteger)repairerSpeed events:(id<CNSeq>)events;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRLevel : NSObject<EGController>
@property (nonatomic, readonly) TRLevelRules* rules;
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRNotifications* notifications;
@property (nonatomic, readonly) TRScore* score;
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) EGSchedule* schedule;
@property (nonatomic, readonly) TRTrainsCollisionWorld* collisionWorld;
@property (nonatomic, readonly) TRTrainsDynamicWorld* dynamicWorld;

+ (id)levelWithRules:(TRLevelRules*)rules;
- (id)initWithRules:(TRLevelRules*)rules;
- (ODClassType*)type;
- (id<CNSeq>)cities;
- (id<CNSeq>)trains;
- (id)repairer;
- (id<CNSeq>)dyingTrains;
- (void)createNewCity;
- (void)runTrainWithGenerator:(TRTrainGenerator*)generator;
- (void)testRunTrain:(TRTrain*)train fromPoint:(TRRailPoint*)fromPoint;
- (void)updateWithDelta:(CGFloat)delta;
- (void)tryTurnTheSwitch:(TRSwitch*)theSwitch;
- (id)cityForTile:(GEVec2i)tile;
- (void)arrivedTrain:(TRTrain*)train;
- (void)processCollisions;
- (id<CNSeq>)detectCollisions;
- (void)destroyTrain:(TRTrain*)train;
- (void)removeTrain:(TRTrain*)train;
- (void)runRepairerFromCity:(TRCity*)city;
+ (ODClassType*)type;
@end


@interface TRTree : NSObject
@property (nonatomic, readonly) GEVec2 position;

+ (id)treeWithPosition:(GEVec2)position;
- (id)initWithPosition:(GEVec2)position;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


