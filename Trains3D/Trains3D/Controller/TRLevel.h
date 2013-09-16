#import "objd.h"
#import "GEVec.h"
#import "EGTypes.h"
#import "GERect.h"
@class TRScoreRules;
@class EGMapSso;
@class TRScore;
@class TRRailroad;
@class EGSchedule;
@class TRCollisionWorld;
@class TRDynamicWorld;
@class TRCity;
@class TRCityAngle;
@class TRRail;
@class TRTrain;
@class EGAnimation;
@class TRTrainGenerator;
@class TRRailPoint;
@class TRSwitch;
@class TRCollision;
@class TRCar;
@class TRTrainType;
@class TRColor;
@class TRCarType;

@class TRLevelRules;
@class TRLevel;

@interface TRLevelRules : NSObject
@property (nonatomic, readonly) GEVec2i mapSize;
@property (nonatomic, readonly) TRScoreRules* scoreRules;
@property (nonatomic, readonly) NSUInteger repairerSpeed;
@property (nonatomic, readonly) id<CNSeq> events;

+ (id)levelRulesWithMapSize:(GEVec2i)mapSize scoreRules:(TRScoreRules*)scoreRules repairerSpeed:(NSUInteger)repairerSpeed events:(id<CNSeq>)events;
- (id)initWithMapSize:(GEVec2i)mapSize scoreRules:(TRScoreRules*)scoreRules repairerSpeed:(NSUInteger)repairerSpeed events:(id<CNSeq>)events;
- (ODClassType*)type;
+ (ODType*)type;
@end


@interface TRLevel : NSObject<EGController>
@property (nonatomic, readonly) TRLevelRules* rules;
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRScore* score;
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) EGSchedule* schedule;
@property (nonatomic, readonly) TRCollisionWorld* collisionWorld;
@property (nonatomic, readonly) TRDynamicWorld* dynamicWorld;

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
+ (ODType*)type;
@end


