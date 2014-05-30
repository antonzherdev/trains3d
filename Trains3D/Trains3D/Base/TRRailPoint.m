#import "TRRailPoint.h"

#import "math.h"
TRRailConnector* TRRailConnector_Values[5];
TRRailConnector* TRRailConnector_left_Desc;
TRRailConnector* TRRailConnector_bottom_Desc;
TRRailConnector* TRRailConnector_top_Desc;
TRRailConnector* TRRailConnector_right_Desc;
@implementation TRRailConnector{
    NSInteger _x;
    NSInteger _y;
    NSInteger _angle;
}
@synthesize x = _x;
@synthesize y = _y;
@synthesize angle = _angle;

+ (instancetype)railConnectorWithOrdinal:(NSUInteger)ordinal name:(NSString*)name x:(NSInteger)x y:(NSInteger)y angle:(NSInteger)angle {
    return [[TRRailConnector alloc] initWithOrdinal:ordinal name:name x:x y:y angle:angle];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name x:(NSInteger)x y:(NSInteger)y angle:(NSInteger)angle {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _x = x;
        _y = y;
        _angle = angle;
    }
    
    return self;
}

+ (void)load {
    [super load];
    TRRailConnector_left_Desc = [TRRailConnector railConnectorWithOrdinal:0 name:@"left" x:-1 y:0 angle:0];
    TRRailConnector_bottom_Desc = [TRRailConnector railConnectorWithOrdinal:1 name:@"bottom" x:0 y:-1 angle:90];
    TRRailConnector_top_Desc = [TRRailConnector railConnectorWithOrdinal:2 name:@"top" x:0 y:1 angle:270];
    TRRailConnector_right_Desc = [TRRailConnector railConnectorWithOrdinal:3 name:@"right" x:1 y:0 angle:180];
    TRRailConnector_Values[0] = nil;
    TRRailConnector_Values[1] = TRRailConnector_left_Desc;
    TRRailConnector_Values[2] = TRRailConnector_bottom_Desc;
    TRRailConnector_Values[3] = TRRailConnector_top_Desc;
    TRRailConnector_Values[4] = TRRailConnector_right_Desc;
}

+ (TRRailConnectorR)connectorForX:(NSInteger)x y:(NSInteger)y {
    if(x == -1 && y == 0) {
        return TRRailConnector_left;
    } else {
        if(x == 0 && y == -1) {
            return TRRailConnector_bottom;
        } else {
            if(x == 0 && y == 1) {
                return TRRailConnector_top;
            } else {
                if(x == 1 && y == 0) return TRRailConnector_right;
                else @throw @"No rail connector";
            }
        }
    }
}

- (TRRailConnectorR)otherSideConnector {
    if(self->_ordinal == TRRailConnector_left) {
        return TRRailConnector_right;
    } else {
        if(self->_ordinal == TRRailConnector_right) {
            return TRRailConnector_left;
        } else {
            if(self->_ordinal == TRRailConnector_top) return TRRailConnector_bottom;
            else return TRRailConnector_top;
        }
    }
}

- (CNPair*)neighbours {
    if(self->_ordinal == TRRailConnector_left) {
        return [CNPair pairWithA:TRRailConnector_Values[TRRailConnector_top] b:TRRailConnector_Values[TRRailConnector_bottom]];
    } else {
        if(self->_ordinal == TRRailConnector_right) {
            return [CNPair pairWithA:TRRailConnector_Values[TRRailConnector_top] b:TRRailConnector_Values[TRRailConnector_bottom]];
        } else {
            if(self->_ordinal == TRRailConnector_top) return [CNPair pairWithA:TRRailConnector_Values[TRRailConnector_left] b:TRRailConnector_Values[TRRailConnector_right]];
            else return [CNPair pairWithA:TRRailConnector_Values[TRRailConnector_left] b:TRRailConnector_Values[TRRailConnector_right]];
        }
    }
}

- (GEVec2i)nextTile:(GEVec2i)tile {
    return GEVec2iMake(tile.x + _x, tile.y + _y);
}

- (GEVec2i)vec {
    return GEVec2iMake(_x, _y);
}

