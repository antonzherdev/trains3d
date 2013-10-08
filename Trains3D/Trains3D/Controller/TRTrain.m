#import "TRTrain.h"

#import "TRRailroad.h"
#import "TRLevel.h"
#import "TRCity.h"
#import "TRRailPoint.h"
#import "TRCar.h"
#import "EGMapIso.h"
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
        if(o.obstacleType == TRObstacleType.damage) [level destroyTrain:train];
        return o.obstacleType == TRObstacleType.light;
    }];
    _TRTrainType_fast = [TRTrainType trainTypeWithOrdinal:2 name:@"fast" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage || o.obstacleType == TRObstacleType.aSwitch) [level destroyTrain:train];
        return NO;
    }];
    _TRTrainType_repairer = [TRTrainType trainTypeWithOrdinal:3 name:@"repairer" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) {
            [level.railroad fixDamageAtPoint:o.point];
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
    id<CNSeq>(^__cars)(TRTrain*);
    NSUInteger _speed;
    id _viewData;
    TRRailPoint* _head;
    BOOL _back;
    CNLazy* __lazy_cars;
    CGFloat _length;
    CGFloat _speedFloat;
    BOOL _isDying;
    BOOL(^_carsObstacleProcessor)(TRObstacle*);
}
static ODClassType* _TRTrain_type;
@synthesize level = _level;
@synthesize trainType = _trainType;
@synthesize color = _color;
@synthesize _cars = __cars;
@synthesize speed = _speed;
@synthesize viewData = _viewData;
@synthesize speedFloat = _speedFloat;
@synthesize isDying = _isDying;

+ (id)trainWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color _cars:(id<CNSeq>(^)(TRTrain*))_cars speed:(NSUInteger)speed {
    return [[TRTrain alloc] initWithLevel:level trainType:trainType color:color _cars:_cars speed:speed];
}

- (id)initWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color _cars:(id<CNSeq>(^)(TRTrain*))_cars speed:(NSUInteger)speed {
    self = [super init];
    __weak TRTrain* _weakSelf = self;
    if(self) {
        _level = level;
        _trainType = trainType;
        _color = color;
        __cars = _cars;
        _speed = speed;
        _viewData = nil;
        _back = NO;
        __lazy_cars = [CNLazy lazyWithF:^id<CNSeq>() {
            return _weakSelf._cars(self);
        }];
        _length = unumf([[[self cars] chain] foldStart:@0.0 by:^id(id r, TRCar* car) {
            return numf(car.carType.fullLength + unumf(r));
        }]);
        _speedFloat = 0.01 * _speed;
        _isDying = NO;
        _carsObstacleProcessor = ^BOOL(TRObstacle* o) {
            return o.obstacleType == TRObstacleType.light;
        };
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTrain_type = [ODClassType classTypeWithCls:[TRTrain class]];
}

- (id<CNSeq>)cars {
    return ((id<CNSeq>)([__lazy_cars get]));
}

- (BOOL)isBack {
    return _back;
}

- (void)startFromCity:(TRCity*)city {
    _head = [city startPoint];
    [self calculateCarPositions];
}

- (void)setHead:(TRRailPoint*)head {
    _head = head;
    [self calculateCarPositions];
}

- (void)calculateCarPositions {
    ((TRRailPoint*)([[[self directedCars] chain] foldStart:[_head invert] by:^TRRailPoint*(TRRailPoint* frontConnector, TRCar* car) {
        TRCarType* tp = car.carType;
        CGFloat fl = tp.startToWheel;
        CGFloat bl = tp.wheelToEnd;
        TRRailPoint* head = [[_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:((_back) ? bl : fl) point:frontConnector] addErrorToPoint];
        TRRailPoint* tail = [[_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:tp.betweenWheels point:head] addErrorToPoint];
        TRRailPoint* backConnector = [[_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:((_back) ? fl : bl) point:tail] addErrorToPoint];
        [car setPosition:((_back) ? [TRCarPosition carPositionWithFrontConnector:backConnector head:tail tail:head backConnector:frontConnector] : [TRCarPosition carPositionWithFrontConnector:frontConnector head:head tail:tail backConnector:backConnector])];
        return backConnector;
    }]));
}

- (GEVec2)movePoint:(GEVec2)point length:(CGFloat)length {
    return GEVec2Make(point.x, point.y + length);
}

- (void)updateWithDelta:(CGFloat)delta {
    [self correctCorrection:[_level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return _trainType.obstacleProcessor(_level, self, _);
    } forLength:delta * _speedFloat point:_head]];
}

- (id<CNSeq>)directedCars {
    if(_back) return [[[[self cars] chain] reverse] toArray];
    else return [self cars];
}

- (void)correctCorrection:(TRRailPointCorrection*)correction {
    if(!(eqf(correction.error, 0.0))) {
        BOOL isMoveToCity = [self isMoveToCityForPoint:correction.point];
        if(!(isMoveToCity) || correction.error >= _length) {
            if(isMoveToCity && (_color == TRCityColor.grey || ((TRCity*)([[_level cityForTile:correction.point.tile] get])).color == _color)) {
                [_level arrivedTrain:self];
            } else {
                _back = !(_back);
                TRCar* lastCar = ((TRCar*)([[self directedCars] head]));
                _head = ((_back) ? [lastCar position].backConnector : [lastCar position].frontConnector);
            }
        } else {
            _head = [correction addErrorToPoint];
        }
    } else {
        _head = correction.point;
    }
    [self calculateCarPositions];
}

- (BOOL)isMoveToCityForPoint:(TRRailPoint*)point {
    return !([_level.map isFullTile:point.tile]) && !([_level.map isFullTile:[point nextTile]]);
}

- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch {
    GEVec2i tile = theSwitch.tile;
    GEVec2i nextTile = [theSwitch.connector nextTile:tile];
    return [[[self cars] findWhere:^BOOL(TRCar* car) {
        TRCarPosition* p = [car position];
        return (GEVec2iEq(p.frontConnector.tile, tile) && GEVec2iEq(p.backConnector.tile, nextTile)) || (GEVec2iEq(p.frontConnector.tile, nextTile) && GEVec2iEq(p.backConnector.tile, tile));
    }] isDefined];
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
    return [self.level isEqual:o.level] && self.trainType == o.trainType && self.color == o.color && [self._cars isEqual:o._cars] && self.speed == o.speed;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    hash = hash * 31 + [self.trainType ordinal];
    hash = hash * 31 + [self.color ordinal];
    hash = hash * 31 + [self._cars hash];
    hash = hash * 31 + self.speed;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendFormat:@", trainType=%@", self.trainType];
    [description appendFormat:@", color=%@", self.color];
    [description appendFormat:@", speed=%li", self.speed];
    [description appendString:@">"];
    return description;
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
    TRCar* engine = [TRCar carWithTrain:train carType:((TRCarType*)([[[[_carTypes chain] filter:^BOOL(TRCarType* _) {
        return [_ isEngine];
    }] randomItem] get]))];
    if(count <= 1) return (@[engine]);
    else return [[[[intRange(count) chain] map:^TRCar*(id i) {
        return [TRCar carWithTrain:train carType:((TRCarType*)([[[[_carTypes chain] filter:^BOOL(TRCarType* _) {
            return !([_ isEngine]);
        }] randomItem] get]))];
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


