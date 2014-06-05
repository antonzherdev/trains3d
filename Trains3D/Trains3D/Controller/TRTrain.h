#import "objd.h"
#import "TRRailroad.h"
#import "TRRailPoint.h"
#import "CNActor.h"
#import "TRCity.h"
#import "TRCar.h"
#import "PGVec.h"
@class TRLevel;
@class PGMapSso;
@class CNSignal;
@class CNChain;
@class CNFuture;

@class TRTrainState;
@class TRDieTrainState;
@class TRLiveTrainState;
@class TRTrain;
@class TRTrainGenerator;
@class TRTrainSoundData;
@class TRTrainType;

typedef enum TRTrainTypeR {
    TRTrainType_Nil = 0,
    TRTrainType_simple = 1,
    TRTrainType_crazy = 2,
    TRTrainType_fast = 3,
    TRTrainType_repairer = 4
} TRTrainTypeR;
@interface TRTrainType : CNEnum
@property (nonatomic, readonly) BOOL(^obstacleProcessor)(TRLevel*, TRTrain*, TRRailPoint, TRObstacle*);

+ (NSArray*)values;
+ (TRTrainType*)value:(TRTrainTypeR)r;
@end


@interface TRTrainState : NSObject {
@public
    TRTrain* _train;
    CGFloat _time;
}
@property (nonatomic, readonly) TRTrain* train;
@property (nonatomic, readonly) CGFloat time;

+ (instancetype)trainStateWithTrain:(TRTrain*)train time:(CGFloat)time;
- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time;
- (CNClassType*)type;
- (NSArray*)carStates;
- (BOOL)isDying;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRDieTrainState : TRTrainState {
@public
    NSArray* _carStates;
}
@property (nonatomic, readonly) NSArray* carStates;

+ (instancetype)dieTrainStateWithTrain:(TRTrain*)train time:(CGFloat)time carStates:(NSArray*)carStates;
- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time carStates:(NSArray*)carStates;
- (CNClassType*)type;
- (BOOL)isDying;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRLiveTrainState : TRTrainState {
@public
    TRRailPoint _head;
    BOOL _isBack;
    NSArray* _carStates;
}
@property (nonatomic, readonly) TRRailPoint head;
@property (nonatomic, readonly) BOOL isBack;
@property (nonatomic, readonly) NSArray* carStates;

+ (instancetype)liveTrainStateWithTrain:(TRTrain*)train time:(CGFloat)time head:(TRRailPoint)head isBack:(BOOL)isBack carStates:(NSArray*)carStates;
- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time head:(TRRailPoint)head isBack:(BOOL)isBack carStates:(NSArray*)carStates;
- (CNClassType*)type;
- (BOOL)isDying;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRTrain : CNActor {
@public
    __weak TRLevel* _level;
    TRTrainTypeR _trainType;
    TRCityColorR _color;
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
@property (nonatomic, readonly) TRTrainTypeR trainType;
@property (nonatomic, readonly) TRCityColorR color;
@property (nonatomic, readonly) NSArray* carTypes;
@property (nonatomic, readonly) NSUInteger speed;
@property (nonatomic, readonly) CGFloat speedFloat;
@property (nonatomic, readonly) CGFloat length;
@property (nonatomic, readonly) NSArray* cars;

+ (instancetype)trainWithLevel:(TRLevel*)level trainType:(TRTrainTypeR)trainType color:(TRCityColorR)color carTypes:(NSArray*)carTypes speed:(NSUInteger)speed;
- (instancetype)initWithLevel:(TRLevel*)level trainType:(TRTrainTypeR)trainType color:(TRCityColorR)color carTypes:(NSArray*)carTypes speed:(NSUInteger)speed;
- (CNClassType*)type;
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
- (BOOL)isEqual:(id)to;
+ (CNSignal*)choo;
+ (CNClassType*)type;
@end


@interface TRTrainGenerator : NSObject {
@public
    TRTrainTypeR _trainType;
    id<CNSeq> _carsCount;
    id<CNSeq> _speed;
    id<CNSeq> _carTypes;
}
@property (nonatomic, readonly) TRTrainTypeR trainType;
@property (nonatomic, readonly) id<CNSeq> carsCount;
@property (nonatomic, readonly) id<CNSeq> speed;
@property (nonatomic, readonly) id<CNSeq> carTypes;

+ (instancetype)trainGeneratorWithTrainType:(TRTrainTypeR)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes;
- (instancetype)initWithTrainType:(TRTrainTypeR)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes;
- (CNClassType*)type;
- (NSArray*)generateCarTypesSeed:(CNSeed*)seed;
- (NSUInteger)generateSpeedSeed:(CNSeed*)seed;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRTrainSoundData : NSObject {
@public
    NSInteger _chooCounter;
    CGFloat _toNextChoo;
    PGVec2i _lastTile;
    CGFloat _lastX;
}
@property (nonatomic) NSInteger chooCounter;
@property (nonatomic) CGFloat toNextChoo;
@property (nonatomic) PGVec2i lastTile;
@property (nonatomic) CGFloat lastX;

+ (instancetype)trainSoundData;
- (instancetype)init;
- (CNClassType*)type;
- (void)nextChoo;
- (void)nextHead:(TRRailPoint)head;
- (NSString*)description;
+ (CNClassType*)type;
@end


