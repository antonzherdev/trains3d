#import "TRTrain.h"

#import "TRCity.h"
#import "TRLevel.h"
@implementation TRTrain{
    __weak TRLevel* _level;
    TRColor* _color;
    NSArray* _cars;
    CGFloat _speed;
    CGPoint _head;
}
@synthesize level = _level;
@synthesize color = _color;
@synthesize cars = _cars;
@synthesize speed = _speed;
@synthesize head = _head;

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
        _head = CGPointMake(0, 0);
    }
    
    return self;
}

- (void)startFromCity:(TRCity*)city {
    _head = egipFloat(city.tile);
    [self calculateCarPositions];
}

- (void)calculateCarPositions {
    [_cars fold:^id(id hl, TRCar* car) {
        car.head = uval(CGPoint, hl);
        CGPoint next = [self movePoint:uval(CGPoint, hl) length:[car length]];
        car.tail = next;
        return val([self movePoint:next length:0.1]);
    } withStart:val(_head)];
}

- (CGPoint)movePoint:(CGPoint)point length:(CGFloat)length {
    return CGPointMake(point.x, point.y + length);
}

@end


@implementation TRCar{
    CGPoint _head;
    CGPoint _tail;
}
@synthesize head = _head;
@synthesize tail = _tail;

+ (id)car {
    return [[TRCar alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _head = CGPointMake(0, 0);
        _tail = CGPointMake(0, 0);
    }
    
    return self;
}

- (CGFloat)length {
    return 0.6;
}

@end


