#import "GEFigureTest.h"

#import "GEFigure.h"
@implementation GEFigureTest
static ODClassType* _GEFigureTest_type;

+ (instancetype)figureTest {
    return [[GEFigureTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GEFigureTest class]) _GEFigureTest_type = [ODClassType classTypeWithCls:[GEFigureTest class]];
}

- (void)testThickLine {
    GEThickLineSegment* l = [GEThickLineSegment thickLineSegmentWithSegment:[GELineSegment lineSegmentWithP0:GEVec2Make(0.0, 0.0) p1:GEVec2Make(1.0, 0.0)] thickness:1.0];
    [self assertEqualsA:wrap(GERect, [l boundingRect]) b:wrap(GERect, geRectApplyXYWidthHeight(0.0, -0.5, 1.0, 1.0))];
    GEPolygon* p = [GEPolygon polygonWithPoints:(@[wrap(GEVec2, GEVec2Make(0.0, 0.5)), wrap(GEVec2, GEVec2Make(0.0, -0.5)), wrap(GEVec2, GEVec2Make(1.0, -0.5)), wrap(GEVec2, GEVec2Make(1.0, 0.5))])];
    [self assertEqualsA:[[l segments] toSet] b:[p.segments toSet]];
    l = [GEThickLineSegment thickLineSegmentWithSegment:[GELineSegment lineSegmentWithP0:GEVec2Make(0.0, 0.0) p1:GEVec2Make(0.0, 1.0)] thickness:1.0];
    [self assertEqualsA:wrap(GERect, [l boundingRect]) b:wrap(GERect, geRectApplyXYWidthHeight(-0.5, 0.0, 1.0, 1.0))];
    p = [GEPolygon polygonWithPoints:(@[wrap(GEVec2, GEVec2Make(0.5, 0.0)), wrap(GEVec2, GEVec2Make(-0.5, 0.0)), wrap(GEVec2, GEVec2Make(-0.5, 1.0)), wrap(GEVec2, GEVec2Make(0.5, 1.0))])];
    [self assertEqualsA:[[l segments] toSet] b:[p.segments toSet]];
    CGFloat s2 = sqrt(2.0);
    l = [GEThickLineSegment thickLineSegmentWithSegment:[GELineSegment lineSegmentWithP0:GEVec2Make(0.0, 0.0) p1:GEVec2Make(1.0, 1.0)] thickness:s2];
    [self assertEqualsA:wrap(GERect, [l boundingRect]) b:wrap(GERect, geRectThickenHalfSize(geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0), GEVec2Make(((float)(s2 / 2)), ((float)(s2 / 2)))))];
    p = [GEPolygon polygonWithPoints:(@[wrap(GEVec2, GEVec2Make(-0.5, 0.5)), wrap(GEVec2, GEVec2Make(0.5, 1.5)), wrap(GEVec2, GEVec2Make(1.5, 0.5)), wrap(GEVec2, GEVec2Make(0.5, -0.5))])];
    [self assertEqualsA:[[l segments] toSet] b:[p.segments toSet]];
}

- (ODClassType*)type {
    return [GEFigureTest type];
}

+ (ODClassType*)type {
    return _GEFigureTest_type;
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


