#import "objd.h"
#import "EGTypes.h"
@class EGMapSso;
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
#import "TRRailPoint.h"
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

+ (id)levelRulesWithMapSize:(EGSizeI)mapSize scoreRules:(TRScoreRules*)scoreRules;
- (id)initWithMapSize:(EGSizeI)mapSize scoreRules:(TRScoreRules*)scoreRules;
@end


@interface TRLevel : NSObject<EGController>
@property (nonatomic, readonly) TRLevelRules* rules;
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRScore* score;
@property (nonatomic, readonly) TRRailroad* railroad;

+ (id)levelWithRules:(TRLevelRules*)rules;
- (id)initWithRules:(TRLevelRules*)rules;
- (NSArray*)cities;
- (NSArray*)trains;
- (void)createNewCity;
- (void)runSample;
- (void)updateWithDelta:(double)delta;
- (void)tryTurnTheSwitch:(TRSwitch*)theSwitch;
@end


