#import "GEFigureTest.h"

#import "GEFigure.h"
#import "math.h"
@implementation GEFigureTest
static CNClassType* _GEFigureTest_type;

+ (instancetype)figureTest {
    return [[GEFigureTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GEFigureTest class]) _GEFigureTest_type = [CNClassType classTypeWithCls:[GEFigureTest class]];
}

- (void)testThickLine {
    GEThickLineSegment* l = [GEThickLineSegment thickLineSegmentWithSegment:[GELineSegment lineSegmentWithP0:GEVec2Make(0.0, 0.0) p1:GEVec2Make(1.0, 0.0)] thickness:1.0];
    assertEquals((wrap(GERect, [l boundingRect])), (wrap(GERect, (geRectApplyXYWidthHeight(0.0, -0.5, 1.0, 1.0)))));
    GEPolygon* p = [GEPolygon polygonWithPoints:(@[wrap(GEVec2, (GEVec2Make(0.0, 0.5))), wrap(GEVec2, (GEVec2Make(0.0, -0.5))), wrap(GEVec2, (GEVec2Make(1.0, -0.5))), wrap(GEVec2, (GEVec2Make(1.0, 0.5)))])];
    assertEquals([[l segments] toSet], [p.segments toSet]);
    l = [GEThickLineSegment thickLineSegmentWithSegment:[GELineSegment lineSegmentWithP0:GEVec2Make(0.0, 0.0) p1:GEVec2Make(0.0, 1.0)] thickness:1.0];
    assertEquals((wrap(GERect, [l boundingRect])), (wrap(GERect, (geRectApplyXYWidthHeight(-0.5, 0.0, 1.0, 1.0)))));
    p = [GEPolygon polygonWithPoints:(@[wrap(GEVec2, (GEVec2Make(0.5, 0.0))), wrap(GEVec2, (GEVec2Make(-0.5, 0.0))), wrap(GEVec2, (GEVec2Make(-0.5, 1.0))), wrap(GEVec2, (GEVec2Make(0.5, 1.0)))])];
    assertEquals([[l segments] toSet], [p.segments toSet]);
    CGFloat s2 = sqrt(2.0);
    l = [GEThickLineSegment thickLineSegmentWithSegment:[GELineSegment lineSegmentWithP0:GEVec2Make(0.0, 0.0) p1:GEVec2Make(1.0, 1.0)] thickness:s2];
    assertEquals((wrap(GERect, [l boundingRect])), (wrap(GERect, (geRectThickenHalfSize((geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0)), (GEVec2Make(((float)(s2 / 2)), ((float)(s2 / 2)))))))));
    p = [GEPolygon polygonWithPoints:(@[wrap(GEVec2, (GEVec2Make(-0.5, 0.5))), wrap(GEVec2, (GEVec2Make(0.5, 1.5))), wrap(GEVec2, (GEVec2Make(1.5, 0.5))), wrap(GEVec2, (GEVec2Make(0.5, -0.5)))])];
    assertEquals([[l segments] toSet], [p.segments toSet]);
}

- (NSString*)description {
    return @"FigureTest";
}

- (CNClassType*)type {
    return [GEFigureTest type];
}

+ (CNClassType*)type {
    return _GEFigureTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

