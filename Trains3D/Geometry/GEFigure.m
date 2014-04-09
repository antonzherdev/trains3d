#import "GEFigure.h"

@implementation GELine
static ODClassType* _GELine_type;

+ (instancetype)line {
    return [[GELine alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GELine class]) _GELine_type = [ODClassType classTypeWithCls:[GELine class]];
}

+ (GELine*)applySlope:(CGFloat)slope point:(GEVec2)point {
    return [GESlopeLine slopeLineWithSlope:slope constant:[GELine calculateConstantWithSlope:slope point:point]];
}

+ (GELine*)applyP0:(GEVec2)p0 p1:(GEVec2)p1 {
    if(eqf4(p0.x, p1.x)) {
        return ((GELine*)([GEVerticalLine verticalLineWithX:((CGFloat)(p0.x))]));
    } else {
        CGFloat slope = [GELine calculateSlopeWithP0:p0 p1:p1];
        return ((GELine*)([GESlopeLine slopeLineWithSlope:slope constant:[GELine calculateConstantWithSlope:slope point:p0]]));
    }
}

+ (CGFloat)calculateSlopeWithP0:(GEVec2)p0 p1:(GEVec2)p1 {
    return ((CGFloat)((p1.y - p0.y) / (p1.x - p0.x)));
}

+ (CGFloat)calculateConstantWithSlope:(CGFloat)slope point:(GEVec2)point {
    return ((CGFloat)(point.y - slope * point.x));
}

- (BOOL)containsPoint:(GEVec2)point {
    @throw @"Method contains is abstract";
}

- (BOOL)isVertical {
    @throw @"Method isVertical is abstract";
}

- (BOOL)isHorizontal {
    @throw @"Method isHorizontal is abstract";
}

- (id)intersectionWithLine:(GELine*)line {
    @throw @"Method intersectionWith is abstract";
}

- (CGFloat)xIntersectionWithLine:(GELine*)line {
    @throw @"Method xIntersectionWith is abstract";
}

- (BOOL)isRightPoint:(GEVec2)point {
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
    return ([self angle] * 180) / M_PI;
}

- (GELine*)perpendicularWithPoint:(GEVec2)point {
    @throw @"Method perpendicularWith is abstract";
}

- (ODClassType*)type {
    return [GELine type];
}

+ (ODClassType*)type {
    return _GELine_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation GESlopeLine
static ODClassType* _GESlopeLine_type;
@synthesize slope = _slope;
@synthesize constant = _constant;

+ (instancetype)slopeLineWithSlope:(CGFloat)slope constant:(CGFloat)constant {
    return [[GESlopeLine alloc] initWithSlope:slope constant:constant];
}

- (instancetype)initWithSlope:(CGFloat)slope constant:(CGFloat)constant {
    self = [super init];
    if(self) {
        _slope = slope;
        _constant = constant;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GESlopeLine class]) _GESlopeLine_type = [ODClassType classTypeWithCls:[GESlopeLine class]];
}

- (BOOL)containsPoint:(GEVec2)point {
    return eqf4(point.y, _slope * point.x + _constant);
}

- (BOOL)isVertical {
    return NO;
}

- (BOOL)isHorizontal {
    return eqf(_slope, 0);
}

- (CGFloat)xIntersectionWithLine:(GELine*)line {
    if([line isVertical]) {
        return [line xIntersectionWithLine:self];
    } else {
        GESlopeLine* that = ((GESlopeLine*)(line));
        return (that.constant - _constant) / (_slope - that.slope);
    }
}

- (CGFloat)yForX:(CGFloat)x {
    return _slope * x + _constant;
}

- (id)intersectionWithLine:(GELine*)line {
    if(!([line isVertical]) && eqf(((GESlopeLine*)(line)).slope, _slope)) {
        return nil;
    } else {
        CGFloat xInt = [self xIntersectionWithLine:line];
        return wrap(GEVec2, (GEVec2Make(((float)(xInt)), ((float)([self yForX:xInt])))));
    }
}

