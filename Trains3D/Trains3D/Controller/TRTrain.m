#import "TRTrain.h"

#import "TRRailroad.h"
#import "TRLevel.h"
#import "EGMapIso.h"
#import "TRCity.h"
#import "TRCar.h"
@implementation TRTrainType{
    BOOL(^_obstacleProcessor)(TRLevel*, TRLiveTrainState*, TRObstacle*);
}
static TRTrainType* _TRTrainType_simple;
static TRTrainType* _TRTrainType_crazy;
static TRTrainType* _TRTrainType_fast;
static TRTrainType* _TRTrainType_repairer;
static NSArray* _TRTrainType_values;
@synthesize obstacleProcessor = _obstacleProcessor;

+ (instancetype)trainTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name obstacleProcessor:(BOOL(^)(TRLevel*, TRLiveTrainState*, TRObstacle*))obstacleProcessor {
    return [[TRTrainType alloc] initWithOrdinal:ordinal name:name obstacleProcessor:obstacleProcessor];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name obstacleProcessor:(BOOL(^)(TRLevel*, TRLiveTrainState*, TRObstacle*))obstacleProcessor {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _obstacleProcessor = [obstacleProcessor copy];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTrainType_simple = [TRTrainType trainTypeWithOrdinal:0 name:@"simple" obstacleProcessor:^BOOL(TRLevel* level, TRLiveTrainState* trainState, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) [level destroyTrain:trainState.train];
        return NO;
    }];
    _TRTrainType_crazy = [TRTrainType trainTypeWithOrdinal:1 name:@"crazy" obstacleProcessor:^BOOL(TRLevel* level, TRLiveTrainState* trainState, TRObstacle* o) {
        if(o.obstacleType != TRObstacleType.light) {
            if(o.obstacleType == TRObstacleType.end) {
                TRRailPoint point = trainState.head;
                if(!([level.map isFullTile:point.tile]) && !([level.map isFullTile:trRailPointNextTile(point)])) {
                    return NO;
                } else {
                    [level.railroad addDamageAtPoint:point];
                    [level destroyTrain:trainState.train];
                    return NO;
                }
            } else {
                [level.railroad addDamageAtPoint:trainState.head];
                [level destroyTrain:trainState.train];
                return NO;
            }
        } else {
            return YES;
        }
    }];
    _TRTrainType_fast = [TRTrainType trainTypeWithOrdinal:2 name:@"fast" obstacleProcessor:^BOOL(TRLevel* level, TRLiveTrainState* trainState, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.aSwitch) {
            [level.railroad addDamageAtPoint:o.point];
            [level destroyTrain:trainState.train];
        } else {
            if(o.obstacleType == TRObstacleType.damage) [level destroyTrain:trainState.train];
        }
        return NO;
    }];
    _TRTrainType_repairer = [TRTrainType trainTypeWithOrdinal:3 name:@"repairer" obstacleProcessor:^BOOL(TRLevel* level, TRLiveTrainState* trainState, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) {
            [level fixDamageAtPoint:o.point];
            return YES;
        } else {
            return NO;
        }
    }];
    _TRTrainType_values = (@[_TRTrainType_simple, _TRTrainType_crazy, _TRTrainType_fast, _TRTrainType_repairer]);
}

+ (TRTrainType*)simple {
    return _TRTrainType_simple;
}

+ (TRTrainType*)crazy {
    return _TRTrainType_crazy;
}

+ (TRTrainType*)fast {
    return _TRTrainType_fast;
}

+ (TRTrainType*)repairer {
    return _TRTrainType_repairer;
}

+ (NSArray*)values {
    return _TRTrainType_values;
}

@end


@implementation TRTrainState
static ODClassType* _TRTrainState_type;
@synthesize train = _train;
@synthesize time = _time;

+ (instancetype)trainStateWithTrain:(TRTrain*)train time:(CGFloat)time {
    return [[TRTrainState alloc] initWithTrain:train time:time];
}

- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time {
    self = [super init];
    if(self) {
        _train = train;
        _time = time;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainState class]) _TRTrainState_type = [ODClassType classTypeWithCls:[TRTrainState class]];
}

- (id<CNImSeq>)carStates {
    @throw @"Method carStates is abstract";
}

- (BOOL)isDying {
    @throw @"Method isDying is abstract";
}

- (ODClassType*)type {
    return [TRTrainState type];
}

