#import "TRRailPoint.h"

@implementation TRRailConnector{
    NSInteger _x;
    NSInteger _y;
    NSInteger _angle;
}
static TRRailConnector* _left;
static TRRailConnector* _bottom;
static TRRailConnector* _top;
static TRRailConnector* _right;
static NSArray* _TRRailConnector_values;
@synthesize x = _x;
@synthesize y = _y;
@synthesize angle = _angle;

+ (id)railConnectorWithOrdinal:(NSUInteger)ordinal name:(NSString*)name x:(NSInteger)x y:(NSInteger)y angle:(NSInteger)angle {
    return [[TRRailConnector alloc] initWithOrdinal:ordinal name:name x:x y:y angle:angle];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name x:(NSInteger)x y:(NSInteger)y angle:(NSInteger)angle {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _x = x;
        _y = y;
        _angle = angle;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _left = [TRRailConnector railConnectorWithOrdinal:((NSUInteger)(0)) name:@"left" x:-1 y:0 angle:0];
    _bottom = [TRRailConnector railConnectorWithOrdinal:((NSUInteger)(1)) name:@"bottom" x:0 y:-1 angle:90];
    _top = [TRRailConnector railConnectorWithOrdinal:((NSUInteger)(2)) name:@"top" x:0 y:1 angle:270];
    _right = [TRRailConnector railConnectorWithOrdinal:((NSUInteger)(3)) name:@"right" x:1 y:0 angle:180];
    _TRRailConnector_values = (@[_left, _bottom, _top, _right]);
}

+ (TRRailConnector*)connectorForX:(NSInteger)x y:(NSInteger)y {
    if(x == -1 && y == 0) {
        return _left;
    } else {
        if(x == 0 && y == -1) {
            return _bottom;
        } else {
            if(x == 0 && y == 1) {
                return _top;
            } else {
                if(x == 1 && y == 0) return _right;
                else @throw @"No rail connector";
            }
        }
    }
}

- (TRRailConnector*)otherSideConnector {
    if(self == _left) {
        return _right;
    } else {
        if(self == _right) {
            return _left;
        } else {
            if(self == _top) return _bottom;
            else return _top;
        }
    }
}

- (EGPointI)nextTile:(EGPointI)tile {
    return EGPointIMake(tile.x + _x, tile.y + _y);
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
    return _TRRailConnector_values;
}

@end


@implementation TRRailForm{
    TRRailConnector* _start;
    TRRailConnector* _end;
    BOOL _isTurn;
    double _length;
    EGPoint(^_pointFun)(double);
}
static TRRailForm* _leftBottom;
static TRRailForm* _leftRight;
static TRRailForm* _leftTop;
static TRRailForm* _bottomTop;
static TRRailForm* _bottomRight;
static TRRailForm* _topRight;
static NSArray* _TRRailForm_values;
@synthesize start = _start;
@synthesize end = _end;
@synthesize isTurn = _isTurn;
@synthesize length = _length;
@synthesize pointFun = _pointFun;

+ (id)railFormWithOrdinal:(NSUInteger)ordinal name:(NSString*)name start:(TRRailConnector*)start end:(TRRailConnector*)end isTurn:(BOOL)isTurn length:(double)length pointFun:(EGPoint(^)(double))pointFun {
    return [[TRRailForm alloc] initWithOrdinal:ordinal name:name start:start end:end isTurn:isTurn length:length pointFun:pointFun];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name start:(TRRailConnector*)start end:(TRRailConnector*)end isTurn:(BOOL)isTurn length:(double)length pointFun:(EGPoint(^)(double))pointFun {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _start = start;
        _end = end;
        _isTurn = isTurn;
        _length = length;
        _pointFun = pointFun;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _leftBottom = [TRRailForm railFormWithOrdinal:((NSUInteger)(0)) name:@"leftBottom" start:TRRailConnector.left end:TRRailConnector.bottom isTurn:YES length:M_PI_4 pointFun:^EGPoint(double x) {
        return EGPointMake(-0.5 + 0.5 * sin(x * 2), -0.5 + 0.5 * cos(x * 2));
    }];
    _leftRight = [TRRailForm railFormWithOrdinal:((NSUInteger)(1)) name:@"leftRight" start:TRRailConnector.left end:TRRailConnector.right isTurn:NO length:1 pointFun:^EGPoint(double x) {
        return EGPointMake(x - 0.5, 0);
    }];
    _leftTop = [TRRailForm railFormWithOrdinal:((NSUInteger)(2)) name:@"leftTop" start:TRRailConnector.left end:TRRailConnector.top isTurn:YES length:M_PI_4 pointFun:^EGPoint(double x) {
        return EGPointMake(-0.5 + 0.5 * sin(x * 2), 0.5 - 0.5 * cos(x * 2));
    }];
    _bottomTop = [TRRailForm railFormWithOrdinal:((NSUInteger)(3)) name:@"bottomTop" start:TRRailConnector.bottom end:TRRailConnector.top isTurn:NO length:1 pointFun:^EGPoint(double x) {
        return EGPointMake(0, x - 0.5);
    }];
    _bottomRight = [TRRailForm railFormWithOrdinal:((NSUInteger)(4)) name:@"bottomRight" start:TRRailConnector.bottom end:TRRailConnector.right isTurn:YES length:M_PI_4 pointFun:^EGPoint(double x) {
        return EGPointMake(0.5 - 0.5 * cos(x * 2), -0.5 + 0.5 * sin(x * 2));
    }];
    _topRight = [TRRailForm railFormWithOrdinal:((NSUInteger)(5)) name:@"topRight" start:TRRailConnector.top end:TRRailConnector.right isTurn:YES length:M_PI_4 pointFun:^EGPoint(double x) {
        return EGPointMake(0.5 - 0.5 * cos(x * 2), 0.5 - 0.5 * sin(x * 2));
    }];
    _TRRailForm_values = (@[_leftBottom, _leftRight, _leftTop, _bottomTop, _bottomRight, _topRight]);
}

+ (TRRailForm*)formForConnector1:(TRRailConnector*)connector1 connector2:(TRRailConnector*)connector2 {
    if(connector1.ordinal > connector2.ordinal) {
        return [TRRailForm formForConnector1:connector2 connector2:connector1];
    } else {
        if(connector1 == TRRailConnector.left && connector2 == TRRailConnector.right) {
            return _leftRight;
        } else {
            if(connector1 == TRRailConnector.left && connector2 == TRRailConnector.bottom) {
                return _leftBottom;
            } else {
                if(connector1 == TRRailConnector.left && connector2 == TRRailConnector.top) {
                    return _leftTop;
                } else {
                    if(connector1 == TRRailConnector.bottom && connector2 == TRRailConnector.top) {
                        return _bottomTop;
                    } else {
                        if(connector1 == TRRailConnector.bottom && connector2 == TRRailConnector.right) {
                            return _bottomRight;
                        } else {
                            if(connector1 == TRRailConnector.top && connector2 == TRRailConnector.right) return _topRight;
                            else @throw @"No form for connectors";
                        }
                    }
                }
            }
        }
    }
}

+ (TRRailForm*)leftBottom {
    return _leftBottom;
}

+ (TRRailForm*)leftRight {
    return _leftRight;
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
    return _TRRailForm_values;
}

@end


@implementation TRRailPoint{
    EGPointI _tile;
    TRRailForm* _form;
    double _x;
    BOOL _back;
    EGPoint _point;
}
@synthesize tile = _tile;
@synthesize form = _form;
@synthesize x = _x;
@synthesize back = _back;
@synthesize point = _point;

+ (id)railPointWithTile:(EGPointI)tile form:(TRRailForm*)form x:(double)x back:(BOOL)back {
    return [[TRRailPoint alloc] initWithTile:tile form:form x:x back:back];
}

- (id)initWithTile:(EGPointI)tile form:(TRRailForm*)form x:(double)x back:(BOOL)back {
    self = [super init];
    if(self) {
        _tile = tile;
        _form = form;
        _x = x;
        _back = back;
        _point = [self calculatePoint];
    }
    
    return self;
}

- (TRRailPoint*)addX:(double)x {
    return [TRRailPoint railPointWithTile:_tile form:_form x:_x + x back:_back];
}

- (TRRailConnector*)startConnector {
    if(_back) return _form.end;
    else return _form.start;
}

- (TRRailConnector*)endConnector {
    if(_back) return _form.start;
    else return _form.end;
}

- (BOOL)isValid {
    return _x >= 0 && _x <= _form.length;
}

- (TRRailPointCorrection*)correct {
    double length = _form.length;
    if(_x > length) return [TRRailPointCorrection railPointCorrectionWithPoint:[TRRailPoint railPointWithTile:_tile form:_form x:length back:_back] error:_x - length];
    else return [TRRailPointCorrection railPointCorrectionWithPoint:self error:0];
}

- (EGPoint)calculatePoint {
    double x = _back ? _form.length - _x : _x;
    EGPoint(^f)(double) = _form.pointFun;
    EGPoint p = f(x);
    return EGPointMake(p.x + _tile.x, p.y + _tile.y);
}

- (TRRailPoint*)invert {
    return [TRRailPoint railPointWithTile:_tile form:_form x:_form.length - _x back:!(_back)];
}

- (TRRailPoint*)setX:(double)x {
    return [TRRailPoint railPointWithTile:_tile form:_form x:x back:_back];
}

- (EGPointI)nextTile {
    return [[self endConnector] nextTile:_tile];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailPoint* o = ((TRRailPoint*)(other));
    return EGPointIEq(self.tile, o.tile) && self.form == o.form && eqf(self.x, o.x) && self.back == o.back;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGPointIHash(self.tile);
    hash = hash * 31 + [self.form ordinal];
    hash = hash * 31 + [[NSNumber numberWithDouble:self.x] hash];
    hash = hash * 31 + self.back;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tile=%@", EGPointIDescription(self.tile)];
    [description appendFormat:@", form=%@", self.form];
    [description appendFormat:@", x=%f", self.x];
    [description appendFormat:@", back=%d", self.back];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRailPointCorrection{
    TRRailPoint* _point;
    double _error;
}
@synthesize point = _point;
@synthesize error = _error;

+ (id)railPointCorrectionWithPoint:(TRRailPoint*)point error:(double)error {
    return [[TRRailPointCorrection alloc] initWithPoint:point error:error];
}

- (id)initWithPoint:(TRRailPoint*)point error:(double)error {
    self = [super init];
    if(self) {
        _point = point;
        _error = error;
    }
    
    return self;
}

- (TRRailPoint*)addErrorToPoint {
    if(eqf(_error, 0)) return _point;
    else return [_point addX:_error];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailPointCorrection* o = ((TRRailPointCorrection*)(other));
    return [self.point isEqual:o.point] && eqf(self.error, o.error);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.point hash];
    hash = hash * 31 + [[NSNumber numberWithDouble:self.error] hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"point=%@", self.point];
    [description appendFormat:@", error=%f", self.error];
    [description appendString:@">"];
    return description;
}

@end


