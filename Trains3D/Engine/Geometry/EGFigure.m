#import "EGFigure.h"

@implementation EGLine

+ (id)line {
    return [[EGLine alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (EGLine*)newWithSlope:(double)slope point:(EGPoint)point {
    return [EGSlopeLine slopeLineWithSlope:slope constant:[EGLine calculateConstantWithSlope:slope point:point]];
}

+ (EGLine*)newWithP1:(EGPoint)p1 p2:(EGPoint)p2 {
    if(eqf(p1.x, p2.x)) {
        return [EGVerticalLine verticalLineWithX:p1.x];
    } else {
        double slope = [EGLine calculateSlopeWithP1:p1 p2:p2];
        return [EGSlopeLine slopeLineWithSlope:slope constant:[EGLine calculateConstantWithSlope:slope point:p1]];
    }
}

+ (double)calculateSlopeWithP1:(EGPoint)p1 p2:(EGPoint)p2 {
    return (p2.y - p1.y) / (p2.x - p1.x);
}

+ (double)calculateConstantWithSlope:(double)slope point:(EGPoint)point {
    return point.y - slope * point.x;
}

- (BOOL)containsPoint:(EGPoint)point {
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

- (double)xIntersectionWithLine:(EGLine*)line {
    @throw @"Method xIntersectionWith is abstract";
}

- (BOOL)isRightPoint:(EGPoint)point {
    @throw @"Method isRight is abstract";
}

- (double)slope {
    @throw @"Method slope is abstract";
}

- (id)moveWithDistance:(double)distance {
    @throw @"Method moveWith is abstract";
}

- (double)angle {
    @throw @"Method angle is abstract";
}

- (double)degreeAngle {
    return [self angle] * 180 / M_PI;
}

- (EGLine*)perpendicularWithPoint:(EGPoint)point {
    @throw @"Method perpendicularWith is abstract";
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
    double _slope;
    double _constant;
}
@synthesize slope = _slope;
@synthesize constant = _constant;

+ (id)slopeLineWithSlope:(double)slope constant:(double)constant {
    return [[EGSlopeLine alloc] initWithSlope:slope constant:constant];
}

- (id)initWithSlope:(double)slope constant:(double)constant {
    self = [super init];
    if(self) {
        _slope = slope;
        _constant = constant;
    }
    
    return self;
}

- (BOOL)containsPoint:(EGPoint)point {
    return eqf(point.y, _slope * point.x + _constant);
}

- (BOOL)isVertical {
    return NO;
}

- (BOOL)isHorizontal {
    return eqf(_slope, 0);
}

- (double)xIntersectionWithLine:(EGLine*)line {
    if([line isVertical]) {
        return [line xIntersectionWithLine:self];
    } else {
        EGSlopeLine* that = ((EGSlopeLine*)(line));
        return (that.constant - _constant) / (_slope - that.slope);
    }
}

- (double)yForX:(double)x {
    return _slope * x + _constant;
}

- (id)intersectionWithLine:(EGLine*)line {
    if(!([line isVertical]) && eqf(((EGSlopeLine*)(line)).slope, _slope)) {
        return [CNOption none];
    } else {
        double xInt = [self xIntersectionWithLine:line];
        return [CNOption opt:wrap(EGPoint, EGPointMake(xInt, [self yForX:xInt]))];
    }
}

- (BOOL)isRightPoint:(EGPoint)point {
    if([self containsPoint:point]) return NO;
    else return point.y < [self yForX:point.x];
}

- (id)moveWithDistance:(double)distance {
    return [EGSlopeLine slopeLineWithSlope:_slope constant:_constant + distance];
}

- (double)angle {
    double a = atan(_slope);
    if(a < 0) return M_PI + a;
    else return a;
}

- (EGLine*)perpendicularWithPoint:(EGPoint)point {
    if(eqf(_slope, 0)) return [EGVerticalLine verticalLineWithX:point.x];
    else return [EGLine newWithSlope:-_slope point:point];
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
    hash = hash * 31 + [[NSNumber numberWithDouble:self.slope] hash];
    hash = hash * 31 + [[NSNumber numberWithDouble:self.constant] hash];
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
    double _x;
}
@synthesize x = _x;

+ (id)verticalLineWithX:(double)x {
    return [[EGVerticalLine alloc] initWithX:x];
}

- (id)initWithX:(double)x {
    self = [super init];
    if(self) _x = x;
    
    return self;
}

- (BOOL)containsPoint:(EGPoint)point {
    return eqf(point.x, _x);
}

- (BOOL)isVertical {
    return YES;
}

- (BOOL)isHorizontal {
    return NO;
}

- (double)xIntersectionWithLine:(EGLine*)line {
    return _x;
}

- (id)intersectionWithLine:(EGLine*)line {
    if([line isVertical]) return [CNOption none];
    else return [line intersectionWithLine:self];
}

- (BOOL)isRightPoint:(EGPoint)point {
    return point.x > _x;
}

- (double)slope {
    return DBL_MAX;
}

- (id)moveWithDistance:(double)distance {
    return [EGVerticalLine verticalLineWithX:_x + distance];
}

- (double)angle {
    return M_PI_2;
}

- (EGLine*)perpendicularWithPoint:(EGPoint)point {
    return [EGSlopeLine slopeLineWithSlope:0 constant:point.y];
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
    hash = hash * 31 + [[NSNumber numberWithDouble:self.x] hash];
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
    EGPoint _p1;
    EGPoint _p2;
    EGLine* __line;
    EGRect _boundingRect;
}
@synthesize p1 = _p1;
@synthesize p2 = _p2;
@synthesize boundingRect = _boundingRect;

+ (id)lineSegmentWithP1:(EGPoint)p1 p2:(EGPoint)p2 {
    return [[EGLineSegment alloc] initWithP1:p1 p2:p2];
}

- (id)initWithP1:(EGPoint)p1 p2:(EGPoint)p2 {
    self = [super init];
    if(self) {
        _p1 = p1;
        _p2 = p2;
        _boundingRect = egRectNewXY(min(_p1.x, _p2.x), max(_p1.x, _p2.x), min(_p1.y, _p2.y), max(_p1.y, _p2.y));
    }
    
    return self;
}

+ (EGLineSegment*)newWithP1:(EGPoint)p1 p2:(EGPoint)p2 {
    if(egPointCompare(p1, p2) < 0) return [EGLineSegment lineSegmentWithP1:p1 p2:p2];
    else return [EGLineSegment lineSegmentWithP1:p2 p2:p1];
}

+ (EGLineSegment*)newWithX1:(double)x1 y1:(double)y1 x2:(double)x2 y2:(double)y2 {
    return [EGLineSegment newWithP1:EGPointMake(x1, y1) p2:EGPointMake(x2, y2)];
}

- (BOOL)isVertical {
    return eqf(_p1.x, _p2.x);
}

- (BOOL)isHorizontal {
    return eqf(_p1.y, _p2.y);
}

- (EGLine*)line {
    if(__line == nil) __line = [EGLine newWithP1:_p1 p2:_p2];
    return __line;
}

- (BOOL)containsPoint:(EGPoint)point {
    return EGPointEq(_p1, point) || EGPointEq(_p2, point) || ([[self line] containsPoint:point] && egRectContains(_boundingRect, point));
}

- (BOOL)containsInBoundingRectPoint:(EGPoint)point {
    return egRectContains(_boundingRect, point);
}

- (id)intersectionWithSegment:(EGLineSegment*)segment {
    if(EGPointEq(_p1, segment.p2)) {
        return [CNOption opt:wrap(EGPoint, _p1)];
    } else {
        if(EGPointEq(_p2, segment.p1)) {
            return [CNOption opt:wrap(EGPoint, _p2)];
        } else {
            if(EGPointEq(_p1, segment.p1)) {
                if([[self line] isEqual:[segment line]]) return [CNOption none];
                else return [CNOption opt:wrap(EGPoint, _p1)];
            } else {
                if(EGPointEq(_p2, segment.p2)) {
                    if([[self line] isEqual:[segment line]]) return [CNOption none];
                    else return [CNOption opt:wrap(EGPoint, _p2)];
                } else {
                    return [[[self line] intersectionWithLine:[segment line]] filter:^BOOL(id p) {
                        return [self containsInBoundingRectPoint:uwrap(EGPoint, p)] && [segment containsInBoundingRectPoint:uwrap(EGPoint, p)];
                    }];
                }
            }
        }
    }
}

- (BOOL)endingsContainPoint:(EGPoint)point {
    return EGPointEq(_p1, point) || EGPointEq(_p2, point);
}

- (id<CNList>)segments {
    return (@[self]);
}

- (EGLineSegment*)moveWithPoint:(EGPoint)point {
    return [self moveWithX:point.x y:point.y];
}

- (EGLineSegment*)moveWithX:(double)x y:(double)y {
    EGLineSegment* ret = [EGLineSegment lineSegmentWithP1:EGPointMake(_p1.x + x, _p1.y + y) p2:EGPointMake(_p2.x + x, _p2.y + y)];
    if(__line != nil) [ret setLine:[__line moveWithDistance:x + y]];
    return ret;
}

- (void)setLine:(EGLine*)line {
    __line = line;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGLineSegment* o = ((EGLineSegment*)(other));
    return EGPointEq(self.p1, o.p1) && EGPointEq(self.p2, o.p2);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGPointHash(self.p1);
    hash = hash * 31 + EGPointHash(self.p2);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"p1=%@", EGPointDescription(self.p1)];
    [description appendFormat:@", p2=%@", EGPointDescription(self.p2)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGPolygon{
    id<CNList> _points;
    id<CNList> _segments;
}
@synthesize points = _points;
@synthesize segments = _segments;

+ (id)polygonWithPoints:(id<CNList>)points {
    return [[EGPolygon alloc] initWithPoints:points];
}

- (id)initWithPoints:(id<CNList>)points {
    self = [super init];
    if(self) {
        _points = points;
        _segments = [[[[_points chain] neighborsRing] map:^EGLineSegment*(CNTuple* ps) {
            return [EGLineSegment newWithP1:uwrap(EGPoint, ps.a) p2:uwrap(EGPoint, ps.b)];
        }] toArray];
    }
    
    return self;
}

- (EGRect)boundingRect {
    __block double minX = DBL_MAX;
    __block double maxX = DBL_MIN;
    __block double minY = DBL_MAX;
    __block double maxY = DBL_MIN;
    [_points forEach:^void(id p) {
        if(uwrap(EGPoint, p).x < minX) minX = uwrap(EGPoint, p).x;
        if(uwrap(EGPoint, p).x > maxX) maxX = uwrap(EGPoint, p).x;
        if(uwrap(EGPoint, p).y < minY) minY = uwrap(EGPoint, p).y;
        if(uwrap(EGPoint, p).y > maxY) maxY = uwrap(EGPoint, p).y;
    }];
    return egRectNewXY(minX, maxX, minY, maxY);
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
    double _thickness;
    double _thickness_2;
    id<CNList> __segments;
}
@synthesize segment = _segment;
@synthesize thickness = _thickness;
@synthesize thickness_2 = _thickness_2;

+ (id)thickLineSegmentWithSegment:(EGLineSegment*)segment thickness:(double)thickness {
    return [[EGThickLineSegment alloc] initWithSegment:segment thickness:thickness];
}

- (id)initWithSegment:(EGLineSegment*)segment thickness:(double)thickness {
    self = [super init];
    if(self) {
        _segment = segment;
        _thickness = thickness;
        _thickness_2 = _thickness / 2;
    }
    
    return self;
}

- (EGRect)boundingRect {
    return egRectThicken(_segment.boundingRect, [_segment isHorizontal] ? 0 : _thickness_2, [_segment isVertical] ? 0 : _thickness_2);
}

- (id<CNList>)segments {
    if(__segments == nil) {
        double dx = 0;
        double dy = 0;
        if([_segment isVertical]) {
            dx = _thickness_2;
            dy = 0;
        } else {
            if([_segment isHorizontal]) {
                dx = 0;
                dy = _thickness_2;
            } else {
                double k = [[_segment line] slope];
                dy = _thickness_2 / sqrt(1 + k);
                dx = k * dy;
            }
        }
        EGLineSegment* line1 = [_segment moveWithX:-dx y:dy];
        EGLineSegment* line2 = [_segment moveWithX:dx y:-dy];
        EGLineSegment* line3 = [EGLineSegment newWithP1:line1.p1 p2:line2.p1];
        __segments = (@[line1, line2, line3, [line3 moveWithPoint:egPointSub(_segment.p2, _segment.p1)]]);
    }
    return __segments;
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
    hash = hash * 31 + [[NSNumber numberWithDouble:self.thickness] hash];
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


