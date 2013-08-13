#import "EGBentleyOttmannTest.h"

#import "EGBentleyOttmann.h"
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
    NSSet* r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:-1 y1:-1 x2:2 y2:2]), tuple(@2, [EGLineSegment newWithX1:-2 y1:1 x2:2 y2:1]), tuple(@3, [EGLineSegment newWithX1:-2 y1:2 x2:1 y2:-1])])];
    NSSet* e = [(@[[EGIntersection intersectionWithPoint:EGPointMake(1, 1) data:[(@[@1, @2]) toSet]], [EGIntersection intersectionWithPoint:EGPointMake(0, 0) data:[(@[@1, @3]) toSet]], [EGIntersection intersectionWithPoint:EGPointMake(-1, 1) data:[(@[@2, @3]) toSet]]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testNoCross {
    NSSet* r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:-1 y1:-1 x2:2 y2:2]), tuple(@3, [EGLineSegment newWithX1:-2 y1:2 x2:0 y2:0])])];
    [self assertEqualsA:[(@[]) toSet] b:r];
}

- (void)testVertical {
    NSSet* r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:-1 y1:-1 x2:2 y2:2]), tuple(@2, [EGLineSegment newWithX1:1 y1:-2 x2:1 y2:2])])];
    NSSet* e = [(@[[EGIntersection intersectionWithPoint:EGPointMake(1, 1) data:[(@[@1, @2]) toSet]]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testOneStart {
    NSSet* r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:-1 y1:1 x2:1 y2:-1]), tuple(@2, [EGLineSegment newWithX1:-1 y1:1 x2:2 y2:1]), tuple(@3, [EGLineSegment newWithX1:-1 y1:-1 x2:2 y2:2])])];
    NSSet* e = [(@[[EGIntersection intersectionWithPoint:EGPointMake(0, 0) data:[(@[@1, @3]) toSet]], [EGIntersection intersectionWithPoint:EGPointMake(1, 1) data:[(@[@2, @3]) toSet]]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testOneEnd {
    NSSet* r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:-2 y1:1 x2:1 y2:1]), tuple(@2, [EGLineSegment newWithX1:-1 y1:-1 x2:1 y2:1]), tuple(@3, [EGLineSegment newWithX1:-2 y1:2 x2:2 y2:-2])])];
    NSSet* e = [(@[[EGIntersection intersectionWithPoint:EGPointMake(-1, 1) data:[(@[@1, @3]) toSet]], [EGIntersection intersectionWithPoint:EGPointMake(0, 0) data:[(@[@2, @3]) toSet]]]) toSet];
    [self assertEqualsA:e b:r];
}

- (void)testSameLines {
    NSSet* r = [EGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [EGLineSegment newWithX1:-1 y1:1 x2:1 y2:-1]), tuple(@2, [EGLineSegment newWithX1:-1 y1:1 x2:1 y2:-1]), tuple(@3, [EGLineSegment newWithX1:-1 y1:-1 x2:2 y2:2])])];
    NSSet* e = [(@[[EGIntersection intersectionWithPoint:EGPointMake(0, 0) data:[(@[@1, @2, @3]) toSet]]]) toSet];
    [self assertEqualsA:e b:r];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBentleyOttmannTest* o = ((EGBentleyOttmannTest*)other);
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


