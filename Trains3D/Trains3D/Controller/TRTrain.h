#import "objd.h"
#import "TRRailPoint.h"
#import "ATActor.h"
#import "GEVec.h"
@class TRObstacle;
@class TRObstacleType;
@class TRLevel;
@class EGMapSso;
@class TRCityColor;
@class TRCarType;
@class TRCar;
@class TRRailroad;
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
- (NSArray*)carStates;
- (BOOL)isDying;
+ (ODClassType*)type;
@end


@interface TRDieTrainState : TRTrainState {
@private
    NSArray* _carStates;
}
@property (nonatomic, readonly) NSArray* carStates;

+ (instancetype)dieTrainStateWithTrain:(TRTrain*)train time:(CGFloat)time carStates:(NSArray*)carStates;
- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time carStates:(NSArray*)carStates;
- (ODClassType*)type;
- (BOOL)isDying;
+ (ODClassType*)type;
@end


@interface TRLiveTrainState : TRTrainState {
@private
    TRRailPoint _head;
    BOOL _isBack;
    NSArray* _carStates;
}
@property (nonatomic, readonly) TRRailPoint head;
@property (nonatomic, readonly) BOOL isBack;
@property (nonatomic, readonly) NSArray* carStates;

+ (instancetype)liveTrainStateWithTrain:(TRTrain*)train time:(CGFloat)time head:(TRRailPoint)head isBack:(BOOL)isBack carStates:(NSArray*)carStates;
- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time head:(TRRailPoint)head isBack:(BOOL)isBack carStates:(NSArray*)carStates;
- (ODClassType*)type;
- (BOOL)isDying;
+ (ODClassType*)type;
@end


@interface TRTrain : ATActor {
@private
    __weak TRLevel* _level;
    TRTrainType* _trainType;
    TRCityColor* _color;
    NSArray* _carTypes;
    NSUInteger _speed;
    TRTrainSoundData* __soundData;
    TRRailPoint __head;
    BOOL __isBack;
    BOOL __isDying;
    CGFloat __time;
    NSArray* __carStates;
    CGFloat _speedFloat;
    CGFloat _length;
    NSArray* _cars;
    BOOL(^_carsObstacleProcessor)(TRObstacle*);
}
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) TRTrainType* trainType;
@property (nonatomic, readonly) TRCityColor* color;
@property (nonatomic, readonly) NSArray* carTypes;
@property (nonatomic, readonly) NSUInteger speed;
@property (nonatomic, readonly) CGFloat speedFloat;
@property (nonatomic, readonly) CGFloat length;
@property (nonatomic, readonly) NSArray* cars;

+ (instancetype)trainWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color carTypes:(NSArray*)carTypes speed:(NSUInteger)speed;
- (instancetype)initWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color carTypes:(NSArray*)carTypes speed:(NSUInteger)speed;
- (ODClassType*)type;
- (CNFuture*)state;
- (CNFuture*)restoreState:(TRTrainState*)state;
- (CNFuture*)startFromCity:(TRCity*)city;
- (NSString*)description;
- (CNFuture*)setHead:(TRRailPoint)head;
- (CNFuture*)die;
- (CNFuture*)setDieCarStates:(NSArray*)dieCarStates;
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
    id<CNSeq> _carsCount;
    id<CNSeq> _speed;
    id<CNSeq> _carTypes;
}
@property (nonatomic, readonly) TRTrainType* trainType;
@property (nonatomic, readonly) id<CNSeq> carsCount;
@property (nonatomic, readonly) id<CNSeq> speed;
@property (nonatomic, readonly) id<CNSeq> carTypes;

+ (instancetype)trainGeneratorWithTrainType:(TRTrainType*)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes;
- (instancetype)initWithTrainType:(TRTrainType*)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes;
- (ODClassType*)type;
- (NSArray*)generateCarTypesSeed:(CNSeed*)seed;
- (NSUInteger)generateSpeedSeed:(CNSeed*)seed;
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


