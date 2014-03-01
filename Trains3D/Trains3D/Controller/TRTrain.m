#import "TRTrain.h"

#import "TRRailroad.h"
#import "TRLevel.h"
#import "EGMapIso.h"
#import "TRCity.h"
#import "TRCar.h"
#import "EGDynamicWorld.h"
#import "TRSmoke.h"
@implementation TRTrainType{
    BOOL(^_obstacleProcessor)(TRLevel*, TRTrain*, TRObstacle*);
}
static TRTrainType* _TRTrainType_simple;
static TRTrainType* _TRTrainType_crazy;
static TRTrainType* _TRTrainType_fast;
static TRTrainType* _TRTrainType_repairer;
static NSArray* _TRTrainType_values;
@synthesize obstacleProcessor = _obstacleProcessor;

+ (instancetype)trainTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name obstacleProcessor:(BOOL(^)(TRLevel*, TRTrain*, TRObstacle*))obstacleProcessor {
    return [[TRTrainType alloc] initWithOrdinal:ordinal name:name obstacleProcessor:obstacleProcessor];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name obstacleProcessor:(BOOL(^)(TRLevel*, TRTrain*, TRObstacle*))obstacleProcessor {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _obstacleProcessor = obstacleProcessor;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTrainType_simple = [TRTrainType trainTypeWithOrdinal:0 name:@"simple" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) [level destroyTrain:[TRTrainActor trainActorWith_train:train]];
        return NO;
    }];
    _TRTrainType_crazy = [TRTrainType trainTypeWithOrdinal:1 name:@"crazy" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType != TRObstacleType.light) {
            if(o.obstacleType == TRObstacleType.end) {
                TRRailPoint point = [train head];
                if(!([level.map isFullTile:point.tile]) && !([level.map isFullTile:trRailPointNextTile(point)])) {
                    return NO;
                } else {
                    [level.railroad addDamageAtPoint:point];
                    [level destroyTrain:[TRTrainActor trainActorWith_train:train]];
                    return NO;
                }
            } else {
                [level.railroad addDamageAtPoint:[train head]];
                [level destroyTrain:[TRTrainActor trainActorWith_train:train]];
                return NO;
            }
        } else {
            return YES;
        }
    }];
    _TRTrainType_fast = [TRTrainType trainTypeWithOrdinal:2 name:@"fast" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.aSwitch) {
            [level.railroad addDamageAtPoint:o.point];
            [level destroyTrain:[TRTrainActor trainActorWith_train:train]];
        } else {
            if(o.obstacleType == TRObstacleType.damage) [level destroyTrain:[TRTrainActor trainActorWith_train:train]];
        }
        return NO;
    }];
    _TRTrainType_repairer = [TRTrainType trainTypeWithOrdinal:3 name:@"repairer" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
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


@implementation TRTrainActor{
    TRTrain* __train;
}
static ODClassType* _TRTrainActor_type;
@synthesize _train = __train;

+ (instancetype)trainActorWith_train:(TRTrain*)_train {
    return [[TRTrainActor alloc] initWith_train:_train];
}

- (instancetype)initWith_train:(TRTrain*)_train {
    self = [super init];
    if(self) __train = _train;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainActor class]) _TRTrainActor_type = [ODClassType classTypeWithCls:[TRTrainActor class]];
}

- (TRTrainType*)trainType {
    return __train.trainType;
}

- (TRCityColor*)color {
    return __train.color;
}

- (NSUInteger)speed {
    return __train.speed;
}

- (NSUInteger)carsCount {
    return [__train.cars count];
}

- (CGFloat)time {
    return [__train time];
}

- (id<CNSeq>)kinematicBodies {
    return [[[__train.cars chain] map:^EGRigidBody*(TRCar* _) {
        return ((TRCar*)(_)).kinematicBody;
    }] toArray];
}

- (CNFuture*)dynamicBodies {
    __weak TRTrainActor* _weakSelf = self;
    return [self futureF:^id<CNSeq>() {
        return [[[_weakSelf._train.cars chain] map:^EGRigidBody*(TRCar* _) {
            return [((TRCar*)(_)) dynamicBody];
        }] toArray];
    }];
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    __weak TRTrainActor* _weakSelf = self;
    return [self futureF:^id() {
        [_weakSelf._train updateWithDelta:delta];
        return nil;
    }];
}

