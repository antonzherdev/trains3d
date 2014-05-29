#import "TRTrain.h"

#import "TRLevel.h"
#import "EGMapIso.h"
#import "CNObserver.h"
#import "CNChain.h"
#import "CNFuture.h"
@implementation TRTrainType{
    BOOL(^_obstacleProcessor)(TRLevel*, TRTrain*, TRRailPoint, TRObstacle*);
}
@synthesize obstacleProcessor = _obstacleProcessor;

+ (instancetype)trainTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name obstacleProcessor:(BOOL(^)(TRLevel*, TRTrain*, TRRailPoint, TRObstacle*))obstacleProcessor {
    return [[TRTrainType alloc] initWithOrdinal:ordinal name:name obstacleProcessor:obstacleProcessor];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name obstacleProcessor:(BOOL(^)(TRLevel*, TRTrain*, TRRailPoint, TRObstacle*))obstacleProcessor {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _obstacleProcessor = [obstacleProcessor copy];
    
    return self;
}

+ (void)load {
    [super load];
    TRTrainType_simple_Desc = [TRTrainType trainTypeWithOrdinal:0 name:@"simple" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRRailPoint point, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType_damage) [level destroyTrain:train];
        return NO;
    }];
    TRTrainType_crazy_Desc = [TRTrainType trainTypeWithOrdinal:1 name:@"crazy" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRRailPoint point, TRObstacle* o) {
        if(o.obstacleType != TRObstacleType_light) {
            if(o.obstacleType == TRObstacleType_end) {
                if(!([level.map isFullTile:point.tile]) && !([level.map isFullTile:trRailPointNextTile(point)])) {
                    return NO;
                } else {
                    [level destroyTrain:train railPoint:wrap(TRRailPoint, point)];
                    return NO;
                }
            } else {
                [level destroyTrain:train railPoint:wrap(TRRailPoint, point)];
                return NO;
            }
        } else {
            return YES;
        }
    }];
    TRTrainType_fast_Desc = [TRTrainType trainTypeWithOrdinal:2 name:@"fast" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRRailPoint point, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType_switch) {
            [level destroyTrain:train railPoint:wrap(TRRailPoint, o.point)];
        } else {
            if(o.obstacleType == TRObstacleType_damage) [level destroyTrain:train];
        }
        return NO;
    }];
    TRTrainType_repairer_Desc = [TRTrainType trainTypeWithOrdinal:3 name:@"repairer" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRRailPoint point, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType_damage) {
            [level fixDamageAtPoint:o.point];
            return YES;
        } else {
            return NO;
        }
    }];
    TRTrainType_Values[0] = TRTrainType_simple_Desc;
    TRTrainType_Values[1] = TRTrainType_crazy_Desc;
    TRTrainType_Values[2] = TRTrainType_fast_Desc;
    TRTrainType_Values[3] = TRTrainType_repairer_Desc;
}

+ (NSArray*)values {
    return (@[TRTrainType_simple_Desc, TRTrainType_crazy_Desc, TRTrainType_fast_Desc, TRTrainType_repairer_Desc]);
}

@end

@implementation TRTrainState
static CNClassType* _TRTrainState_type;
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
    if(self == [TRTrainState class]) _TRTrainState_type = [CNClassType classTypeWithCls:[TRTrainState class]];
}

- (NSArray*)carStates {
    @throw @"Method carStates is abstract";
}

- (BOOL)isDying {
    @throw @"Method isDying is abstract";
}

- (NSString*)description {
    return [NSString stringWithFormat:@"TrainState(%@, %f)", _train, _time];
}

- (CNClassType*)type {
    return [TRTrainState type];
}

+ (CNClassType*)type {
    return _TRTrainState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRDieTrainState
static CNClassType* _TRDieTrainState_type;
@synthesize carStates = _carStates;

+ (instancetype)dieTrainStateWithTrain:(TRTrain*)train time:(CGFloat)time carStates:(NSArray*)carStates {
    return [[TRDieTrainState alloc] initWithTrain:train time:time carStates:carStates];
}

- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time carStates:(NSArray*)carStates {
    self = [super initWithTrain:train time:time];
    if(self) _carStates = carStates;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRDieTrainState class]) _TRDieTrainState_type = [CNClassType classTypeWithCls:[TRDieTrainState class]];
}

- (BOOL)isDying {
    return YES;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"DieTrainState(%@)", _carStates];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRDieTrainState class]])) return NO;
    TRDieTrainState* o = ((TRDieTrainState*)(to));
    return [_carStates isEqual:o.carStates];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_carStates hash];
    return hash;
}

- (CNClassType*)type {
    return [TRDieTrainState type];
}