- (BOOL)isRightPoint:(GEVec2)point {
    if([self containsPoint:point]) return NO;
    else return point.y < [self yForX:((CGFloat)(point.x))];
}

- (id)moveWithDistance:(CGFloat)distance {
    return [GESlopeLine slopeLineWithSlope:_slope constant:_constant + distance];
}

- (CGFloat)angle {
    CGFloat a = atan(_slope);
    if(a < 0) return M_PI + a;
    else return a;
}

- (GELine*)perpendicularWithPoint:(GEVec2)point {
    if(eqf(_slope, 0)) return ((GELine*)([GEVerticalLine verticalLineWithX:((CGFloat)(point.x))]));
    else return [GELine applySlope:-_slope point:point];
}

- (ODClassType*)type {
    return [GESlopeLine type];
}

+ (ODClassType*)type {
    return _GESlopeLine_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GESlopeLine* o = ((GESlopeLine*)(other));
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


@implementation GEVerticalLine
static ODClassType* _GEVerticalLine_type;
@synthesize x = _x;

+ (instancetype)verticalLineWithX:(CGFloat)x {
    return [[GEVerticalLine alloc] initWithX:x];
}

- (instancetype)initWithX:(CGFloat)x {
    self = [super init];
    if(self) _x = x;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GEVerticalLine class]) _GEVerticalLine_type = [ODClassType classTypeWithCls:[GEVerticalLine class]];
}

- (BOOL)containsPoint:(GEVec2)point {
    return eqf4(point.x, _x);
}

- (BOOL)isVertical {
    return YES;
}

- (BOOL)isHorizontal {
    return NO;
}

- (CGFloat)xIntersectionWithLine:(GELine*)line {
    return _x;
}

- (id)intersectionWithLine:(GELine*)line {
    if([line isVertical]) return nil;
    else return [line intersectionWithLine:self];
}

- (BOOL)isRightPoint:(GEVec2)point {
    return point.x > _x;
}

- (CGFloat)slope {
    return odFloatMax();
}

- (id)moveWithDistance:(CGFloat)distance {
    return [GEVerticalLine verticalLineWithX:_x + distance];
}

- (CGFloat)angle {
    return M_PI_2;
}

- (GELine*)perpendicularWithPoint:(GEVec2)point {
    return [GESlopeLine slopeLineWithSlope:0.0 constant:((CGFloat)(point.y))];
}

- (ODClassType*)type {
    return [GEVerticalLine type];
}

+ (ODClassType*)type {
    return _GEVerticalLine_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEVerticalLine* o = ((GEVerticalLine*)(other));
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


@implementation GELineSegment
static ODClassType* _GELineSegment_type;
@synthesize p0 = _p0;
@synthesize p1 = _p1;
@synthesize boundingRect = _boundingRect;

+ (instancetype)lineSegmentWithP0:(GEVec2)p0 p1:(GEVec2)p1 {
    return [[GELineSegment alloc] initWithP0:p0 p1:p1];
}

- (instancetype)initWithP0:(GEVec2)p0 p1:(GEVec2)p1 {
    self = [super init];
    if(self) {
        _p0 = p0;
        _p1 = p1;
        _dir = _p0.y < _p1.y || (eqf4(_p0.y, _p1.y) && _p0.x < _p1.x);
        _boundingRect = geVec2RectToVec2((GEVec2Make((float4MinB(_p0.x, _p1.x)), (float4MinB(_p0.y, _p1.y)))), (GEVec2Make((float4MaxB(_p0.x, _p1.x)), (float4MaxB(_p0.y, _p1.y)))));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GELineSegment class]) _GELineSegment_type = [ODClassType classTypeWithCls:[GELineSegment class]];
}

+ (GELineSegment*)newWithP0:(GEVec2)p0 p1:(GEVec2)p1 {
    if(geVec2CompareTo(p0, p1) < 0) return [GELineSegment lineSegmentWithP0:p0 p1:p1];
    else return [GELineSegment lineSegmentWithP0:p1 p1:p0];
}

