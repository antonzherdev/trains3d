#import "EGDynamicWorld.h"

#import "EGCollisionBody.h"
#import "EGMatrix.h"
#include "btBulletDynamicsCommon.h"
@implementation EGDynamicWorld{
    EGVec3 _gravity;
    NSMutableArray* __bodies;
    btDefaultCollisionConfiguration* _collisionConfiguration;
    btCollisionDispatcher* _dispatcher;
    btBroadphaseInterface* _overlappingPairCache;
    btSequentialImpulseConstraintSolver* _solver;
    btDiscreteDynamicsWorld* _world;
}
static ODClassType* _EGDynamicWorld_type;
@synthesize gravity = _gravity;

+ (id)dynamicWorldWithGravity:(EGVec3)gravity {
    return [[EGDynamicWorld alloc] initWithGravity:gravity];
}

- (id)initWithGravity:(EGVec3)gravity {
    self = [super init];
    if(self) {
        _gravity = gravity;
        __bodies = [NSMutableArray mutableArray];
        _collisionConfiguration = new btDefaultCollisionConfiguration();

        ///use the default collision dispatcher. For parallel processing you can use a diffent dispatcher (see Extras/BulletMultiThreaded)
        _dispatcher = new	btCollisionDispatcher(_collisionConfiguration);

        ///btDbvtBroadphase is a good general purpose broadphase. You can also try out btAxis3Sweep.
        _overlappingPairCache = new btDbvtBroadphase();

        ///the default constraint solver. For parallel processing you can use a different solver (see Extras/BulletMultiThreaded)
        _solver = new btSequentialImpulseConstraintSolver;

        _world = new btDiscreteDynamicsWorld(_dispatcher, _overlappingPairCache, _solver, _collisionConfiguration);

        _world->setGravity(btVector3(gravity.x, gravity.y, gravity.z));

    }
    
    return self;
}

- (void)updateWithDelta:(CGFloat)delta {
    _world->stepSimulation((btScalar) delta, 10);
}

- (void)dealloc {
    delete _world;
    delete _collisionConfiguration;
    delete _dispatcher;
    delete _overlappingPairCache;
    delete _solver;
}

+ (void)initialize {
    [super initialize];
    _EGDynamicWorld_type = [ODClassType classTypeWithCls:[EGDynamicWorld class]];
}

- (id<CNSeq>)bodies {
    return __bodies;
}

- (void)addBody:(EGDynamicBody*)body {
    [__bodies addItem:body];
    _world->addRigidBody(static_cast<btRigidBody*>(body.obj));
}

- (void)removeBody:(EGDynamicBody*)body {
    [__bodies removeItem:body];
    _world->removeRigidBody(static_cast<btRigidBody*>(body.obj));
}

- (ODClassType*)type {
    return [EGDynamicWorld type];
}

+ (ODClassType*)type {
    return _EGDynamicWorld_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGDynamicWorld* o = ((EGDynamicWorld*)(other));
    return EGVec3Eq(self.gravity, o.gravity);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec3Hash(self.gravity);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"gravity=%@", EGVec3Description(self.gravity)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGDynamicBody{
    id _data;
    id<EGCollisionShape> _shape;
    BOOL _isKinematic;
    float _mass;
    btRigidBody* _body;
    btDefaultMotionState* _motionState;
}
static ODClassType* _EGDynamicBody_type;
@synthesize data = _data;
@synthesize shape = _shape;
@synthesize isKinematic = _isKinematic;
@synthesize mass = _mass;

- (VoidRef) obj {
    return _body;
}

+ (id)dynamicBodyWithData:(id)data shape:(id<EGCollisionShape>)shape isKinematic:(BOOL)isKinematic mass:(float)mass {
    return [[EGDynamicBody alloc] initWithData:data shape:shape isKinematic:isKinematic mass:mass];
}

- (id)initWithData:(id)data shape:(id<EGCollisionShape>)shape isKinematic:(BOOL)isKinematic mass:(float)mass {
    self = [super init];
    if(self) {
        _data = data;
        _shape = shape;
        _isKinematic = isKinematic;
        _mass = mass;
        btCollisionShape* sh = static_cast<btCollisionShape*>([_shape shape]);
        btVector3 localInertia(0,0,0);
        if (mass > 0.000001)
            sh->calculateLocalInertia(mass,localInertia);
        btTransform transform;
        transform.setIdentity();
        //using motionstate is recommended, it provides interpolation capabilities, and only synchronizes 'active' objects
        _motionState = new btDefaultMotionState(transform);
        btRigidBody::btRigidBodyConstructionInfo rbInfo(mass, _motionState, sh, localInertia);
        _body = new btRigidBody(rbInfo);
    }
    
    return self;
}

-(void) dealloc {
    delete _motionState;
    delete _body;
}

+ (void)initialize {
    [super initialize];
    _EGDynamicBody_type = [ODClassType classTypeWithCls:[EGDynamicBody class]];
}

- (EGMatrix*)matrix {
    btTransform trans;
    _motionState->getWorldTransform(trans);
    float matrix[16];
    trans.getOpenGLMatrix(matrix);
    return [EGMatrix matrixWithArray:matrix];
}

- (void)setMatrix:(EGMatrix*)matrix {
    btTransform trans;
    trans.setFromOpenGLMatrix(matrix.array);
    _motionState->setWorldTransform(trans);
}

- (ODClassType*)type {
    return [EGDynamicBody type];
}

+ (ODClassType*)type {
    return _EGDynamicBody_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGDynamicBody* o = ((EGDynamicBody*)(other));
    return [self.data isEqual:o.data] && [self.shape isEqual:o.shape] && self.isKinematic == o.isKinematic && eqf4(self.mass, o.mass);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.data hash];
    hash = hash * 31 + [self.shape hash];
    hash = hash * 31 + self.isKinematic;
    hash = hash * 31 + float4Hash(self.mass);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"data=%@", self.data];
    [description appendFormat:@", shape=%@", self.shape];
    [description appendFormat:@", isKinematic=%d", self.isKinematic];
    [description appendFormat:@", mass=%f", self.mass];
    [description appendString:@">"];
    return description;
}

@end