+ (NSArray*)values {
    return (@[TRRailConnector_left_Desc, TRRailConnector_bottom_Desc, TRRailConnector_top_Desc, TRRailConnector_right_Desc]);
}

@end

TRRailForm* TRRailForm_Values[7];
TRRailForm* TRRailForm_leftBottom_Desc;
TRRailForm* TRRailForm_leftRight_Desc;
TRRailForm* TRRailForm_leftTop_Desc;
TRRailForm* TRRailForm_bottomTop_Desc;
TRRailForm* TRRailForm_bottomRight_Desc;
TRRailForm* TRRailForm_topRight_Desc;
@implementation TRRailForm{
    TRRailConnectorR _start;
    TRRailConnectorR _end;
    BOOL _isTurn;
    CGFloat _length;
    GEVec2(^_pointFun)(CGFloat);
}
@synthesize start = _start;
@synthesize end = _end;
@synthesize isTurn = _isTurn;
@synthesize length = _length;
@synthesize pointFun = _pointFun;

+ (instancetype)railFormWithOrdinal:(NSUInteger)ordinal name:(NSString*)name start:(TRRailConnectorR)start end:(TRRailConnectorR)end isTurn:(BOOL)isTurn length:(CGFloat)length pointFun:(GEVec2(^)(CGFloat))pointFun {
    return [[TRRailForm alloc] initWithOrdinal:ordinal name:name start:start end:end isTurn:isTurn length:length pointFun:pointFun];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name start:(TRRailConnectorR)start end:(TRRailConnectorR)end isTurn:(BOOL)isTurn length:(CGFloat)length pointFun:(GEVec2(^)(CGFloat))pointFun {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _start = start;
        _end = end;
        _isTurn = isTurn;
        _length = length;
        _pointFun = [pointFun copy];
    }
    
    return self;
}

+ (void)load {
    [super load];
    TRRailForm_leftBottom_Desc = [TRRailForm railFormWithOrdinal:0 name:@"leftBottom" start:TRRailConnector_left end:TRRailConnector_bottom isTurn:YES length:M_PI_4 pointFun:^GEVec2(CGFloat x) {
        return GEVec2Make(((float)(-0.5 + 0.5 * sin(x * 2))), ((float)(-0.5 + 0.5 * cos(x * 2))));
    }];
    TRRailForm_leftRight_Desc = [TRRailForm railFormWithOrdinal:1 name:@"leftRight" start:TRRailConnector_left end:TRRailConnector_right isTurn:NO length:1.0 pointFun:^GEVec2(CGFloat x) {
        return GEVec2Make(((float)(x - 0.5)), 0.0);
    }];
    TRRailForm_leftTop_Desc = [TRRailForm railFormWithOrdinal:2 name:@"leftTop" start:TRRailConnector_left end:TRRailConnector_top isTurn:YES length:M_PI_4 pointFun:^GEVec2(CGFloat x) {
        return GEVec2Make(((float)(-0.5 + 0.5 * sin(x * 2))), ((float)(0.5 - 0.5 * cos(x * 2))));
    }];
    TRRailForm_bottomTop_Desc = [TRRailForm railFormWithOrdinal:3 name:@"bottomTop" start:TRRailConnector_bottom end:TRRailConnector_top isTurn:NO length:1.0 pointFun:^GEVec2(CGFloat x) {
        return GEVec2Make(0.0, ((float)(x - 0.5)));
    }];
    TRRailForm_bottomRight_Desc = [TRRailForm railFormWithOrdinal:4 name:@"bottomRight" start:TRRailConnector_bottom end:TRRailConnector_right isTurn:YES length:M_PI_4 pointFun:^GEVec2(CGFloat x) {
        return GEVec2Make(((float)(0.5 - 0.5 * cos(x * 2))), ((float)(-0.5 + 0.5 * sin(x * 2))));
    }];
    TRRailForm_topRight_Desc = [TRRailForm railFormWithOrdinal:5 name:@"topRight" start:TRRailConnector_top end:TRRailConnector_right isTurn:YES length:M_PI_4 pointFun:^GEVec2(CGFloat x) {
        return GEVec2Make(((float)(0.5 - 0.5 * cos(x * 2))), ((float)(0.5 - 0.5 * sin(x * 2))));
    }];
    TRRailForm_Values[0] = nil;
    TRRailForm_Values[1] = TRRailForm_leftBottom_Desc;
    TRRailForm_Values[2] = TRRailForm_leftRight_Desc;
    TRRailForm_Values[3] = TRRailForm_leftTop_Desc;
    TRRailForm_Values[4] = TRRailForm_bottomTop_Desc;
    TRRailForm_Values[5] = TRRailForm_bottomRight_Desc;
    TRRailForm_Values[6] = TRRailForm_topRight_Desc;
}

