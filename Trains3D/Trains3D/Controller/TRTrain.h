#import "objd.h"
#import "TRRailPoint.h"
#import "ATTypedActor.h"
#import "GEVec.h"
@class TRObstacle;
@class TRObstacleType;
@class TRLevel;
@class EGMapSso;
@class TRRailroad;
@class TRCityColor;
@class TRCarType;
@class TRCar;
@class TRCity;
@class TRLiveCarState;
@class TRSwitch;
@class TRRail;

@class TRTrainState;
@class TRDieTrainState;
@class TRLiveTrainState;
@class TRTrain;
@class TRTrainGenerator;
@class TRTrainSoundData;
@class TRTrainType;

@interface TRTrainType : ODEnum
@property (nonatomic, readonly) BOOL(^obstacleProcessor)(TRLevel*, TRLiveTrainState*, TRObstacle*);

+ (TRTrainType*)simple;
+ (TRTrainType*)crazy;
+ (TRTrainType*)fast;
+ (TRTrainType*)repairer;
+ (NSArray*)values;
@end


@interface TRTrainState : NSObject
@property (nonatomic, readonly, weak) TRTrain* train;
@property (nonatomic, readonly) CGFloat time;

+ (instancetype)trainStateWithTrain:(TRTrain*)train time:(CGFloat)time;
- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time;
- (ODClassType*)type;
- (id<CNSeq>)carStates;
- (BOOL)isDying;
+ (ODClassType*)type;
@end


@interface TRDieTrainState : TRTrainState
@property (nonatomic, readonly) id<CNSeq> carStates;

+ (instancetype)dieTrainStateWithTrain:(TRTrain*)train time:(CGFloat)time carStates:(id<CNSeq>)carStates;
- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time carStates:(id<CNSeq>)carStates;
- (ODClassType*)type;
- (BOOL)isDying;
+ (ODClassType*)type;
@end


@interface TRLiveTrainState : TRTrainState
@property (nonatomic, readonly) TRRailPoint head;
@property (nonatomic, readonly) BOOL isBack;
@property (nonatomic, readonly) id<CNSeq> carStates;

+ (instancetype)liveTrainStateWithTrain:(TRTrain*)train time:(CGFloat)time head:(TRRailPoint)head isBack:(BOOL)isBack carStates:(id<CNSeq>)carStates;
- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time head:(TRRailPoint)head isBack:(BOOL)isBack carStates:(id<CNSeq>)carStates;
- (ODClassType*)type;
- (BOOL)isDying;
+ (ODClassType*)type;
@end


@interface TRTrain : ATTypedActor
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) TRTrainType* trainType;
@property (nonatomic, readonly) TRCityColor* color;
@property (nonatomic, readonly) id<CNSeq> carTypes;
@property (nonatomic, readonly) NSUInteger speed;
@property (nonatomic, readonly) TRTrainSoundData* _soundData;
@property (nonatomic) TRRailPoint _head;
@property (nonatomic, readonly) CGFloat speedFloat;
@property (nonatomic) BOOL _isDying;
@property (nonatomic) CGFloat _time;
@property (nonatomic, retain) TRTrainState* _state;
@property (nonatomic, readonly) id<CNSeq> cars;

+ (instancetype)trainWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color carTypes:(id<CNSeq>)carTypes speed:(NSUInteger)speed;
- (instancetype)initWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color carTypes:(id<CNSeq>)carTypes speed:(NSUInteger)speed;
- (ODClassType*)type;
- (CNFuture*)state;
- (CNFuture*)startFromCity:(TRCity*)city;
- (NSString*)description;
- (CNFuture*)setHead:(TRRailPoint)head;
- (CNFuture*)die;
- (CNFuture*)setDieCarStates:(id<CNSeq>)dieCarStates;
- (NSUInteger)carsCount;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (CNFuture*)isLockedTheSwitch:(TRSwitch*)theSwitch;
- (CNFuture*)lockedTiles;
- (CNFuture*)isLockedRail:(TRRail*)rail;
+ (CNNotificationHandle*)chooNotification;
+ (ODClassType*)type;
@end


@interface TRTrainGenerator : NSObject
@property (nonatomic, readonly) TRTrainType* trainType;
@property (nonatomic, readonly) id<CNSeq> carsCount;
@property (nonatomic, readonly) id<CNSeq> speed;
@property (nonatomic, readonly) id<CNSeq> carTypes;

+ (instancetype)trainGeneratorWithTrainType:(TRTrainType*)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes;
- (instancetype)initWithTrainType:(TRTrainType*)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes;
- (ODClassType*)type;
- (id<CNSeq>)generateCarTypes;
- (NSUInteger)generateSpeed;
+ (ODClassType*)type;
@end


@interface TRTrainSoundData : NSObject
@property (nonatomic) NSInteger chooCounter;
@property (nonatomic) CGFloat toNextChoo;
@property (nonatomic) GEVec2i lastTile;
@property (nonatomic) CGFloat lastX;

+ (instancetype)trainSoundData;
- (instancetype)init;
- (ODClassType*)type;
- (void)nextChoo;
- (void)nextHead:(TRRailPoint)head;
+ (ODClassType*)type;
@end


