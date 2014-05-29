#import "EGDynamicTest.h"

#import "EGDynamicWorld.h"
#import "EGCollisionBody.h"
#import "GEMat4.h"
@implementation EGDynamicTest
static CNClassType* _EGDynamicTest_type;

+ (instancetype)dynamicTest {
    return [[EGDynamicTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGDynamicTest class]) _EGDynamicTest_type = [CNClassType classTypeWithCls:[EGDynamicTest class]];
}

- (void)runSecondInWorld:(EGDynamicWorld*)world {
    id<CNIterator> __il__0i = [intRange(30) iterator];
    while([__il__0i hasNext]) {
        id _ = [__il__0i next];
        [world updateWithDelta:1.0 / 30.0];
    }
}

- (void)testSimple {
    EGDynamicWorld* world = [EGDynamicWorld dynamicWorldWithGravity:GEVec3Make(0.0, -10.0, 0.0)];
    EGCollisionBox* shape = [EGCollisionBox applyX:1.0 y:1.0 z:1.0];
    EGRigidBody* body = [EGRigidBody dynamicData:@1 shape:shape mass:1.0];
    [world addBody:body];
    body.matrix = [[GEMat4 identity] translateX:0.0 y:5.0 z:0.0];
    GEMat4* m = body.matrix;
    assertTrue((eqf4(m.array[13], 5)));
    GEVec3 v = body.velocity;
    assertEquals((wrap(GEVec3, v)), (wrap(GEVec3, (GEVec3Make(0.0, 0.0, 0.0)))));
    [self runSecondInWorld:world];
    m = body.matrix;
    assertTrue((float4Between(m.array[13], -0.1, 0.1)));
    v = body.velocity;
    assertTrue((eqf4(v.x, 0)));
    assertTrue((float4Between(v.y, -10.01, -9.99)));
    assertTrue((eqf4(v.z, 0)));
}

- (void)testFriction {
    EGDynamicWorld* world = [EGDynamicWorld dynamicWorldWithGravity:GEVec3Make(0.0, -10.0, 0.0)];
    EGRigidBody* plane = [EGRigidBody staticalData:@1 shape:[EGCollisionPlane collisionPlaneWithNormal:GEVec3Make(0.0, 1.0, 0.0) distance:0.0]];
    [world addBody:plane];
    EGRigidBody* body = [EGRigidBody dynamicData:@2 shape:[EGCollisionBox applyX:1.0 y:1.0 z:1.0] mass:1.0];
    [world addBody:body];
    body.matrix = [[GEMat4 identity] translateX:0.0 y:0.5 z:0.0];
    body.velocity = GEVec3Make(10.0, 0.0, 0.0);
    [self runSecondInWorld:world];
    GEVec3 v = body.velocity;
    if(!(float4Between(v.x, 7.4, 7.6))) fail(([NSString stringWithFormat:@"%f is not between 7.4 and 7.6", v.x]));
    assertTrue((float4Between(v.y, -0.1, 0.1)));
    assertTrue((float4Between(v.z, -0.1, 0.1)));
}

- (NSString*)description {
    return @"DynamicTest";
}

- (CNClassType*)type {
    return [EGDynamicTest type];
}

+ (CNClassType*)type {
    return _EGDynamicTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

