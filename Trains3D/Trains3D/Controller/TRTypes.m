#import "TRTypes.h"

@implementation TRColor{
    NSInteger _ordinal;
    NSString* _name;
    EGColor _color;
}
static TRColor* orange;
static TRColor* green;
static TRColor* purple;
static NSArray* values;
@synthesize ordinal = _ordinal;
@synthesize name = _name;
@synthesize color = _color;

+ (id)colorWithOrdinal:(NSInteger)ordinal name:(NSString*)name color:(EGColor)color {
    return [[TRColor alloc] initWithOrdinal:ordinal name:name color:color];
}

- (id)initWithOrdinal:(NSInteger)ordinal name:(NSString*)name color:(EGColor)color {
    self = [super init];
    if(self) {
        _ordinal = ordinal;
        _name = name;
        _color = color;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    orange = [TRColor colorWithOrdinal:0 name:@"orange" color:EGColorMake(1.0, 0.5, 0.0, 1.0)];
    green = [TRColor colorWithOrdinal:1 name:@"green" color:EGColorMake(0.66, 0.9, 0.44, 1.0)];
    purple = [TRColor colorWithOrdinal:2 name:@"purple" color:EGColorMake(0.9, 0.44, 0.66, 1.0)];
    values = (@[orange, green, purple]);
}

- (void)gl {
    egColor(_color);
}

+ (TRColor*)orange {
    return orange;
}

+ (TRColor*)green {
    return green;
}

+ (TRColor*)purple {
    return purple;
}

+ (NSArray*)values {
    return values;
}

@end


@implementation TRRailConnector{
    NSInteger _ordinal;
    NSString* _name;
    NSInteger _x;
    NSInteger _y;
}
static TRRailConnector* left;
static TRRailConnector* bottom;
static TRRailConnector* top;
static TRRailConnector* right;
static NSArray* values;
@synthesize ordinal = _ordinal;
@synthesize name = _name;
@synthesize x = _x;
@synthesize y = _y;

+ (id)railConnectorWithOrdinal:(NSInteger)ordinal name:(NSString*)name x:(NSInteger)x y:(NSInteger)y {
    return [[TRRailConnector alloc] initWithOrdinal:ordinal name:name x:x y:y];
}

- (id)initWithOrdinal:(NSInteger)ordinal name:(NSString*)name x:(NSInteger)x y:(NSInteger)y {
    self = [super init];
    if(self) {
        _ordinal = ordinal;
        _name = name;
        _x = x;
        _y = y;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    left = [TRRailConnector railConnectorWithOrdinal:0 name:@"left" x:-1 y:0];
    bottom = [TRRailConnector railConnectorWithOrdinal:1 name:@"bottom" x:0 y:-1];
    top = [TRRailConnector railConnectorWithOrdinal:2 name:@"top" x:0 y:1];
    right = [TRRailConnector railConnectorWithOrdinal:3 name:@"right" x:1 y:0];
    values = (@[left, bottom, top, right]);
}

+ (TRRailConnector*)connectorForX:(NSInteger)x y:(NSInteger)y {
    if(x == -1 && y == 0) return [TRRailConnector left];
    else if(x == 0 && y == -1) return [TRRailConnector bottom];
    else if(x == 0 && y == 1) return [TRRailConnector top];
    else if(x == 1 && y == 0) return [TRRailConnector right];
    else @throw @"No rail connector";
}

+ (TRRailConnector*)left {
    return left;
}

+ (TRRailConnector*)bottom {
    return bottom;
}

+ (TRRailConnector*)top {
    return top;
}

+ (TRRailConnector*)right {
    return right;
}

+ (NSArray*)values {
    return values;
}

@end


@implementation TRRailForm{
    NSInteger _ordinal;
    NSString* _name;
    TRRailConnector* _start;
    TRRailConnector* _end;
}
static TRRailForm* leftRight;
static TRRailForm* leftBottom;
static TRRailForm* leftTop;
static TRRailForm* bottomTop;
static TRRailForm* bottomRight;
static TRRailForm* topRight;
static NSArray* values;
@synthesize ordinal = _ordinal;
@synthesize name = _name;
@synthesize start = _start;
@synthesize end = _end;

+ (id)railFormWithOrdinal:(NSInteger)ordinal name:(NSString*)name start:(TRRailConnector*)start end:(TRRailConnector*)end {
    return [[TRRailForm alloc] initWithOrdinal:ordinal name:name start:start end:end];
}

- (id)initWithOrdinal:(NSInteger)ordinal name:(NSString*)name start:(TRRailConnector*)start end:(TRRailConnector*)end {
    self = [super init];
    if(self) {
        _ordinal = ordinal;
        _name = name;
        _start = start;
        _end = end;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    leftRight = [TRRailForm railFormWithOrdinal:0 name:@"leftRight" start:[TRRailConnector left] end:[TRRailConnector right]];
    leftBottom = [TRRailForm railFormWithOrdinal:1 name:@"leftBottom" start:[TRRailConnector left] end:[TRRailConnector bottom]];
    leftTop = [TRRailForm railFormWithOrdinal:2 name:@"leftTop" start:[TRRailConnector left] end:[TRRailConnector top]];
    bottomTop = [TRRailForm railFormWithOrdinal:3 name:@"bottomTop" start:[TRRailConnector bottom] end:[TRRailConnector top]];
    bottomRight = [TRRailForm railFormWithOrdinal:4 name:@"bottomRight" start:[TRRailConnector bottom] end:[TRRailConnector right]];
    topRight = [TRRailForm railFormWithOrdinal:5 name:@"topRight" start:[TRRailConnector top] end:[TRRailConnector right]];
    values = (@[leftRight, leftBottom, leftTop, bottomTop, bottomRight, topRight]);
}

+ (TRRailForm*)formForConnector1:(TRRailConnector*)connector1 connector2:(TRRailConnector*)connector2 {
    if(connector1.ordinal > connector2.ordinal) return [TRRailForm formForConnector1:connector2 connector2:connector1];
    else if(connector1 == [TRRailConnector left] && connector2 == [TRRailConnector right]) return [TRRailForm leftRight];
    else if(connector1 == [TRRailConnector left] && connector2 == [TRRailConnector bottom]) return [TRRailForm leftBottom];
    else if(connector1 == [TRRailConnector left] && connector2 == [TRRailConnector top]) return [TRRailForm leftTop];
    else if(connector1 == [TRRailConnector bottom] && connector2 == [TRRailConnector top]) return [TRRailForm bottomTop];
    else if(connector1 == [TRRailConnector bottom] && connector2 == [TRRailConnector right]) return [TRRailForm bottomRight];
    else if(connector1 == [TRRailConnector top] && connector2 == [TRRailConnector right]) return [TRRailForm topRight];
    else @throw @"No form for connectors";
}

+ (TRRailForm*)leftRight {
    return leftRight;
}

+ (TRRailForm*)leftBottom {
    return leftBottom;
}

+ (TRRailForm*)leftTop {
    return leftTop;
}

+ (TRRailForm*)bottomTop {
    return bottomTop;
}

+ (TRRailForm*)bottomRight {
    return bottomRight;
}

+ (TRRailForm*)topRight {
    return topRight;
}

+ (NSArray*)values {
    return values;
}

@end


