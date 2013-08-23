#import "EGCollisionsTest.h"

#import "CNPair.h"
#import "EGFigure.h"
#import "EGCollisions.h"
@implementation EGCollisionsTest

+ (id)collisionsTest {
    return [[EGCollisionsTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)testDavidsStar {
    id<CNSeq> figures = (@[tuple(@1, [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((CGFloat)(1)), ((CGFloat)(0)))), wrap(EGPoint, EGPointMake(((CGFloat)(3)), ((CGFloat)(2)))), wrap(EGPoint, EGPointMake(((CGFloat)(5)), ((CGFloat)(0))))])]), tuple(@2, [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((CGFloat)(1)), ((CGFloat)(1)))), wrap(EGPoint, EGPointMake(((CGFloat)(5)), ((CGFloat)(1)))), wrap(EGPoint, EGPointMake(((CGFloat)(3)), ((CGFloat)(-1))))])]), tuple(@3, [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((CGFloat)(4)), ((CGFloat)(-1)))), wrap(EGPoint, EGPointMake(4.5, -0.5)), wrap(EGPoint, EGPointMake(((CGFloat)(5)), ((CGFloat)(-1))))])])]);
    id<CNSet> collisions = [EGCollisions collisionsForFigures:figures];
    [self assertEqualsA:collisions b:[(@[[EGCollision collisionWithItems:[CNPair pairWithA:@1 b:@2] points:[(@[wrap(EGPoint, EGPointMake(1.5, 0.5)), wrap(EGPoint, EGPointMake(((CGFloat)(2)), ((CGFloat)(0)))), wrap(EGPoint, EGPointMake(((CGFloat)(2)), ((CGFloat)(1)))), wrap(EGPoint, EGPointMake(4.5, 0.5)), wrap(EGPoint, EGPointMake(((CGFloat)(4)), ((CGFloat)(0)))), wrap(EGPoint, EGPointMake(((CGFloat)(4)), ((CGFloat)(1))))]) toSet]]]) toSet]];
}

- (void)testEmptyWithCrossedBoundingRects {
    id<CNSeq> figures = (@[tuple(@1, [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((CGFloat)(1)), ((CGFloat)(0)))), wrap(EGPoint, EGPointMake(((CGFloat)(3)), ((CGFloat)(2)))), wrap(EGPoint, EGPointMake(((CGFloat)(5)), ((CGFloat)(0))))])]), tuple(@3, [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((CGFloat)(4)), ((CGFloat)(-1)))), wrap(EGPoint, EGPointMake(4.5, -0.5)), wrap(EGPoint, EGPointMake(((CGFloat)(5)), ((CGFloat)(-1))))])])]);
    id<CNSet> collisions = [EGCollisions collisionsForFigures:figures];
    [self assertEqualsA:collisions b:[(@[]) toSet]];
}

- (void)testEmptyWithoutCrossedBoundingRects {
    id<CNSeq> figures = (@[tuple(@1, [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((CGFloat)(1)), ((CGFloat)(0)))), wrap(EGPoint, EGPointMake(((CGFloat)(3)), ((CGFloat)(2)))), wrap(EGPoint, EGPointMake(((CGFloat)(5)), ((CGFloat)(0))))])]), tuple(@3, [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((CGFloat)(6)), ((CGFloat)(-1)))), wrap(EGPoint, EGPointMake(6.5, -0.5)), wrap(EGPoint, EGPointMake(((CGFloat)(7)), ((CGFloat)(-1))))])])]);
    id<CNSet> collisions = [EGCollisions collisionsForFigures:figures];
    [self assertEqualsA:collisions b:[(@[]) toSet]];
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