- (CNFuture*)setHead:(TRRailPoint)head {
    __weak TRTrainActor* _weakSelf = self;
    return [self futureF:^id() {
        [_weakSelf._train setHead:head];
        return nil;
    }];
}

- (CNFuture*)lockedTiles {
    __weak TRTrainActor* _weakSelf = self;
    return [self futureF:^NSMutableSet*() {
        NSMutableSet* ret = [NSMutableSet mutableSet];
        [_weakSelf._train.cars forEach:^void(TRCar* car) {
            [ret appendItem:wrap(GEVec2i, [((TRCar*)(car)) position].head.tile)];
            [ret appendItem:wrap(GEVec2i, [((TRCar*)(car)) position].tail.tile)];
        }];
        return ret;
    }];
}

- (CNFuture*)isLockedASwitch:(TRSwitch*)aSwitch {
    __weak TRTrainActor* _weakSelf = self;
    return [self futureF:^id() {
        return numb([_weakSelf._train isLockedTheSwitch:aSwitch]);
    }];
}

- (CNFuture*)isLockedRail:(TRRail*)rail {
    __weak TRTrainActor* _weakSelf = self;
    return [self futureF:^id() {
        return numb([_weakSelf._train isLockedRail:rail]);
    }];
}

- (CNFuture*)startFromCity:(TRCity*)city {
    __weak TRTrainActor* _weakSelf = self;
    return [self futureF:^id() {
        [_weakSelf._train startFromCity:city];
        return nil;
    }];
}

- (CNFuture*)die {
    __weak TRTrainActor* _weakSelf = self;
    return [self promptF:^id() {
        _weakSelf._train.isDying = YES;
        return nil;
    }];
}

- (CNFuture*)isDying {
    __weak TRTrainActor* _weakSelf = self;
    return [self promptF:^id() {
        return numb(_weakSelf._train.isDying);
    }];
}

- (CNFuture*)carPositions {
    __weak TRTrainActor* _weakSelf = self;
    return [self promptF:^id<CNSeq>() {
        return [[[_weakSelf._train.cars chain] map:^TRCarPosition*(TRCar* _) {
            return [((TRCar*)(_)) position];
        }] toArray];
    }];
}

- (CNFuture*)carDynamicMatrix {
    __weak TRTrainActor* _weakSelf = self;
    return [self promptF:^id<CNSeq>() {
        return [[[_weakSelf._train.cars chain] map:^CNTuple*(TRCar* car) {
            return tuple(((TRCar*)(car)).carType, [((TRCar*)(car)) dynamicBody].matrix);
        }] toArray];
    }];
}

- (CNFuture*)writeKinematicMatrix {
    __weak TRTrainActor* _weakSelf = self;
    return [self promptF:^id() {
        [_weakSelf._train.cars forEach:^void(TRCar* _) {
            [((TRCar*)(_)) writeKinematicMatrix];
        }];
        return nil;
    }];
}

- (CNFuture*)smokeDataCreator:(id(^)(TRSmoke*))creator {
    __weak TRTrainActor* _weakSelf = self;
    return [self promptF:^id() {
        if(_weakSelf._train.viewData == nil) _weakSelf._train.viewData = creator(_weakSelf._train.smoke);
        return ((id)(_weakSelf._train.viewData));
    }];
}

- (ODClassType*)type {
    return [TRTrainActor type];
}

+ (ODClassType*)type {
    return _TRTrainActor_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTrainActor* o = ((TRTrainActor*)(other));
    return [self._train isEqual:o._train];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self._train hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"_train=%@", self._train];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTrain{
    __weak TRLevel* _level;
    TRTrainType* _trainType;
    TRCityColor* _color;
    id<CNSeq>(^___cars)(TRTrain*);
    NSUInteger _speed;
    id _viewData;
    TRTrainSoundData* _soundData;
    TRRailPoint __head;
    BOOL _back;
    id<CNSeq> _cars;
    TRSmoke* _smoke;
    CGFloat _length;
    CGFloat _speedFloat;
    BOOL _isDying;
    BOOL(^_carsObstacleProcessor)(TRObstacle*);
    CGFloat __time;
}
static CNNotificationHandle* _TRTrain_chooNotification;
static ODClassType* _TRTrain_type;
@synthesize level = _level;
@synthesize trainType = _trainType;
@synthesize color = _color;
@synthesize __cars = ___cars;
@synthesize speed = _speed;
@synthesize viewData = _viewData;
@synthesize soundData = _soundData;
@synthesize cars = _cars;
@synthesize smoke = _smoke;
@synthesize speedFloat = _speedFloat;
@synthesize isDying = _isDying;

