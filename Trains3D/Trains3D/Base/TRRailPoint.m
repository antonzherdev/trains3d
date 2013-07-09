#import "TRRailPoint.h"

@implementation TRRailConnector{
    NSUInteger _ordinal;
    NSString* _name;
    NSInteger _x;
    NSInteger _y;
}
static TRRailConnector* _left;
static TRRailConnector* _bottom;
static TRRailConnector* _top;
static TRRailConnector* _right;
static NSArray* values;
@synthesize ordinal = _ordinal;
@synthesize name = _name;
@synthesize x = _x;
@synthesize y = _y;

+ (id)railConnectorWithOrdinal:(NSUInteger)ordinal name:(NSString*)name x:(NSInteger)x y:(NSInteger)y {
    return [[TRRailConnector alloc] initWithOrdinal:ordinal name:name x:x y:y];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name x:(NSInteger)x y:(NSInteger)y {
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
    _left = [TRRailConnector railConnectorWithOrdinal:0 name:@"left" x:-1 y:0];
    _bottom = [TRRailConnector railConnectorWithOrdinal:1 name:@"bottom" x:0 y:-1];
    _top = [TRRailConnector railConnectorWithOrdinal:2 name:@"top" x:0 y:1];
    _right = [TRRailConnector railConnectorWithOrdinal:3 name:@"right" x:1 y:0];
    values = (@[_left, _bottom, _top, _right]);
}

+ (TRRailConnector*)connectorForX:(NSInteger)x y:(NSInteger)y {
    if(x == -1 && y == 0) return _left;
    else if(x == 0 && y == -1) return _bottom;
    else if(x == 0 && y == 1) return _top;
    else if(x == 1 && y == 0) return _right;
    else @throw @"No rail connector";
}

- (TRRailConnector*)otherSideConnector {
    if(self == _left) return _right;
    else if(self == _right) return _left;
    else if(self == _top) return _bottom;
    else return _top;
}

- (EGIPoint)nextTile:(EGIPoint)tile {
    return EGIPointMake(tile.x + _x, tile.y + _y);
}

+ (TRRailConnector*)left {
    return _left;
}

+ (TRRailConnector*)bottom {
    return _bottom;
}

+ (TRRailConnector*)top {
    return _top;
}

+ (TRRailConnector*)right {
    return _right;
}

+ (NSArray*)values {
    return values;
}

@end


@implementation TRRailForm{
    NSUInteger _ordinal;
    NSString* _name;
    TRRailConnector* _start;
    TRRailConnector* _end;
    CGFloat _length;
}
static TRRailForm* _leftRight;
static TRRailForm* _leftBottom;
static TRRailForm* _leftTop;
static TRRailForm* _bottomTop;
static TRRailForm* _bottomRight;
static TRRailForm* _topRight;
static NSArray* values;
@synthesize ordinal = _ordinal;
@synthesize name = _name;
@synthesize start = _start;
@synthesize end = _end;
@synthesize length = _length;

+ (id)railFormWithOrdinal:(NSUInteger)ordinal name:(NSString*)name start:(TRRailConnector*)start end:(TRRailConnector*)end length:(CGFloat)length {
    return [[TRRailForm alloc] initWithOrdinal:ordinal name:name start:start end:end length:length];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name start:(TRRailConnector*)start end:(TRRailConnector*)end length:(CGFloat)length {
    self = [super init];
    if(self) {
        _ordinal = ordinal;
        _name = name;
        _start = start;
        _end = end;
        _length = length;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _leftRight = [TRRailForm railFormWithOrdinal:0 name:@"leftRight" start:TRRailConnector.left end:TRRailConnector.right length:1];
    _leftBottom = [TRRailForm railFormWithOrdinal:1 name:@"leftBottom" start:TRRailConnector.left end:TRRailConnector.bottom length:M_PI_4];
    _leftTop = [TRRailForm railFormWithOrdinal:2 name:@"leftTop" start:TRRailConnector.left end:TRRailConnector.top length:M_PI_4];
    _bottomTop = [TRRailForm railFormWithOrdinal:3 name:@"bottomTop" start:TRRailConnector.bottom end:TRRailConnector.top length:1];
    _bottomRight = [TRRailForm railFormWithOrdinal:4 name:@"bottomRight" start:TRRailConnector.bottom end:TRRailConnector.right length:M_PI_4];
    _topRight = [TRRailForm railFormWithOrdinal:5 name:@"topRight" start:TRRailConnector.top end:TRRailConnector.right length:M_PI_4];
    values = (@[_leftRight, _leftBottom, _leftTop, _bottomTop, _bottomRight, _topRight]);
}

+ (TRRailForm*)formForConnector1:(TRRailConnector*)connector1 connector2:(TRRailConnector*)connector2 {
    if(connector1.ordinal > connector2.ordinal) return [TRRailForm formForConnector1:connector2 connector2:connector1];
    else if(connector1 == TRRailConnector.left && connector2 == TRRailConnector.right) return _leftRight;
    else if(connector1 == TRRailConnector.left && connector2 == TRRailConnector.bottom) return _leftBottom;
    else if(connector1 == TRRailConnector.left && connector2 == TRRailConnector.top) return _leftTop;
    else if(connector1 == TRRailConnector.bottom && connector2 == TRRailConnector.top) return _bottomTop;
    else if(connector1 == TRRailConnector.bottom && connector2 == TRRailConnector.right) return _bottomRight;
    else if(connector1 == TRRailConnector.top && connector2 == TRRailConnector.right) return _topRight;
    else @throw @"No form for connectors";
}

+ (TRRailForm*)leftRight {
    return _leftRight;
}

+ (TRRailForm*)leftBottom {
    return _leftBottom;
}

+ (TRRailForm*)leftTop {
    return _leftTop;
}

+ (TRRailForm*)bottomTop {
    return _bottomTop;
}

+ (TRRailForm*)bottomRight {
    return _bottomRight;
}

+ (TRRailForm*)topRight {
    return _topRight;
}

+ (NSArray*)values {
    return values;
}

@end


TRRailPoint trRailPointAdd(TRRailPoint self, CGFloat x) {
    return TRRailPointMake(self.tile, self.form, self.x + x, self.back);
}
TRRailForm* trRailPointGetForm(TRRailPoint self) {
    return TRRailForm.values[self.form];
}
TRRailConnector* trRailPointStartConnector(TRRailPoint self) {
    if(self.back) return trRailPointGetForm(self).end;
    else return trRailPointGetForm(self).start;
}
TRRailConnector* trRailPointEndConnector(TRRailPoint self) {
    if(self.back) return trRailPointGetForm(self).start;
    else return trRailPointGetForm(self).end;
}
BOOL trRailPointIsValid(TRRailPoint self) {
    return self.x >= 0 && self.x <= trRailPointGetForm(self).length;
}
TRRailPointCorrection trRailPointCorrect(TRRailPoint self) {
    if(self.x < 0) return TRRailPointCorrectionMake(TRRailPointMake(self.tile, self.form, 0, self.back), self.x);
    else {
        CGFloat length = trRailPointGetForm(self).length;
        if(self.x > length) return TRRailPointCorrectionMake(TRRailPointMake(self.tile, self.form, length, self.back), self.x - length);
        else return TRRailPointCorrectionMake(self, 0);
    }
}
