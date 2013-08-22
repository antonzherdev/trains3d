#import "TRTrain.h"

#import "EGMapIso.h"
#import "EGFigure.h"
#import "TRTypes.h"
#import "TRCity.h"
#import "TRLevel.h"
#import "TRRailPoint.h"
#import "TRRailroad.h"
@implementation TRTrainType{
    BOOL(^_obstacleProcessor)(TRLevel*, TRTrain*, TRObstacle*);
}
static TRTrainType* _simple;
static TRTrainType* _crazy;
static TRTrainType* _fast;
static TRTrainType* _repairer;
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
    _simple = [TRTrainType trainTypeWithOrdinal:((NSUInteger)(0)) name:@"simple" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) [level destroyTrain:train];
        return NO;
    }];
    _crazy = [TRTrainType trainTypeWithOrdinal:((NSUInteger)(1)) name:@"crazy" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) [level destroyTrain:train];
        return o.obstacleType == TRObstacleType.light;
    }];
    _fast = [TRTrainType trainTypeWithOrdinal:((NSUInteger)(2)) name:@"fast" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage || o.obstacleType == TRObstacleType.aSwitch) [level destroyTrain:train];
        return NO;
    }];
    _repairer = [TRTrainType trainTypeWithOrdinal:((NSUInteger)(3)) name:@"repairer" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) {
            [level.railroad fixDamageAtPoint:o.point];
            return YES;
        } else {
            return NO;
        }
    }];
    _TRTrainType_values = (@[_simple, _crazy, _fast, _repairer]);
}

+ (TRTrainType*)simple {
    return _simple;
}

+ (TRTrainType*)crazy {
    return _crazy;
}

+ (TRTrainType*)fast {
    return _fast;
}

+ (TRTrainType*)repairer {
    return _repairer;
}

+ (NSArray*)values {
    return _TRTrainType_values;
}

@end


@implementation TRTrain{
    __weak TRLevel* _level;
    TRTrainType* _trainType;
    TRColor* _color;
    id<CNList> _cars;
    NSUInteger _speed;
    TRRailPoint* _head;
    BOOL _back;
    CGFloat _length;
    CGFloat __speedF;
    BOOL(^_carsObstacleProcessor)(TRObstacle*);
}
@synthesize level = _level;
@synthesize trainType = _trainType;
@synthesize color = _color;
@synthesize cars = _cars;
@synthesize speed = _speed;

+ (id)trainWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRColor*)color cars:(id<CNList>)cars speed:(NSUInteger)speed {
    return [[TRTrain alloc] initWithLevel:level trainType:trainType color:color cars:cars speed:speed];
}

- (id)initWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRColor*)color cars:(id<CNList>)cars speed:(NSUInteger)speed {
    self = [super init];
    if(self) {
        _level = level;
        _trainType = trainType;
        _color = color;
        _cars = cars;
        _speed = speed;
        _back = NO;
        _length = unumf([[_cars chain] fold:^id(id r, TRCar* car) {
            return numf([car fullLength] + unumf(r));
        } withStart:@0.0]);
        __speedF = 0.01 * _speed;
        _carsObstacleProcessor = ^BOOL(TRObstacle* o) {
            return o.obstacleType == TRObstacleType.light;
        };
    }
    
    return self;
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
    ((TRRailPoint*)([[[self directedCars] chain] fold:^TRRailPoint*(TRRailPoint* hl, TRCar* car) {
        car.frontConnector = hl;
        CGFloat fl = [car frontConnectorLength];
        CGFloat bl = [car backConnectorLength];
        TRRailPoint* p = [[_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:((_back) ? bl : fl) point:hl] addErrorToPoint];
        car.head = p;
        p = [[_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:[car length] point:p] addErrorToPoint];
        car.tail = p;
        p = [[_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:((_back) ? fl : bl) point:p] addErrorToPoint];
        car.backConnector = p;
        return p;
    } withStart:[_head invert]]));
}

- (EGPoint)movePoint:(EGPoint)point length:(CGFloat)length {
    return EGPointMake(point.x, point.y + length);
}

- (void)updateWithDelta:(CGFloat)delta {
    [self correctCorrection:[_level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return _trainType.obstacleProcessor(_level, self, _);
    } forLength:delta * __speedF point:_head]];
}

- (id<CNList>)directedCars {
    if(_back) return [[[_cars chain] reverse] toArray];
    else return _cars;
}