+ (ODClassType*)type {
    return _TRTrainState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTrainState* o = ((TRTrainState*)(other));
    return [self.train isEqual:o.train] && eqf(self.time, o.time);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.train hash];
    hash = hash * 31 + floatHash(self.time);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"train=%@", self.train];
    [description appendFormat:@", time=%f", self.time];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRDieTrainState
static ODClassType* _TRDieTrainState_type;
@synthesize carStates = _carStates;

+ (instancetype)dieTrainStateWithTrain:(TRTrain*)train time:(CGFloat)time carStates:(id<CNImSeq>)carStates {
    return [[TRDieTrainState alloc] initWithTrain:train time:time carStates:carStates];
}

- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time carStates:(id<CNImSeq>)carStates {
    self = [super initWithTrain:train time:time];
    if(self) _carStates = carStates;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRDieTrainState class]) _TRDieTrainState_type = [ODClassType classTypeWithCls:[TRDieTrainState class]];
}

- (BOOL)isDying {
    return YES;
}

- (ODClassType*)type {
    return [TRDieTrainState type];
}

+ (ODClassType*)type {
    return _TRDieTrainState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRDieTrainState* o = ((TRDieTrainState*)(other));
    return [self.train isEqual:o.train] && eqf(self.time, o.time) && [self.carStates isEqual:o.carStates];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.train hash];
    hash = hash * 31 + floatHash(self.time);
    hash = hash * 31 + [self.carStates hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"train=%@", self.train];
    [description appendFormat:@", time=%f", self.time];
    [description appendFormat:@", carStates=%@", self.carStates];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRLiveTrainState
static ODClassType* _TRLiveTrainState_type;
@synthesize head = _head;
@synthesize isBack = _isBack;
@synthesize carStates = _carStates;

+ (instancetype)liveTrainStateWithTrain:(TRTrain*)train time:(CGFloat)time head:(TRRailPoint)head isBack:(BOOL)isBack carStates:(id<CNImSeq>)carStates {
    return [[TRLiveTrainState alloc] initWithTrain:train time:time head:head isBack:isBack carStates:carStates];
}

- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time head:(TRRailPoint)head isBack:(BOOL)isBack carStates:(id<CNImSeq>)carStates {
    self = [super initWithTrain:train time:time];
    if(self) {
        _head = head;
        _isBack = isBack;
        _carStates = carStates;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLiveTrainState class]) _TRLiveTrainState_type = [ODClassType classTypeWithCls:[TRLiveTrainState class]];
}

- (BOOL)isDying {
    return NO;
}

- (ODClassType*)type {
    return [TRLiveTrainState type];
}

+ (ODClassType*)type {
    return _TRLiveTrainState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLiveTrainState* o = ((TRLiveTrainState*)(other));
    return [self.train isEqual:o.train] && eqf(self.time, o.time) && TRRailPointEq(self.head, o.head) && self.isBack == o.isBack && [self.carStates isEqual:o.carStates];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.train hash];
    hash = hash * 31 + floatHash(self.time);
    hash = hash * 31 + TRRailPointHash(self.head);
    hash = hash * 31 + self.isBack;
    hash = hash * 31 + [self.carStates hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"train=%@", self.train];
    [description appendFormat:@", time=%f", self.time];
    [description appendFormat:@", head=%@", TRRailPointDescription(self.head)];
    [description appendFormat:@", isBack=%d", self.isBack];
    [description appendFormat:@", carStates=%@", self.carStates];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTrain
static CNNotificationHandle* _TRTrain_chooNotification;
static ODClassType* _TRTrain_type;
@synthesize level = _level;
@synthesize trainType = _trainType;
@synthesize color = _color;
@synthesize carTypes = _carTypes;
@synthesize speed = _speed;
@synthesize _soundData = __soundData;
@synthesize _head = __head;
@synthesize speedFloat = _speedFloat;
@synthesize length = _length;
@synthesize _isDying = __isDying;
@synthesize _time = __time;
@synthesize _state = __state;
@synthesize cars = _cars;

+ (instancetype)trainWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color carTypes:(id<CNImSeq>)carTypes speed:(NSUInteger)speed {
    return [[TRTrain alloc] initWithLevel:level trainType:trainType color:color carTypes:carTypes speed:speed];
}

