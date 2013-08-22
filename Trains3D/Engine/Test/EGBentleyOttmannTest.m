#import "EGBentleyOttmannTest.h"

#import "EGBentleyOttmann.h"
#import "CNPair.h"
#import "EGFigure.h"
@implementation EGBentleyOttmannTest

+ (id)bentleyOttmannTest {
    return [[EGBentleyOttmannTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)testMain {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(-1)) x2:((float)(2)) y2:((float)(2))]), tuple(@2, [EGLineSegment newWithX1:((float)(-2)) y1:((float)(1)) x2:((float)(2)) y2:((float)(1))]), tuple(@3, [EGLineSegment newWithX1:((float)(-2)) y1:((float)(2)) x2:((float)(1)) y2:((float)(-1))])])];
    id<CNSet> e = [(@[[EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@2] point:EGPointMake(((float)(1)), ((float)(1)))], [EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:EGPointMake(((float)(0)), ((float)(0)))], [EGIntersection intersectionWithItems:[CNPair newWithA:@2 b:@3] point:EGPointMake(((float)(-1)), ((float)(1)))]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testInPoint {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(-1)) x2:((float)(2)) y2:((float)(2))]), tuple(@3, [EGLineSegment newWithX1:((float)(-2)) y1:((float)(2)) x2:((float)(0)) y2:((float)(0))])])];
    [self assertEqualsA:[(@[[EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:EGPointMake(((float)(0)), ((float)(0)))]]) toSet] b:r];
}

- (void)testNoCross {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(-1)) x2:((float)(2)) y2:((float)(2))]), tuple(@3, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(-1)) x2:((float)(2)) y2:((float)(0))])])];
    [self assertEqualsA:[(@[]) toSet] b:r];
}

- (void)testVertical {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(-1)) x2:((float)(2)) y2:((float)(2))]), tuple(@2, [EGLineSegment newWithX1:((float)(1)) y1:((float)(-2)) x2:((float)(1)) y2:((float)(2))]), tuple(@3, [EGLineSegment newWithX1:((float)(1)) y1:((float)(-4)) x2:((float)(1)) y2:((float)(0))]), tuple(@4, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(-1)) x2:((float)(2)) y2:((float)(-4))]), tuple(@5, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(-1)) x2:((float)(2)) y2:((float)(-1))])])];
    id<CNSet> e = [(@[[EGIntersection intersectionWithItems:[CNPair newWithA:@3 b:@4] point:EGPointMake(((float)(1)), ((float)(-3)))], [EGIntersection intersectionWithItems:[CNPair newWithA:@2 b:@5] point:EGPointMake(((float)(1)), ((float)(-1)))], [EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@2] point:EGPointMake(((float)(1)), ((float)(1)))], [EGIntersection intersectionWithItems:[CNPair newWithA:@3 b:@5] point:EGPointMake(((float)(1)), ((float)(-1)))]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testVerticalInPoint {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:((float)(0)) y1:((float)(0)) x2:((float)(0)) y2:((float)(1))]), tuple(@2, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(1)) x2:((float)(1)) y2:((float)(1))]), tuple(@3, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(0)) x2:((float)(1)) y2:((float)(0))])])];
    id<CNSet> e = [(@[[EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@2] point:EGPointMake(((float)(0)), ((float)(1)))], [EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:EGPointMake(((float)(0)), ((float)(0)))]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testOneStart {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(1)) x2:((float)(1)) y2:((float)(-1))]), tuple(@2, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(1)) x2:((float)(2)) y2:((float)(1))]), tuple(@3, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(-1)) x2:((float)(2)) y2:((float)(2))])])];
    id<CNSet> e = [(@[[EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:EGPointMake(((float)(0)), ((float)(0)))], [EGIntersection intersectionWithItems:[CNPair newWithA:@2 b:@3] point:EGPointMake(((float)(1)), ((float)(1)))]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testOneEnd {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:((float)(-2)) y1:((float)(1)) x2:((float)(1)) y2:((float)(1))]), tuple(@2, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(-1)) x2:((float)(1)) y2:((float)(1))]), tuple(@3, [EGLineSegment newWithX1:((float)(-2)) y1:((float)(2)) x2:((float)(2)) y2:((float)(-2))])])];
    id<CNSet> e = [(@[[EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:EGPointMake(((float)(-1)), ((float)(1)))], [EGIntersection intersectionWithItems:[CNPair newWithA:@2 b:@3] point:EGPointMake(((float)(0)), ((float)(0)))]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testSameLines {
    id<CNSet> r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(1)) x2:((float)(1)) y2:((float)(-1))]), tuple(@2, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(1)) x2:((float)(1)) y2:((float)(-1))]), tuple(@3, [EGLineSegment newWithX1:((float)(-1)) y1:((float)(-1)) x2:((float)(2)) y2:((float)(2))])])];
    id<CNSet> e = [(@[[EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@2] point:EGPointMake(((float)(0)), ((float)(0)))], [EGIntersection intersectionWithItems:[CNPair newWithA:@2 b:@3] point:EGPointMake(((float)(0)), ((float)(0)))], [EGIntersection intersectionWithItems:[CNPair newWithA:@1 b:@3] point:EGPointMake(((float)(0)), ((float)(0)))]]) toSet];
    [self assertEqualsA:e b:r];
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


