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
    EGThickLineSegment* l = [EGThickLineSegment thickLineSegmentWithSegment:[EGLineSegment lineSegmentWithP1:EGPointMake(((float)(0)), ((float)(0))) p2:EGPointMake(((float)(1)), ((float)(0)))] thickness:((float)(1))];
    [self assertEqualsA:wrap(EGRect, [l boundingRect]) b:wrap(EGRect, EGRectMake(((float)(0)), ((float)(1)), -0.5, ((float)(1))))];
    EGPolygon* p = [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((float)(0)), 0.5)), wrap(EGPoint, EGPointMake(((float)(0)), -0.5)), wrap(EGPoint, EGPointMake(((float)(1)), -0.5)), wrap(EGPoint, EGPointMake(((float)(1)), 0.5))])];
    [self assertEqualsA:[[l segments] toSet] b:[p.segments toSet]];
    l = [EGThickLineSegment thickLineSegmentWithSegment:[EGLineSegment lineSegmentWithP1:EGPointMake(((float)(0)), ((float)(0))) p2:EGPointMake(((float)(0)), ((float)(1)))] thickness:((float)(1))];
    [self assertEqualsA:wrap(EGRect, [l boundingRect]) b:wrap(EGRect, EGRectMake(-0.5, ((float)(1)), ((float)(0)), ((float)(1))))];
    p = [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(0.5, ((float)(0)))), wrap(EGPoint, EGPointMake(-0.5, ((float)(0)))), wrap(EGPoint, EGPointMake(-0.5, ((float)(1)))), wrap(EGPoint, EGPointMake(0.5, ((float)(1))))])];
    [self assertEqualsA:[[l segments] toSet] b:[p.segments toSet]];
    float s2 = sqrt(((float)(2)));
    l = [EGThickLineSegment thickLineSegmentWithSegment:[EGLineSegment lineSegmentWithP1:EGPointMake(((float)(0)), ((float)(0))) p2:EGPointMake(((float)(1)), ((float)(1)))] thickness:s2];
    [self assertEqualsA:wrap(EGRect, [l boundingRect]) b:wrap(EGRect, egRectThicken(EGRectMake(((float)(0)), ((float)(1)), ((float)(0)), ((float)(1))), s2 / 2, s2 / 2))];
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


