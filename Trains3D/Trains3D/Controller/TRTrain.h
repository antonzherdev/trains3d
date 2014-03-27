#import "objd.h"
#import "TRRailPoint.h"
#import "ATActor.h"
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
@class TRRailroadState;
@class TRLiveCarState;
@class TRCarState;
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
@property (nonatomic, readonly) BOOL(^obstacleProcessor)(TRLevel*, TRTrain*, TRRailPoint, TRObstacle*);

+ (TRTrainType*)simple;
+ (TRTrainType*)crazy;
+ (TRTrainType*)fast;
+ (TRTrainType*)repairer;
+ (NSArray*)values;
@end


@interface TRTrainState : NSObject {
@private
    TRTrain* _train;
    CGFloat _time;
}
@property (nonatomic, readonly) TRTrain* train;
@property (nonatomic, readonly) CGFloat time;

+ (instancetype)trainStateWithTrain:(TRTrain*)train time:(CGFloat)time;
- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time;
- (ODClassType*)type;
- (id<CNImSeq>)carStates;
- (BOOL)isDying;
+ (ODClassType*)type;
@end


@interface TRDieTrainState : TRTrainState {
@private
    id<CNImSeq> _carStates;
}
@property (nonatomic, readonly) id<CNImSeq> carStates;

+ (instancetype)dieTrainStateWithTrain:(TRTrain*)train time:(CGFloat)time carStates:(id<CNImSeq>)carStates;
- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time carStates:(id<CNImSeq>)carStates;
- (ODClassType*)type;
- (BOOL)isDying;
+ (ODClassType*)type;
@end


@interface TRLiveTrainState : TRTrainState {
@private
    TRRailPoint _head;
    BOOL _isBack;
    id<CNImSeq> _carStates;
}
@property (nonatomic, readonly) TRRailPoint head;
@property (nonatomic, readonly) BOOL isBack;
@property (nonatomic, readonly) id<CNImSeq> carStates;

+ (instancetype)liveTrainStateWithTrain:(TRTrain*)train time:(CGFloat)time head:(TRRailPoint)head isBack:(BOOL)isBack carStates:(id<CNImSeq>)carStates;
- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time head:(TRRailPoint)head isBack:(BOOL)isBack carStates:(id<CNImSeq>)carStates;
- (ODClassType*)type;
- (BOOL)isDying;
+ (ODClassType*)type;
@end


@interface TRTrain : ATActor {
@private
    __weak TRLevel* _level;
    TRTrainType* _trainType;
    TRCityColor* _color;
    id<CNImSeq> _carTypes;
    NSUInteger _speed;
    TRTrainSoundData* __soundData;
    TRRailPoint __head;
    BOOL __isBack;
    BOOL __isDying;
    CGFloat __time;
    id<CNImSeq> __carStates;
    CGFloat _speedFloat;
    CGFloat _length;
    id<CNImSeq> _cars;
    BOOL(^_carsObstacleProcessor)(TRObstacle*);
}
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) TRTrainType* trainType;
@property (nonatomic, readonly) TRCityColor* color;
@property (nonatomic, readonly) id<CNImSeq> carTypes;
@property (nonatomic, readonly) NSUInteger speed;
@property (nonatomic, readonly) CGFloat speedFloat;
@property (nonatomic, readonly) CGFloat length;
@property (nonatomic, readonly) id<CNImSeq> cars;

+ (instancetype)trainWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color carTypes:(id<CNImSeq>)carTypes speed:(NSUInteger)speed;
- (instancetype)initWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color carTypes:(id<CNImSeq>)carTypes speed:(NSUInteger)speed;
- (ODClassType*)type;
- (CNFuture*)state;
- (CNFuture*)restoreState:(TRTrainState*)state;
- (CNFuture*)startFromCity:(TRCity*)city;
- (NSString*)description;
- (CNFuture*)setHead:(TRRailPoint)head;
- (CNFuture*)die;
- (CNFuture*)setDieCarStates:(id<CNImSeq>)dieCarStates;
- (NSUInteger)carsCount;
- (CNFuture*)updateWithRrState:(TRRailroadState*)rrState delta:(CGFloat)delta;
- (CNFuture*)isLockedTheSwitch:(TRSwitch*)theSwitch;
- (CNFuture*)lockedTiles;
- (CNFuture*)isLockedRail:(TRRail*)rail;
- (BOOL)isEqualTrain:(TRTrain*)train;
- (NSUInteger)hash;
+ (CNNotificationHandle*)chooNotification;
+ (ODClassType*)type;
@end


@interface TRTrainGenerator : NSObject {
@private
    TRTrainType* _trainType;
    id<CNImSeq> _carsCount;
    id<CNImSeq> _speed;
    id<CNImSeq> _carTypes;
}
@property (nonatomic, readonly) TRTrainType* trainType;
@property (nonatomic, readonly) id<CNImSeq> carsCount;
@property (nonatomic, readonly) id<CNImSeq> speed;
@property (nonatomic, readonly) id<CNImSeq> carTypes;

+ (instancetype)trainGeneratorWithTrainType:(TRTrainType*)trainType carsCount:(id<CNImSeq>)carsCount speed:(id<CNImSeq>)speed carTypes:(id<CNImSeq>)carTypes;
- (instancetype)initWithTrainType:(TRTrainType*)trainType carsCount:(id<CNImSeq>)carsCount speed:(id<CNImSeq>)speed carTypes:(id<CNImSeq>)carTypes;
- (ODClassType*)type;
- (id<CNImSeq>)generateCarTypes;
- (NSUInteger)generateSpeed;
+ (ODClassType*)type;
@end


@interface TRTrainSoundData : NSObject {
@private
    NSInteger _chooCounter;
    CGFloat _toNextChoo;
    GEVec2i _lastTile;
    CGFloat _lastX;
}
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


