#import "TRRailPoint.h"

@implementation TRRailConnector{
    NSInteger _x;
    NSInteger _y;
    NSInteger _angle;
}
static TRRailConnector* _TRRailConnector_left;
static TRRailConnector* _TRRailConnector_bottom;
static TRRailConnector* _TRRailConnector_top;
static TRRailConnector* _TRRailConnector_right;
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
    _TRRailConnector_left = [TRRailConnector railConnectorWithOrdinal:0 name:@"left" x:-1 y:0 angle:0];
    _TRRailConnector_bottom = [TRRailConnector railConnectorWithOrdinal:1 name:@"bottom" x:0 y:-1 angle:90];
    _TRRailConnector_top = [TRRailConnector railConnectorWithOrdinal:2 name:@"top" x:0 y:1 angle:270];
    _TRRailConnector_right = [TRRailConnector railConnectorWithOrdinal:3 name:@"right" x:1 y:0 angle:180];
    _TRRailConnector_values = (@[_TRRailConnector_left, _TRRailConnector_bottom, _TRRailConnector_top, _TRRailConnector_right]);
}

+ (TRRailConnector*)connectorForX:(NSInteger)x y:(NSInteger)y {
    if(x == -1 && y == 0) {
        return _TRRailConnector_left;
    } else {
        if(x == 0 && y == -1) {
            return _TRRailConnector_bottom;
        } else {
            if(x == 0 && y == 1) {
                return _TRRailConnector_top;
            } else {
                if(x == 1 && y == 0) return _TRRailConnector_right;
                else @throw @"No rail connector";
            }
        }
    }
}

- (TRRailConnector*)otherSideConnector {
    if(self == _TRRailConnector_left) {
        return _TRRailConnector_right;
    } else {
        if(self == _TRRailConnector_right) {
            return _TRRailConnector_left;
        } else {
            if(self == _TRRailConnector_top) return _TRRailConnector_bottom;
            else return _TRRailConnector_top;
        }
    }
}

- (EGVec2I)nextTile:(EGVec2I)tile {
    return EGVec2IMake(tile.x + _x, tile.y + _y);
}

+ (TRRailConnector*)left {
    return _TRRailConnector_left;
}

+ (TRRailConnector*)bottom {
    return _TRRailConnector_bottom;
}

+ (TRRailConnector*)top {
    return _TRRailConnector_top;
}

+ (TRRailConnector*)right {
    return _TRRailConnector_right;
}

+ (NSArray*)values {
    return _TRRailConnector_values;
}

@end


@implementation TRRailForm{
    TRRailConnector* _start;
    TRRailConnector* _end;
    BOOL _isTurn;
    CGFloat _length;
    EGVec2(^_pointFun)(CGFloat);
}
static TRRailForm* _TRRailForm_leftBottom;
static TRRailForm* _TRRailForm_leftRight;
static TRRailForm* _TRRailForm_leftTop;
static TRRailForm* _TRRailForm_bottomTop;
static TRRailForm* _TRRailForm_bottomRight;
static TRRailForm* _TRRailForm_topRight;
static NSArray* _TRRailForm_values;
@synthesize start = _start;
@synthesize end = _end;
@synthesize isTurn = _isTurn;
@synthesize length = _length;
@synthesize pointFun = _pointFun;

