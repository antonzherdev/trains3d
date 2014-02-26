#import "EGCollisionsTest.h"

#import "EGCollisionWorld.h"
#import "EGCollisionBody.h"
#import "EGCollision.h"
@implementation EGCollisionsTest
static ODClassType* _EGCollisionsTest_type;

+ (instancetype)collisionsTest {
    return [[EGCollisionsTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCollisionsTest class]) _EGCollisionsTest_type = [ODClassType classTypeWithCls:[EGCollisionsTest class]];
}

- (void)testCollisions {
    EGCollisionWorld* world = [EGCollisionWorld collisionWorld];
    EGCollisionBody* box1 = [EGCollisionBody collisionBodyWithData:@1 shape:[EGCollisionBox applyX:2.0 y:2.0 z:2.0] isKinematic:YES];
    EGCollisionBody* box2 = [EGCollisionBody collisionBodyWithData:@2 shape:[EGCollisionBox applyX:2.0 y:2.0 z:2.0] isKinematic:NO];
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
    EGCollisionBody* box1 = [EGCollisionBody collisionBodyWithData:@1 shape:[EGCollisionBox2d applyX:2.0 y:2.0] isKinematic:YES];
    EGCollisionBody* box2 = [EGCollisionBody collisionBodyWithData:@2 shape:[EGCollisionBox2d applyX:2.0 y:2.0] isKinematic:NO];
    [world addBody:box1];
    [world addBody:box2];
    [box1 translateX:1.8 y:1.8 z:0.0];
    [self assertTrueValue:[[world detect] count] == 1];
    [box1 translateX:0.1 y:0.1 z:0.0];
    [self assertTrueValue:[[world detect] count] == 1];
    [box1 translateX:0.2 y:0.2 z:0.0];
    [self assertTrueValue:[[world detect] isEmpty]];
}

- (void)testRay {
    EGCollisionWorld* world = [EGCollisionWorld collisionWorld];
    EGCollisionBody* box1 = [EGCollisionBody collisionBodyWithData:@1 shape:[EGCollisionBox2d applyX:1.0 y:1.0] isKinematic:NO];
    EGCollisionBody* box2 = [EGCollisionBody collisionBodyWithData:@2 shape:[EGCollisionBox2d applyX:1.0 y:1.0] isKinematic:YES];
    [box1 translateX:2.0 y:2.0 z:0.0];
    [world addBody:box1];
    [world addBody:box2];
    GELine3 segment = GELine3Make(GEVec3Make(2.0, 2.0, 2.0), GEVec3Make(0.0, 0.0, -10.0));
    id<CNSeq> r = [world crossPointsWithSegment:segment];
    EGCrossPoint* p1 = [EGCrossPoint crossPointWithBody:box1 point:GEVec3Make(2.0, 2.0, 0.0)];
    [self assertEqualsA:r b:(@[p1])];
    [box2 translateX:2.0 y:2.0 z:-1.0];
    r = [world crossPointsWithSegment:segment];
    [self assertEqualsA:r b:(@[p1, [EGCrossPoint crossPointWithBody:box2 point:GEVec3Make(2.0, 2.0, -1.0)]])];
    [self assertEqualsA:[[world closestCrossPointWithSegment:segment] get] b:p1];
    [box2 translateX:0.0 y:0.0 z:-10.0];
    r = [world crossPointsWithSegment:segment];
    [self assertEqualsA:r b:(@[p1])];
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


