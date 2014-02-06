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

- (CNPair*)neighbours {
    if(self == _TRRailConnector_left) {
        return [CNPair pairWithA:_TRRailConnector_top b:_TRRailConnector_bottom];
    } else {
        if(self == _TRRailConnector_right) {
            return [CNPair pairWithA:_TRRailConnector_top b:_TRRailConnector_bottom];
        } else {
            if(self == _TRRailConnector_top) return [CNPair pairWithA:_TRRailConnector_left b:_TRRailConnector_right];
            else return [CNPair pairWithA:_TRRailConnector_left b:_TRRailConnector_right];
        }
    }
}

- (GEVec2i)nextTile:(GEVec2i)tile {
    return GEVec2iMake(tile.x + _x, tile.y + _y);
}

- (GEVec2i)vec {
    return GEVec2iMake(_x, _y);
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
    GEVec2(^_pointFun)(CGFloat);
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

+ (id)railFormWithOrdinal:(NSUInteger)ordinal name:(NSString*)name start:(TRRailConnector*)start end:(TRRailConnector*)end isTurn:(BOOL)isTurn length:(CGFloat)length pointFun:(GEVec2(^)(CGFloat))pointFun {
    return [[TRRailForm alloc] initWithOrdinal:ordinal name:name start:start end:end isTurn:isTurn length:length pointFun:pointFun];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name start:(TRRailConnector*)start end:(TRRailConnector*)end isTurn:(BOOL)isTurn length:(CGFloat)length pointFun:(GEVec2(^)(CGFloat))pointFun {
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
    _TRRailForm_leftBottom = [TRRailForm railFormWithOrdinal:0 name:@"leftBottom" start:TRRailConnector.left end:TRRailConnector.bottom isTurn:YES length:M_PI_4 pointFun:^GEVec2(CGFloat x) {
        return GEVec2Make(((float)(-0.5 + 0.5 * sin(x * 2))), ((float)(-0.5 + 0.5 * cos(x * 2))));
    }];
    _TRRailForm_leftRight = [TRRailForm railFormWithOrdinal:1 name:@"leftRight" start:TRRailConnector.left end:TRRailConnector.right isTurn:NO length:1.0 pointFun:^GEVec2(CGFloat x) {
        return GEVec2Make(((float)(x - 0.5)), 0.0);
    }];
    _TRRailForm_leftTop = [TRRailForm railFormWithOrdinal:2 name:@"leftTop" start:TRRailConnector.left end:TRRailConnector.top isTurn:YES length:M_PI_4 pointFun:^GEVec2(CGFloat x) {
        return GEVec2Make(((float)(-0.5 + 0.5 * sin(x * 2))), ((float)(0.5 - 0.5 * cos(x * 2))));
    }];
    _TRRailForm_bottomTop = [TRRailForm railFormWithOrdinal:3 name:@"bottomTop" start:TRRailConnector.bottom end:TRRailConnector.top isTurn:NO length:1.0 pointFun:^GEVec2(CGFloat x) {
        return GEVec2Make(0.0, ((float)(x - 0.5)));
    }];
    _TRRailForm_bottomRight = [TRRailForm railFormWithOrdinal:4 name:@"bottomRight" start:TRRailConnector.bottom end:TRRailConnector.right isTurn:YES length:M_PI_4 pointFun:^GEVec2(CGFloat x) {
        return GEVec2Make(((float)(0.5 - 0.5 * cos(x * 2))), ((float)(-0.5 + 0.5 * sin(x * 2))));
    }];
    _TRRailForm_topRight = [TRRailForm railFormWithOrdinal:5 name:@"topRight" start:TRRailConnector.top end:TRRailConnector.right isTurn:YES length:M_PI_4 pointFun:^GEVec2(CGFloat x) {
        return GEVec2Make(((float)(0.5 - 0.5 * cos(x * 2))), ((float)(0.5 - 0.5 * sin(x * 2))));
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

- (BOOL)containsConnector:(TRRailConnector*)connector {
    return _start == connector || _end == connector;
}

- (BOOL)isStraight {
    return !(_isTurn);
}

- (GELine2)line {
    return geLine2ApplyP0P1(geVec2iDivF([_start vec], 2.0), geVec2iDivF([_end vec], 2.0));
}

- (id<CNSeq>)connectors {
    return (@[_start, _end]);
}

- (TRRailConnector*)otherConnectorThan:(TRRailConnector*)than {
    if(than == _start) return _end;
    else return _start;
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


NSString* TRRailPointDescription(TRRailPoint self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRRailPoint: "];
    [description appendFormat:@"tile=%@", GEVec2iDescription(self.tile)];
    [description appendFormat:@", form=%@", self.form];
    [description appendFormat:@", x=%f", self.x];
    [description appendFormat:@", back=%d", self.back];
    [description appendFormat:@", point=%@", GEVec2Description(self.point)];
    [description appendString:@">"];
    return description;
}
TRRailPoint trRailPointApplyTileFormXBack(GEVec2i tile, TRRailForm* form, CGFloat x, BOOL back) {
    CGFloat xx = ((back) ? form.length - x : x);
    GEVec2(^f)(CGFloat) = form.pointFun;
    GEVec2 p = f(xx);
    return TRRailPointMake(tile, form, x, back, GEVec2Make(p.x + tile.x, p.y + tile.y));
}
TRRailPoint trRailPointAddX(TRRailPoint self, CGFloat x) {
    return trRailPointApplyTileFormXBack(self.tile, self.form, self.x + x, self.back);
}
TRRailConnector* trRailPointStartConnector(TRRailPoint self) {
    if(self.back) return self.form.end;
    else return self.form.start;
}
TRRailConnector* trRailPointEndConnector(TRRailPoint self) {
    if(self.back) return self.form.start;
    else return self.form.end;
}
BOOL trRailPointIsValid(TRRailPoint self) {
    return self.x >= 0 && self.x <= self.form.length;
}
TRRailPointCorrection trRailPointCorrect(TRRailPoint self) {
    CGFloat length = self.form.length;
    if(self.x > length) return TRRailPointCorrectionMake(trRailPointApplyTileFormXBack(self.tile, self.form, length, self.back), self.x - length);
    else return TRRailPointCorrectionMake(self, 0.0);
}
TRRailPoint trRailPointInvert(TRRailPoint self) {
    return trRailPointApplyTileFormXBack(self.tile, self.form, self.form.length - self.x, !(self.back));
}
TRRailPoint trRailPointSetX(TRRailPoint self, CGFloat x) {
    return trRailPointApplyTileFormXBack(self.tile, self.form, x, self.back);
}
GEVec2i trRailPointNextTile(TRRailPoint self) {
    return [trRailPointEndConnector(self) nextTile:self.tile];
}
TRRailPoint trRailPointStraight(TRRailPoint self) {
    if(self.back) return trRailPointInvert(self);
    else return self;
}
BOOL trRailPointBetweenAB(TRRailPoint self, TRRailPoint a, TRRailPoint b) {
    if(GEVec2iEq(a.tile, self.tile) && GEVec2iEq(b.tile, self.tile) && a.form == self.form && b.form == self.form) {
        CGFloat ax = trRailPointStraight(a).x;
        CGFloat bx = trRailPointStraight(b).x;
        if(ax > bx) return floatBetween(trRailPointStraight(self).x, bx, ax);
        else return floatBetween(trRailPointStraight(self).x, ax, bx);
    } else {
        return NO;
    }
}
ODPType* trRailPointType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[TRRailPointWrap class] name:@"TRRailPoint" size:sizeof(TRRailPoint) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRRailPoint, ((TRRailPoint*)(data))[i]);
    }];
    return _ret;
}
@implementation TRRailPointWrap{
    TRRailPoint _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRRailPoint)value {
    return [[TRRailPointWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRRailPoint)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return TRRailPointDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailPointWrap* o = ((TRRailPointWrap*)(other));
    return TRRailPointEq(_value, o.value);
}

- (NSUInteger)hash {
    return TRRailPointHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



NSString* TRRailPointCorrectionDescription(TRRailPointCorrection self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRRailPointCorrection: "];
    [description appendFormat:@"point=%@", TRRailPointDescription(self.point)];
    [description appendFormat:@", error=%f", self.error];
    [description appendString:@">"];
    return description;
}
TRRailPoint trRailPointCorrectionAddErrorToPoint(TRRailPointCorrection self) {
    if(eqf(self.error, 0)) return self.point;
    else return trRailPointAddX(self.point, self.error);
}
ODPType* trRailPointCorrectionType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[TRRailPointCorrectionWrap class] name:@"TRRailPointCorrection" size:sizeof(TRRailPointCorrection) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRRailPointCorrection, ((TRRailPointCorrection*)(data))[i]);
    }];
    return _ret;
}
@implementation TRRailPointCorrectionWrap{
    TRRailPointCorrection _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRRailPointCorrection)value {
    return [[TRRailPointCorrectionWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRRailPointCorrection)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return TRRailPointCorrectionDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailPointCorrectionWrap* o = ((TRRailPointCorrectionWrap*)(other));
    return TRRailPointCorrectionEq(_value, o.value);
}

- (NSUInteger)hash {
    return TRRailPointCorrectionHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



