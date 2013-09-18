#import "EGCollisionWorld.h"

#import "EGCollisionBody.h"

#include "btBulletCollisionCommon.h"
#import "EGCollision.h"
#import "GELine.h"

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
                                     return [EGContact contactWithA:GEVec3Make(a.x(), a.y(), a.z())
                                                                  b:GEVec3Make(b.x(), b.y(), b.z())];
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

- (id <CNSeq>)crossPointsWithSegment:(GELine3)line3 {
    btVector3 from = btVector3(line3.r0.x, line3.r0.y, line3.r0.z);
    btVector3 to = btVector3(line3.r0.x + line3.u.x, line3.r0.y + line3.u.y, line3.r0.z + line3.u.z);
    btCollisionWorld::AllHitsRayResultCallback results(from, to);
    _world->rayTest(from, to, results);
    
    return [CNIndexFunSeq indexFunSeqWithCount:(NSUInteger) results.m_collisionObjects.size() f:^id(NSUInteger i) {
        EGCollisionBody *body = (__bridge EGCollisionBody *) results.m_collisionObjects.at(i)->getUserPointer();
        const btVector3 & p = results.m_hitPointWorld.at(i);
        return [EGCrossPoint crossPointWithBody:body point:(GEVec3){p.x(), p.y(), p.z()}];
    }];
}

- (id)closestCrossPointWithSegment:(GELine3)line3 {
    btVector3 from = btVector3(line3.r0.x, line3.r0.y, line3.r0.z);
    btVector3 to = btVector3(line3.r0.x + line3.u.x, line3.r0.y + line3.u.y, line3.r0.z + line3.u.z);
    btCollisionWorld::ClosestRayResultCallback results(from, to);
    _world->rayTest(from, to, results);
    if(results.m_collisionObject == nil) return [CNOption none];
    EGCollisionBody *body = (__bridge EGCollisionBody *) results.m_collisionObject->getUserPointer();
    const btVector3 & p = results.m_hitPointWorld;
    return [EGCrossPoint crossPointWithBody:body point:(GEVec3){p.x(), p.y(), p.z()}];
}
@end


