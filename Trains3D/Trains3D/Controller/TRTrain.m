#import "TRTrain.h"

#import "TRRailroad.h"
#import "TRLevel.h"
#import "TRTypes.h"
#import "TRRailPoint.h"
#import "TRCity.h"
#import "EGMapIso.h"
#import "EGCollisionBody.h"
#import "EGFigure.h"
#import "EGMatrix.h"
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
    TRColor* _color;
    id<CNSeq>(^__cars)(TRTrain*);
    NSUInteger _speed;
    id _viewData;
    TRRailPoint* _head;
    BOOL _back;
    CNLazy* __lazy_cars;
    CGFloat _length;
    CGFloat _speedFloat;
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

+ (id)trainWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRColor*)color _cars:(id<CNSeq>(^)(TRTrain*))_cars speed:(NSUInteger)speed {
    return [[TRTrain alloc] initWithLevel:level trainType:trainType color:color _cars:_cars speed:speed];
}

- (id)initWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRColor*)color _cars:(id<CNSeq>(^)(TRTrain*))_cars speed:(NSUInteger)speed {
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
        _length = unumf([[[self cars] chain] fold:^id(id r, TRCar* car) {
            return numf([car.carType fullLength] + unumf(r));
        } withStart:@0.0]);
        _speedFloat = 0.01 * _speed;
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
    return [__lazy_cars get];
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
    ((TRRailPoint*)([[[self directedCars] chain] fold:^TRRailPoint*(TRRailPoint* frontConnector, TRCar* car) {
        TRCarType* tp = car.carType;
        CGFloat fl = tp.frontConnectorLength;
        CGFloat bl = tp.backConnectorLength;
        TRRailPoint* head = [[_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:((_back) ? bl : fl) point:frontConnector] addErrorToPoint];
        TRRailPoint* tail = [[_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:tp.length point:head] addErrorToPoint];
        TRRailPoint* backConnector = [[_level.railroad moveWithObstacleProcessor:_carsObstacleProcessor forLength:((_back) ? fl : bl) point:tail] addErrorToPoint];
        [car setPosition:((_back) ? [TRCarPosition carPositionWithFrontConnector:backConnector head:tail tail:head backConnector:frontConnector] : [TRCarPosition carPositionWithFrontConnector:frontConnector head:head tail:tail backConnector:backConnector])];
        return backConnector;
    } withStart:[_head invert]]));
}

