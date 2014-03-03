#import "EGDynamicWorld.h"

#import "EGCollisionBody.h"
#import "GEMat4.h"
#include "btBulletDynamicsCommon.h"
#import "EGCollision.h"

@implementation EGDynamicWorld{
    GEVec3 _gravity;
    btDefaultCollisionConfiguration* _collisionConfiguration;
    btCollisionDispatcher* _dispatcher;
    btBroadphaseInterface* _overlappingPairCache;
    btSequentialImpulseConstraintSolver* _solver;
    btDiscreteDynamicsWorld* _world;
}
static ODClassType* _EGDynamicWorld_type;
@synthesize gravity = _gravity;

+ (id)dynamicWorldWithGravity:(GEVec3)gravity {
    return [[EGDynamicWorld alloc] initWithGravity:gravity];
}

- (id)initWithGravity:(GEVec3)gravity {
    self = [super init];
    if(self) {
        _gravity = gravity;
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
    _world->stepSimulation((btScalar) (delta), 20);
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

- (void)addBody:(EGRigidBody *)body {
    [super addBody:body];
    _world->addRigidBody(static_cast<btRigidBody*>(body.obj));
}

- (void)removeBody:(EGRigidBody *)body {
    [super removeBody:body];
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
    return GEVec3Eq(self.gravity, o.gravity);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec3Hash(self.gravity);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"gravity=<%f, %f, %f>", self.gravity.x, self.gravity.y, self.gravity.z];
    [description appendString:@">"];
    return description;
}

- (id <CNIterable>)collisions {
    return [self collisionsOnlyNew:NO];
}

- (id <CNIterable>)collisionsOnlyNew:(BOOL)onlyNew {
    return [EGIndexFunFilteredIterable indexFunFilteredIterableWithMaxCount:(NSUInteger) _dispatcher->getNumManifolds() f:^id(NSUInteger i) {
        if(_dispatcher->getNumManifolds() <= i) return [CNOption none];
        btPersistentManifold *pManifold = _dispatcher->getManifoldByIndexInternal((int)i);
        if(pManifold->getNumContacts() == 0) return [CNOption none];
        EGRigidBody *body0 = (__bridge EGRigidBody *) pManifold->getBody0()->getUserPointer();
        EGRigidBody *body1 = (__bridge EGRigidBody *) pManifold->getBody1()->getUserPointer();
        CNArrayBuilder *builder = [CNArrayBuilder arrayBuilder];
        for(int j = 0; j <  pManifold->getNumContacts(); j ++) {
            btManifoldPoint & p = pManifold->getContactPoint(j);
            if(p.getDistance() < 0.f) {
                if(p.getLifeTime() != 1 && onlyNew) return [CNOption none];
                btVector3 const & a = p.getPositionWorldOnA();
                btVector3 const & b = p.getPositionWorldOnB();
                [builder appendItem: [EGContact
                        contactWithA:GEVec3Make(a.x(), a.y(), a.z())
                                   b:GEVec3Make(b.x(), b.y(), b.z())
                            distance:p.getDistance()
                             impulse:p.getAppliedImpulse()
                            lifeTime:(unsigned int) p.getLifeTime()]];
            }
        }
        NSArray *array = [builder build];
        if([array isEmpty]) return [CNOption none];

        return [CNSome someWithValue:[EGDynamicCollision dynamicCollisionWithBodies:[CNPair newWithA:body0 b:body1] contacts:array]];
    }];
}

- (id <CNIterable>)newCollisions {
    return [self collisionsOnlyNew:YES];
}

- (void)clear {
    [[self bodies] forEach:^(EGRigidBody * body) {
        _world->removeCollisionObject(static_cast<btRigidBody*>(body.obj));
    }];
    [super clear];
}
@end


@implementation EGRigidBody {
    id _data;
    id<EGCollisionShape> _shape;
    BOOL _isKinematic;
    float _mass;
    btRigidBody* _body;
    btDefaultMotionState* _motionState;
    BOOL _isDynamic;
    BOOL _isStatic;
}
static ODClassType* _EGDynamicBody_type;
@synthesize data = _data;
@synthesize shape = _shape;
@synthesize isKinematic = _isKinematic;
@synthesize mass = _mass;
@synthesize isDynamic = _isDynamic;
@synthesize isStatic = _isStatic;

- (VoidRef) obj {
    return _body;
}

+ (id)rigidBodyWithData:(id)data shape:(id <EGCollisionShape>)shape isKinematic:(BOOL)isKinematic mass:(float)mass {
    return [[EGRigidBody alloc] initWithData:data shape:shape isKinematic:isKinematic mass:mass];
}

- (id)initWithData:(id)data shape:(id<EGCollisionShape>)shape isKinematic:(BOOL)isKinematic mass:(float)mass {
    self = [super init];
    if(self) {
        _data = data;
        _shape = shape;
        _isKinematic = isKinematic;
        _mass = mass;
        _isDynamic = !(_isKinematic) && _mass > 0;
        _isStatic = !(_isKinematic) && _mass <= 0;
        btCollisionShape* sh = static_cast<btCollisionShape*>([_shape shape]);
        btVector3 localInertia(0,0,0);
        if (mass > 0.000001) sh->calculateLocalInertia(mass,localInertia);
        btTransform transform;
        transform.setIdentity();
        //using motionstate is recommended, it provides interpolation capabilities, and only synchronizes 'active' objects
        _motionState = new btDefaultMotionState(transform);
        btRigidBody::btRigidBodyConstructionInfo rbInfo(mass, _motionState, sh, localInertia);
        _body = new btRigidBody(rbInfo);
        _body->setUserPointer((__bridge void *)self);
        if(isKinematic) {
            _body->setCollisionFlags(_body->getCollisionFlags() | btCollisionObject::CF_KINEMATIC_OBJECT);
            _body->setActivationState(DISABLE_DEACTIVATION);
        }
    }
    
    return self;
}

+ (EGRigidBody*)kinematicData:(id)data shape:(id<EGCollisionShape>)shape {
    return [EGRigidBody rigidBodyWithData:data shape:shape isKinematic:YES mass:0.0];
}

+ (EGRigidBody*)dynamicData:(id)data shape:(id<EGCollisionShape>)shape mass:(float)mass {
    return [EGRigidBody rigidBodyWithData:data shape:shape isKinematic:NO mass:mass];
}

+ (EGRigidBody*)staticalData:(id)data shape:(id<EGCollisionShape>)shape {
    return [EGRigidBody rigidBodyWithData:data shape:shape isKinematic:NO mass:0.0];
}


-(void) dealloc {
    delete _motionState;
    delete _body;
}

+ (void)initialize {
    [super initialize];
    _EGDynamicBody_type = [ODClassType classTypeWithCls:[EGRigidBody class]];
}

- (GEMat4 *)matrix {
    btTransform trans;
    if(_isKinematic) {
        _motionState->getWorldTransform(trans);
    } else {
        trans = _body->getWorldTransform();
    }
    float matrix[16];
    trans.getOpenGLMatrix(matrix);
    return [GEMat4 mat4WithArray:matrix];
}

- (float)friction {
    return _body->getFriction();
}

- (void)setFriction:(float)friction {
    _body->setFriction(friction);
}

- (float)bounciness {
    return _body->getRestitution();
}

- (void)setBounciness:(float)bounciness {
    _body->setRestitution(bounciness);
}


- (void)setMatrix:(GEMat4 *)matrix {
    btTransform trans;
    trans.setFromOpenGLMatrix(matrix.array);
    if(_isKinematic) {
        _motionState->setWorldTransform(trans);
    } else {
        _body->setWorldTransform(trans);
    }
}

- (GEVec3)velocity {
    btVector3 const & v = _body->getLinearVelocity();
    return GEVec3Make(v.x(), v.y(), v.z());
}

- (void)setVelocity:(GEVec3)vec3 {
    _body->setLinearVelocity(btVector3(vec3.x, vec3.y, vec3.z));
}

- (GEVec3)angularVelocity {
    btVector3 const & v = _body->getAngularVelocity();
    return GEVec3Make(v.x(), v.y(), v.z());
}

- (void)setAngularVelocity:(GEVec3)vec3 {
    _body->setAngularVelocity(btVector3(vec3.x, vec3.y, vec3.z));
}


- (ODClassType*)type {
    return [EGRigidBody type];
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
    EGRigidBody * o = ((EGRigidBody *)(other));
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


