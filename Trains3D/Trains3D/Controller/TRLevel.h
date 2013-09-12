#import "objd.h"
#import "EGVec.h"
#import "EGTypes.h"
@class TRScoreRules;
@class EGMapSso;
@class TRScore;
@class TRRailroad;
@class EGSchedule;
@class TRCollisionWorld;
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
@property (nonatomic, readonly) EGVec2I mapSize;
@property (nonatomic, readonly) TRScoreRules* scoreRules;
@property (nonatomic, readonly) NSUInteger repairerSpeed;
@property (nonatomic, readonly) id<CNSeq> events;

+ (id)levelRulesWithMapSize:(EGVec2I)mapSize scoreRules:(TRScoreRules*)scoreRules repairerSpeed:(NSUInteger)repairerSpeed events:(id<CNSeq>)events;
- (id)initWithMapSize:(EGVec2I)mapSize scoreRules:(TRScoreRules*)scoreRules repairerSpeed:(NSUInteger)repairerSpeed events:(id<CNSeq>)events;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRLevel : NSObject<EGController>
@property (nonatomic, readonly) TRLevelRules* rules;
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRScore* score;
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) EGSchedule* schedule;
@property (nonatomic, readonly) TRCollisionWorld* collisionWorld;

+ (id)levelWithRules:(TRLevelRules*)rules;
- (id)initWithRules:(TRLevelRules*)rules;
- (ODClassType*)type;
- (id<CNSeq>)cities;
- (id<CNSeq>)trains;
- (id)repairer;
- (void)createNewCity;
- (void)runTrainWithGenerator:(TRTrainGenerator*)generator;
- (void)testRunTrain:(TRTrain*)train fromPoint:(TRRailPoint*)fromPoint;
- (void)updateWithDelta:(CGFloat)delta;
- (void)tryTurnTheSwitch:(TRSwitch*)theSwitch;
- (id)cityForTile:(EGVec2I)tile;
- (void)arrivedTrain:(TRTrain*)train;
- (void)processCollisions;
- (id<CNSeq>)detectCollisions;
- (void)destroyTrain:(TRTrain*)train;
- (void)removeTrain:(TRTrain*)train;
- (void)runRepairerFromCity:(TRCity*)city;
+ (ODClassType*)type;
@end