+ (CNClassType*)type {
    return _TRDieTrainState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRLiveTrainState
static CNClassType* _TRLiveTrainState_type;
@synthesize head = _head;
@synthesize isBack = _isBack;
@synthesize carStates = _carStates;

+ (instancetype)liveTrainStateWithTrain:(TRTrain*)train time:(CGFloat)time head:(TRRailPoint)head isBack:(BOOL)isBack carStates:(NSArray*)carStates {
    return [[TRLiveTrainState alloc] initWithTrain:train time:time head:head isBack:isBack carStates:carStates];
}

- (instancetype)initWithTrain:(TRTrain*)train time:(CGFloat)time head:(TRRailPoint)head isBack:(BOOL)isBack carStates:(NSArray*)carStates {
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
    if(self == [TRLiveTrainState class]) _TRLiveTrainState_type = [CNClassType classTypeWithCls:[TRLiveTrainState class]];
}

- (BOOL)isDying {
    return NO;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"LiveTrainState(%@, %d, %@)", trRailPointDescription(_head), _isBack, _carStates];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRLiveTrainState class]])) return NO;
    TRLiveTrainState* o = ((TRLiveTrainState*)(to));
    return trRailPointIsEqualTo(_head, o.head) && _isBack == o.isBack && [_carStates isEqual:o.carStates];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + trRailPointHash(_head);
    hash = hash * 31 + _isBack;
    hash = hash * 31 + [_carStates hash];
    return hash;
}

- (CNClassType*)type {
    return [TRLiveTrainState type];
}

+ (CNClassType*)type {
    return _TRLiveTrainState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRTrain
static CNSignal* _TRTrain_choo;
static CNClassType* _TRTrain_type;
@synthesize level = _level;
@synthesize trainType = _trainType;
@synthesize color = _color;
@synthesize carTypes = _carTypes;
@synthesize speed = _speed;
@synthesize speedFloat = _speedFloat;
@synthesize length = _length;
@synthesize cars = _cars;

+ (instancetype)trainWithLevel:(TRLevel*)level trainType:(TRTrainTypeR)trainType color:(TRCityColorR)color carTypes:(NSArray*)carTypes speed:(NSUInteger)speed {
    return [[TRTrain alloc] initWithLevel:level trainType:trainType color:color carTypes:carTypes speed:speed];
}

- (instancetype)initWithLevel:(TRLevel*)level trainType:(TRTrainTypeR)trainType color:(TRCityColorR)color carTypes:(NSArray*)carTypes speed:(NSUInteger)speed {
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
        __isDying = NO;
        __time = 0.0;
        __carStates = ((NSArray*)((@[])));
        _speedFloat = 0.01 * speed;
        _length = unumf(([[carTypes chain] foldStart:@0.0 by:^id(id r, TRCarType* car) {
            return numf(TRCarType_Values[((TRCarTypeR)([car ordinal]))].fullLength + unumf(r));
        }]));
        _cars = ({
            __block NSInteger i = 0;
            [[[carTypes chain] mapF:^TRCar*(TRCarType* tp) {
                TRCar* car = [TRCar carWithTrain:self carType:((TRCarTypeR)([tp ordinal])) number:((NSUInteger)(i))];
                i++;
                return car;
            }] toArray];
        });
        _carsObstacleProcessor = ^BOOL(TRObstacle* o) {
            return o.obstacleType == TRObstacleType_light;
        };
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrain class]) {
        _TRTrain_type = [CNClassType classTypeWithCls:[TRTrain class]];
        _TRTrain_choo = [CNSignal signal];
    }
}

- (CNFuture*)state {
    return [self promptF:^TRTrainState*() {
        if(__isDying) return ((TRTrainState*)([TRDieTrainState dieTrainStateWithTrain:self time:__time carStates:((NSArray*)(__carStates))]));
        else return ((TRTrainState*)([TRLiveTrainState liveTrainStateWithTrain:self time:__time head:__head isBack:__isBack carStates:((NSArray*)(__carStates))]));
    }];
}

- (CNFuture*)restoreState:(TRTrainState*)state {
    return [self promptF:^id() {
        __time = state.time;
        __carStates = [state carStates];
        __isDying = [state isDying];
        if(!(__isDying)) {
            TRLiveTrainState* s = ((TRLiveTrainState*)(state));
            __head = s.head;
            __isBack = s.isBack;
        }
        return nil;
    }];
}

