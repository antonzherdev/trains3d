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
    id<CNList> figures = (@[tuple(@1, [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((float)(1)), ((float)(0)))), wrap(EGPoint, EGPointMake(((float)(3)), ((float)(2)))), wrap(EGPoint, EGPointMake(((float)(5)), ((float)(0))))])]), tuple(@2, [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((float)(1)), ((float)(1)))), wrap(EGPoint, EGPointMake(((float)(5)), ((float)(1)))), wrap(EGPoint, EGPointMake(((float)(3)), ((float)(-1))))])]), tuple(@3, [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((float)(4)), ((float)(-1)))), wrap(EGPoint, EGPointMake(4.5, -0.5)), wrap(EGPoint, EGPointMake(((float)(5)), ((float)(-1))))])])]);
    id<CNSet> collisions = [EGCollisions collisionsForFigures:figures];
    [self assertEqualsA:collisions b:[(@[[EGCollision collisionWithItems:[CNPair pairWithA:@1 b:@2] points:[(@[wrap(EGPoint, EGPointMake(1.5, 0.5)), wrap(EGPoint, EGPointMake(((float)(2)), ((float)(0)))), wrap(EGPoint, EGPointMake(((float)(2)), ((float)(1)))), wrap(EGPoint, EGPointMake(4.5, 0.5)), wrap(EGPoint, EGPointMake(((float)(4)), ((float)(0)))), wrap(EGPoint, EGPointMake(((float)(4)), ((float)(1))))]) toSet]]]) toSet]];
}

- (void)testEmptyWithCrossedBoundingRects {
    id<CNList> figures = (@[tuple(@1, [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((float)(1)), ((float)(0)))), wrap(EGPoint, EGPointMake(((float)(3)), ((float)(2)))), wrap(EGPoint, EGPointMake(((float)(5)), ((float)(0))))])]), tuple(@3, [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((float)(4)), ((float)(-1)))), wrap(EGPoint, EGPointMake(4.5, -0.5)), wrap(EGPoint, EGPointMake(((float)(5)), ((float)(-1))))])])]);
    id<CNSet> collisions = [EGCollisions collisionsForFigures:figures];
    [self assertEqualsA:collisions b:[(@[]) toSet]];
}

- (void)testEmptyWithoutCrossedBoundingRects {
    id<CNList> figures = (@[tuple(@1, [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((float)(1)), ((float)(0)))), wrap(EGPoint, EGPointMake(((float)(3)), ((float)(2)))), wrap(EGPoint, EGPointMake(((float)(5)), ((float)(0))))])]), tuple(@3, [EGPolygon polygonWithPoints:(@[wrap(EGPoint, EGPointMake(((float)(6)), ((float)(-1)))), wrap(EGPoint, EGPointMake(6.5, -0.5)), wrap(EGPoint, EGPointMake(((float)(7)), ((float)(-1))))])])]);
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