- (void)correctCorrection:(TRRailPointCorrection*)correction {
    if(!(eqf(correction.error, 0.0))) {
        BOOL isMoveToCity = [self isMoveToCityForPoint:correction.point];
        if(!(isMoveToCity) || correction.error >= _length) {
            if(isMoveToCity && (_color == TRColor.grey || ((TRCity*)([[_level cityForTile:correction.point.tile] get])).color == _color)) {
                [_level arrivedTrain:self];
            } else {
                _back = !(_back);
                TRCar* lastCar = ((TRCar*)([[[self directedCars] head] get]));
                _head = lastCar.backConnector;
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
    EGPointI tile = theSwitch.tile;
    EGPointI nextTile = [theSwitch.connector nextTile:tile];
    return [[_cars findWhere:^BOOL(TRCar* _) {
        return (EGPointIEq(_.frontConnector.tile, tile) && EGPointIEq(_.backConnector.tile, nextTile)) || (EGPointIEq(_.frontConnector.tile, nextTile) && EGPointIEq(_.backConnector.tile, tile));
    }] isDefined];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTrain* o = ((TRTrain*)(other));
    return [self.level isEqual:o.level] && self.trainType == o.trainType && self.color == o.color && [self.cars isEqual:o.cars] && self.speed == o.speed;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    hash = hash * 31 + [self.trainType ordinal];
    hash = hash * 31 + [self.color ordinal];
    hash = hash * 31 + [self.cars hash];
    hash = hash * 31 + self.speed;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendFormat:@", trainType=%@", self.trainType];
    [description appendFormat:@", color=%@", self.color];
    [description appendFormat:@", cars=%@", self.cars];
    [description appendFormat:@", speed=%li", self.speed];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRCarType{
    CGFloat _length;
    CGFloat _width;
    CGFloat _frontConnectorLength;
    CGFloat _backConnectorLength;
    BOOL _isEngine;
}
static TRCarType* _car;
static TRCarType* _engine;
static NSArray* _TRCarType_values;
@synthesize length = _length;
@synthesize width = _width;
@synthesize frontConnectorLength = _frontConnectorLength;
@synthesize backConnectorLength = _backConnectorLength;
@synthesize isEngine = _isEngine;

+ (id)carTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name length:(CGFloat)length width:(CGFloat)width frontConnectorLength:(CGFloat)frontConnectorLength backConnectorLength:(CGFloat)backConnectorLength isEngine:(BOOL)isEngine {
    return [[TRCarType alloc] initWithOrdinal:ordinal name:name length:length width:width frontConnectorLength:frontConnectorLength backConnectorLength:backConnectorLength isEngine:isEngine];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name length:(CGFloat)length width:(CGFloat)width frontConnectorLength:(CGFloat)frontConnectorLength backConnectorLength:(CGFloat)backConnectorLength isEngine:(BOOL)isEngine {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _length = length;
        _width = width;
        _frontConnectorLength = frontConnectorLength;
        _backConnectorLength = backConnectorLength;
        _isEngine = isEngine;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _car = [TRCarType carTypeWithOrdinal:((NSUInteger)(0)) name:@"car" length:0.44 width:0.18 frontConnectorLength:0.13 backConnectorLength:0.13 isEngine:NO];
    _engine = [TRCarType carTypeWithOrdinal:((NSUInteger)(1)) name:@"engine" length:0.43 width:0.18 frontConnectorLength:0.12 backConnectorLength:0.2 isEngine:YES];
    _TRCarType_values = (@[_car, _engine]);
}

- (CGFloat)fullLength {
    return _length + _frontConnectorLength + _backConnectorLength;
}

+ (TRCarType*)car {
    return _car;
}

+ (TRCarType*)engine {
    return _engine;
}

+ (NSArray*)values {
    return _TRCarType_values;
}

@end


@implementation TRCar{
    TRCarType* _carType;
    TRRailPoint* _frontConnector;
    TRRailPoint* _backConnector;
    TRRailPoint* _head;
    TRRailPoint* _tail;
}
@synthesize carType = _carType;
@synthesize frontConnector = _frontConnector;
@synthesize backConnector = _backConnector;
@synthesize head = _head;
@synthesize tail = _tail;

+ (id)carWithCarType:(TRCarType*)carType {
    return [[TRCar alloc] initWithCarType:carType];
}

- (id)initWithCarType:(TRCarType*)carType {
    self = [super init];
    if(self) _carType = carType;
    
    return self;
}

- (CGFloat)frontConnectorLength {
    return _carType.frontConnectorLength;
}

- (CGFloat)backConnectorLength {
    return _carType.backConnectorLength;
}

- (CGFloat)length {
    return _carType.length;
}

- (CGFloat)width {
    return _carType.width;
}

- (CGFloat)fullLength {
    return [_carType fullLength];
}

- (EGThickLineSegment*)figure {
    return [EGThickLineSegment thickLineSegmentWithSegment:[EGLineSegment newWithP1:_head.point p2:_tail.point] thickness:[self width]];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRCar* o = ((TRCar*)(other));
    return self.carType == o.carType;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.carType ordinal];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"carType=%@", self.carType];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTrainGenerator{
    TRTrainType* _trainType;
    id<CNList> _carsCount;
    id<CNList> _speed;
    id<CNList> _carTypes;
}
@synthesize trainType = _trainType;
@synthesize carsCount = _carsCount;
@synthesize speed = _speed;
@synthesize carTypes = _carTypes;

+ (id)trainGeneratorWithTrainType:(TRTrainType*)trainType carsCount:(id<CNList>)carsCount speed:(id<CNList>)speed carTypes:(id<CNList>)carTypes {
    return [[TRTrainGenerator alloc] initWithTrainType:trainType carsCount:carsCount speed:speed carTypes:carTypes];
}

- (id)initWithTrainType:(TRTrainType*)trainType carsCount:(id<CNList>)carsCount speed:(id<CNList>)speed carTypes:(id<CNList>)carTypes {
    self = [super init];
    if(self) {
        _trainType = trainType;
        _carsCount = carsCount;
        _speed = speed;
        _carTypes = carTypes;
    }
    
    return self;
}

- (id<CNList>)generateCars {
    NSInteger count = unumi([[_carsCount randomItem] get]);
    TRCar* engine = [TRCar carWithCarType:((TRCarType*)([[[[_carTypes chain] filter:^BOOL(TRCarType* _) {
        return _.isEngine;
    }] randomItem] get]))];
    if(count <= 1) return (@[engine]);
    else return [[[[intRange(count - 1) chain] map:^TRCar*(id i) {
        return [TRCar carWithCarType:((TRCarType*)([[[[_carTypes chain] filter:^BOOL(TRCarType* _) {
            return !(_.isEngine);
        }] randomItem] get]))];
    }] prepend:(@[engine])] toArray];
}

- (NSUInteger)generateSpeed {
    return ((NSUInteger)(unumi([[_speed randomItem] get])));
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