- (instancetype)initWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color carTypes:(id<CNImSeq>)carTypes speed:(NSUInteger)speed {
    self = [super init];
    if(self) {
        _level = level;
        _trainType = trainType;
        _color = color;
        _carTypes = carTypes;
        _speed = speed;
        __soundData = [TRTrainSoundData trainSoundData];
        __head = trRailPointApply();
        __isBack = NO;
        _speedFloat = 0.01 * _speed;
        _length = unumf(([[_carTypes chain] foldStart:@0.0 by:^id(id r, TRCarType* car) {
            return numf(((TRCarType*)(car)).fullLength + unumf(r));
        }]));
        __isDying = NO;
        __time = 0.0;
        __state = [TRLiveTrainState liveTrainStateWithTrain:self time:0.0 head:__head isBack:NO carStates:(@[])];
        _cars = ^id<CNImSeq>() {
            __block NSInteger i = 0;
            return [[[_carTypes chain] map:^TRCar*(TRCarType* tp) {
                TRCar* car = [TRCar carWithTrain:self carType:tp number:((NSUInteger)(i))];
                i++;
                return car;
            }] toArray];
        }();
        _carsObstacleProcessor = ^BOOL(TRObstacle* o) {
            return o.obstacleType == TRObstacleType.light;
        };
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrain class]) {
        _TRTrain_type = [ODClassType classTypeWithCls:[TRTrain class]];
        _TRTrain_chooNotification = [CNNotificationHandle notificationHandleWithName:@"chooNotification"];
    }
}

- (CNFuture*)state {
    return [self promptF:^TRTrainState*() {
        return __state;
    }];
}

