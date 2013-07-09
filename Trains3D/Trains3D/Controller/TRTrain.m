#import "TRTrain.h"

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
    }
    
    return self;
}

- (void)startFromCity:(TRCity*)city {
    _head = [city startPoint];
    [self calculateCarPositions];
}

- (void)calculateCarPositions {
    [_cars fold:^id(id hl, TRCar* car) {
        car.head = uval(TRRailPoint, hl);
        TRRailPoint next = [_level.railroad moveForLength:[car length] point:uval(TRRailPoint, hl)].point;
        car.tail = next;
        return val([_level.railroad moveForLength:0.1 point:next].point);
    } withStart:val(_head)];
}

- (CGPoint)movePoint:(CGPoint)point length:(CGFloat)length {
    return CGPointMake(point.x, point.y + length);
}

@end


@implementation TRCar{
    TRRailPoint _head;
    TRRailPoint _tail;
}
@synthesize head = _head;
@synthesize tail = _tail;

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