+ (id)railFormWithOrdinal:(NSUInteger)ordinal name:(NSString*)name start:(TRRailConnector*)start end:(TRRailConnector*)end isTurn:(BOOL)isTurn length:(CGFloat)length pointFun:(EGVec2(^)(CGFloat))pointFun {
    return [[TRRailForm alloc] initWithOrdinal:ordinal name:name start:start end:end isTurn:isTurn length:length pointFun:pointFun];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name start:(TRRailConnector*)start end:(TRRailConnector*)end isTurn:(BOOL)isTurn length:(CGFloat)length pointFun:(EGVec2(^)(CGFloat))pointFun {
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
    _TRRailForm_leftBottom = [TRRailForm railFormWithOrdinal:0 name:@"leftBottom" start:TRRailConnector.left end:TRRailConnector.bottom isTurn:YES length:M_PI_4 pointFun:^EGVec2(CGFloat x) {
        return EGVec2Make(-0.5 + 0.5 * sin(x * 2), -0.5 + 0.5 * cos(x * 2));
    }];
    _TRRailForm_leftRight = [TRRailForm railFormWithOrdinal:1 name:@"leftRight" start:TRRailConnector.left end:TRRailConnector.right isTurn:NO length:1.0 pointFun:^EGVec2(CGFloat x) {
        return EGVec2Make(x - 0.5, 0.0);
    }];
    _TRRailForm_leftTop = [TRRailForm railFormWithOrdinal:2 name:@"leftTop" start:TRRailConnector.left end:TRRailConnector.top isTurn:YES length:M_PI_4 pointFun:^EGVec2(CGFloat x) {
        return EGVec2Make(-0.5 + 0.5 * sin(x * 2), 0.5 - 0.5 * cos(x * 2));
    }];
    _TRRailForm_bottomTop = [TRRailForm railFormWithOrdinal:3 name:@"bottomTop" start:TRRailConnector.bottom end:TRRailConnector.top isTurn:NO length:1.0 pointFun:^EGVec2(CGFloat x) {
        return EGVec2Make(0.0, x - 0.5);
    }];
    _TRRailForm_bottomRight = [TRRailForm railFormWithOrdinal:4 name:@"bottomRight" start:TRRailConnector.bottom end:TRRailConnector.right isTurn:YES length:M_PI_4 pointFun:^EGVec2(CGFloat x) {
        return EGVec2Make(0.5 - 0.5 * cos(x * 2), -0.5 + 0.5 * sin(x * 2));
    }];
    _TRRailForm_topRight = [TRRailForm railFormWithOrdinal:5 name:@"topRight" start:TRRailConnector.top end:TRRailConnector.right isTurn:YES length:M_PI_4 pointFun:^EGVec2(CGFloat x) {
        return EGVec2Make(0.5 - 0.5 * cos(x * 2), 0.5 - 0.5 * sin(x * 2));
    }];
    _TRRailForm_values = (@[_TRRailForm_leftBottom, _TRRailForm_leftRight, _TRRailForm_leftTop, _TRRailForm_bottomTop, _TRRailForm_bottomRight, _TRRailForm_topRight]);
}

+ (TRRailForm*)formForConnector1:(TRRailConnector*)connector1 connector2:(TRRailConnector*)connector2 {
    if(connector1.ordinal > connector2.ordinal) {
        return [TRRailForm formForConnector1:connector2 connector2:connector1];
    } else {
        if(connector1 == TRRailConnector.left && connector2 == TRRailConnector.right) {
            return _TRRailForm_leftRight;
        } else {
            if(connector1 == TRRailConnector.left && connector2 == TRRailConnector.bottom) {
                return _TRRailForm_leftBottom;
            } else {
                if(connector1 == TRRailConnector.left && connector2 == TRRailConnector.top) {
                    return _TRRailForm_leftTop;
                } else {
                    if(connector1 == TRRailConnector.bottom && connector2 == TRRailConnector.top) {
                        return _TRRailForm_bottomTop;
                    } else {
                        if(connector1 == TRRailConnector.bottom && connector2 == TRRailConnector.right) {
                            return _TRRailForm_bottomRight;
                        } else {
                            if(connector1 == TRRailConnector.top && connector2 == TRRailConnector.right) return _TRRailForm_topRight;
                            else @throw @"No form for connectors";
                        }
                    }
                }
            }
        }
    }
}

+ (TRRailForm*)leftBottom {
    return _TRRailForm_leftBottom;
}

+ (TRRailForm*)leftRight {
    return _TRRailForm_leftRight;
}

+ (TRRailForm*)leftTop {
    return _TRRailForm_leftTop;
}

+ (TRRailForm*)bottomTop {
    return _TRRailForm_bottomTop;
}

+ (TRRailForm*)bottomRight {
    return _TRRailForm_bottomRight;
}

+ (TRRailForm*)topRight {
    return _TRRailForm_topRight;
}

+ (NSArray*)values {
    return _TRRailForm_values;
}

@end


@implementation TRRailPoint{
    EGVec2I _tile;
    TRRailForm* _form;
    CGFloat _x;
    BOOL _back;
    EGVec2 _point;
}
static ODClassType* _TRRailPoint_type;
@synthesize tile = _tile;
@synthesize form = _form;
@synthesize x = _x;
@synthesize back = _back;
@synthesize point = _point;

+ (id)railPointWithTile:(EGVec2I)tile form:(TRRailForm*)form x:(CGFloat)x back:(BOOL)back {
    return [[TRRailPoint alloc] initWithTile:tile form:form x:x back:back];
}

- (id)initWithTile:(EGVec2I)tile form:(TRRailForm*)form x:(CGFloat)x back:(BOOL)back {
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

+ (void)initialize {
    [super initialize];
    _TRRailPoint_type = [ODClassType classTypeWithCls:[TRRailPoint class]];
}

- (TRRailPoint*)addX:(CGFloat)x {
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
    CGFloat length = _form.length;
    if(_x > length) return [TRRailPointCorrection railPointCorrectionWithPoint:[TRRailPoint railPointWithTile:_tile form:_form x:length back:_back] error:_x - length];
    else return [TRRailPointCorrection railPointCorrectionWithPoint:self error:0.0];
}

- (EGVec2)calculatePoint {
    CGFloat x = ((_back) ? _form.length - _x : _x);
    EGVec2(^f)(CGFloat) = _form.pointFun;
    EGVec2 p = f(x);
    return EGVec2Make(p.x + _tile.x, p.y + _tile.y);
}

- (TRRailPoint*)invert {
    return [TRRailPoint railPointWithTile:_tile form:_form x:_form.length - _x back:!(_back)];
}

- (TRRailPoint*)setX:(CGFloat)x {
    return [TRRailPoint railPointWithTile:_tile form:_form x:x back:_back];
}

- (EGVec2I)nextTile {
    return [[self endConnector] nextTile:_tile];
}

- (ODClassType*)type {
    return [TRRailPoint type];
}

+ (ODClassType*)type {
    return _TRRailPoint_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailPoint* o = ((TRRailPoint*)(other));
    return EGVec2IEq(self.tile, o.tile) && self.form == o.form && eqf(self.x, o.x) && self.back == o.back;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec2IHash(self.tile);
    hash = hash * 31 + [self.form ordinal];
    hash = hash * 31 + floatHash(self.x);
    hash = hash * 31 + self.back;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tile=%@", EGVec2IDescription(self.tile)];
    [description appendFormat:@", form=%@", self.form];
    [description appendFormat:@", x=%f", self.x];
    [description appendFormat:@", back=%d", self.back];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRailPointCorrection{
    TRRailPoint* _point;
    CGFloat _error;
}
static ODClassType* _TRRailPointCorrection_type;
@synthesize point = _point;
@synthesize error = _error;

+ (id)railPointCorrectionWithPoint:(TRRailPoint*)point error:(CGFloat)error {
    return [[TRRailPointCorrection alloc] initWithPoint:point error:error];
}

- (id)initWithPoint:(TRRailPoint*)point error:(CGFloat)error {
    self = [super init];
    if(self) {
        _point = point;
        _error = error;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRailPointCorrection_type = [ODClassType classTypeWithCls:[TRRailPointCorrection class]];
}

- (TRRailPoint*)addErrorToPoint {
    if(eqf(_error, 0)) return _point;
    else return [_point addX:_error];
}

- (ODClassType*)type {
    return [TRRailPointCorrection type];
}

+ (ODClassType*)type {
    return _TRRailPointCorrection_type;
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
    hash = hash * 31 + floatHash(self.error);
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