- (CNFuture*)startFromCity:(TRCity*)city {
    return [self lockAndOnSuccessFuture:[_level.railroad state] f:^id(TRRailroadState* rrState) {
        __head = [city startPoint];
        [self calculateCarPositionsRrState:rrState];
        return nil;
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<Train: %@, %@>", _trainType, _color];
}

- (CNFuture*)setHead:(TRRailPoint)head {
    return [self lockAndOnSuccessFuture:[_level.railroad state] f:^id(TRRailroadState* rrState) {
        __head = head;
        [self calculateCarPositionsRrState:rrState];
        return nil;
    }];
}

- (CNFuture*)die {
    return [self promptF:^id() {
        __isDying = YES;
        return nil;
    }];
}

- (CNFuture*)setDieCarStates:(id<CNImSeq>)dieCarStates {
    return [self promptF:^id() {
        __state = [TRDieTrainState dieTrainStateWithTrain:self time:__time carStates:dieCarStates];
        return nil;
    }];
}

- (NSUInteger)carsCount {
    return [_carTypes count];
}

- (void)calculateCarPositionsRrState:(TRRailroadState*)rrState {
    __block TRRailPoint frontConnector = trRailPointInvert(__head);
    id<CNImSeq> carStates = [[[[[_cars chain] reverseWhen:__isBack] map:^TRLiveCarState*(TRCar* car) {
        TRCarType* tp = ((TRCar*)(car)).carType;
        CGFloat fl = tp.startToWheel;
        CGFloat bl = tp.wheelToEnd;
        TRRailPoint head = trRailPointCorrectionAddErrorToPoint([rrState moveWithObstacleProcessor:_carsObstacleProcessor forLength:((__isBack) ? bl : fl) point:frontConnector]);
        TRRailPoint tail = trRailPointCorrectionAddErrorToPoint([rrState moveWithObstacleProcessor:_carsObstacleProcessor forLength:tp.betweenWheels point:head]);
        TRRailPoint backConnector = trRailPointCorrectionAddErrorToPoint([rrState moveWithObstacleProcessor:_carsObstacleProcessor forLength:((__isBack) ? fl : bl) point:tail]);
        TRRailPoint fc = frontConnector;
        frontConnector = backConnector;
        if(__isBack) return [TRLiveCarState applyCar:car frontConnector:backConnector head:tail tail:head backConnector:fc];
        else return [TRLiveCarState applyCar:car frontConnector:fc head:head tail:tail backConnector:backConnector];
    }] reverseWhen:__isBack] toArray];
    __state = [TRLiveTrainState liveTrainStateWithTrain:self time:__time head:__head isBack:__isBack carStates:carStates];
}

- (GEVec2)movePoint:(GEVec2)point length:(CGFloat)length {
    return GEVec2Make(point.x, point.y + length);
}

- (CNFuture*)updateWithRrState:(TRRailroadState*)rrState delta:(CGFloat)delta {
    return [self futureF:^id() {
        if(!(__isDying)) [self correctRrState:rrState correction:[rrState moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
            return _trainType.obstacleProcessor(_level, ((TRLiveTrainState*)(__state)), _);
        } forLength:delta * _speedFloat point:__head]];
        __time += delta;
        if(!(__isDying)) {
            if(__soundData.chooCounter > 0 && __soundData.toNextChoo <= 0.0) {
                [_TRTrain_chooNotification postSender:self];
                [__soundData nextChoo];
            } else {
                if(!(GEVec2iEq(__head.tile, __soundData.lastTile))) {
                    [_TRTrain_chooNotification postSender:self];
                    __soundData.lastTile = __head.tile;
                    __soundData.lastX = __head.x;
                    [__soundData nextChoo];
                } else {
                    if(__soundData.chooCounter > 0) [__soundData nextHead:__head];
                }
            }
        }
        return nil;
    }];
}

- (void)correctRrState:(TRRailroadState*)rrState correction:(TRRailPointCorrection)correction {
    if(!(eqf(correction.error, 0.0))) {
        BOOL isMoveToCity = [self isMoveToCityForPoint:correction.point];
        if(!(isMoveToCity) || correction.error >= _length - 0.5) {
            if(isMoveToCity && (_color == TRCityColor.grey || ((TRCity*)([[_level cityForTile:correction.point.tile] get])).color == _color)) {
                if(correction.error >= _length - 0.5) [_level possiblyArrivedTrain:self tile:correction.point.tile tailX:_length - correction.error];
                __head = trRailPointCorrectionAddErrorToPoint(correction);
            } else {
                __isBack = !(__isBack);
                TRLiveCarState* lastCar = ((__isBack) ? [((TRLiveTrainState*)(__state)).carStates last] : [((TRLiveTrainState*)(__state)).carStates head]);
                __head = ((__isBack) ? lastCar.backConnector : lastCar.frontConnector);
            }
        } else {
            __head = trRailPointCorrectionAddErrorToPoint(correction);
        }
    } else {
        __head = correction.point;
    }
    [self calculateCarPositionsRrState:rrState];
}

- (BOOL)isMoveToCityForPoint:(TRRailPoint)point {
    return !([_level.map isFullTile:point.tile]) && !([_level.map isFullTile:trRailPointNextTile(point)]);
}

- (CNFuture*)isLockedTheSwitch:(TRSwitch*)theSwitch {
    return [self futureF:^id() {
        if(__isDying) return @NO;
        GEVec2i tile = theSwitch.tile;
        GEVec2i nextTile = [theSwitch.connector nextTile:tile];
        TRRailPoint rp11 = [theSwitch railPoint1];
        TRRailPoint rp12 = trRailPointAddX(rp11, 0.3);
        TRRailPoint rp21 = [theSwitch railPoint2];
        TRRailPoint rp22 = trRailPointAddX(rp21, 0.3);
        return numb(([((TRLiveTrainState*)(__state)).carStates existsWhere:^BOOL(TRLiveCarState* p) {
            return (GEVec2iEq(((TRLiveCarState*)(p)).frontConnector.tile, tile) && GEVec2iEq(((TRLiveCarState*)(p)).backConnector.tile, nextTile)) || (GEVec2iEq(((TRLiveCarState*)(p)).frontConnector.tile, nextTile) && GEVec2iEq(((TRLiveCarState*)(p)).backConnector.tile, tile)) || trRailPointBetweenAB(((TRLiveCarState*)(p)).frontConnector, rp11, rp12) || trRailPointBetweenAB(((TRLiveCarState*)(p)).backConnector, rp21, rp22);
        }]));
    }];
}

- (CNFuture*)lockedTiles {
    return [self futureF:^NSMutableSet*() {
        NSMutableSet* ret = [NSMutableSet mutableSet];
        if(!(__isDying)) [((TRLiveTrainState*)(__state)).carStates forEach:^void(TRLiveCarState* p) {
            [ret appendItem:wrap(GEVec2i, ((TRLiveCarState*)(p)).head.tile)];
            [ret appendItem:wrap(GEVec2i, ((TRLiveCarState*)(p)).tail.tile)];
        }];
        return ret;
    }];
}

- (CNFuture*)isLockedRail:(TRRail*)rail {
    return [self futureF:^id() {
        return numb(!(__isDying) && [((TRLiveTrainState*)(__state)).carStates existsWhere:^BOOL(TRLiveCarState* car) {
    return [((TRLiveCarState*)(car)) isOnRail:rail];
}]);
    }];
}

- (BOOL)isEqualTo:(id)to {
    return self == to;
}

- (NSUInteger)hash {
    return ((NSUInteger)(self));
}

- (ODClassType*)type {
    return [TRTrain type];
}

+ (CNNotificationHandle*)chooNotification {
    return _TRTrain_chooNotification;
}

+ (ODClassType*)type {
    return _TRTrain_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTrain* o = ((TRTrain*)(other));
    return [self.level isEqual:o.level] && self.trainType == o.trainType && self.color == o.color && [self.carTypes isEqual:o.carTypes] && self.speed == o.speed;
}

@end


@implementation TRTrainGenerator
static ODClassType* _TRTrainGenerator_type;
@synthesize trainType = _trainType;
@synthesize carsCount = _carsCount;
@synthesize speed = _speed;
@synthesize carTypes = _carTypes;

+ (instancetype)trainGeneratorWithTrainType:(TRTrainType*)trainType carsCount:(id<CNImSeq>)carsCount speed:(id<CNImSeq>)speed carTypes:(id<CNImSeq>)carTypes {
    return [[TRTrainGenerator alloc] initWithTrainType:trainType carsCount:carsCount speed:speed carTypes:carTypes];
}

- (instancetype)initWithTrainType:(TRTrainType*)trainType carsCount:(id<CNImSeq>)carsCount speed:(id<CNImSeq>)speed carTypes:(id<CNImSeq>)carTypes {
    self = [super init];
    if(self) {
        _trainType = trainType;
        _carsCount = carsCount;
        _speed = speed;
        _carTypes = carTypes;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainGenerator class]) _TRTrainGenerator_type = [ODClassType classTypeWithCls:[TRTrainGenerator class]];
}

