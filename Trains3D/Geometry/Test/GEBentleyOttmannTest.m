#import "GEBentleyOttmannTest.h"

#import "GEFigure.h"
#import "GEBentleyOttmann.h"
@implementation GEBentleyOttmannTest
static ODClassType* _GEBentleyOttmannTest_type;

+ (id)bentleyOttmannTest {
    return [[GEBentleyOttmannTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GEBentleyOttmannTest class]) _GEBentleyOttmannTest_type = [ODClassType classTypeWithCls:[GEBentleyOttmannTest class]];
}

- (void)testMain {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@2, [GELineSegment newWithX1:-2.0 y1:1.0 x2:2.0 y2:1.0]), tuple(@3, [GELineSegment newWithX1:-2.0 y1:2.0 x2:1.0 y2:-1.0])])];
    id<CNSet> e = [(@[[GEIntersection intersectionWithItems:[CNPair newWithA:@1 b:@2] point:GEVec2Make(1.0, 1.0)], [GEIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:GEVec2Make(0.0, 0.0)], [GEIntersection intersectionWithItems:[CNPair newWithA:@2 b:@3] point:GEVec2Make(-1.0, 1.0)]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testInPoint {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@3, [GELineSegment newWithX1:-2.0 y1:2.0 x2:0.0 y2:0.0])])];
    [self assertEqualsA:[(@[[GEIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:GEVec2Make(0.0, 0.0)]]) toSet] b:r];
}

- (void)testNoCross {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@3, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:0.0])])];
    [self assertEqualsA:[(@[]) toSet] b:r];
}

- (void)testVertical {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@2, [GELineSegment newWithX1:1.0 y1:-2.0 x2:1.0 y2:2.0]), tuple(@3, [GELineSegment newWithX1:1.0 y1:-4.0 x2:1.0 y2:0.0]), tuple(@4, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:-4.0]), tuple(@5, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:-1.0])])];
    id<CNSet> e = [(@[[GEIntersection intersectionWithItems:[CNPair newWithA:@3 b:@4] point:GEVec2Make(1.0, -3.0)], [GEIntersection intersectionWithItems:[CNPair newWithA:@2 b:@5] point:GEVec2Make(1.0, -1.0)], [GEIntersection intersectionWithItems:[CNPair newWithA:@1 b:@2] point:GEVec2Make(1.0, 1.0)], [GEIntersection intersectionWithItems:[CNPair newWithA:@3 b:@5] point:GEVec2Make(1.0, -1.0)]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testVerticalInPoint {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:0.0 y1:0.0 x2:0.0 y2:1.0]), tuple(@2, [GELineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:1.0]), tuple(@3, [GELineSegment newWithX1:-1.0 y1:0.0 x2:1.0 y2:0.0])])];
    id<CNSet> e = [(@[[GEIntersection intersectionWithItems:[CNPair newWithA:@1 b:@2] point:GEVec2Make(0.0, 1.0)], [GEIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:GEVec2Make(0.0, 0.0)]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testOneStart {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:-1.0]), tuple(@2, [GELineSegment newWithX1:-1.0 y1:1.0 x2:2.0 y2:1.0]), tuple(@3, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0])])];
    id<CNSet> e = [(@[[GEIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:GEVec2Make(0.0, 0.0)], [GEIntersection intersectionWithItems:[CNPair newWithA:@2 b:@3] point:GEVec2Make(1.0, 1.0)]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testOneEnd {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:-2.0 y1:1.0 x2:1.0 y2:1.0]), tuple(@2, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:1.0 y2:1.0]), tuple(@3, [GELineSegment newWithX1:-2.0 y1:2.0 x2:2.0 y2:-2.0])])];
    id<CNSet> e = [(@[[GEIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:GEVec2Make(-1.0, 1.0)], [GEIntersection intersectionWithItems:[CNPair newWithA:@2 b:@3] point:GEVec2Make(0.0, 0.0)]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testSameLines {
    id<CNSet> r = [GEBentleyOttmann intersectionsForSegments:(@[tuple(@1, [GELineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:-1.0]), tuple(@2, [GELineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:-1.0]), tuple(@3, [GELineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0])])];
    id<CNSet> e = [(@[[GEIntersection intersectionWithItems:[CNPair newWithA:@1 b:@2] point:GEVec2Make(0.0, 0.0)], [GEIntersection intersectionWithItems:[CNPair newWithA:@2 b:@3] point:GEVec2Make(0.0, 0.0)], [GEIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:GEVec2Make(0.0, 0.0)]]) toSet];
    [self assertEqualsA:e b:r];
}

- (ODClassType*)type {
    return [GEBentleyOttmannTest type];
}

+ (ODClassType*)type {
    return _GEBentleyOttmannTest_type;
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