+ (instancetype)trainWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color __cars:(id<CNSeq>(^)(TRTrain*))__cars speed:(NSUInteger)speed {
    return [[TRTrain alloc] initWithLevel:level trainType:trainType color:color __cars:__cars speed:speed];
}

- (instancetype)initWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color __cars:(id<CNSeq>(^)(TRTrain*))__cars speed:(NSUInteger)speed {
    self = [super init];
    if(self) {
        _level = level;
        _trainType = trainType;
        _color = color;
        ___cars = __cars;
        _speed = speed;
        _viewData = nil;
        _soundData = [TRTrainSoundData trainSoundData];
        _back = NO;
        _cars = ___cars(self);
        _smoke = [TRSmoke smokeWithTrain:self weather:_level.weather];
        _length = unumf(([[_cars chain] foldStart:@0.0 by:^id(id r, TRCar* car) {
            return numf(((TRCar*)(car)).carType.fullLength + unumf(r));
        }]));
        _speedFloat = 0.01 * _speed;
        _isDying = NO;
        _carsObstacleProcessor = ^BOOL(TRObstacle* o) {
            return o.obstacleType == TRObstacleType.light;
        };
        __time = 0.0;
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

- (BOOL)isBack {
    return _back;
}

- (void)startFromCity:(TRCity*)city {
    __head = [city startPoint];
    [self calculateCarPositions];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<Train: %@, %@>", _trainType, _color];
}

- (TRRailPoint)head {
    return __head;
}

- (void)setHead:(TRRailPoint)head {
    __head = head;
    [self calculateCarPositions];
}

- (void)calculateCarPositions {
    __block TRRailPoint frontConnector = trRailPointInvert(__head);
    [[self directedCars] forEach:^void(TRCar* car) {
        TRCarType* tp = ((TRCar*)(car)).carType;
        CGFloat fl = tp.startToWheel;
        CGFloat bl = tp.wheelToEnd;
        TRRailPoint head = trRailPointCorrectionAddErrorToPoint([_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:((_back) ? bl : fl) point:frontConnector]);
        TRRailPoint tail = trRailPointCorrectionAddErrorToPoint([_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:tp.betweenWheels point:head]);
        TRRailPoint backConnector = trRailPointCorrectionAddErrorToPoint([_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:((_back) ? fl : bl) point:tail]);
        [((TRCar*)(car)) setPosition:((_back) ? [TRCarPosition applyCarType:((TRCar*)(car)).carType frontConnector:backConnector head:tail tail:head backConnector:frontConnector] : [TRCarPosition applyCarType:((TRCar*)(car)).carType frontConnector:frontConnector head:head tail:tail backConnector:backConnector])];
        frontConnector = backConnector;
    }];
}

- (GEVec2)movePoint:(GEVec2)point length:(CGFloat)length {
    return GEVec2Make(point.x, point.y + length);
}

- (CGFloat)time {
    return __time;
}

- (void)updateWithDelta:(CGFloat)delta {
    __weak TRTrain* _weakSelf = self;
    if(!(_isDying)) [self correctCorrection:[_level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return _weakSelf.trainType.obstacleProcessor(_weakSelf.level, _weakSelf, _);
    } forLength:delta * _speedFloat point:__head]];
    __time += delta;
    if(_soundData.chooCounter > 0 && _soundData.toNextChoo <= 0.0) {
        [_TRTrain_chooNotification postSender:self];
        [_soundData nextChoo];
    } else {
        if(!(GEVec2iEq(__head.tile, _soundData.lastTile))) {
            [_TRTrain_chooNotification postSender:self];
            _soundData.lastTile = __head.tile;
            _soundData.lastX = __head.x;
            [_soundData nextChoo];
        } else {
            if(_soundData.chooCounter > 0) [_soundData nextHead:__head];
        }
    }
    [_smoke updateWithDelta:delta];
}

- (id<CNSeq>)directedCars {
    if(_back) return [[[_cars chain] reverse] toArray];
    else return _cars;
}

- (void)correctCorrection:(TRRailPointCorrection)correction {
    if(!(eqf(correction.error, 0.0))) {
        BOOL isMoveToCity = [self isMoveToCityForPoint:correction.point];
        if(!(isMoveToCity) || correction.error >= _length - 0.5) {
            if(isMoveToCity && (_color == TRCityColor.grey || ((TRCity*)([[_level cityForTile:correction.point.tile] get])).color == _color)) {
                if(correction.error >= _length + 0.7) [_level arrivedTrain:[TRTrainActor trainActorWith_train:self]];
                else __head = trRailPointCorrectionAddErrorToPoint(correction);
            } else {
                _back = !(_back);
                TRCar* lastCar = [[self directedCars] head];
                __head = ((_back) ? [lastCar position].backConnector : [lastCar position].frontConnector);
            }
        } else {
            __head = trRailPointCorrectionAddErrorToPoint(correction);
        }
    } else {
        __head = correction.point;
    }
    [self calculateCarPositions];
}

- (BOOL)isMoveToCityForPoint:(TRRailPoint)point {
    return !([_level.map isFullTile:point.tile]) && !([_level.map isFullTile:trRailPointNextTile(point)]);
}

- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch {
    GEVec2i tile = theSwitch.tile;
    GEVec2i nextTile = [theSwitch.connector nextTile:tile];
    TRRailPoint rp11 = [theSwitch railPoint1];
    TRRailPoint rp12 = trRailPointAddX(rp11, 0.3);
    TRRailPoint rp21 = [theSwitch railPoint2];
    TRRailPoint rp22 = trRailPointAddX(rp21, 0.3);
    return [[_cars findWhere:^BOOL(TRCar* car) {
        TRCarPosition* p = [((TRCar*)(car)) position];
        return (GEVec2iEq(p.frontConnector.tile, tile) && GEVec2iEq(p.backConnector.tile, nextTile)) || (GEVec2iEq(p.frontConnector.tile, nextTile) && GEVec2iEq(p.backConnector.tile, tile)) || trRailPointBetweenAB(p.frontConnector, rp11, rp12) || trRailPointBetweenAB(p.backConnector, rp21, rp22);
    }] isDefined];
}

- (BOOL)isLockedRail:(TRRail*)rail {
    return [[_cars findWhere:^BOOL(TRCar* car) {
        return [[((TRCar*)(car)) position] isOnRail:rail];
    }] isDefined];
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
    return [self.level isEqual:o.level] && self.trainType == o.trainType && self.color == o.color && [self.__cars isEqual:o.__cars] && self.speed == o.speed;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    hash = hash * 31 + [self.trainType ordinal];
    hash = hash * 31 + [self.color ordinal];
    hash = hash * 31 + [self.__cars hash];
    hash = hash * 31 + self.speed;
    return hash;
}

@end


@implementation TRTrainGenerator{
    TRTrainType* _trainType;
    id<CNSeq> _carsCount;
    id<CNSeq> _speed;
    id<CNSeq> _carTypes;
}
static ODClassType* _TRTrainGenerator_type;
@synthesize trainType = _trainType;
@synthesize carsCount = _carsCount;
@synthesize speed = _speed;
@synthesize carTypes = _carTypes;

+ (instancetype)trainGeneratorWithTrainType:(TRTrainType*)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes {
    return [[TRTrainGenerator alloc] initWithTrainType:trainType carsCount:carsCount speed:speed carTypes:carTypes];
}

- (instancetype)initWithTrainType:(TRTrainType*)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes {
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

- (id<CNSeq>)generateCarsForTrain:(TRTrain*)train {
    NSInteger count = unumi([[_carsCount randomItem] get]);
    TRCar* engine = [TRCar carWithTrain:train carType:[[[[_carTypes chain] filter:^BOOL(TRCarType* _) {
        return [((TRCarType*)(_)) isEngine];
    }] randomItem] get]];
    if(count <= 1) return (@[engine]);
    else return [[[[intRange(count - 1) chain] map:^TRCar*(id i) {
        return [TRCar carWithTrain:train carType:[[[[_carTypes chain] filter:^BOOL(TRCarType* _) {
            return !([((TRCarType*)(_)) isEngine]);
        }] randomItem] get]];
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


@implementation TRTrainSoundData{
    NSInteger _chooCounter;
    CGFloat _toNextChoo;
    GEVec2i _lastTile;
    CGFloat _lastX;
}
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


