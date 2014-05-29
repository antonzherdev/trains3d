#import "objd.h"
#import "GEVec.h"
#import "TRHistory.h"
#import "CNActor.h"
#import "EGController.h"
#import "EGMapIso.h"
#import "TRCity.h"
#import "TRRailPoint.h"
#import "TRTrain.h"
#import "TRCar.h"
#import "TRTree.h"
@class TRScoreRules;
@class TRWeatherRules;
@class EGImSchedule;
@class TRRailroadState;
@class TRRailroadBuilderState;
@class TRScoreState;
@class EGCounter;
@class CNVar;
@class CNSignal;
@class CNSlot;
@class TRScore;
@class TRWeather;
@class TRRailroad;
@class TRRailroadBuilder;
@class EGMSchedule;
@class CNFuture;
@class TRTrainCollisions;
@class EGEmptyCounter;
@class CNChain;
@class TRRailroadConnectorContent;
@class TRRail;
@class TRStr;
@class TRStrings;
@class CNReact;
@class TRSwitch;
@class TRCarsCollision;
@class CNConcurrentQueue;

@class TRLevelRules;
@class TRLevelState;
@class TRRewindButton;
@class TRLevel;
@class TRHelp;
@class TRLevelResult;
@class TRNotifications;
@class TRLevelTheme;

typedef enum TRLevelThemeR {
    TRLevelTheme_Nil = 0,
    TRLevelTheme_forest = 1,
    TRLevelTheme_winter = 2,
    TRLevelTheme_leafForest = 3,
    TRLevelTheme_palm = 4
} TRLevelThemeR;
@interface TRLevelTheme : CNEnum
@property (nonatomic, readonly) NSString* background;
@property (nonatomic, readonly) TRForestRules* forestRules;

+ (NSArray*)values;
@end
static TRLevelTheme* TRLevelTheme_Values[5];
static TRLevelTheme* TRLevelTheme_forest_Desc;
static TRLevelTheme* TRLevelTheme_winter_Desc;
static TRLevelTheme* TRLevelTheme_leafForest_Desc;
static TRLevelTheme* TRLevelTheme_palm_Desc;


@interface TRLevelRules : NSObject {
@protected
    GEVec2i _mapSize;
    TRLevelThemeR _theme;
    NSUInteger _trainComingPeriod;
    TRScoreRules* _scoreRules;
    TRRewindRules _rewindRules;
    TRWeatherRules* _weatherRules;
    NSUInteger _repairerSpeed;
    NSUInteger _sporadicDamagePeriod;
    NSArray* _events;
}
@property (nonatomic, readonly) GEVec2i mapSize;
@property (nonatomic, readonly) TRLevelThemeR theme;
@property (nonatomic, readonly) NSUInteger trainComingPeriod;
@property (nonatomic, readonly) TRScoreRules* scoreRules;
@property (nonatomic, readonly) TRRewindRules rewindRules;
@property (nonatomic, readonly) TRWeatherRules* weatherRules;
@property (nonatomic, readonly) NSUInteger repairerSpeed;
@property (nonatomic, readonly) NSUInteger sporadicDamagePeriod;
@property (nonatomic, readonly) NSArray* events;