+ (TRRailFormR)formForConnector1:(TRRailConnectorR)connector1 connector2:(TRRailConnectorR)connector2 {
    if(connector1 > connector2) {
        return [TRRailForm formForConnector1:connector2 connector2:connector1];
    } else {
        if(connector1 == TRRailConnector_left && connector2 == TRRailConnector_right) {
            return TRRailForm_leftRight;
        } else {
            if(connector1 == TRRailConnector_left && connector2 == TRRailConnector_bottom) {
                return TRRailForm_leftBottom;
            } else {
                if(connector1 == TRRailConnector_left && connector2 == TRRailConnector_top) {
                    return TRRailForm_leftTop;
                } else {
                    if(connector1 == TRRailConnector_bottom && connector2 == TRRailConnector_top) {
                        return TRRailForm_bottomTop;
                    } else {
                        if(connector1 == TRRailConnector_bottom && connector2 == TRRailConnector_right) {
                            return TRRailForm_bottomRight;
                        } else {
                            if(connector1 == TRRailConnector_top && connector2 == TRRailConnector_right) return TRRailForm_topRight;
                            else @throw @"No form for connectors";
                        }
                    }
                }
            }
        }
    }
}

- (BOOL)containsConnector:(TRRailConnectorR)connector {
    return _start == connector || _end == connector;
}

- (BOOL)isStraight {
    return !(_isTurn);
}

- (GELine2)line {
    return geLine2ApplyP0P1((geVec2iDivF4([TRRailConnector_Values[_start] vec], 2.0)), (geVec2iDivF4([TRRailConnector_Values[_end] vec], 2.0)));
}

- (NSArray*)connectors {
    return (@[TRRailConnector_Values[_start], TRRailConnector_Values[_end]]);
}

- (TRRailConnectorR)otherConnectorThan:(TRRailConnectorR)than {
    if(than == _start) return _end;
    else return _start;
}

+ (NSArray*)values {
    return (@[TRRailForm_leftBottom_Desc, TRRailForm_leftRight_Desc, TRRailForm_leftTop_Desc, TRRailForm_bottomTop_Desc, TRRailForm_bottomRight_Desc, TRRailForm_topRight_Desc]);
}

@end

