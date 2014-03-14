#import "objd.h"
#import "GEVec.h"
#import "ATActor.h"
#import "EGScene.h"
#import "EGMapIso.h"
#import "TRRailPoint.h"
@class TRScoreRules;
@class TRWeatherRules;
@class ATVar;
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
@class TRRailroadState;
@class TRCityAngle;
@class TRRailroadConnectorContent;
@class TRRail;
@class TRStr;
@class TRStrings;
@class TRTrain;
@class TRTrainGenerator;
@class TRTrainType;
@class TRCityColor;
@class ATReact;
@class TRSwitch;
@class TRCarsCollision;
@class TRCarType;
@class TRForestRules;
@class TRForestType;
@class ATConcurrentQueue;

@class TRLevelRules;
@class TRLevel;
@class TRHelp;
@class TRLevelResult;
@class TRNotifications;
@class TRLevelTheme;

@interface TRLevelRules : NSObject {
@private
    GEVec2i _mapSize;
    TRLevelTheme* _theme;
    TRScoreRules* _scoreRules;
    TRWeatherRules* _weatherRules;
    NSUInteger _repairerSpeed;
    NSUInteger _sporadicDamagePeriod;
    id<CNImSeq> _events;
}
@property (nonatomic, readonly) GEVec2i mapSize;
@property (nonatomic, readonly) TRLevelTheme* theme;
@property (nonatomic, readonly) TRScoreRules* scoreRules;
@property (nonatomic, readonly) TRWeatherRules* weatherRules;
@property (nonatomic, readonly) NSUInteger repairerSpeed;
@property (nonatomic, readonly) NSUInteger sporadicDamagePeriod;
@property (nonatomic, readonly) id<CNImSeq> events;

+ (instancetype)levelRulesWithMapSize:(GEVec2i)mapSize theme:(TRLevelTheme*)theme scoreRules:(TRScoreRules*)scoreRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(id<CNImSeq>)events;
- (instancetype)initWithMapSize:(GEVec2i)mapSize theme:(TRLevelTheme*)theme scoreRules:(TRScoreRules*)scoreRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(id<CNImSeq>)events;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRLevel : ATActor<EGController> {
@private
    NSUInteger _number;
    TRLevelRules* _rules;
    ATVar* _scale;
    EGMapSso* _map;
    TRNotifications* _notifications;
    TRScore* _score;
    TRWeather* _weather;
    TRForest* _forest;
    TRRailroad* _railroad;
    TRRailroadBuilder* _builder;
    id<CNImSeq> __cities;
    EGSchedule* __schedule;
    id<CNImSeq> __trains;
    id __repairer;
    TRTrainsCollisionWorld* _collisionWorld;
    TRTrainsDynamicWorld* _dynamicWorld;
    NSMutableArray* __dyingTrains;
    CGFloat __timeToNextDamage;
    CGFloat _looseCounter;
    BOOL __resultSent;
    NSUInteger __crashCounter;
    ATVar* _help;
    ATVar* _result;
    BOOL _rate;
    NSInteger _slowMotionShop;
    EGCounter* _slowMotionCounter;
}
@property (nonatomic, readonly) NSUInteger number;
@property (nonatomic, readonly) TRLevelRules* rules;
@property (nonatomic, readonly) ATVar* scale;
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRNotifications* notifications;
@property (nonatomic, readonly) TRScore* score;
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) TRForest* forest;
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) TRRailroadBuilder* builder;
@property (nonatomic, readonly) TRTrainsCollisionWorld* collisionWorld;
@property (nonatomic, readonly) TRTrainsDynamicWorld* dynamicWorld;
@property (nonatomic, readonly) ATVar* help;
@property (nonatomic, readonly) ATVar* result;
@property (nonatomic) BOOL rate;
@property (nonatomic) NSInteger slowMotionShop;
@property (nonatomic, retain) EGCounter* slowMotionCounter;

+ (instancetype)levelWithNumber:(NSUInteger)number rules:(TRLevelRules*)rules;
- (instancetype)initWithNumber:(NSUInteger)number rules:(TRLevelRules*)rules;
- (ODClassType*)type;
- (id<CNSeq>)cities;
- (CNFuture*)trains;
- (id)repairer;
- (void)_init;
- (CNFuture*)dyingTrains;
- (CNFuture*)scheduleAfter:(CGFloat)after event:(void(^)())event;
- (CNFuture*)create2Cities;
- (CNFuture*)createNewCity;
- (CNFuture*)runTrainWithGenerator:(TRTrainGenerator*)generator;
- (CNFuture*)testRunTrain:(TRTrain*)train fromPoint:(TRRailPoint)fromPoint;
- (void)updateWithDelta:(CGFloat)delta;
- (void)tryTurnASwitch:(TRSwitch*)aSwitch;
- (CNFuture*)isLockedTheSwitch:(TRSwitch*)theSwitch;
- (CNFuture*)isLockedRail:(TRRail*)rail;
- (id)cityForTile:(GEVec2i)tile;
- (CNFuture*)arrivedTrain:(TRTrain*)train;
- (CNFuture*)processCollisions;
- (CNFuture*)knockDownTrain:(TRTrain*)train;
- (CNFuture*)addSporadicDamage;
- (CNFuture*)detectCollisions;
- (CNFuture*)destroyTrain:(TRTrain*)train;
- (CNFuture*)runRepairerFromCity:(TRCity*)city;
- (CNFuture*)fixDamageAtPoint:(TRRailPoint)point;
- (void)showHelpText:(NSString*)text;
- (void)clearHelp;
+ (NSInteger)trainComingPeriod;
+ (CNNotificationHandle*)buildCityNotification;
+ (CNNotificationHandle*)prepareToRunTrainNotification;
+ (CNNotificationHandle*)expectedTrainNotification;
+ (CNNotificationHandle*)runTrainNotification;
+ (CNNotificationHandle*)crashNotification;
+ (CNNotificationHandle*)knockDownNotification;
+ (CNNotificationHandle*)damageNotification;
+ (CNNotificationHandle*)sporadicDamageNotification;
+ (CNNotificationHandle*)removeTrainNotification;
+ (CNNotificationHandle*)runRepairerNotification;
+ (CNNotificationHandle*)fixDamageNotification;
+ (CNNotificationHandle*)winNotification;
+ (ODClassType*)type;
@end


@interface TRHelp : NSObject {
@private
    NSString* _text;
}
@property (nonatomic, readonly) NSString* text;

+ (instancetype)helpWithText:(NSString*)text;
- (instancetype)initWithText:(NSString*)text;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRLevelResult : NSObject {
@private
    BOOL _win;
}
@property (nonatomic, readonly) BOOL win;

+ (instancetype)levelResultWithWin:(BOOL)win;
- (instancetype)initWithWin:(BOOL)win;
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


@interface TRNotifications : NSObject {
@private
    ATConcurrentQueue* _queue;
}
+ (instancetype)notifications;
- (instancetype)init;
- (ODClassType*)type;
- (void)notifyNotification:(NSString*)notification;
- (BOOL)isEmpty;
- (id)take;
+ (ODClassType*)type;
@end


