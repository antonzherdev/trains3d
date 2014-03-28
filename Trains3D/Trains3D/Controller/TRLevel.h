#import "objd.h"
#import "GEVec.h"
#import "TRHistory.h"
#import "ATActor.h"
#import "EGScene.h"
#import "EGMapIso.h"
#import "TRRailPoint.h"
@class TRScoreRules;
@class TRWeatherRules;
@class EGImSchedule;
@class TRRailroadState;
@class TRScoreState;
@class ATSlot;
@class TRScore;
@class TRWeather;
@class TRForest;
@class TRRailroad;
@class TRRailroadBuilder;
@class EGMSchedule;
@class TRTrainCollisions;
@class ATSignal;
@class ATVar;
@class EGCounter;
@class EGEmptyCounter;
@class TRTrain;
@class TRCity;
@class TRLiveTrainState;
@class TRDieTrainState;
@class TRCityState;
@class TRTrainType;
@class TRCityAngle;
@class TRRailroadConnectorContent;
@class TRRail;
@class TRStr;
@class TRStrings;
@class TRTrainGenerator;
@class TRCityColor;
@class ATReact;
@class TRSwitch;
@class TRCarsCollision;
@class TRCarType;
@class TRForestRules;
@class TRForestType;
@class ATConcurrentQueue;

@class TRLevelRules;
@class TRLevelState;
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
    TRRewindRules _rewindRules;
    TRWeatherRules* _weatherRules;
    NSUInteger _repairerSpeed;
    NSUInteger _sporadicDamagePeriod;
    id<CNImSeq> _events;
}
@property (nonatomic, readonly) GEVec2i mapSize;
@property (nonatomic, readonly) TRLevelTheme* theme;
@property (nonatomic, readonly) TRScoreRules* scoreRules;
@property (nonatomic, readonly) TRRewindRules rewindRules;
@property (nonatomic, readonly) TRWeatherRules* weatherRules;
@property (nonatomic, readonly) NSUInteger repairerSpeed;
@property (nonatomic, readonly) NSUInteger sporadicDamagePeriod;
@property (nonatomic, readonly) id<CNImSeq> events;

+ (instancetype)levelRulesWithMapSize:(GEVec2i)mapSize theme:(TRLevelTheme*)theme scoreRules:(TRScoreRules*)scoreRules rewindRules:(TRRewindRules)rewindRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(id<CNImSeq>)events;
- (instancetype)initWithMapSize:(GEVec2i)mapSize theme:(TRLevelTheme*)theme scoreRules:(TRScoreRules*)scoreRules rewindRules:(TRRewindRules)rewindRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(id<CNImSeq>)events;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRLevelState : NSObject {
@private
    CGFloat _time;
    unsigned int _seedPosition;
    EGImSchedule* _schedule;
    TRRailroadState* _railroad;
    id<CNImSeq> _cities;
    id<CNImSeq> _trains;
    id<CNImSeq> _dyingTrains;
    TRScoreState* _score;
    id<CNImIterable> _trees;
}
@property (nonatomic, readonly) CGFloat time;
@property (nonatomic, readonly) unsigned int seedPosition;
@property (nonatomic, readonly) EGImSchedule* schedule;
@property (nonatomic, readonly) TRRailroadState* railroad;
@property (nonatomic, readonly) id<CNImSeq> cities;
@property (nonatomic, readonly) id<CNImSeq> trains;
@property (nonatomic, readonly) id<CNImSeq> dyingTrains;
@property (nonatomic, readonly) TRScoreState* score;
@property (nonatomic, readonly) id<CNImIterable> trees;