- (CNFuture*)startFromCity:(TRCity*)city {
    return [self lockAndOnSuccessFuture:[_level.railroad state] f:^id(TRRailroadState* rrState) {
        __head = [city startPoint];
        __isBack = NO;
        __isDying = NO;
        __time = 0.0;
        [self calculateCarPositionsRrState:rrState];
        return nil;
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<Train: %@, %@>", TRTrainType_Values[_trainType], TRCityColor_Values[_color]];
}

- (CNFuture*)setHead:(TRRailPoint)head {
    return [self lockAndOnSuccessFuture:[_level.railroad state] f:^id(TRRailroadState* rrState) {
        __head = head;
        [self calculateCarPositionsRrState:rrState];
        return nil;
    }];
}

- (CNFuture*)die {
    return [self promptF:^TRLiveTrainState*() {
        if(!(__isDying)) {
            __isDying = YES;
            return [TRLiveTrainState liveTrainStateWithTrain:self time:__time head:__head isBack:__isBack carStates:((NSArray*)(__carStates))];
        } else {
            return nil;
        }
    }];
}

- (CNFuture*)setDieCarStates:(NSArray*)dieCarStates {
    return [self promptF:^id() {
        __isDying = YES;
        __carStates = dieCarStates;
        return nil;
    }];
}

- (NSUInteger)carsCount {
    return [_carTypes count];
}

- (void)calculateCarPositionsRrState:(TRRailroadState*)rrState {
    __block TRRailPoint frontConnector = trRailPointInvert(__head);
    __carStates = [[[[[_cars chain] reverseWhen:__isBack] mapF:^TRLiveCarState*(TRCar* car) {
        TRCarTypeR tp = ((TRCar*)(car)).carType;
        CGFloat fl = TRCarType_Values[tp].startToWheel;
        CGFloat bl = TRCarType_Values[tp].wheelToEnd;
        TRRailPoint head = trRailPointCorrectionAddErrorToPoint([rrState moveWithObstacleProcessor:_carsObstacleProcessor forLength:((__isBack) ? bl : fl) point:frontConnector]);
        TRRailPoint tail = trRailPointCorrectionAddErrorToPoint([rrState moveWithObstacleProcessor:_carsObstacleProcessor forLength:TRCarType_Values[tp].betweenWheels point:head]);
        TRRailPoint backConnector = trRailPointCorrectionAddErrorToPoint([rrState moveWithObstacleProcessor:_carsObstacleProcessor forLength:((__isBack) ? fl : bl) point:tail]);
        TRRailPoint fc = frontConnector;
        frontConnector = backConnector;
        if(__isBack) return [TRLiveCarState applyCar:car frontConnector:backConnector head:tail tail:head backConnector:fc];
        else return [TRLiveCarState applyCar:car frontConnector:fc head:head tail:tail backConnector:backConnector];
    }] reverseWhen:__isBack] toArray];
}

- (GEVec2)movePoint:(GEVec2)point length:(CGFloat)length {
    return GEVec2Make(point.x, point.y + length);
}

- (CNFuture*)updateWithRrState:(TRRailroadState*)rrState delta:(CGFloat)delta {
    return [self futureF:^id() {
        if(!(__isDying)) [self correctRrState:rrState correction:[rrState moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
            return TRTrainType_Values[_trainType].obstacleProcessor(_level, self, __head, _);
        } forLength:delta * _speedFloat point:__head]];
        __time += delta;
        if(!(__isDying)) {
            if(__soundData.chooCounter > 0 && __soundData.toNextChoo <= 0.0) {
                [_TRTrain_choo postData:self];
                [__soundData nextChoo];
            } else {
                if(!(geVec2iIsEqualTo(__head.tile, __soundData.lastTile))) {
                    [_TRTrain_choo postData:self];
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
            if(isMoveToCity && (_color == TRCityColor_grey || ((TRCity*)(nonnil([_level cityForTile:correction.point.tile]))).color == _color)) {
                if(correction.error >= _length - 0.5) [_level possiblyArrivedTrain:self tile:correction.point.tile tailX:_length - correction.error];
                __head = trRailPointCorrectionAddErrorToPoint(correction);
            } else {
                __isBack = !(__isBack);
                TRLiveCarState* lastCar = ((TRLiveCarState*)(((TRCarState*)(nonnil(((__isBack) ? [__carStates last] : [__carStates head]))))));
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
        GEVec2i nextTile = [TRRailConnector_Values[theSwitch.connector] nextTile:tile];
        TRRailPoint rp11 = [theSwitch railPoint1];
        TRRailPoint rp12 = trRailPointAddX(rp11, 0.3);
        TRRailPoint rp21 = [theSwitch railPoint2];
        TRRailPoint rp22 = trRailPointAddX(rp21, 0.3);
        return numb(([((NSArray*)(__carStates)) existsWhere:^BOOL(TRLiveCarState* p) {
            return (geVec2iIsEqualTo(((TRLiveCarState*)(p)).frontConnector.tile, tile) && geVec2iIsEqualTo(((TRLiveCarState*)(p)).backConnector.tile, nextTile)) || (geVec2iIsEqualTo(((TRLiveCarState*)(p)).frontConnector.tile, nextTile) && geVec2iIsEqualTo(((TRLiveCarState*)(p)).backConnector.tile, tile)) || trRailPointBetweenAB(((TRLiveCarState*)(p)).frontConnector, rp11, rp12) || trRailPointBetweenAB(((TRLiveCarState*)(p)).backConnector, rp21, rp22);
        }]));
    }];
}

- (CNFuture*)lockedTiles {
    return [self futureF:^CNMHashSet*() {
        CNMHashSet* ret = [CNMHashSet hashSet];
        if(!(__isDying)) for(TRLiveCarState* p in ((NSArray*)(__carStates))) {
            [ret appendItem:wrap(GEVec2i, ((TRLiveCarState*)(p)).head.tile)];
            [ret appendItem:wrap(GEVec2i, ((TRLiveCarState*)(p)).tail.tile)];
        }
        return ret;
    }];
}

- (CNFuture*)isLockedRail:(TRRail*)rail {
    return [self futureF:^id() {
        return numb(!(__isDying) && [((NSArray*)(__carStates)) existsWhere:^BOOL(TRLiveCarState* car) {
            return [((TRLiveCarState*)(car)) isOnRail:rail];
        }]);
    }];
}

- (BOOL)isEqualTrain:(TRTrain*)train {
    return self == train;
}

- (NSUInteger)hash {
    return ((NSUInteger)(self));
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil) return NO;
    if([to isKindOfClass:[TRTrain class]]) return [self isEqualTrain:((TRTrain*)(to))];
    return NO;
}

- (CNClassType*)type {
    return [TRTrain type];
}

+ (CNSignal*)choo {
    return _TRTrain_choo;
}

+ (CNClassType*)type {
    return _TRTrain_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRTrainGenerator
static CNClassType* _TRTrainGenerator_type;
@synthesize trainType = _trainType;
@synthesize carsCount = _carsCount;
@synthesize speed = _speed;
@synthesize carTypes = _carTypes;

+ (instancetype)trainGeneratorWithTrainType:(TRTrainTypeR)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes {
    return [[TRTrainGenerator alloc] initWithTrainType:trainType carsCount:carsCount speed:speed carTypes:carTypes];
}

- (instancetype)initWithTrainType:(TRTrainTypeR)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes {
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
    if(self == [TRTrainGenerator class]) _TRTrainGenerator_type = [CNClassType classTypeWithCls:[TRTrainGenerator class]];
}

- (NSArray*)generateCarTypesSeed:(CNSeed*)seed {
    NSInteger count = unumi(nonnil([[_carsCount chain] randomItemSeed:seed]));
    TRCarTypeR engine = ((TRCarTypeR)([nonnil([[[_carTypes chain] filterWhen:^BOOL(TRCarType* _) {
        return [TRCarType_Values[((TRCarTypeR)([_ ordinal]))] isEngine];
    }] randomItem]) ordinal]));
    if(count <= 1) return ((NSArray*)((@[TRCarType_Values[engine]])));
    else return ((NSArray*)([[[[intRange(count - 1) chain] mapF:^TRCarType*(id i) {
        return TRCarType_Values[((TRCarTypeR)([nonnil([[[_carTypes chain] filterWhen:^BOOL(TRCarType* _) {
            return !([TRCarType_Values[((TRCarTypeR)([_ ordinal]))] isEngine]);
        }] randomItem]) ordinal]))];
    }] prependCollection:(@[TRCarType_Values[engine]])] toArray]));
}

- (NSUInteger)generateSpeedSeed:(CNSeed*)seed {
    return ((NSUInteger)(unumi(nonnil([[_speed chain] randomItemSeed:seed]))));
}

- (NSString*)description {
    return [NSString stringWithFormat:@"TrainGenerator(%@, %@, %@, %@)", TRTrainType_Values[_trainType], _carsCount, _speed, _carTypes];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRTrainGenerator class]])) return NO;
    TRTrainGenerator* o = ((TRTrainGenerator*)(to));
    return _trainType == o.trainType && [_carsCount isEqual:o.carsCount] && [_speed isEqual:o.speed] && [_carTypes isEqual:o.carTypes];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [TRTrainType_Values[_trainType] hash];
    hash = hash * 31 + [_carsCount hash];
    hash = hash * 31 + [_speed hash];
    hash = hash * 31 + [_carTypes hash];
    return hash;
}

- (CNClassType*)type {
    return [TRTrainGenerator type];
}

+ (CNClassType*)type {
    return _TRTrainGenerator_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRTrainSoundData
static CNClassType* _TRTrainSoundData_type;
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
    if(self == [TRTrainSoundData class]) _TRTrainSoundData_type = [CNClassType classTypeWithCls:[TRTrainSoundData class]];
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

- (NSString*)description {
    return @"TrainSoundData";
}

- (CNClassType*)type {
    return [TRTrainSoundData type];
}

+ (CNClassType*)type {
    return _TRTrainSoundData_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

