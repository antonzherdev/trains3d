#import "objd.h"
#import "GEVec.h"
#import "EGScene.h"
#import "EGMapIso.h"
#import "TRRailPoint.h"
@class TRScoreRules;
@class TRWeatherRules;
@class TRNotifications;
@class TRScore;
@class TRWeather;
@class TRForest;
@class TRRailroad;
@class TRRailroadBuilder;
@class EGSchedule;
@class TRTrainsCollisionWorld;
@class TRTrainsDynamicWorld;
@class EGCounter;
@class EGEmptyCounter;
@class TRCity;
@class TRCityAngle;
@class TRRailroadConnectorContent;
@class TRRail;
@class TRStr;
@class TRStrings;
@class TRTrain;
@class TRTrainGenerator;
@class TRTrainType;
@class TRCityColor;
@class TRSwitch;
@class TRCarsCollision;
@class TRCar;
@class TRCarType;
@class TRForestRules;
@class TRForestType;

@class TRLevelRules;
@class TRLevel;
@class TRHelp;
@class TRLevelResult;
@class TRLevelTheme;

@interface TRLevelRules : NSObject
@property (nonatomic, readonly) GEVec2i mapSize;
@property (nonatomic, readonly) TRLevelTheme* theme;
@property (nonatomic, readonly) TRScoreRules* scoreRules;
@property (nonatomic, readonly) TRWeatherRules* weatherRules;
@property (nonatomic, readonly) NSUInteger repairerSpeed;
@property (nonatomic, readonly) NSUInteger sporadicDamagePeriod;
@property (nonatomic, readonly) id<CNSeq> events;

+ (id)levelRulesWithMapSize:(GEVec2i)mapSize theme:(TRLevelTheme*)theme scoreRules:(TRScoreRules*)scoreRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(id<CNSeq>)events;
- (id)initWithMapSize:(GEVec2i)mapSize theme:(TRLevelTheme*)theme scoreRules:(TRScoreRules*)scoreRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(id<CNSeq>)events;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRLevel : NSObject<EGController>
@property (nonatomic, readonly) NSUInteger number;
@property (nonatomic, readonly) TRLevelRules* rules;
@property (nonatomic) CGFloat scale;
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRNotifications* notifications;
@property (nonatomic, readonly) TRScore* score;
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) TRForest* forest;
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) TRRailroadBuilder* builder;
@property (nonatomic, readonly) EGSchedule* schedule;
@property (nonatomic, readonly) TRTrainsCollisionWorld* collisionWorld;
@property (nonatomic) BOOL rate;
@property (nonatomic) NSInteger slowMotionShop;
@property (nonatomic, retain) EGCounter* slowMotionCounter;

+ (id)levelWithNumber:(NSUInteger)number rules:(TRLevelRules*)rules;
- (id)initWithNumber:(NSUInteger)number rules:(TRLevelRules*)rules;
- (ODClassType*)type;
- (TRTrainsDynamicWorld*)dynamicWorld;
- (id<CNSeq>)cities;
- (id<CNSeq>)trains;
- (id)repairer;
- (void)_init;
- (id<CNSeq>)dyingTrains;
- (void)create2Cities;
- (TRCity*)createNewCity;
- (BOOL)hasCityInTile:(GEVec2i)tile;
- (TRCity*)createCityWithTile:(GEVec2i)tile direction:(TRCityAngle*)direction;
- (void)runTrainWithGenerator:(TRTrainGenerator*)generator;
- (void)testRunTrain:(TRTrain*)train fromPoint:(TRRailPoint)fromPoint;
- (void)updateWithDelta:(CGFloat)delta;
- (void)tryTurnTheSwitch:(TRSwitch*)theSwitch;
- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch;
- (BOOL)isLockedRail:(TRRail*)rail;
- (id)cityForTile:(GEVec2i)tile;
- (void)arrivedTrain:(TRTrain*)train;
- (void)processCollisions;
- (void)knockDownTrain:(TRTrain*)train;
- (void)addSporadicDamage;
- (id<CNSeq>)detectCollisions;
- (void)destroyTrain:(TRTrain*)train;
- (void)removeTrain:(TRTrain*)train;
- (void)runRepairerFromCity:(TRCity*)city;
- (void)fixDamageAtPoint:(TRRailPoint)point;
- (id)help;
- (void)showHelpText:(NSString*)text;
- (void)clearHelp;
- (id)result;
- (void)win;
- (void)lose;
+ (NSInteger)trainComingPeriod;
+ (CNNotificationHandle*)buildCityNotification;
+ (CNNotificationHandle*)prepareToRunTrainNotification;
+ (CNNotificationHandle*)expectedTrainNotification;
+ (CNNotificationHandle*)runTrainNotification;
+ (CNNotificationHandle*)crashNotification;
+ (CNNotificationHandle*)knockDownNotification;
+ (CNNotificationHandle*)damageNotification;
+ (CNNotificationHandle*)sporadicDamageNotification;
+ (CNNotificationHandle*)runRepairerNotification;
+ (CNNotificationHandle*)fixDamageNotification;
+ (CNNotificationHandle*)winNotification;
+ (ODClassType*)type;
@end


@interface TRHelp : NSObject
@property (nonatomic, readonly) NSString* text;

+ (id)helpWithText:(NSString*)text;
- (id)initWithText:(NSString*)text;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRLevelResult : NSObject
@property (nonatomic, readonly) BOOL win;

+ (id)levelResultWithWin:(BOOL)win;
- (id)initWithWin:(BOOL)win;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRLevelTheme : ODEnum
@property (nonatomic, readonly) NSString* background;
@property (nonatomic, readonly) TRForestRules* forestRules;
@property (nonatomic, readonly) BOOL dark;

+ (TRLevelTheme*)forest;
+ (TRLevelTheme*)winter;
+ (TRLevelTheme*)leafForest;
+ (TRLevelTheme*)palm;
+ (NSArray*)values;
@end


