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
    _simple = [TRTrainType trainTypeWithOrdinal:((NSUInteger)0) name:@"simple" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) [level destroyTrain:train];
        return NO;
    }];
    _crazy = [TRTrainType trainTypeWithOrdinal:((NSUInteger)1) name:@"crazy" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) [level destroyTrain:train];
        return o.obstacleType == TRObstacleType.light;
    }];
    _fast = [TRTrainType trainTypeWithOrdinal:((NSUInteger)2) name:@"fast" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage || o.obstacleType == TRObstacleType.aSwitch) [level destroyTrain:train];
        return NO;
    }];
    _repairer = [TRTrainType trainTypeWithOrdinal:((NSUInteger)3) name:@"repairer" obstacleProcessor:^BOOL(TRLevel* level, TRTrain* train, TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) [level.railroad fixDamageAtPoint:o.point];
        return NO;
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
    double _length;
    double __speedF;
    BOOL(^_carsObstacleProcessor)(TRObstacle*);
}
static double _carsDelta;
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
            return numf([car length] + unumf(r) + _carsDelta);
        } withStart:numf(-1.0 * _carsDelta)]);
        __speedF = 0.01 * _speed;
        _carsObstacleProcessor = ^BOOL(TRObstacle* o) {
            return o.obstacleType == TRObstacleType.light;
        };
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _carsDelta = 0.3;
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
    ((TRRailPoint*)[[[self directedCars] chain] fold:^TRRailPoint*(TRRailPoint* hl, TRCar* car) {
        car.head = hl;
        TRRailPoint* next = [[_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:[car length] point:hl] addErrorToPoint];
        car.tail = next;
        car.nextHead = [[_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:_carsDelta point:next] addErrorToPoint];
        return car.nextHead;
    } withStart:[_head invert]]);
}

- (EGPoint)movePoint:(EGPoint)point length:(double)length {
    return EGPointMake(point.x, point.y + length);
}

- (void)updateWithDelta:(double)delta {
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
            if(isMoveToCity && ((TRCity*)[[_level cityForTile:correction.point.tile] get]).color == _color) {
                [_level arrivedTrain:self];
            } else {
                _back = !(_back);
                TRCar* lastCar = ((TRCar*)[[[self directedCars] head] get]);
                _head = lastCar.tail;
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
        return (EGPointIEq(_.head.tile, tile) && EGPointIEq(_.nextHead.tile, nextTile)) || (EGPointIEq(_.head.tile, nextTile) && EGPointIEq(_.nextHead.tile, tile));
    }] isDefined];
}

+ (double)carsDelta {
    return _carsDelta;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTrain* o = ((TRTrain*)other);
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


@implementation TRCar{
    TRRailPoint* _head;
    TRRailPoint* _tail;
    TRRailPoint* _nextHead;
}
@synthesize head = _head;
@synthesize tail = _tail;
@synthesize nextHead = _nextHead;

+ (id)car {
    return [[TRCar alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (double)length {
    return 0.6;
}

- (double)width {
    return 0.2;
}

- (EGThickLineSegment*)figure {
    return [EGThickLineSegment thickLineSegmentWithSegment:[EGLineSegment newWithP1:_head.point p2:_tail.point] thickness:[self width]];
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


@implementation TRTrainGenerator{
    TRTrainType* _trainType;
    id<CNList> _carsCount;
    id<CNList> _speed;
}
@synthesize trainType = _trainType;
@synthesize carsCount = _carsCount;
@synthesize speed = _speed;

+ (id)trainGeneratorWithTrainType:(TRTrainType*)trainType carsCount:(id<CNList>)carsCount speed:(id<CNList>)speed {
    return [[TRTrainGenerator alloc] initWithTrainType:trainType carsCount:carsCount speed:speed];
}

- (id)initWithTrainType:(TRTrainType*)trainType carsCount:(id<CNList>)carsCount speed:(id<CNList>)speed {
    self = [super init];
    if(self) {
        _trainType = trainType;
        _carsCount = carsCount;
        _speed = speed;
    }
    
    return self;
}

- (id<CNList>)generateCars {
    return [[[intRange(unumi([[_carsCount randomItem] get])) chain] map:^TRCar*(id _) {
        return [TRCar car];
    }] toArray];
}

- (NSUInteger)generateSpeed {
    return ((NSUInteger)unumi([[_speed randomItem] get]));
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTrainGenerator* o = ((TRTrainGenerator*)other);
    return self.trainType == o.trainType && [self.carsCount isEqual:o.carsCount] && [self.speed isEqual:o.speed];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.trainType ordinal];
    hash = hash * 31 + [self.carsCount hash];
    hash = hash * 31 + [self.speed hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"trainType=%@", self.trainType];
    [description appendFormat:@", carsCount=%@", self.carsCount];
    [description appendFormat:@", speed=%@", self.speed];
    [description appendString:@">"];
    return description;
}

@end


