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
    EGThickLineSegment* l = [EGThickLineSegment thickLineSegmentWithSegment:[EGLineSegment lineSegmentWithP1:EGPointMake(0.0, 0.0) p2:EGPointMake(1.0, 0.0)] thickness:1.0];
    [self assertEqualsA:wrap(EGRect, [l boundingRect]) b:wrap(EGRect, EGRectMake(0.0, 1.0, -0.5, 1.0))];
    EGPolygon* p = [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(0.0, 0.5)), wrap(EGPoint, EGPointMake(0.0, -0.5)), wrap(EGPoint, EGPointMake(1.0, -0.5)), wrap(EGPoint, EGPointMake(1.0, 0.5))])];
    [self assertEqualsA:[[l segments] toSet] b:[p.segments toSet]];
    l = [EGThickLineSegment thickLineSegmentWithSegment:[EGLineSegment lineSegmentWithP1:EGPointMake(0.0, 0.0) p2:EGPointMake(0.0, 1.0)] thickness:1.0];
    [self assertEqualsA:wrap(EGRect, [l boundingRect]) b:wrap(EGRect, EGRectMake(-0.5, 1.0, 0.0, 1.0))];
    p = [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(0.5, 0.0)), wrap(EGPoint, EGPointMake(-0.5, 0.0)), wrap(EGPoint, EGPointMake(-0.5, 1.0)), wrap(EGPoint, EGPointMake(0.5, 1.0))])];
    [self assertEqualsA:[[l segments] toSet] b:[p.segments toSet]];
    CGFloat s2 = sqrt(2.0);
    l = [EGThickLineSegment thickLineSegmentWithSegment:[EGLineSegment lineSegmentWithP1:EGPointMake(0.0, 0.0) p2:EGPointMake(1.0, 1.0)] thickness:s2];
    [self assertEqualsA:wrap(EGRect, [l boundingRect]) b:wrap(EGRect, egRectThicken(EGRectMake(0.0, 1.0, 0.0, 1.0), s2 / 2, s2 / 2))];
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