+ (instancetype)levelRulesWithMapSize:(GEVec2i)mapSize theme:(TRLevelThemeR)theme trainComingPeriod:(NSUInteger)trainComingPeriod scoreRules:(TRScoreRules*)scoreRules rewindRules:(TRRewindRules)rewindRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(NSArray*)events;
- (instancetype)initWithMapSize:(GEVec2i)mapSize theme:(TRLevelThemeR)theme trainComingPeriod:(NSUInteger)trainComingPeriod scoreRules:(TRScoreRules*)scoreRules rewindRules:(TRRewindRules)rewindRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(NSArray*)events;
- (CNClassType*)type;
+ (TRLevelRules*)aDefault;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRLevelState : NSObject {
@protected
    CGFloat _time;
    unsigned int _seedPosition;
    EGImSchedule* _schedule;
    TRRailroadState* _railroad;
    TRRailroadBuilderState* _builderState;
    NSArray* _cities;
    NSArray* _trains;
    NSArray* _dyingTrains;
    TRTrain* _repairer;
    TRScoreState* _score;
    NSArray* _trees;
    CGFloat _timeToNextDamage;
    NSArray* _generators;
    CNFuture*(^_scheduleAwait)(TRLevel*);
}
@property (nonatomic, readonly) CGFloat time;
@property (nonatomic, readonly) unsigned int seedPosition;
@property (nonatomic, readonly) EGImSchedule* schedule;
@property (nonatomic, readonly) TRRailroadState* railroad;
@property (nonatomic, readonly) TRRailroadBuilderState* builderState;
@property (nonatomic, readonly) NSArray* cities;
@property (nonatomic, readonly) NSArray* trains;
@property (nonatomic, readonly) NSArray* dyingTrains;
@property (nonatomic, readonly) TRTrain* repairer;
@property (nonatomic, readonly) TRScoreState* score;
@property (nonatomic, readonly) NSArray* trees;
@property (nonatomic, readonly) CGFloat timeToNextDamage;
@property (nonatomic, readonly) NSArray* generators;
@property (nonatomic, readonly) CNFuture*(^scheduleAwait)(TRLevel*);

+ (instancetype)levelStateWithTime:(CGFloat)time seedPosition:(unsigned int)seedPosition schedule:(EGImSchedule*)schedule railroad:(TRRailroadState*)railroad builderState:(TRRailroadBuilderState*)builderState cities:(NSArray*)cities trains:(NSArray*)trains dyingTrains:(NSArray*)dyingTrains repairer:(TRTrain*)repairer score:(TRScoreState*)score trees:(NSArray*)trees timeToNextDamage:(CGFloat)timeToNextDamage generators:(NSArray*)generators scheduleAwait:(CNFuture*(^)(TRLevel*))scheduleAwait;
- (instancetype)initWithTime:(CGFloat)time seedPosition:(unsigned int)seedPosition schedule:(EGImSchedule*)schedule railroad:(TRRailroadState*)railroad builderState:(TRRailroadBuilderState*)builderState cities:(NSArray*)cities trains:(NSArray*)trains dyingTrains:(NSArray*)dyingTrains repairer:(TRTrain*)repairer score:(TRScoreState*)score trees:(NSArray*)trees timeToNextDamage:(CGFloat)timeToNextDamage generators:(NSArray*)generators scheduleAwait:(CNFuture*(^)(TRLevel*))scheduleAwait;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRRewindButton : NSObject {
@protected
    EGCounter* _animation;
    CNVar* _position;
}
@property (nonatomic, readonly) EGCounter* animation;
@property (nonatomic, readonly) CNVar* position;

