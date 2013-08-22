#import "EGFigureTest.h"

#import "EGFigure.h"
@implementation EGFigureTest

+ (id)figureTest {
    return [[EGFigureTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)testThickLine {
    EGThickLineSegment* l = [EGThickLineSegment thickLineSegmentWithSegment:[EGLineSegment lineSegmentWithP1:EGPointMake(((CGFloat)(0)), ((CGFloat)(0))) p2:EGPointMake(((CGFloat)(1)), ((CGFloat)(0)))] thickness:((CGFloat)(1))];
    [self assertEqualsA:wrap(EGRect, [l boundingRect]) b:wrap(EGRect, EGRectMake(((CGFloat)(0)), ((CGFloat)(1)), -0.5, ((CGFloat)(1))))];
    EGPolygon* p = [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((CGFloat)(0)), 0.5)), wrap(EGPoint, EGPointMake(((CGFloat)(0)), -0.5)), wrap(EGPoint, EGPointMake(((CGFloat)(1)), -0.5)), wrap(EGPoint, EGPointMake(((CGFloat)(1)), 0.5))])];
    [self assertEqualsA:[[l segments] toSet] b:[p.segments toSet]];
    l = [EGThickLineSegment thickLineSegmentWithSegment:[EGLineSegment lineSegmentWithP1:EGPointMake(((CGFloat)(0)), ((CGFloat)(0))) p2:EGPointMake(((CGFloat)(0)), ((CGFloat)(1)))] thickness:((CGFloat)(1))];
    [self assertEqualsA:wrap(EGRect, [l boundingRect]) b:wrap(EGRect, EGRectMake(-0.5, ((CGFloat)(1)), ((CGFloat)(0)), ((CGFloat)(1))))];
    p = [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(0.5, ((CGFloat)(0)))), wrap(EGPoint, EGPointMake(-0.5, ((CGFloat)(0)))), wrap(EGPoint, EGPointMake(-0.5, ((CGFloat)(1)))), wrap(EGPoint, EGPointMake(0.5, ((CGFloat)(1))))])];
    [self assertEqualsA:[[l segments] toSet] b:[p.segments toSet]];
    CGFloat s2 = sqrt(((CGFloat)(2)));
    l = [EGThickLineSegment thickLineSegmentWithSegment:[EGLineSegment lineSegmentWithP1:EGPointMake(((CGFloat)(0)), ((CGFloat)(0))) p2:EGPointMake(((CGFloat)(1)), ((CGFloat)(1)))] thickness:s2];
    [self assertEqualsA:wrap(EGRect, [l boundingRect]) b:wrap(EGRect, egRectThicken(EGRectMake(((CGFloat)(0)), ((CGFloat)(1)), ((CGFloat)(0)), ((CGFloat)(1))), s2 / 2, s2 / 2))];
    p = [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(-0.5, 0.5)), wrap(EGPoint, EGPointMake(0.5, 1.5)), wrap(EGPoint, EGPointMake(1.5, 0.5)), wrap(EGPoint, EGPointMake(0.5, -0.5))])];
    [self assertEqualsA:[[l segments] toSet] b:[p.segments toSet]];
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


