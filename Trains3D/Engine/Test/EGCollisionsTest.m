#import "EGCollisionsTest.h"

#import "CNPair.h"
#import "EGFigure.h"
#import "EGCollisions.h"
@implementation EGCollisionsTest
static ODClassType* _EGCollisionsTest_type;

+ (id)collisionsTest {
    return [[EGCollisionsTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCollisionsTest_type = [ODClassType classTypeWithCls:[EGCollisionsTest class]];
}

- (void)testDavidsStar {
    id<CNSeq> figures = (@[tuple(@1, [EGPolygon polygonWithPoints:(@[wrap(EGVec2, EGVec2Make(1.0, 0.0)), wrap(EGVec2, EGVec2Make(3.0, 2.0)), wrap(EGVec2, EGVec2Make(5.0, 0.0))])]), tuple(@2, [EGPolygon polygonWithPoints:(@[wrap(EGVec2, EGVec2Make(1.0, 1.0)), wrap(EGVec2, EGVec2Make(5.0, 1.0)), wrap(EGVec2, EGVec2Make(3.0, -1.0))])]), tuple(@3, [EGPolygon polygonWithPoints:(@[wrap(EGVec2, EGVec2Make(4.0, -1.0)), wrap(EGVec2, EGVec2Make(((float)(4.5)), ((float)(-0.5)))), wrap(EGVec2, EGVec2Make(5.0, -1.0))])])]);
    id<CNSet> collisions = [EGCollisions collisionsForFigures:figures];
    [self assertEqualsA:collisions b:[(@[[EGCollision collisionWithItems:[CNPair pairWithA:@1 b:@2] points:[(@[wrap(EGVec2, EGVec2Make(((float)(1.5)), ((float)(0.5)))), wrap(EGVec2, EGVec2Make(2.0, 0.0)), wrap(EGVec2, EGVec2Make(2.0, 1.0)), wrap(EGVec2, EGVec2Make(((float)(4.5)), ((float)(0.5)))), wrap(EGVec2, EGVec2Make(4.0, 0.0)), wrap(EGVec2, EGVec2Make(4.0, 1.0))]) toSet]]]) toSet]];
}

- (void)testEmptyWithCrossedBoundingRects {
    id<CNSeq> figures = (@[tuple(@1, [EGPolygon polygonWithPoints:(@[wrap(EGVec2, EGVec2Make(1.0, 0.0)), wrap(EGVec2, EGVec2Make(3.0, 2.0)), wrap(EGVec2, EGVec2Make(5.0, 0.0))])]), tuple(@3, [EGPolygon polygonWithPoints:(@[wrap(EGVec2, EGVec2Make(4.0, -1.0)), wrap(EGVec2, EGVec2Make(((float)(4.5)), ((float)(-0.5)))), wrap(EGVec2, EGVec2Make(5.0, -1.0))])])]);
    id<CNSet> collisions = [EGCollisions collisionsForFigures:figures];
    [self assertEqualsA:collisions b:[(@[]) toSet]];
}

- (void)testEmptyWithoutCrossedBoundingRects {
    id<CNSeq> figures = (@[tuple(@1, [EGPolygon polygonWithPoints:(@[wrap(EGVec2, EGVec2Make(1.0, 0.0)), wrap(EGVec2, EGVec2Make(3.0, 2.0)), wrap(EGVec2, EGVec2Make(5.0, 0.0))])]), tuple(@3, [EGPolygon polygonWithPoints:(@[wrap(EGVec2, EGVec2Make(6.0, -1.0)), wrap(EGVec2, EGVec2Make(((float)(6.5)), ((float)(-0.5)))), wrap(EGVec2, EGVec2Make(7.0, -1.0))])])]);
    id<CNSet> collisions = [EGCollisions collisionsForFigures:figures];
    [self assertEqualsA:collisions b:[(@[]) toSet]];
}

- (ODClassType*)type {
    return [EGCollisionsTest type];
}

+ (ODClassType*)type {
    return _EGCollisionsTest_type;
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


