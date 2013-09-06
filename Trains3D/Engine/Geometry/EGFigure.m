#import "EGFigure.h"

#import "EGMath.h"
@implementation EGLine
static ODClassType* _EGLine_type;

+ (id)line {
    return [[EGLine alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGLine_type = [ODClassType classTypeWithCls:[EGLine class]];
}

+ (EGLine*)newWithSlope:(CGFloat)slope point:(EGVec2)point {
    return [EGSlopeLine slopeLineWithSlope:slope constant:[EGLine calculateConstantWithSlope:slope point:point]];
}

+ (EGLine*)newWithP1:(EGVec2)p1 p2:(EGVec2)p2 {
    if(eqf4(p1.x, p2.x)) {
        return [EGVerticalLine verticalLineWithX:((CGFloat)(p1.x))];
    } else {
        CGFloat slope = [EGLine calculateSlopeWithP1:p1 p2:p2];
        return [EGSlopeLine slopeLineWithSlope:slope constant:[EGLine calculateConstantWithSlope:slope point:p1]];
    }
}

+ (CGFloat)calculateSlopeWithP1:(EGVec2)p1 p2:(EGVec2)p2 {
    return ((CGFloat)((p2.y - p1.y) / (p2.x - p1.x)));
}

+ (CGFloat)calculateConstantWithSlope:(CGFloat)slope point:(EGVec2)point {
    return ((CGFloat)(point.y - slope * point.x));
}

- (BOOL)containsPoint:(EGVec2)point {
    @throw @"Method contains is abstract";
}

- (BOOL)isVertical {
    @throw @"Method isVertical is abstract";
}

- (BOOL)isHorizontal {
    @throw @"Method isHorizontal is abstract";
}

- (id)intersectionWithLine:(EGLine*)line {
    @throw @"Method intersectionWith is abstract";
}

- (CGFloat)xIntersectionWithLine:(EGLine*)line {
    @throw @"Method xIntersectionWith is abstract";
}

- (BOOL)isRightPoint:(EGVec2)point {
    @throw @"Method isRight is abstract";
}

- (CGFloat)slope {
    @throw @"Method slope is abstract";
}

- (id)moveWithDistance:(CGFloat)distance {
    @throw @"Method moveWith is abstract";
}

- (CGFloat)angle {
    @throw @"Method angle is abstract";
}

- (CGFloat)degreeAngle {
    return self.angle * 180 / M_PI;
}

- (EGLine*)perpendicularWithPoint:(EGVec2)point {
    @throw @"Method perpendicularWith is abstract";
}

- (ODClassType*)type {
    return [EGLine type];
}

+ (ODClassType*)type {
    return _EGLine_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSlopeLine{
    CGFloat _slope;
    CGFloat _constant;
}
static ODClassType* _EGSlopeLine_type;
@synthesize slope = _slope;
@synthesize constant = _constant;

+ (id)slopeLineWithSlope:(CGFloat)slope constant:(CGFloat)constant {
    return [[EGSlopeLine alloc] initWithSlope:slope constant:constant];
}

- (id)initWithSlope:(CGFloat)slope constant:(CGFloat)constant {
    self = [super init];
    if(self) {
        _slope = slope;
        _constant = constant;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSlopeLine_type = [ODClassType classTypeWithCls:[EGSlopeLine class]];
}

- (BOOL)containsPoint:(EGVec2)point {
    return eqf4(point.y, _slope * point.x + _constant);
}

- (BOOL)isVertical {
    return NO;
}

- (BOOL)isHorizontal {
    return eqf(_slope, 0);
}

- (CGFloat)xIntersectionWithLine:(EGLine*)line {
    if([line isVertical]) {
        return [line xIntersectionWithLine:self];
    } else {
        EGSlopeLine* that = ((EGSlopeLine*)(line));
        return (that.constant - _constant) / (_slope - that.slope);
    }
}

- (CGFloat)yForX:(CGFloat)x {
    return _slope * x + _constant;
}

- (id)intersectionWithLine:(EGLine*)line {
    if(!([line isVertical]) && eqf(((EGSlopeLine*)(line)).slope, _slope)) {
        return [CNOption none];
    } else {
        CGFloat xInt = [self xIntersectionWithLine:line];
        return [CNOption opt:wrap(EGVec2, EGVec2Make(((float)(xInt)), ((float)([self yForX:xInt]))))];
    }
}

- (BOOL)isRightPoint:(EGVec2)point {
    if([self containsPoint:point]) return NO;
    else return point.y < [self yForX:((CGFloat)(point.x))];
}

- (id)moveWithDistance:(CGFloat)distance {
    return [EGSlopeLine slopeLineWithSlope:_slope constant:_constant + distance];
}

- (CGFloat)angle {
    CGFloat a = atan(_slope);
    if(a < 0) return M_PI + a;
    else return a;
}

- (EGLine*)perpendicularWithPoint:(EGVec2)point {
    if(eqf(_slope, 0)) return [EGVerticalLine verticalLineWithX:((CGFloat)(point.x))];
    else return [EGLine newWithSlope:-_slope point:point];
}

- (ODClassType*)type {
    return [EGSlopeLine type];
}

+ (ODClassType*)type {
    return _EGSlopeLine_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSlopeLine* o = ((EGSlopeLine*)(other));
    return eqf(self.slope, o.slope) && eqf(self.constant, o.constant);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.slope);
    hash = hash * 31 + floatHash(self.constant);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"slope=%f", self.slope];
    [description appendFormat:@", constant=%f", self.constant];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGVerticalLine{
    CGFloat _x;
}
static ODClassType* _EGVerticalLine_type;
@synthesize x = _x;

+ (id)verticalLineWithX:(CGFloat)x {
    return [[EGVerticalLine alloc] initWithX:x];
}

- (id)initWithX:(CGFloat)x {
    self = [super init];
    if(self) _x = x;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGVerticalLine_type = [ODClassType classTypeWithCls:[EGVerticalLine class]];
}

- (BOOL)containsPoint:(EGVec2)point {
    return eqf4(point.x, _x);
}

- (BOOL)isVertical {
    return YES;
}

- (BOOL)isHorizontal {
    return NO;
}

- (CGFloat)xIntersectionWithLine:(EGLine*)line {
    return _x;
}

- (id)intersectionWithLine:(EGLine*)line {
    if([line isVertical]) return [CNOption none];
    else return [line intersectionWithLine:self];
}

- (BOOL)isRightPoint:(EGVec2)point {
    return point.x > _x;
}

- (CGFloat)slope {
    return DBL_MAX;
}

- (id)moveWithDistance:(CGFloat)distance {
    return [EGVerticalLine verticalLineWithX:_x + distance];
}

- (CGFloat)angle {
    return M_PI_2;
}

- (EGLine*)perpendicularWithPoint:(EGVec2)point {
    return [EGSlopeLine slopeLineWithSlope:0.0 constant:((CGFloat)(point.y))];
}

- (ODClassType*)type {
    return [EGVerticalLine type];
}

+ (ODClassType*)type {
    return _EGVerticalLine_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVerticalLine* o = ((EGVerticalLine*)(other));
    return eqf(self.x, o.x);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.x);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"x=%f", self.x];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGLineSegment{
    EGVec2 _p1;
    EGVec2 _p2;
    EGLine* __line;
    EGRect _boundingRect;
}
static ODClassType* _EGLineSegment_type;
@synthesize p1 = _p1;
@synthesize p2 = _p2;
@synthesize boundingRect = _boundingRect;

+ (id)lineSegmentWithP1:(EGVec2)p1 p2:(EGVec2)p2 {
    return [[EGLineSegment alloc] initWithP1:p1 p2:p2];
}

- (id)initWithP1:(EGVec2)p1 p2:(EGVec2)p2 {
    self = [super init];
    if(self) {
        _p1 = p1;
        _p2 = p2;
        _boundingRect = egRectNewXYXX2YY2(min(((CGFloat)(_p1.x)), ((CGFloat)(_p2.x))), max(((CGFloat)(_p1.x)), ((CGFloat)(_p2.x))), min(((CGFloat)(_p1.y)), ((CGFloat)(_p2.y))), max(((CGFloat)(_p1.y)), ((CGFloat)(_p2.y))));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGLineSegment_type = [ODClassType classTypeWithCls:[EGLineSegment class]];
}

+ (EGLineSegment*)newWithP1:(EGVec2)p1 p2:(EGVec2)p2 {
    if(egVec2CompareTo(p1, p2) < 0) return [EGLineSegment lineSegmentWithP1:p1 p2:p2];
    else return [EGLineSegment lineSegmentWithP1:p2 p2:p1];
}

+ (EGLineSegment*)newWithX1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2 {
    return [EGLineSegment newWithP1:EGVec2Make(((float)(x1)), ((float)(y1))) p2:EGVec2Make(((float)(x2)), ((float)(y2)))];
}

- (BOOL)isVertical {
    return eqf4(_p1.x, _p2.x);
}

- (BOOL)isHorizontal {
    return eqf4(_p1.y, _p2.y);
}

- (EGLine*)line {
    if(__line == nil) __line = [EGLine newWithP1:_p1 p2:_p2];
    return __line;
}

- (BOOL)containsPoint:(EGVec2)point {
    return EGVec2Eq(_p1, point) || EGVec2Eq(_p2, point) || ([self.line containsPoint:point] && egRectContainsPoint(_boundingRect, point));
}

- (BOOL)containsInBoundingRectPoint:(EGVec2)point {
    return egRectContainsPoint(_boundingRect, point);
}

- (id)intersectionWithSegment:(EGLineSegment*)segment {
    if(EGVec2Eq(_p1, segment.p2)) {
        return [CNOption opt:wrap(EGVec2, _p1)];
    } else {
        if(EGVec2Eq(_p2, segment.p1)) {
            return [CNOption opt:wrap(EGVec2, _p2)];
        } else {
            if(EGVec2Eq(_p1, segment.p1)) {
                if([self.line isEqual:[segment line]]) return [CNOption none];
                else return [CNOption opt:wrap(EGVec2, _p1)];
            } else {
                if(EGVec2Eq(_p2, segment.p2)) {
                    if([self.line isEqual:[segment line]]) return [CNOption none];
                    else return [CNOption opt:wrap(EGVec2, _p2)];
                } else {
                    return [[self.line intersectionWithLine:[segment line]] filter:^BOOL(id p) {
                        return [self containsInBoundingRectPoint:uwrap(EGVec2, p)] && [segment containsInBoundingRectPoint:uwrap(EGVec2, p)];
                    }];
                }
            }
        }
    }
}

- (BOOL)endingsContainPoint:(EGVec2)point {
    return EGVec2Eq(_p1, point) || EGVec2Eq(_p2, point);
}

- (id<CNSeq>)segments {
    return (@[self]);
}

- (EGLineSegment*)moveWithPoint:(EGVec2)point {
    return [self moveWithX:((CGFloat)(point.x)) y:((CGFloat)(point.y))];
}

- (EGLineSegment*)moveWithX:(CGFloat)x y:(CGFloat)y {
    EGLineSegment* ret = [EGLineSegment lineSegmentWithP1:EGVec2Make(_p1.x + x, _p1.y + y) p2:EGVec2Make(_p2.x + x, _p2.y + y)];
    if(__line != nil) [ret setLine:[__line moveWithDistance:x + y]];
    return ret;
}

- (void)setLine:(EGLine*)line {
    __line = line;
}

- (ODClassType*)type {
    return [EGLineSegment type];
}

+ (ODClassType*)type {
    return _EGLineSegment_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGLineSegment* o = ((EGLineSegment*)(other));
    return EGVec2Eq(self.p1, o.p1) && EGVec2Eq(self.p2, o.p2);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec2Hash(self.p1);
    hash = hash * 31 + EGVec2Hash(self.p2);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"p1=%@", EGVec2Description(self.p1)];
    [description appendFormat:@", p2=%@", EGVec2Description(self.p2)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGPolygon{
    id<CNSeq> _points;
    id<CNSeq> _segments;
}
static ODClassType* _EGPolygon_type;
@synthesize points = _points;
@synthesize segments = _segments;

+ (id)polygonWithPoints:(id<CNSeq>)points {
    return [[EGPolygon alloc] initWithPoints:points];
}

- (id)initWithPoints:(id<CNSeq>)points {
    self = [super init];
    if(self) {
        _points = points;
        _segments = [[[[_points chain] neighborsRing] map:^EGLineSegment*(CNTuple* ps) {
            return [EGLineSegment newWithP1:uwrap(EGVec2, ps.a) p2:uwrap(EGVec2, ps.b)];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGPolygon_type = [ODClassType classTypeWithCls:[EGPolygon class]];
}

- (EGRect)boundingRect {
    __block CGFloat minX = DBL_MAX;
    __block CGFloat maxX = DBL_MIN;
    __block CGFloat minY = DBL_MAX;
    __block CGFloat maxY = DBL_MIN;
    [_points forEach:^void(id p) {
        if(uwrap(EGVec2, p).x < minX) minX = ((CGFloat)(uwrap(EGVec2, p).x));
        if(uwrap(EGVec2, p).x > maxX) maxX = ((CGFloat)(uwrap(EGVec2, p).x));
        if(uwrap(EGVec2, p).y < minY) minY = ((CGFloat)(uwrap(EGVec2, p).y));
        if(uwrap(EGVec2, p).y > maxY) maxY = ((CGFloat)(uwrap(EGVec2, p).y));
    }];
    return egRectNewXYXX2YY2(minX, maxX, minY, maxY);
}

- (ODClassType*)type {
    return [EGPolygon type];
}

+ (ODClassType*)type {
    return _EGPolygon_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGPolygon* o = ((EGPolygon*)(other));
    return [self.points isEqual:o.points];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.points hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"points=%@", self.points];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGThickLineSegment{
    EGLineSegment* _segment;
    CGFloat _thickness;
    CGFloat _thickness_2;
    id<CNSeq> __segments;
}
static ODClassType* _EGThickLineSegment_type;
@synthesize segment = _segment;
@synthesize thickness = _thickness;
@synthesize thickness_2 = _thickness_2;

+ (id)thickLineSegmentWithSegment:(EGLineSegment*)segment thickness:(CGFloat)thickness {
    return [[EGThickLineSegment alloc] initWithSegment:segment thickness:thickness];
}

- (id)initWithSegment:(EGLineSegment*)segment thickness:(CGFloat)thickness {
    self = [super init];
    if(self) {
        _segment = segment;
        _thickness = thickness;
        _thickness_2 = _thickness / 2;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGThickLineSegment_type = [ODClassType classTypeWithCls:[EGThickLineSegment class]];
}

- (EGRect)boundingRect {
    return egRectThickenXY(_segment.boundingRect, ((CGFloat)((([_segment isHorizontal]) ? 0 : _thickness_2))), ((CGFloat)((([_segment isVertical]) ? 0 : _thickness_2))));
}

- (id<CNSeq>)segments {
    if(__segments == nil) {
        CGFloat dx = 0.0;
        CGFloat dy = 0.0;
        if([_segment isVertical]) {
            dx = _thickness_2;
            dy = 0.0;
        } else {
            if([_segment isHorizontal]) {
                dx = 0.0;
                dy = _thickness_2;
            } else {
                CGFloat k = [[_segment line] slope];
                dy = _thickness_2 / sqrt(1 + k);
                dx = k * dy;
            }
        }
        EGLineSegment* line1 = [_segment moveWithX:-dx y:dy];
        EGLineSegment* line2 = [_segment moveWithX:dx y:-dy];
        EGLineSegment* line3 = [EGLineSegment newWithP1:line1.p1 p2:line2.p1];
        __segments = (@[line1, line2, line3, [line3 moveWithPoint:egVec2SubVec2(_segment.p2, _segment.p1)]]);
    }
    return __segments;
}

- (ODClassType*)type {
    return [EGThickLineSegment type];
}

+ (ODClassType*)type {
    return _EGThickLineSegment_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGThickLineSegment* o = ((EGThickLineSegment*)(other));
    return [self.segment isEqual:o.segment] && eqf(self.thickness, o.thickness);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.segment hash];
    hash = hash * 31 + floatHash(self.thickness);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"segment=%@", self.segment];
    [description appendFormat:@", thickness=%f", self.thickness];
    [description appendString:@">"];
    return description;
}

@end


