#import "TRTrain.h"

#import "TRRailroad.h"
#import "TRLevel.h"
#import "TRRailPoint.h"
#import "EGMapIso.h"
#import "TRCity.h"
#import "TRCar.h"
@implementation TRTrainType{
    BOOL(^_obstacleProcessor)(TRLevel*, TRTrain*, TRObstacle*);
}
static TRTrainType* _TRTrainType_simple;
static TRTrainType* _TRTrainType_crazy;
static TRTrainType* _TRTrainType_fast;
static TRTrainType* _TRTrainType_repairer;
static NSArray* _TRTrainType_values;
@synthesize obstacleProcessor = _obstacleProcessor;

+ (id)trainTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name obstacleProcessor:(BOOL(^)(TRLevel*, TRTrain*, TRObstacle*))obstacleProcessor {
    return [[TRTrainType alloc] initWithOrdinal:ordinal name:name obstacleProcessor:obstacleProcessor];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name obstacleProcessor:(BOOL(^)(TRLevel*, TRTrain*, TRObstacle*))obstacleProcessor {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _obstacleProcessor = obstacleProcessor;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTrainType_simple = [TRTrainType trainTypeWithOrdinal:0 name:@"simple" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) [level destroyTrain:train];
        return NO;
    }];
    _TRTrainType_crazy = [TRTrainType trainTypeWithOrdinal:1 name:@"crazy" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType != TRObstacleType.light) {
            if(o.obstacleType == TRObstacleType.end) {
                TRRailPoint* point = [train head];
                if(!([level.map isFullTile:point.tile]) && !([level.map isFullTile:[point nextTile]])) {
                    return NO;
                } else {
                    [level.railroad addDamageAtPoint:point];
                    [level destroyTrain:train];
                    return NO;
                }
            } else {
                [level.railroad addDamageAtPoint:[train head]];
                [level destroyTrain:train];
                return NO;
            }
        } else {
            return YES;
        }
    }];
    _TRTrainType_fast = [TRTrainType trainTypeWithOrdinal:2 name:@"fast" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.aSwitch) {
            [level.railroad addDamageAtPoint:o.point];
            [level destroyTrain:train];
        } else {
            if(o.obstacleType == TRObstacleType.damage) [level destroyTrain:train];
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


@implementation TRTrain{
    __weak TRLevel* _level;
    TRTrainType* _trainType;
    TRCityColor* _color;
    id<CNSeq>(^___cars)(TRTrain*);
    NSUInteger _speed;
    id _viewData;
    id _soundData;
    TRRailPoint* __head;
    BOOL _back;
    id<CNSeq> _cars;
    CGFloat _length;
    CGFloat _speedFloat;
    BOOL _isDying;
    BOOL(^_carsObstacleProcessor)(TRObstacle*);
    CGFloat __time;
}
static ODClassType* _TRTrain_type;
@synthesize level = _level;
@synthesize trainType = _trainType;
@synthesize color = _color;
@synthesize __cars = ___cars;
@synthesize speed = _speed;
@synthesize viewData = _viewData;
@synthesize soundData = _soundData;
@synthesize cars = _cars;
@synthesize speedFloat = _speedFloat;
@synthesize isDying = _isDying;

+ (id)trainWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color __cars:(id<CNSeq>(^)(TRTrain*))__cars speed:(NSUInteger)speed {
    return [[TRTrain alloc] initWithLevel:level trainType:trainType color:color __cars:__cars speed:speed];
}

- (id)initWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color __cars:(id<CNSeq>(^)(TRTrain*))__cars speed:(NSUInteger)speed {
    self = [super init];
    if(self) {
        _level = level;
        _trainType = trainType;
        _color = color;
        ___cars = __cars;
        _speed = speed;
        _viewData = nil;
        _soundData = nil;
        _back = NO;
        _cars = ___cars(self);
        _length = unumf([[_cars chain] foldStart:@0.0 by:^id(id r, TRCar* car) {
            return numf(((TRCar*)(car)).carType.fullLength + unumf(r));
        }]);
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
    _TRTrain_type = [ODClassType classTypeWithCls:[TRTrain class]];
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

- (TRRailPoint*)head {
    return __head;
}

- (void)setHead:(TRRailPoint*)head {
    __head = head;
    [self calculateCarPositions];
}

- (void)calculateCarPositions {
    __block TRRailPoint* frontConnector = [__head invert];
    [[self directedCars] forEach:^void(TRCar* car) {
        TRCarType* tp = ((TRCar*)(car)).carType;
        CGFloat fl = tp.startToWheel;
        CGFloat bl = tp.wheelToEnd;
        TRRailPoint* head = [[_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:((_back) ? bl : fl) point:frontConnector] addErrorToPoint];
        TRRailPoint* tail = [[_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:tp.betweenWheels point:head] addErrorToPoint];
        TRRailPoint* backConnector = [[_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:((_back) ? fl : bl) point:tail] addErrorToPoint];
        [((TRCar*)(car)) setPosition:((_back) ? [TRCarPosition carPositionWithFrontConnector:backConnector head:tail tail:head backConnector:frontConnector] : [TRCarPosition carPositionWithFrontConnector:frontConnector head:head tail:tail backConnector:backConnector])];
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
    [self correctCorrection:[_level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return _weakSelf.trainType.obstacleProcessor(_weakSelf.level, _weakSelf, _);
    } forLength:delta * _speedFloat point:__head]];
    __time += delta;
}

- (id<CNSeq>)directedCars {
    if(_back) return [[[_cars chain] reverse] toArray];
    else return _cars;
}

- (void)correctCorrection:(TRRailPointCorrection*)correction {
    if(!(eqf(correction.error, 0.0))) {
        BOOL isMoveToCity = [self isMoveToCityForPoint:correction.point];
        if(!(isMoveToCity) || correction.error >= _length - 0.5) {
            if(isMoveToCity && (_color == TRCityColor.grey || ((TRCity*)([[_level cityForTile:correction.point.tile] get])).color == _color)) {
                if(correction.error >= _length + 0.5) [_level arrivedTrain:self];
                else __head = [correction addErrorToPoint];
            } else {
                _back = !(_back);
                TRCar* lastCar = [[self directedCars] head];
                __head = ((_back) ? [lastCar position].backConnector : [lastCar position].frontConnector);
            }
        } else {
            __head = [correction addErrorToPoint];
        }
    } else {
        __head = correction.point;
    }
    [self calculateCarPositions];
}

- (BOOL)isInTile:(GEVec2i)tile {
    return [[_cars chain] existsWhere:^BOOL(TRCar* car) {
        return [[((TRCar*)(car)) position] isInTile:tile];
    }];
}

- (BOOL)isMoveToCityForPoint:(TRRailPoint*)point {
    return !([_level.map isFullTile:point.tile]) && !([_level.map isFullTile:[point nextTile]]);
}

- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch {
    GEVec2i tile = theSwitch.tile;
    GEVec2i nextTile = [theSwitch.connector nextTile:tile];
    TRRailPoint* rp11 = [theSwitch railPoint1];
    TRRailPoint* rp12 = [rp11 addX:0.3];
    TRRailPoint* rp21 = [theSwitch railPoint2];
    TRRailPoint* rp22 = [rp21 addX:0.3];
    return [[_cars findWhere:^BOOL(TRCar* car) {
        TRCarPosition* p = [((TRCar*)(car)) position];
        return (GEVec2iEq(p.frontConnector.tile, tile) && GEVec2iEq(p.backConnector.tile, nextTile)) || (GEVec2iEq(p.frontConnector.tile, nextTile) && GEVec2iEq(p.backConnector.tile, tile)) || [p.frontConnector betweenA:rp11 b:rp12] || [p.backConnector betweenA:rp21 b:rp22];
    }] isDefined];
}

- (void)dealloc {
    [CNLog applyText:@"Dealloc train"];
}

- (ODClassType*)type {
    return [TRTrain type];
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

+ (id)trainGeneratorWithTrainType:(TRTrainType*)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes {
    return [[TRTrainGenerator alloc] initWithTrainType:trainType carsCount:carsCount speed:speed carTypes:carTypes];
}

- (id)initWithTrainType:(TRTrainType*)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes {
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
    _TRTrainGenerator_type = [ODClassType classTypeWithCls:[TRTrainGenerator class]];
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
    return self.trainType == o.trainType && self.carsCount == o.carsCount && self.speed == o.speed && [self.carTypes isEqual:o.carTypes];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.trainType ordinal];
    hash = hash * 31 + 0;
    hash = hash * 31 + 0;
    hash = hash * 31 + [self.carTypes hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"trainType=%@", self.trainType];
    [description appendFormat:@", carsCount=[]"];
    [description appendFormat:@", speed=[]"];
    [description appendFormat:@", carTypes=%@", self.carTypes];
    [description appendString:@">"];
    return description;
}

@end


