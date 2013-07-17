#import "TRTrain.h"

#import "EGMapIso.h"
#import "TRTypes.h"
#import "TRCity.h"
#import "TRLevel.h"
#import "TRRailroad.h"
@implementation TRTrain{
    __weak TRLevel* _level;
    TRColor* _color;
    NSArray* _cars;
    double _speed;
    TRRailPoint _head;
    BOOL _back;
    double _carsDelta;
    double _length;
}
@synthesize level = _level;
@synthesize color = _color;
@synthesize cars = _cars;
@synthesize speed = _speed;

+ (id)trainWithLevel:(TRLevel*)level color:(TRColor*)color cars:(NSArray*)cars speed:(double)speed {
    return [[TRTrain alloc] initWithLevel:level color:color cars:cars speed:speed];
}

- (id)initWithLevel:(TRLevel*)level color:(TRColor*)color cars:(NSArray*)cars speed:(double)speed {
    self = [super init];
    if(self) {
        _level = level;
        _color = color;
        _cars = cars;
        _speed = speed;
        _back = NO;
        _carsDelta = 0.1;
        _length = unumf([_cars fold:^id(id r, TRCar* car) {
            return numf([car length] + unumf(r) + _carsDelta);
        } withStart:numf(-1.0 * _carsDelta)]);
    }
    
    return self;
}

- (void)startFromCity:(TRCity*)city {
    _head = [city startPoint];
    [self calculateCarPositions];
}

- (void)calculateCarPositions {
    [[self directedCars] fold:^id(id hl, TRCar* car) {
        car.head = uval(TRRailPoint, hl);
        TRRailPoint next = trRailPointCorrectionAddErrorToPoint([_level.railroad moveConsideringLights:NO forLength:[car length] point:uval(TRRailPoint, hl)]);
        car.tail = next;
        car.nextHead = trRailPointCorrectionAddErrorToPoint([_level.railroad moveConsideringLights:NO forLength:_carsDelta point:next]);
        return val(car.nextHead);
    } withStart:val(trRailPointInvert(_head))];
}

- (EGPoint)movePoint:(EGPoint)point length:(double)length {
    return EGPointMake(point.x, point.y + length);
}

- (void)updateWithDelta:(double)delta {
    [self correctCorrection:[_level.railroad moveConsideringLights:YES forLength:delta * _speed point:_head]];
}

- (NSArray*)directedCars {
    if(_back) return [[_cars reverse] toArray];
    else return _cars;
}

- (void)correctCorrection:(TRRailPointCorrection)correction {
    if(!(eqf(correction.error, 0.0))) {
        if(!([self isMoveToCityForPoint:correction.point]) || correction.error >= _length) {
            _back = !(_back);
            TRCar* lastCar = [[[self directedCars] head] get];
            _head = lastCar.tail;
        } else {
            _head = trRailPointCorrectionAddErrorToPoint(correction);
        }
    } else {
        _head = correction.point;
    }
    [self calculateCarPositions];
}

- (BOOL)isMoveToCityForPoint:(TRRailPoint)point {
    return !([_level.map isFullTile:point.tile]) && !([_level.map isFullTile:trRailPointNextTile(point)]);
}

- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch {
    EGPointI tile = theSwitch.tile;
    EGPointI nextTile = [theSwitch.connector nextTile:tile];
    return [[_cars find:^BOOL(TRCar* _) {
        return (EGPointIEq(_.head.tile, tile) && EGPointIEq(_.nextHead.tile, nextTile)) || (EGPointIEq(_.head.tile, nextTile) && EGPointIEq(_.nextHead.tile, tile));
    }] isDefined];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation TRCar{
    TRRailPoint _head;
    TRRailPoint _tail;
    TRRailPoint _nextHead;
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

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