+ (instancetype)levelStateWithTime:(CGFloat)time seedPosition:(unsigned int)seedPosition schedule:(EGImSchedule*)schedule railroad:(TRRailroadState*)railroad cities:(id<CNImSeq>)cities trains:(id<CNImSeq>)trains dyingTrains:(id<CNImSeq>)dyingTrains score:(TRScoreState*)score trees:(id<CNImIterable>)trees;
- (instancetype)initWithTime:(CGFloat)time seedPosition:(unsigned int)seedPosition schedule:(EGImSchedule*)schedule railroad:(TRRailroadState*)railroad cities:(id<CNImSeq>)cities trains:(id<CNImSeq>)trains dyingTrains:(id<CNImSeq>)dyingTrains score:(TRScoreState*)score trees:(id<CNImIterable>)trees;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRLevel : ATActor<EGController> {
@private
    NSUInteger _number;
    TRLevelRules* _rules;
    ATSlot* _scale;
    ATSlot* _cameraReserves;
    ATSlot* _viewRatio;
    CNSeed* __seed;
    CGFloat __time;
    TRHistory* _history;
    EGMapSso* _map;
    TRNotifications* _notifications;
    TRScore* _score;
    TRWeather* _weather;
    TRForest* _forest;
    TRRailroad* _railroad;
    TRRailroadBuilder* _builder;
    id<CNImSeq> __cities;
    EGMSchedule* __schedule;
    id<CNImSeq> __trains;
    id __repairer;
    TRTrainCollisions* _collisions;
    id<CNImSeq> __dyingTrains;
    CGFloat __timeToNextDamage;
    ATSignal* _trainIsAboutToRun;
    ATSignal* _trainIsExpected;
    ATSignal* _trainWasAdded;
    CGFloat _looseCounter;
    BOOL __resultSent;
    NSUInteger __crashCounter;
    ATSignal* _trainWasRemoved;
    ATVar* _help;
    ATVar* _result;
    BOOL _rate;
    NSInteger _slowMotionShop;
    EGCounter* _slowMotionCounter;
}
@property (nonatomic, readonly) NSUInteger number;
@property (nonatomic, readonly) TRLevelRules* rules;
@property (nonatomic, readonly) ATSlot* scale;
@property (nonatomic, readonly) ATSlot* cameraReserves;
@property (nonatomic, readonly) ATSlot* viewRatio;
@property (nonatomic, readonly) TRHistory* history;
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRNotifications* notifications;
@property (nonatomic, readonly) TRScore* score;
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) TRForest* forest;
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) TRRailroadBuilder* builder;
@property (nonatomic, readonly) TRTrainCollisions* collisions;
@property (nonatomic, readonly) ATSignal* trainIsAboutToRun;
@property (nonatomic, readonly) ATSignal* trainIsExpected;
@property (nonatomic, readonly) ATSignal* trainWasAdded;
@property (nonatomic, readonly) ATSignal* trainWasRemoved;
@property (nonatomic, readonly) ATVar* help;
@property (nonatomic, readonly) ATVar* result;
@property (nonatomic) BOOL rate;
@property (nonatomic) NSInteger slowMotionShop;
@property (nonatomic, retain) EGCounter* slowMotionCounter;

+ (instancetype)levelWithNumber:(NSUInteger)number rules:(TRLevelRules*)rules;
- (instancetype)initWithNumber:(NSUInteger)number rules:(TRLevelRules*)rules;
- (ODClassType*)type;
- (CNFuture*)time;
- (CNFuture*)state;
- (CNFuture*)restoreState:(TRLevelState*)state;
- (id<CNSeq>)cities;
- (CNFuture*)trains;
- (id)repairer;
- (void)_init;
- (CNFuture*)dyingTrains;
- (CNFuture*)scheduleAfter:(CGFloat)after event:(void(^)())event;
- (CNFuture*)create2Cities;
- (CNFuture*)createNewCity;
- (CNFuture*)addTrain:(TRTrain*)train;
- (CNFuture*)runTrainWithGenerator:(TRTrainGenerator*)generator;
- (CNFuture*)testRunTrain:(TRTrain*)train fromPoint:(TRRailPoint)fromPoint;
- (void)updateWithDelta:(CGFloat)delta;
- (CNFuture*)_updateWithDelta:(CGFloat)delta;
- (CNFuture*)tryTurnASwitch:(TRSwitch*)aSwitch;
- (CNFuture*)isLockedTheSwitch:(TRSwitch*)theSwitch;
- (CNFuture*)isLockedRail:(TRRail*)rail;
- (id)cityForTile:(GEVec2i)tile;
- (CNFuture*)possiblyArrivedTrain:(TRTrain*)train tile:(GEVec2i)tile tailX:(CGFloat)tailX;
- (CNFuture*)processCollisions;
- (CNFuture*)processCollision:(TRCarsCollision*)collision;
- (CNFuture*)knockDownTrain:(TRTrain*)train;
- (CNFuture*)addSporadicDamage;
- (CNFuture*)detectCollisions;
- (CNFuture*)destroyTrain:(TRTrain*)train;
- (CNFuture*)runRepairerFromCity:(TRCity*)city;
- (CNFuture*)fixDamageAtPoint:(TRRailPoint)point;
- (void)showHelpText:(NSString*)text;
- (void)clearHelp;
- (void)rewind;
+ (NSInteger)trainComingPeriod;
+ (CNNotificationHandle*)buildCityNotification;
+ (CNNotificationHandle*)crashNotification;
+ (CNNotificationHandle*)knockDownNotification;
+ (CNNotificationHandle*)damageNotification;
+ (CNNotificationHandle*)sporadicDamageNotification;
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