+ (GELineSegment*)newWithX1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2 {
    return [GELineSegment newWithP0:GEVec2Make(((float)(x1)), ((float)(y1))) p1:GEVec2Make(((float)(x2)), ((float)(y2)))];
}

- (BOOL)isVertical {
    return eqf4(_p0.x, _p1.x);
}

- (BOOL)isHorizontal {
    return eqf4(_p0.y, _p1.y);
}

- (GELine*)line {
    if(__line == nil) {
        __line = [GELine applyP0:_p0 p1:_p1];
        return ((GELine*)(nonnil(__line)));
    } else {
        return __line;
    }
}

- (BOOL)containsPoint:(GEVec2)point {
    return GEVec2Eq(_p0, point) || GEVec2Eq(_p1, point) || ([[self line] containsPoint:point] && geRectContainsVec2(_boundingRect, point));
}

- (BOOL)containsInBoundingRectPoint:(GEVec2)point {
    return geRectContainsVec2(_boundingRect, point);
}

- (id)intersectionWithSegment:(GELineSegment*)segment {
    if(GEVec2Eq(_p0, segment.p1)) {
        return wrap(GEVec2, _p0);
    } else {
        if(GEVec2Eq(_p1, segment.p0)) {
            return wrap(GEVec2, _p0);
        } else {
            if(GEVec2Eq(_p0, segment.p0)) {
                if([[self line] isEqual:[segment line]]) return nil;
                else return wrap(GEVec2, _p0);
            } else {
                if(GEVec2Eq(_p1, segment.p1)) {
                    if([[self line] isEqual:[segment line]]) return nil;
                    else return wrap(GEVec2, _p1);
                } else {
                    id p = wrap(GEVec2, (uwrap(GEVec2, [[self line] intersectionWithLine:[segment line]])));
                    if(p != nil) {
                        if([self containsInBoundingRectPoint:uwrap(GEVec2, p)] && [segment containsInBoundingRectPoint:uwrap(GEVec2, p)]) return p;
                        else return nil;
                    } else {
                        return nil;
                    }
                }
            }
        }
    }
}

- (BOOL)endingsContainPoint:(GEVec2)point {
    return GEVec2Eq(_p0, point) || GEVec2Eq(_p1, point);
}

- (NSArray*)segments {
    return (@[self]);
}

- (GELineSegment*)moveWithPoint:(GEVec2)point {
    return [self moveWithX:((CGFloat)(point.x)) y:((CGFloat)(point.y))];
}

- (GELineSegment*)moveWithX:(CGFloat)x y:(CGFloat)y {
    GELineSegment* ret = [GELineSegment lineSegmentWithP0:GEVec2Make(_p0.x + x, _p0.y + y) p1:GEVec2Make(_p1.x + x, _p1.y + y)];
    [ret setLine:[[self line] moveWithDistance:x + y]];
    return ret;
}

- (void)setLine:(GELine*)line {
    __line = line;
}

- (GEVec2)mid {
    return geVec2MidVec2(_p0, _p1);
}

- (CGFloat)angle {
    if(_dir) return [[self line] angle];
    else return M_PI + [[self line] angle];
}

- (CGFloat)degreeAngle {
    if(_dir) return [[self line] degreeAngle];
    else return 180 + [[self line] degreeAngle];
}

- (float)length {
    return geVec2Length((geVec2SubVec2(_p1, _p0)));
}

- (GEVec2)vec {
    return geVec2SubVec2(_p1, _p0);
}

- (GEVec2)vec1 {
    return geVec2SubVec2(_p0, _p1);
}

- (ODClassType*)type {
    return [GELineSegment type];
}

