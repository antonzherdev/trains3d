#import "objd.h"
@class CNChain;
#import "CNSet.h"
#import "EGTypes.h"
@class EGMapSso;
@class EGCollisions;
@class EGCollision;
@class EGSchedule;
@class TRCityAngle;
@class TRCity;
@class TRColor;
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRRailroad;
@class TRRailroadBuilder;
@class TRRailConnector;
@class TRRailForm;
@class TRRailPoint;
@class TRRailPointCorrection;
@class TRTrain;
@class TRCar;
@class TRScoreRules;
@class TRScore;
@class TRTrainScore;

@class TRLevelRules;
@class TRLevel;

@interface TRLevelRules : NSObject
@property (nonatomic, readonly) EGSizeI mapSize;
@property (nonatomic, readonly) TRScoreRules* scoreRules;
@property (nonatomic, readonly) NSArray* events;

+ (id)levelRulesWithMapSize:(EGSizeI)mapSize scoreRules:(TRScoreRules*)scoreRules events:(NSArray*)events;
- (id)initWithMapSize:(EGSizeI)mapSize scoreRules:(TRScoreRules*)scoreRules events:(NSArray*)events;
@end


@interface TRLevel : NSObject<EGController>
@property (nonatomic, readonly) TRLevelRules* rules;
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRScore* score;
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) EGSchedule* schedule;

+ (id)levelWithRules:(TRLevelRules*)rules;
- (id)initWithRules:(TRLevelRules*)rules;
- (NSArray*)cities;
- (NSArray*)trains;
- (void)testRunTrain:(TRTrain*)train fromPoint:(TRRailPoint*)fromPoint;
- (void)runSample;
- (void)updateWithDelta:(double)delta;
- (void)tryTurnTheSwitch:(TRSwitch*)theSwitch;
- (id)cityForTile:(EGPointI)tile;
- (void)arrivedTrain:(TRTrain*)train;
- (NSSet*)detectCollisions;
- (void)destroyTrain:(TRTrain*)train;
@end


