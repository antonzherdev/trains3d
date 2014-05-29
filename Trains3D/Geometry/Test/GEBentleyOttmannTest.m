#import "GEBentleyOttmannTest.h"

#import "GEFigure.h"
#import "GEBentleyOttmann.h"
@implementation GEBentleyOttmannTest
static CNClassType* _GEBentleyOttmannTest_type;

+ (instancetype)bentleyOttmannTest {
    return [[GEBentleyOttmannTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GEBentleyOttmannTest class]) _GEBentleyOttmannTest_type = [CNClassType classTypeWithCls:[GEBentleyOttmannTest class]];
}

- (void)testMain {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@2, [GELineSegment newWithX1:-2.0 y1:1.0 x2:2.0 y2:1.0]), tuple(@3, [GELineSegment newWithX1:-2.0 y1:2.0 x2:1.0 y2:-1.0])])];
    id<CNSet> e = [(@[[GEIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@2] point:GEVec2Make(1.0, 1.0)], [GEIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@3] point:GEVec2Make(0.0, 0.0)], [GEIntersection intersectionWithItems:[CNPair pairWithA:@2 b:@3] point:GEVec2Make(-1.0, 1.0)]]) toSet];
    assertEquals(e, r);
}

- (void)testInPoint {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@3, [GELineSegment newWithX1:-2.0 y1:2.0 x2:0.0 y2:0.0])])];
    assertEquals(([(@[[GEIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@3] point:GEVec2Make(0.0, 0.0)]]) toSet]), r);
}

- (void)testNoCross {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@3, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:0.0])])];
    assertTrue([r isEmpty]);
}

- (void)testVertical {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@2, [GELineSegment newWithX1:1.0 y1:-2.0 x2:1.0 y2:2.0]), tuple(@3, [GELineSegment newWithX1:1.0 y1:-4.0 x2:1.0 y2:0.0]), tuple(@4, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:-4.0]), tuple(@5, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:-1.0])])];
    id<CNSet> e = [(@[[GEIntersection intersectionWithItems:[CNPair pairWithA:@3 b:@4] point:GEVec2Make(1.0, -3.0)], [GEIntersection intersectionWithItems:[CNPair pairWithA:@2 b:@5] point:GEVec2Make(1.0, -1.0)], [GEIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@2] point:GEVec2Make(1.0, 1.0)], [GEIntersection intersectionWithItems:[CNPair pairWithA:@3 b:@5] point:GEVec2Make(1.0, -1.0)]]) toSet];
    assertEquals(e, r);
}

- (void)testVerticalInPoint {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:0.0 y1:0.0 x2:0.0 y2:1.0]), tuple(@2, [GELineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:1.0]), tuple(@3, [GELineSegment newWithX1:-1.0 y1:0.0 x2:1.0 y2:0.0])])];
    id<CNSet> e = [(@[[GEIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@2] point:GEVec2Make(0.0, 1.0)], [GEIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@3] point:GEVec2Make(0.0, 0.0)]]) toSet];
    assertEquals(e, r);
}

- (void)testOneStart {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:-1.0]), tuple(@2, [GELineSegment newWithX1:-1.0 y1:1.0 x2:2.0 y2:1.0]), tuple(@3, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0])])];
    id<CNSet> e = [(@[[GEIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@3] point:GEVec2Make(0.0, 0.0)], [GEIntersection intersectionWithItems:[CNPair pairWithA:@2 b:@3] point:GEVec2Make(1.0, 1.0)]]) toSet];
    assertEquals(e, r);
}

- (void)testOneEnd {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:-2.0 y1:1.0 x2:1.0 y2:1.0]), tuple(@2, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:1.0 y2:1.0]), tuple(@3, [GELineSegment newWithX1:-2.0 y1:2.0 x2:2.0 y2:-2.0])])];
    id<CNSet> e = [(@[[GEIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@3] point:GEVec2Make(-1.0, 1.0)], [GEIntersection intersectionWithItems:[CNPair pairWithA:@2 b:@3] point:GEVec2Make(0.0, 0.0)]]) toSet];
    assertEquals(e, r);
}

- (void)testSameLines {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:-1.0]), tuple(@2, [GELineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:-1.0]), tuple(@3, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0])])];
    id<CNSet> e = [(@[[GEIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@2] point:GEVec2Make(0.0, 0.0)], [GEIntersection intersectionWithItems:[CNPair pairWithA:@2 b:@3] point:GEVec2Make(0.0, 0.0)], [GEIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@3] point:GEVec2Make(0.0, 0.0)]]) toSet];
    assertEquals(e, r);
}

- (NSString*)description {
    return @"BentleyOttmannTest";
}

- (CNClassType*)type {
    return [GEBentleyOttmannTest type];
}

+ (CNClassType*)type {
    return _GEBentleyOttmannTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