- (id<CNImSeq>)generateCarTypes {
    NSInteger count = unumi([[_carsCount randomItem] get]);
    TRCarType* engine = [[[[_carTypes chain] filter:^BOOL(TRCarType* _) {
        return [((TRCarType*)(_)) isEngine];
    }] randomItem] get];
    if(count <= 1) return (@[engine]);
    else return [[[[intRange(count - 1) chain] map:^TRCarType*(id i) {
        return [[[[_carTypes chain] filter:^BOOL(TRCarType* _) {
            return !([((TRCarType*)(_)) isEngine]);
        }] randomItem] get];
    }] prepend:(@[engine])] toArray];
}

- (NSUInteger)generateSpeed {
    return ((NSUInteger)(unumi([[_speed randomItem] get])));
}

- (ODClassType*)type {
    return [TRTrainGenerator type];
}

+ (ODClassType*)type {
    return _TRTrainGenerator_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTrainGenerator* o = ((TRTrainGenerator*)(other));
    return self.trainType == o.trainType && [self.carsCount isEqual:o.carsCount] && [self.speed isEqual:o.speed] && [self.carTypes isEqual:o.carTypes];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.trainType ordinal];
    hash = hash * 31 + [self.carsCount hash];
    hash = hash * 31 + [self.speed hash];
    hash = hash * 31 + [self.carTypes hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"trainType=%@", self.trainType];
    [description appendFormat:@", carsCount=%@", self.carsCount];
    [description appendFormat:@", speed=%@", self.speed];
    [description appendFormat:@", carTypes=%@", self.carTypes];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTrainSoundData
static ODClassType* _TRTrainSoundData_type;
@synthesize chooCounter = _chooCounter;
@synthesize toNextChoo = _toNextChoo;
@synthesize lastTile = _lastTile;
@synthesize lastX = _lastX;

+ (instancetype)trainSoundData {
    return [[TRTrainSoundData alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _chooCounter = 0;
        _toNextChoo = 0.0;
        _lastTile = GEVec2iMake(0, 0);
        _lastX = 0.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainSoundData class]) _TRTrainSoundData_type = [ODClassType classTypeWithCls:[TRTrainSoundData class]];
}

- (void)nextChoo {
    if(_chooCounter == 0) {
        _toNextChoo = 0.03;
        _chooCounter = 1;
    } else {
        if(_chooCounter == 1) {
            _chooCounter = 2;
            _toNextChoo = 0.15;
        } else {
            if(_chooCounter == 2) {
                _toNextChoo = 0.03;
                _chooCounter = 3;
            } else {
                if(_chooCounter == 3) _chooCounter = 0;
            }
        }
    }
}

- (void)nextHead:(TRRailPoint)head {
    _toNextChoo -= floatAbs(_lastX - head.x);
    _lastX = head.x;
}

- (ODClassType*)type {
    return [TRTrainSoundData type];
}

+ (ODClassType*)type {
    return _TRTrainSoundData_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


