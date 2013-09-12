#import "EGCollisionsTest.h"

#import "EGFigure.h"
#import "EGCollisions.h"
#import "EGCollisionWorld.h"
#import "EGCollisionBody.h"
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
    id<CNSeq> figures = (@[tuple(@1, [EGPolygon polygonWithPoints:(@[wrap(EGVec2, EGVec2Make(1.0, 0.0)), wrap(EGVec2, EGVec2Make(3.0, 2.0)), wrap(EGVec2, EGVec2Make(5.0, 0.0))])]), tuple(@2, [EGPolygon polygonWithPoints:(@[wrap(EGVec2, EGVec2Make(1.0, 1.0)), wrap(EGVec2, EGVec2Make(5.0, 1.0)), wrap(EGVec2, EGVec2Make(3.0, -1.0))])]), tuple(@3, [EGPolygon polygonWithPoints:(@[wrap(EGVec2, EGVec2Make(4.0, -1.0)), wrap(EGVec2, EGVec2Make(4.5, -0.5)), wrap(EGVec2, EGVec2Make(5.0, -1.0))])])]);
    id<CNSet> collisions = [EGCollisions collisionsForFigures:figures];
    [self assertEqualsA:collisions b:[(@[[EGCollision collisionWithItems:[CNPair pairWithA:@1 b:@2] points:[(@[wrap(EGVec2, EGVec2Make(1.5, 0.5)), wrap(EGVec2, EGVec2Make(2.0, 0.0)), wrap(EGVec2, EGVec2Make(2.0, 1.0)), wrap(EGVec2, EGVec2Make(4.5, 0.5)), wrap(EGVec2, EGVec2Make(4.0, 0.0)), wrap(EGVec2, EGVec2Make(4.0, 1.0))]) toSet]]]) toSet]];
}

- (void)testEmptyWithCrossedBoundingRects {
    id<CNSeq> figures = (@[tuple(@1, [EGPolygon polygonWithPoints:(@[wrap(EGVec2, EGVec2Make(1.0, 0.0)), wrap(EGVec2, EGVec2Make(3.0, 2.0)), wrap(EGVec2, EGVec2Make(5.0, 0.0))])]), tuple(@3, [EGPolygon polygonWithPoints:(@[wrap(EGVec2, EGVec2Make(4.0, -1.0)), wrap(EGVec2, EGVec2Make(4.5, -0.5)), wrap(EGVec2, EGVec2Make(5.0, -1.0))])])]);
    id<CNSet> collisions = [EGCollisions collisionsForFigures:figures];
    [self assertEqualsA:collisions b:[(@[]) toSet]];
}

- (void)testEmptyWithoutCrossedBoundingRects {
    id<CNSeq> figures = (@[tuple(@1, [EGPolygon polygonWithPoints:(@[wrap(EGVec2, EGVec2Make(1.0, 0.0)), wrap(EGVec2, EGVec2Make(3.0, 2.0)), wrap(EGVec2, EGVec2Make(5.0, 0.0))])]), tuple(@3, [EGPolygon polygonWithPoints:(@[wrap(EGVec2, EGVec2Make(6.0, -1.0)), wrap(EGVec2, EGVec2Make(6.5, -0.5)), wrap(EGVec2, EGVec2Make(7.0, -1.0))])])]);
    id<CNSet> collisions = [EGCollisions collisionsForFigures:figures];
    [self assertEqualsA:collisions b:[(@[]) toSet]];
}

- (void)testCollisions2 {
    EGCollisionWorld* world = [EGCollisionWorld collisionWorld];
    EGCollisionBody* box1 = [EGCollisionBody collisionBodyWithData:@1 shape:[EGCollisionBox applyX:1.0 y:1.0 z:1.0] isKinematic:YES];
    EGCollisionBody* box2 = [EGCollisionBody collisionBodyWithData:@2 shape:[EGCollisionBox applyX:1.0 y:1.0 z:1.0] isKinematic:NO];
    [world addBody:box1];
    [world addBody:box2];
    [box1 translateX:1.8 y:1.8 z:0.0];
    [self assertTrueValue:[[world detect] count] == 1];
    [box1 translateX:0.1 y:0.1 z:0.0];
    [self assertTrueValue:[[world detect] count] == 1];
    [box1 translateX:0.2 y:0.2 z:0.0];
    [self assertTrueValue:[[world detect] isEmpty]];
}

- (void)testCollisions2d {
    EGCollisionWorld* world = [EGCollisionWorld collisionWorld];
    EGCollisionBody* box1 = [EGCollisionBody collisionBodyWithData:@1 shape:[EGCollisionBox2d applyX:1.0 y:1.0] isKinematic:YES];
    EGCollisionBody* box2 = [EGCollisionBody collisionBodyWithData:@2 shape:[EGCollisionBox2d applyX:1.0 y:1.0] isKinematic:NO];
    [world addBody:box1];
    [world addBody:box2];
    [box1 translateX:1.8 y:1.8 z:0.0];
    [self assertTrueValue:[[world detect] count] == 1];
    [box1 translateX:0.1 y:0.1 z:0.0];
    [self assertTrueValue:[[world detect] count] == 1];
    [box1 translateX:0.2 y:0.2 z:0.0];
    [self assertTrueValue:[[world detect] isEmpty]];
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


