#import "EGCollision.h"

#import "CNChain.h"
#import "EGCollisionBody.h"
#import "GEMat4.h"
@implementation EGCollision
static CNClassType* _EGCollision_type;
@synthesize bodies = _bodies;
@synthesize contacts = _contacts;

+ (instancetype)collisionWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts {
    return [[EGCollision alloc] initWithBodies:bodies contacts:contacts];
}

- (instancetype)initWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts {
    self = [super init];
    if(self) {
        _bodies = bodies;
        _contacts = contacts;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCollision class]) _EGCollision_type = [CNClassType classTypeWithCls:[EGCollision class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Collision(%@, %@)", _bodies, _contacts];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGCollision class]])) return NO;
    EGCollision* o = ((EGCollision*)(to));
    return [_bodies isEqual:o.bodies] && [_contacts isEqual:o.contacts];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_bodies hash];
    hash = hash * 31 + [_contacts hash];
    return hash;
}

- (CNClassType*)type {
    return [EGCollision type];
}

+ (CNClassType*)type {
    return _EGCollision_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGDynamicCollision
static CNClassType* _EGDynamicCollision_type;
@synthesize bodies = _bodies;
@synthesize contacts = _contacts;

+ (instancetype)dynamicCollisionWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts {
    return [[EGDynamicCollision alloc] initWithBodies:bodies contacts:contacts];
}

- (instancetype)initWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts {
    self = [super init];
    if(self) {
        _bodies = bodies;
        _contacts = contacts;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGDynamicCollision class]) _EGDynamicCollision_type = [CNClassType classTypeWithCls:[EGDynamicCollision class]];
}

- (float)impulse {
    id __tmp = [[[_contacts chain] mapF:^id(EGContact* _) {
        return numf4(((EGContact*)(_)).impulse);
    }] max];
    if(__tmp != nil) return unumf4(__tmp);
    else return 0.0;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"DynamicCollision(%@, %@)", _bodies, _contacts];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGDynamicCollision class]])) return NO;
    EGDynamicCollision* o = ((EGDynamicCollision*)(to));
    return [_bodies isEqual:o.bodies] && [_contacts isEqual:o.contacts];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_bodies hash];
    hash = hash * 31 + [_contacts hash];
    return hash;
}

- (CNClassType*)type {
    return [EGDynamicCollision type];
}

