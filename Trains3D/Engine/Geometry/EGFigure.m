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

- (double)yForX:(double)x {
    @throw @"Method yFor is abstract";
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

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGLine* o = ((EGLine*)other);
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
        EGSlopeLine* that = ((EGSlopeLine*)[[line asKindOfClass:[EGSlopeLine class]] get]);
        return (that.constant - _constant) / (_slope - that.slope);
    }
}

- (double)yForX:(double)x {
    return _slope * x + _constant;
}

- (id)intersectionWithLine:(EGLine*)line {
    if(!([line isVertical]) && eqf(((EGSlopeLine*)[[line asKindOfClass:[EGSlopeLine class]] get]).slope, _slope)) {
        return [CNOption none];
    } else {
        double xInt = [self xIntersectionWithLine:line];
        return [CNOption opt:val(EGPointMake(xInt, [self yForX:xInt]))];
    }
}

- (BOOL)isRightPoint:(EGPoint)point {
    if([self containsPoint:point]) return NO;
    else return point.y < [self yForX:point.x];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSlopeLine* o = ((EGSlopeLine*)other);
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

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVerticalLine* o = ((EGVerticalLine*)other);
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
    EGLine* _line;
    double _minX;
    double _maxX;
    double _minY;
    double _maxY;
}
@synthesize p1 = _p1;
@synthesize p2 = _p2;
@synthesize line = _line;
@synthesize minX = _minX;
@synthesize maxX = _maxX;
@synthesize minY = _minY;
@synthesize maxY = _maxY;

+ (id)lineSegmentWithP1:(EGPoint)p1 p2:(EGPoint)p2 {
    return [[EGLineSegment alloc] initWithP1:p1 p2:p2];
}

- (id)initWithP1:(EGPoint)p1 p2:(EGPoint)p2 {
    self = [super init];
    if(self) {
        _p1 = p1;
        _p2 = p2;
        _line = [EGLine newWithP1:_p1 p2:_p2];
        _minX = min(_p1.x, _p1.x);
        _maxX = max(_p1.x, _p1.x);
        _minY = min(_p1.y, _p1.y);
        _maxY = max(_p1.y, _p1.y);
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

- (BOOL)containsPoint:(EGPoint)point {
    return EGPointEq(_p1, point) || EGPointEq(_p2, point) || ([_line containsPoint:point] && point.x >= _minX && point.x <= _maxX && point.y >= _minY && point.y <= _maxY);
}

- (id)intersectionWithSegment:(EGLineSegment*)segment {
    if(EGPointEq(_p1, segment.p2)) {
        return [CNOption opt:val(_p1)];
    } else {
        if(EGPointEq(_p2, segment.p1)) {
            return [CNOption opt:val(_p2)];
        } else {
            if(EGPointEq(_p1, segment.p1)) {
                if([_line isEqual:segment.line]) return [CNOption none];
                else return [CNOption opt:val(_p1)];
            } else {
                if(EGPointEq(_p2, segment.p2)) {
                    if([_line isEqual:segment.line]) return [CNOption none];
                    else return [CNOption opt:val(_p2)];
                } else {
                    return [[_line intersectionWithLine:segment.line] filter:^BOOL(id p) {
                        return [self containsPoint:uval(EGPoint, p)] && [segment containsPoint:uval(EGPoint, p)];
                    }];
                }
            }
        }
    }
}

- (BOOL)endingsContainPoint:(EGPoint)point {
    return EGPointEq(_p1, point) || EGPointEq(_p2, point);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGLineSegment* o = ((EGLineSegment*)other);
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