+ (instancetype)rewindButton;
- (instancetype)init;
- (CNClassType*)type;
- (void)showAt:(GEVec2)at;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRLevel : CNActor<EGController> {
@protected
    NSUInteger _number;
    TRLevelRules* _rules;
    CNSlot* _scale;
    CNSlot* _cameraReserves;
    CNSlot* _viewRatio;
    CNSeed* __seed;
    CGFloat __time;
    TRRewindButton* _rewindButton;
    TRHistory* _history;
    EGMapSso* _map;
    TRNotifications* _notifications;
    TRScore* _score;
    TRWeather* _weather;
    TRForest* _forest;
    TRRailroad* _railroad;
    TRRailroadBuilder* _builder;
    volatile NSArray* __cities;
    EGMSchedule* __schedule;
    CNFuture*(^__scheduleAwait)(TRLevel*);
    CNFuture* __scheduleAwaitLastFuture;
    volatile NSArray* __trains;
    TRTrain* __repairer;
    TRTrainCollisions* _collisions;
    NSArray* __dyingTrains;
    CGFloat __timeToNextDamage;
    CNSignal* _cityWasBuilt;
    CNSignal* _trainIsAboutToRun;
    CNSignal* _trainIsExpected;
    CNSignal* _trainWasAdded;
    NSArray* __generators;
    CGFloat _looseCounter;
    BOOL __resultSent;
    NSUInteger __crashCounter;
    CNSignal* _trainWasRemoved;
    CNVar* _help;
    CNVar* _result;
    BOOL _rate;
    NSInteger _rewindShop;
    EGCounter* _slowMotionCounter;
}
@property (nonatomic, readonly) NSUInteger number;
@property (nonatomic, readonly) TRLevelRules* rules;
@property (nonatomic, readonly) CNSlot* scale;
@property (nonatomic, readonly) CNSlot* cameraReserves;
@property (nonatomic, readonly) CNSlot* viewRatio;
@property (nonatomic, readonly) TRRewindButton* rewindButton;
@property (nonatomic, readonly) TRHistory* history;
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRNotifications* notifications;
@property (nonatomic, readonly) TRScore* score;
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) TRForest* forest;
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) TRRailroadBuilder* builder;
@property (nonatomic, readonly) TRTrainCollisions* collisions;
@property (nonatomic, readonly) CNSignal* cityWasBuilt;
@property (nonatomic, readonly) CNSignal* trainIsAboutToRun;
@property (nonatomic, readonly) CNSignal* trainIsExpected;
@property (nonatomic, readonly) CNSignal* trainWasAdded;
@property (nonatomic, readonly) CNSignal* trainWasRemoved;
@property (nonatomic, readonly) CNVar* help;
@property (nonatomic, readonly) CNVar* result;
@property (nonatomic) BOOL rate;
@property (nonatomic) NSInteger rewindShop;
@property (nonatomic, retain) EGCounter* slowMotionCounter;

+ (instancetype)levelWithNumber:(NSUInteger)number rules:(TRLevelRules*)rules;
- (instancetype)initWithNumber:(NSUInteger)number rules:(TRLevelRules*)rules;
- (CNClassType*)type;
- (CNFuture*)time;
- (CNFuture*)state;
- (CNFuture*)restoreState:(TRLevelState*)state;
- (void)scheduleAwaitBy:(CNFuture*(^)(TRLevel*))by;
- (CNFuture*)cities;
- (CNFuture*)trains;
- (TRTrain*)repairer;
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
- (TRCity*)cityForTile:(GEVec2i)tile;
- (CNFuture*)possiblyArrivedTrain:(TRTrain*)train tile:(GEVec2i)tile tailX:(CGFloat)tailX;
- (CNFuture*)processCollisions;
- (CNFuture*)processCollision:(TRCarsCollision*)collision;
- (CNFuture*)knockDownTrain:(TRTrain*)train;
- (CNFuture*)addSporadicDamage;
- (CNFuture*)detectCollisions;
- (CNFuture*)destroyTrain:(TRTrain*)train railPoint:(id)railPoint;
- (CNFuture*)destroyTrain:(TRTrain*)train;
- (CNFuture*)runRepairerFromCity:(TRCity*)city;
- (CNFuture*)fixDamageAtPoint:(TRRailPoint)point;
- (void)showHelpText:(NSString*)text;
- (void)clearHelp;
- (void)rewind;
- (NSString*)description;
+ (CNSignal*)crashed;
+ (CNSignal*)knockedDown;
+ (CNSignal*)damaged;
+ (CNSignal*)sporadicDamaged;
+ (CNSignal*)runRepairer;
+ (CNSignal*)fixedDamage;
+ (CNSignal*)wan;
+ (CNClassType*)type;
@end


@interface TRHelp : NSObject {
@protected
    NSString* _text;
}
@property (nonatomic, readonly) NSString* text;

+ (instancetype)helpWithText:(NSString*)text;
- (instancetype)initWithText:(NSString*)text;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRLevelResult : NSObject {
@protected
    BOOL _win;
}
@property (nonatomic, readonly) BOOL win;

+ (instancetype)levelResultWithWin:(BOOL)win;
- (instancetype)initWithWin:(BOOL)win;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRNotifications : NSObject {
@protected
    CNConcurrentQueue* _queue;
}
+ (instancetype)notifications;
- (instancetype)init;
- (CNClassType*)type;
- (void)notifyNotification:(NSString*)notification;
- (BOOL)isEmpty;
- (NSString*)take;
- (NSString*)description;
+ (CNClassType*)type;
@end


