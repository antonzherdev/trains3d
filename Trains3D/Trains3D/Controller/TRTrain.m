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
    CGFloat _speed;
    TRRailPoint _head;
    BOOL _back;
    CGFloat _carsDelta;
    CGFloat _length;
}
@synthesize level = _level;
@synthesize color = _color;
@synthesize cars = _cars;
@synthesize speed = _speed;

+ (id)trainWithLevel:(TRLevel*)level color:(TRColor*)color cars:(NSArray*)cars speed:(CGFloat)speed {
    return [[TRTrain alloc] initWithLevel:level color:color cars:cars speed:speed];
}

- (id)initWithLevel:(TRLevel*)level color:(TRColor*)color cars:(NSArray*)cars speed:(CGFloat)speed {
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
        TRRailPoint next = trRailPointCorrectionAddErrorToPoint([_level.railroad moveForLength:[car length] point:uval(TRRailPoint, hl)]);
        car.tail = next;
        car.nextHead = trRailPointCorrectionAddErrorToPoint([_level.railroad moveForLength:_carsDelta point:next]);
        return val(car.nextHead);
    } withStart:val(trRailPointInvert(_head))];
}

- (CGPoint)movePoint:(CGPoint)point length:(CGFloat)length {
    return CGPointMake(point.x, point.y + length);
}

- (void)updateWithDelta:(CGFloat)delta {
    [self correctCorrection:[_level.railroad moveForLength:delta * _speed point:_head]];
}

- (NSArray*)directedCars {
    if(_back) return [[_cars reverse] array];
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
    return !(egMapSsoIsFullTileP(_level.mapSize, point.tile)) && !(egMapSsoIsFullTileP(_level.mapSize, trRailPointNextTile(point)));
}

- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch {
    EGIPoint tile = theSwitch.tile;
    EGIPoint nextTile = [theSwitch.connector nextTile:tile];
    return [[_cars find:^BOOL(TRCar* _) {
        return (EGIPointEq(_.head.tile, tile) && EGIPointEq(_.nextHead.tile, nextTile)) || (EGIPointEq(_.head.tile, nextTile) && EGIPointEq(_.nextHead.tile, tile));
    }] isDefined];
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

- (CGFloat)length {
    return 0.6;
}

@end