TRRailPoint trRailPointApply() {
    return TRRailPointMake((GEVec2iMake(0, 0)), TRRailForm_leftRight, 0.5, NO, (GEVec2Make(0.0, 0.0)));
}
TRRailPoint trRailPointApplyTileFormXBack(GEVec2i tile, TRRailFormR form, CGFloat x, BOOL back) {
    CGFloat xx = ((back) ? TRRailForm_Values[form].length - x : x);
    GEVec2(^f)(CGFloat) = TRRailForm_Values[form].pointFun;
    GEVec2 p = f(xx);
    return TRRailPointMake(tile, form, x, back, (GEVec2Make(p.x + tile.x, p.y + tile.y)));
}
TRRailPoint trRailPointAddX(TRRailPoint self, CGFloat x) {
    return trRailPointApplyTileFormXBack(self.tile, self.form, self.x + x, self.back);
}
TRRailConnectorR trRailPointStartConnector(TRRailPoint self) {
    if(self.back) return TRRailForm_Values[self.form].end;
    else return TRRailForm_Values[self.form].start;
}
TRRailConnectorR trRailPointEndConnector(TRRailPoint self) {
    if(self.back) return TRRailForm_Values[self.form].start;
    else return TRRailForm_Values[self.form].end;
}
BOOL trRailPointIsValid(TRRailPoint self) {
    return self.x >= 0 && self.x <= TRRailForm_Values[self.form].length;
}
TRRailPointCorrection trRailPointCorrect(TRRailPoint self) {
    CGFloat length = TRRailForm_Values[self.form].length;
    if(self.x > length) return TRRailPointCorrectionMake((trRailPointApplyTileFormXBack(self.tile, self.form, length, self.back)), self.x - length);
    else return TRRailPointCorrectionMake(self, 0.0);
}
TRRailPoint trRailPointInvert(TRRailPoint self) {
    return trRailPointApplyTileFormXBack(self.tile, self.form, TRRailForm_Values[self.form].length - self.x, !(self.back));
}
TRRailPoint trRailPointSetX(TRRailPoint self, CGFloat x) {
    return trRailPointApplyTileFormXBack(self.tile, self.form, x, self.back);
}
GEVec2i trRailPointNextTile(TRRailPoint self) {
    return [TRRailConnector_Values[trRailPointEndConnector(self)] nextTile:self.tile];
}
TRRailPoint trRailPointStraight(TRRailPoint self) {
    if(self.back) return trRailPointInvert(self);
    else return self;
}
BOOL trRailPointBetweenAB(TRRailPoint self, TRRailPoint a, TRRailPoint b) {
    if(geVec2iIsEqualTo(a.tile, self.tile) && geVec2iIsEqualTo(b.tile, self.tile) && a.form == self.form && b.form == self.form) {
        CGFloat ax = trRailPointStraight(a).x;
        CGFloat bx = trRailPointStraight(b).x;
        if(ax > bx) return floatBetween(trRailPointStraight(self).x, bx, ax);
        else return floatBetween(trRailPointStraight(self).x, ax, bx);
    } else {
        return NO;
    }
}
NSString* trRailPointDescription(TRRailPoint self) {
    return [NSString stringWithFormat:@"RailPoint(%@, %@, %f, %d, %@)", geVec2iDescription(self.tile), TRRailForm_Values[self.form], self.x, self.back, geVec2Description(self.point)];
}
BOOL trRailPointIsEqualTo(TRRailPoint self, TRRailPoint to) {
    return geVec2iIsEqualTo(self.tile, to.tile) && self.form == to.form && eqf(self.x, to.x) && self.back == to.back && geVec2IsEqualTo(self.point, to.point);
}
NSUInteger trRailPointHash(TRRailPoint self) {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2iHash(self.tile);
    hash = hash * 31 + [TRRailForm_Values[self.form] hash];
    hash = hash * 31 + floatHash(self.x);
    hash = hash * 31 + self.back;
    hash = hash * 31 + geVec2Hash(self.point);
    return hash;
}
CNPType* trRailPointType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[TRRailPointWrap class] name:@"TRRailPoint" size:sizeof(TRRailPoint) wrap:^id(void* data, NSUInteger i) {
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
    return trRailPointDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailPointWrap* o = ((TRRailPointWrap*)(other));
    return trRailPointIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return trRailPointHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


TRRailPoint trRailPointCorrectionAddErrorToPoint(TRRailPointCorrection self) {
    if(eqf(self.error, 0)) return self.point;
    else return trRailPointAddX(self.point, self.error);
}
NSString* trRailPointCorrectionDescription(TRRailPointCorrection self) {
    return [NSString stringWithFormat:@"RailPointCorrection(%@, %f)", trRailPointDescription(self.point), self.error];
}
BOOL trRailPointCorrectionIsEqualTo(TRRailPointCorrection self, TRRailPointCorrection to) {
    return trRailPointIsEqualTo(self.point, to.point) && eqf(self.error, to.error);
}
NSUInteger trRailPointCorrectionHash(TRRailPointCorrection self) {
    NSUInteger hash = 0;
    hash = hash * 31 + trRailPointHash(self.point);
    hash = hash * 31 + floatHash(self.error);
    return hash;
}
CNPType* trRailPointCorrectionType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[TRRailPointCorrectionWrap class] name:@"TRRailPointCorrection" size:sizeof(TRRailPointCorrection) wrap:^id(void* data, NSUInteger i) {
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
    return trRailPointCorrectionDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailPointCorrectionWrap* o = ((TRRailPointCorrectionWrap*)(other));
    return trRailPointCorrectionIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return trRailPointCorrectionHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


