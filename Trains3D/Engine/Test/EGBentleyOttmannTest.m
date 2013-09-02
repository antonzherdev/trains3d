#import "EGBentleyOttmannTest.h"

#import "EGBentleyOttmann.h"
#import "CNPair.h"
#import "EGFigure.h"
@implementation EGBentleyOttmannTest
static ODClassType* _EGBentleyOttmannTest_type;

+ (id)bentleyOttmannTest {
    return [[EGBentleyOttmannTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBentleyOttmannTest_type = [ODClassType classTypeWithCls:[EGBentleyOttmannTest class]];
}

- (void)testMain {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@2, [EGLineSegment newWithX1:-2.0 y1:1.0 x2:2.0 y2:1.0]), tuple(@3, [EGLineSegment newWithX1:-2.0 y1:2.0 x2:1.0 y2:-1.0])])];
    id<CNSet> e = [(@[[EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@2] point:EGPointMake(1.0, 1.0)], [EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:EGPointMake(0.0, 0.0)], [EGIntersection intersectionWithItems:[CNPair newWithA:@2 b:@3] point:EGPointMake(-1.0, 1.0)]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testInPoint {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@3, [EGLineSegment newWithX1:-2.0 y1:2.0 x2:0.0 y2:0.0])])];
    [self assertEqualsA:[(@[[EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:EGPointMake(0.0, 0.0)]]) toSet] b:r];
}

- (void)testNoCross {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@3, [EGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:0.0])])];
    [self assertEqualsA:[(@[]) toSet] b:r];
}

- (void)testVertical {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@2, [EGLineSegment newWithX1:1.0 y1:-2.0 x2:1.0 y2:2.0]), tuple(@3, [EGLineSegment newWithX1:1.0 y1:-4.0 x2:1.0 y2:0.0]), tuple(@4, [EGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:-4.0]), tuple(@5, [EGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:-1.0])])];
    id<CNSet> e = [(@[[EGIntersection intersectionWithItems:[CNPair newWithA:@3 b:@4] point:EGPointMake(1.0, -3.0)], [EGIntersection intersectionWithItems:[CNPair newWithA:@2 b:@5] point:EGPointMake(1.0, -1.0)], [EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@2] point:EGPointMake(1.0, 1.0)], [EGIntersection intersectionWithItems:[CNPair newWithA:@3 b:@5] point:EGPointMake(1.0, -1.0)]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testVerticalInPoint {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:0.0 y1:0.0 x2:0.0 y2:1.0]), tuple(@2, [EGLineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:1.0]), tuple(@3, [EGLineSegment newWithX1:-1.0 y1:0.0 x2:1.0 y2:0.0])])];
    id<CNSet> e = [(@[[EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@2] point:EGPointMake(0.0, 1.0)], [EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:EGPointMake(0.0, 0.0)]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testOneStart {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:-1.0]), tuple(@2, [EGLineSegment newWithX1:-1.0 y1:1.0 x2:2.0 y2:1.0]), tuple(@3, [EGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0])])];
    id<CNSet> e = [(@[[EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:EGPointMake(0.0, 0.0)], [EGIntersection intersectionWithItems:[CNPair newWithA:@2 b:@3] point:EGPointMake(1.0, 1.0)]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testOneEnd {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:-2.0 y1:1.0 x2:1.0 y2:1.0]), tuple(@2, [EGLineSegment newWithX1:-1.0 y1:-1.0 x2:1.0 y2:1.0]), tuple(@3, [EGLineSegment newWithX1:-2.0 y1:2.0 x2:2.0 y2:-2.0])])];
    id<CNSet> e = [(@[[EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:EGPointMake(-1.0, 1.0)], [EGIntersection intersectionWithItems:[CNPair newWithA:@2 b:@3] point:EGPointMake(0.0, 0.0)]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testSameLines {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:-1.0]), tuple(@2, [EGLineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:-1.0]), tuple(@3, [EGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0])])];
    id<CNSet> e = [(@[[EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@2] point:EGPointMake(0.0, 0.0)], [EGIntersection intersectionWithItems:[CNPair newWithA:@2 b:@3] point:EGPointMake(0.0, 0.0)], [EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:EGPointMake(0.0, 0.0)]]) toSet];
    [self assertEqualsA:e b:r];
}

- (ODClassType*)type {
    return [EGBentleyOttmannTest type];
}

+ (ODClassType*)type {
    return _EGBentleyOttmannTest_type;
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