+ (ODClassType*)type {
    return _GELineSegment_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GELineSegment* o = ((GELineSegment*)(other));
    return GEVec2Eq(self.p0, o.p0) && GEVec2Eq(self.p1, o.p1);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.p0);
    hash = hash * 31 + GEVec2Hash(self.p1);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"p0=%@", GEVec2Description(self.p0)];
    [description appendFormat:@", p1=%@", GEVec2Description(self.p1)];
    [description appendString:@">"];
    return description;
}

@end


@implementation GEPolygon
static ODClassType* _GEPolygon_type;
@synthesize points = _points;
@synthesize segments = _segments;

+ (instancetype)polygonWithPoints:(NSArray*)points {
    return [[GEPolygon alloc] initWithPoints:points];
}

- (instancetype)initWithPoints:(NSArray*)points {
    self = [super init];
    if(self) {
        _points = points;
        _segments = [[[[_points chain] neighborsRing] map:^GELineSegment*(CNTuple* ps) {
            return [GELineSegment newWithP0:uwrap(GEVec2, ((CNTuple*)(ps)).a) p1:uwrap(GEVec2, ((CNTuple*)(ps)).b)];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GEPolygon class]) _GEPolygon_type = [ODClassType classTypeWithCls:[GEPolygon class]];
}

- (GERect)boundingRect {
    __block CGFloat minX = odFloatMax();
    __block CGFloat maxX = odFloatMin();
    __block CGFloat minY = odFloatMax();
    __block CGFloat maxY = odFloatMin();
    for(id p in _points) {
        if(uwrap(GEVec2, p).x < minX) minX = ((CGFloat)(uwrap(GEVec2, p).x));
        if(uwrap(GEVec2, p).x > maxX) maxX = ((CGFloat)(uwrap(GEVec2, p).x));
        if(uwrap(GEVec2, p).y < minY) minY = ((CGFloat)(uwrap(GEVec2, p).y));
        if(uwrap(GEVec2, p).y > maxY) maxY = ((CGFloat)(uwrap(GEVec2, p).y));
    }
    return geVec2RectToVec2((GEVec2Make(((float)(minX)), ((float)(minY)))), (GEVec2Make(((float)(maxX)), ((float)(maxY)))));
}

- (ODClassType*)type {
    return [GEPolygon type];
}

+ (ODClassType*)type {
    return _GEPolygon_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEPolygon* o = ((GEPolygon*)(other));
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


@implementation GEThickLineSegment
static ODClassType* _GEThickLineSegment_type;
@synthesize segment = _segment;
@synthesize thickness = _thickness;
@synthesize thickness_2 = _thickness_2;

+ (instancetype)thickLineSegmentWithSegment:(GELineSegment*)segment thickness:(CGFloat)thickness {
    return [[GEThickLineSegment alloc] initWithSegment:segment thickness:thickness];
}

- (instancetype)initWithSegment:(GELineSegment*)segment thickness:(CGFloat)thickness {
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
    if(self == [GEThickLineSegment class]) _GEThickLineSegment_type = [ODClassType classTypeWithCls:[GEThickLineSegment class]];
}

- (GERect)boundingRect {
    return geRectThickenHalfSize(_segment.boundingRect, (GEVec2Make((([_segment isHorizontal]) ? ((float)(0.0)) : ((float)(_thickness_2))), (([_segment isVertical]) ? ((float)(0.0)) : ((float)(_thickness_2))))));
}

- (NSArray*)segments {
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
        GELineSegment* line1 = [_segment moveWithX:-dx y:dy];
        GELineSegment* line2 = [_segment moveWithX:dx y:-dy];
        GELineSegment* line3 = [GELineSegment newWithP0:line1.p0 p1:line2.p0];
        __segments = (@[line1, line2, line3, [line3 moveWithPoint:geVec2SubVec2(_segment.p1, _segment.p0)]]);
        return ((NSArray*)(nonnil(__segments)));
    } else {
        return __segments;
    }
}

- (ODClassType*)type {
    return [GEThickLineSegment type];
}

+ (ODClassType*)type {
    return _GEThickLineSegment_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEThickLineSegment* o = ((GEThickLineSegment*)(other));
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


