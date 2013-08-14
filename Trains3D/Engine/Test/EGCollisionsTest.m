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
    NSArray* figures = (@[tuple(@1, [EGPolygon polygonWithPoints:(@[val(EGPointMake(1, 0)), val(EGPointMake(3, 2)), val(EGPointMake(5, 0))])]), tuple(@2, [EGPolygon polygonWithPoints:(@[val(EGPointMake(1, 1)), val(EGPointMake(5, 1)), val(EGPointMake(3, -1))])]), tuple(@3, [EGPolygon polygonWithPoints:(@[val(EGPointMake(4, -1)), val(EGPointMake(4.5, -0.5)), val(EGPointMake(5, -1))])])]);
    NSSet* collisions = [EGCollisions collisionsForFigures:figures];
    [self assertEqualsA:collisions b:[(@[[EGCollision collisionWithItems:[CNPair pairWithA:@1 b:@2] points:[(@[val(EGPointMake(1.5, 0.5)), val(EGPointMake(2, 0)), val(EGPointMake(2, 1)), val(EGPointMake(4.5, 0.5)), val(EGPointMake(4, 0)), val(EGPointMake(4, 1))]) toSet]]]) toSet]];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCollisionsTest* o = ((EGCollisionsTest*)other);
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