+ (CNClassType*)type {
    return _EGDynamicCollision_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGCrossPoint
static CNClassType* _EGCrossPoint_type;
@synthesize body = _body;
@synthesize point = _point;

+ (instancetype)crossPointWithBody:(EGCollisionBody*)body point:(GEVec3)point {
    return [[EGCrossPoint alloc] initWithBody:body point:point];
}

- (instancetype)initWithBody:(EGCollisionBody*)body point:(GEVec3)point {
    self = [super init];
    if(self) {
        _body = body;
        _point = point;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCrossPoint class]) _EGCrossPoint_type = [CNClassType classTypeWithCls:[EGCrossPoint class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CrossPoint(%@, %@)", _body, geVec3Description(_point)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGCrossPoint class]])) return NO;
    EGCrossPoint* o = ((EGCrossPoint*)(to));
    return [_body isEqual:o.body] && geVec3IsEqualTo(_point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_body hash];
    hash = hash * 31 + geVec3Hash(_point);
    return hash;
}

- (CNClassType*)type {
    return [EGCrossPoint type];
}

+ (CNClassType*)type {
    return _EGCrossPoint_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGContact
static CNClassType* _EGContact_type;
@synthesize a = _a;
@synthesize b = _b;
@synthesize distance = _distance;
@synthesize impulse = _impulse;
@synthesize lifeTime = _lifeTime;

+ (instancetype)contactWithA:(GEVec3)a b:(GEVec3)b distance:(float)distance impulse:(float)impulse lifeTime:(unsigned int)lifeTime {
    return [[EGContact alloc] initWithA:a b:b distance:distance impulse:impulse lifeTime:lifeTime];
}

- (instancetype)initWithA:(GEVec3)a b:(GEVec3)b distance:(float)distance impulse:(float)impulse lifeTime:(unsigned int)lifeTime {
    self = [super init];
    if(self) {
        _a = a;
        _b = b;
        _distance = distance;
        _impulse = impulse;
        _lifeTime = lifeTime;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGContact class]) _EGContact_type = [CNClassType classTypeWithCls:[EGContact class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Contact(%@, %@, %f, %f, %u)", geVec3Description(_a), geVec3Description(_b), _distance, _impulse, _lifeTime];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGContact class]])) return NO;
    EGContact* o = ((EGContact*)(to));
    return geVec3IsEqualTo(_a, o.a) && geVec3IsEqualTo(_b, o.b) && eqf4(_distance, o.distance) && eqf4(_impulse, o.impulse) && _lifeTime == o.lifeTime;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec3Hash(_a);
    hash = hash * 31 + geVec3Hash(_b);
    hash = hash * 31 + float4Hash(_distance);
    hash = hash * 31 + float4Hash(_impulse);
    hash = hash * 31 + _lifeTime;
    return hash;
}

- (CNClassType*)type {
    return [EGContact type];
}

+ (CNClassType*)type {
    return _EGContact_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGIndexFunFilteredIterable
static CNClassType* _EGIndexFunFilteredIterable_type;
@synthesize maxCount = _maxCount;
@synthesize f = _f;

+ (instancetype)indexFunFilteredIterableWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f {
    return [[EGIndexFunFilteredIterable alloc] initWithMaxCount:maxCount f:f];
}

- (instancetype)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f {
    self = [super init];
    if(self) {
        _maxCount = maxCount;
        _f = [f copy];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGIndexFunFilteredIterable class]) _EGIndexFunFilteredIterable_type = [CNClassType classTypeWithCls:[EGIndexFunFilteredIterable class]];
}

- (id<CNIterator>)iterator {
    return [EGIndexFunFilteredIterator indexFunFilteredIteratorWithMaxCount:_maxCount f:_f];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"IndexFunFilteredIterable(%lu)", (unsigned long)_maxCount];
}

- (CNClassType*)type {
    return [EGIndexFunFilteredIterable type];
}

+ (CNClassType*)type {
    return _EGIndexFunFilteredIterable_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGIndexFunFilteredIterator
static CNClassType* _EGIndexFunFilteredIterator_type;
@synthesize maxCount = _maxCount;
@synthesize f = _f;

+ (instancetype)indexFunFilteredIteratorWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f {
    return [[EGIndexFunFilteredIterator alloc] initWithMaxCount:maxCount f:f];
}

- (instancetype)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f {
    self = [super init];
    if(self) {
        _maxCount = maxCount;
        _f = [f copy];
        _i = 0;
        __next = [self roll];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGIndexFunFilteredIterator class]) _EGIndexFunFilteredIterator_type = [CNClassType classTypeWithCls:[EGIndexFunFilteredIterator class]];
}

- (BOOL)hasNext {
    return __next != nil;
}

- (id)next {
    id ret = __next;
    __next = [self roll];
    return ret;
}

- (id)roll {
    id ret = nil;
    while(ret == nil && _i < _maxCount) {
        ret = _f(_i);
        _i++;
    }
    return ret;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"IndexFunFilteredIterator(%lu)", (unsigned long)_maxCount];
}

- (CNClassType*)type {
    return [EGIndexFunFilteredIterator type];
}

+ (CNClassType*)type {
    return _EGIndexFunFilteredIterator_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGPhysicsBody_impl

+ (instancetype)physicsBody_impl {
    return [[EGPhysicsBody_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (id)data {
    @throw @"Method data is abstract";
}

- (id<EGCollisionShape>)shape {
    @throw @"Method shape is abstract";
}

- (BOOL)isKinematic {
    @throw @"Method isKinematic is abstract";
}

- (GEMat4*)matrix {
    @throw @"Method matrix is abstract";
}

- (void)setMatrix:(GEMat4*)matrix {
    @throw @"Method set is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGPhysicsWorld
static CNClassType* _EGPhysicsWorld_type;

+ (instancetype)physicsWorld {
    return [[EGPhysicsWorld alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __bodiesMap = [CNMHashMap hashMap];
        __bodies = ((NSArray*)((@[])));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGPhysicsWorld class]) _EGPhysicsWorld_type = [CNClassType classTypeWithCls:[EGPhysicsWorld class]];
}

- (void)addBody:(id<EGPhysicsBody>)body {
    __bodies = [__bodies addItem:body];
    [__bodiesMap setKey:[body data] value:body];
    [self _addBody:body];
}

- (void)_addBody:(id<EGPhysicsBody>)body {
    @throw @"Method _add is abstract";
}

- (void)removeBody:(id<EGPhysicsBody>)body {
    [self _removeBody:body];
    [__bodiesMap removeKey:[body data]];
    NSArray* bs = __bodies;
    __bodies = [bs subItem:body];
}

- (BOOL)removeItem:(id)item {
    id __tmp_0;
    {
        id<EGPhysicsBody> body = [__bodiesMap removeKey:item];
        if(body != nil) {
            [self removeBody:body];
            __tmp_0 = @YES;
        } else {
            __tmp_0 = nil;
        }
    }
    if(__tmp_0 != nil) return unumb(__tmp_0);
    else return NO;
}

- (void)_removeBody:(id<EGPhysicsBody>)body {
    @throw @"Method _remove is abstract";
}

- (id<EGPhysicsBody>)bodyForItem:(id)item {
    return [__bodiesMap applyKey:item];
}

- (void)clear {
    for(id<EGPhysicsBody> body in __bodies) {
        [self _removeBody:body];
    }
    __bodies = ((NSArray*)((@[])));
    [__bodiesMap clear];
}

- (id<CNIterable>)bodies {
    return __bodies;
}

- (NSString*)description {
    return @"PhysicsWorld";
}

- (CNClassType*)type {
    return [EGPhysicsWorld type];
}

+ (CNClassType*)type {
    return _EGPhysicsWorld_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