- (EGVec2)movePoint:(EGVec2)point length:(CGFloat)length {
    return EGVec2Make(point.x, point.y + length);
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
            if(isMoveToCity && (_color == TRColor.grey || ((TRCity*)([[_level cityForTile:correction.point.tile] get])).color == _color)) {
                [_level arrivedTrain:self];
            } else {
                _back = !(_back);
                TRCar* lastCar = ((TRCar*)([[[self directedCars] head] get]));
                _head = [lastCar position].backConnector;
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
    EGVec2I tile = theSwitch.tile;
    EGVec2I nextTile = [theSwitch.connector nextTile:tile];
    return [[[self cars] findWhere:^BOOL(TRCar* car) {
        TRCarPosition* p = [car position];
        return (EGVec2IEq(p.frontConnector.tile, tile) && EGVec2IEq(p.backConnector.tile, nextTile)) || (EGVec2IEq(p.frontConnector.tile, nextTile) && EGVec2IEq(p.backConnector.tile, tile));
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


@implementation TREngineType{
    EGVec3 _tubePos;
}
static ODClassType* _TREngineType_type;
@synthesize tubePos = _tubePos;

+ (id)engineTypeWithTubePos:(EGVec3)tubePos {
    return [[TREngineType alloc] initWithTubePos:tubePos];
}

- (id)initWithTubePos:(EGVec3)tubePos {
    self = [super init];
    if(self) _tubePos = tubePos;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TREngineType_type = [ODClassType classTypeWithCls:[TREngineType class]];
}

- (ODClassType*)type {
    return [TREngineType type];
}

+ (ODClassType*)type {
    return _TREngineType_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TREngineType* o = ((TREngineType*)(other));
    return EGVec3Eq(self.tubePos, o.tubePos);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec3Hash(self.tubePos);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tubePos=%@", EGVec3Description(self.tubePos)];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRCarType{
    CGFloat _length;
    CGFloat _width;
    CGFloat _frontConnectorLength;
    CGFloat _backConnectorLength;
    id _engineType;
    id<EGCollisionShape> _shape;
}
static TRCarType* _TRCarType_car;
static TRCarType* _TRCarType_engine;
static NSArray* _TRCarType_values;
@synthesize length = _length;
@synthesize width = _width;
@synthesize frontConnectorLength = _frontConnectorLength;
@synthesize backConnectorLength = _backConnectorLength;
@synthesize engineType = _engineType;
@synthesize shape = _shape;

+ (id)carTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name length:(CGFloat)length width:(CGFloat)width frontConnectorLength:(CGFloat)frontConnectorLength backConnectorLength:(CGFloat)backConnectorLength engineType:(id)engineType {
    return [[TRCarType alloc] initWithOrdinal:ordinal name:name length:length width:width frontConnectorLength:frontConnectorLength backConnectorLength:backConnectorLength engineType:engineType];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name length:(CGFloat)length width:(CGFloat)width frontConnectorLength:(CGFloat)frontConnectorLength backConnectorLength:(CGFloat)backConnectorLength engineType:(id)engineType {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _length = length;
        _width = width;
        _frontConnectorLength = frontConnectorLength;
        _backConnectorLength = backConnectorLength;
        _engineType = engineType;
        _shape = [EGCollisionBox2d applyX:((float)(_length / 2)) y:((float)(_width / 2))];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCarType_car = [TRCarType carTypeWithOrdinal:0 name:@"car" length:0.44 width:0.18 frontConnectorLength:0.13 backConnectorLength:0.13 engineType:[CNOption none]];
    _TRCarType_engine = [TRCarType carTypeWithOrdinal:1 name:@"engine" length:0.43 width:0.18 frontConnectorLength:0.12 backConnectorLength:0.2 engineType:[CNOption opt:[TREngineType engineTypeWithTubePos:EGVec3Make(-0.06, 0.0, 0.5)]]];
    _TRCarType_values = (@[_TRCarType_car, _TRCarType_engine]);
}

- (CGFloat)fullLength {
    return _length + _frontConnectorLength + _backConnectorLength;
}

- (BOOL)isEngine {
    return [_engineType isDefined];
}

+ (TRCarType*)car {
    return _TRCarType_car;
}

+ (TRCarType*)engine {
    return _TRCarType_engine;
}

+ (NSArray*)values {
    return _TRCarType_values;
}

@end


@implementation TRCar{
    __weak TRTrain* _train;
    TRCarType* _carType;
    EGCollisionBody* _collisionBody;
    TRCarPosition* __position;
}
static ODClassType* _TRCar_type;
@synthesize train = _train;
@synthesize carType = _carType;
@synthesize collisionBody = _collisionBody;

+ (id)carWithTrain:(TRTrain*)train carType:(TRCarType*)carType {
    return [[TRCar alloc] initWithTrain:train carType:carType];
}

- (id)initWithTrain:(TRTrain*)train carType:(TRCarType*)carType {
    self = [super init];
    if(self) {
        _train = train;
        _carType = carType;
        _collisionBody = [EGCollisionBody collisionBodyWithData:self shape:_carType.shape isKinematic:YES];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCar_type = [ODClassType classTypeWithCls:[TRCar class]];
}

- (TRCarPosition*)position {
    return __position;
}

- (void)setPosition:(TRCarPosition*)position {
    __position = position;
    [_collisionBody setMatrix:[position matrix]];
}

- (ODClassType*)type {
    return [TRCar type];
}

+ (ODClassType*)type {
    return _TRCar_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRCar* o = ((TRCar*)(other));
    return [self.train isEqual:o.train] && self.carType == o.carType;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.train hash];
    hash = hash * 31 + [self.carType ordinal];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"train=%@", self.train];
    [description appendFormat:@", carType=%@", self.carType];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRCarPosition{
    TRRailPoint* _frontConnector;
    TRRailPoint* _head;
    TRRailPoint* _tail;
    TRRailPoint* _backConnector;
    EGLineSegment* _line;
    CNLazy* __lazy_matrix;
}
static ODClassType* _TRCarPosition_type;
@synthesize frontConnector = _frontConnector;
@synthesize head = _head;
@synthesize tail = _tail;
@synthesize backConnector = _backConnector;
@synthesize line = _line;

+ (id)carPositionWithFrontConnector:(TRRailPoint*)frontConnector head:(TRRailPoint*)head tail:(TRRailPoint*)tail backConnector:(TRRailPoint*)backConnector {
    return [[TRCarPosition alloc] initWithFrontConnector:frontConnector head:head tail:tail backConnector:backConnector];
}

- (id)initWithFrontConnector:(TRRailPoint*)frontConnector head:(TRRailPoint*)head tail:(TRRailPoint*)tail backConnector:(TRRailPoint*)backConnector {
    self = [super init];
    __weak TRCarPosition* _weakSelf = self;
    if(self) {
        _frontConnector = frontConnector;
        _head = head;
        _tail = tail;
        _backConnector = backConnector;
        _line = [EGLineSegment lineSegmentWithP1:_head.point p2:_tail.point];
        __lazy_matrix = [CNLazy lazyWithF:^EGMatrix*() {
            return ^EGMatrix*() {
                EGVec2 mid = [_weakSelf.line mid];
                return [[[EGMatrix identity] translateX:mid.x y:mid.y z:0.0] rotateAngle:((float)([_weakSelf.line degreeAngle])) x:0.0 y:0.0 z:1.0];
            }();
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCarPosition_type = [ODClassType classTypeWithCls:[TRCarPosition class]];
}

- (EGMatrix*)matrix {
    return [__lazy_matrix get];
}

- (ODClassType*)type {
    return [TRCarPosition type];
}

+ (ODClassType*)type {
    return _TRCarPosition_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRCarPosition* o = ((TRCarPosition*)(other));
    return [self.frontConnector isEqual:o.frontConnector] && [self.head isEqual:o.head] && [self.tail isEqual:o.tail] && [self.backConnector isEqual:o.backConnector];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.frontConnector hash];
    hash = hash * 31 + [self.head hash];
    hash = hash * 31 + [self.tail hash];
    hash = hash * 31 + [self.backConnector hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"frontConnector=%@", self.frontConnector];
    [description appendFormat:@", head=%@", self.head];
    [description appendFormat:@", tail=%@", self.tail];
    [description appendFormat:@", backConnector=%@", self.backConnector];
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


