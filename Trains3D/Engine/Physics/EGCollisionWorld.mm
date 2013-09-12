#import "EGCollisionWorld.h"

#import "EGCollisionBody.h"

#include "btBulletCollisionCommon.h"
#import "EGCollision.h"

@implementation EGCollisionWorld {
    btCollisionWorld * _world;
    btDefaultCollisionConfiguration* _configuration;
    btCollisionDispatcher* _dispatcher;
    btSimpleBroadphase*	_broadphase;
    NSMutableArray *_objects;
}
static ODClassType* _EGCollisionWorld_type;

+ (id)collisionWorld {
    return [[EGCollisionWorld alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _configuration = new btDefaultCollisionConfiguration();
        _dispatcher = new btCollisionDispatcher(_configuration);
        _broadphase = new btSimpleBroadphase;
        _world = new btCollisionWorld(_dispatcher, _broadphase, _configuration);
        _objects = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
//    for(EGCollisionBody * body : _objects) {
//        _world->removeCollisionObject(static_cast<btCollisionObject*>(body.obj));
//    }
    delete _world;
    delete _broadphase;
    delete _dispatcher;
    delete _configuration;
}

+ (void)initialize {
    [super initialize];
    _EGCollisionWorld_type = [ODClassType classTypeWithCls:[EGCollisionWorld class]];
}

- (void)addBody:(EGCollisionBody*)body {
    [_objects addObject:body];
    _world->addCollisionObject(static_cast<btCollisionObject*>(body.obj));
}

- (void)removeBody:(EGCollisionBody*)body {
    [_objects removeObject:body];
    _world->removeCollisionObject(static_cast<btCollisionObject*>(body.obj));
}

- (id<CNIterable>)detect {
    _world->performDiscreteCollisionDetection();
    return [EGIndexFunFilteredIterable indexFunFilteredIterableWithMaxCount:(NSUInteger) _dispatcher->getNumManifolds() f:^id(NSUInteger i) {
        btPersistentManifold *pManifold = _dispatcher->getManifoldByIndexInternal(i);
        if(pManifold->getNumContacts() == 0) return [CNOption none];
        EGCollisionBody *body0 = (__bridge EGCollisionBody *) pManifold->getBody0()->getUserPointer();
        EGCollisionBody *body1 = (__bridge EGCollisionBody *) pManifold->getBody1()->getUserPointer();
        return [EGCollision collisionWithBodies:[CNPair newWithA:body0 b:body1]
                                 contacts:[CNIndexFunSeq indexFunSeqWithCount:(NSUInteger) pManifold->getNumContacts() f:^id(NSUInteger i) {
                                     btManifoldPoint & p = pManifold->getContactPoint(i);
                                     btVector3 const & a = p.getPositionWorldOnA();
                                     btVector3 const & b = p.getPositionWorldOnB();
                                     return [EGContact contactWithA:EGVec3Make(a.x(), a.y(), a.z())
                                                                  b:EGVec3Make(b.x(), b.y(), b.z())];
                                 }]];
    }];
}

- (ODClassType*)type {
    return [EGCollisionWorld type];
}

+ (ODClassType*)type {
    return _EGCollisionWorld_type;
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


