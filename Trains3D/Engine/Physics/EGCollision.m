#import "EGCollision.h"

#import "EGCollisionBody.h"
#import "GEMat4.h"
@implementation EGCollision
static ODClassType* _EGCollision_type;
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
    if(self == [EGCollision class]) _EGCollision_type = [ODClassType classTypeWithCls:[EGCollision class]];
}

- (ODClassType*)type {
    return [EGCollision type];
}

+ (ODClassType*)type {
    return _EGCollision_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCollision* o = ((EGCollision*)(other));
    return [self.bodies isEqual:o.bodies] && [self.contacts isEqual:o.contacts];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.bodies hash];
    hash = hash * 31 + [self.contacts hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"bodies=%@", self.bodies];
    [description appendFormat:@", contacts=%@", self.contacts];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGDynamicCollision
static ODClassType* _EGDynamicCollision_type;
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
    if(self == [EGDynamicCollision class]) _EGDynamicCollision_type = [ODClassType classTypeWithCls:[EGDynamicCollision class]];
}

- (float)impulse {
    id __tmp = [[[_contacts chain] map:^id(EGContact* _) {
        return numf4(((EGContact*)(_)).impulse);
    }] max];
    if(__tmp != nil) return unumf4(__tmp);
    else return 0.0;
}

- (ODClassType*)type {
    return [EGDynamicCollision type];
}

+ (ODClassType*)type {
    return _EGDynamicCollision_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGDynamicCollision* o = ((EGDynamicCollision*)(other));
    return [self.bodies isEqual:o.bodies] && [self.contacts isEqual:o.contacts];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.bodies hash];
    hash = hash * 31 + [self.contacts hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"bodies=%@", self.bodies];
    [description appendFormat:@", contacts=%@", self.contacts];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCrossPoint
static ODClassType* _EGCrossPoint_type;
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
    if(self == [EGCrossPoint class]) _EGCrossPoint_type = [ODClassType classTypeWithCls:[EGCrossPoint class]];
}

- (ODClassType*)type {
    return [EGCrossPoint type];
}

+ (ODClassType*)type {
    return _EGCrossPoint_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCrossPoint* o = ((EGCrossPoint*)(other));
    return [self.body isEqual:o.body] && GEVec3Eq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.body hash];
    hash = hash * 31 + GEVec3Hash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"body=%@", self.body];
    [description appendFormat:@", point=%@", GEVec3Description(self.point)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGContact
static ODClassType* _EGContact_type;
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
    if(self == [EGContact class]) _EGContact_type = [ODClassType classTypeWithCls:[EGContact class]];
}

- (ODClassType*)type {
    return [EGContact type];
}

+ (ODClassType*)type {
    return _EGContact_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGContact* o = ((EGContact*)(other));
    return GEVec3Eq(self.a, o.a) && GEVec3Eq(self.b, o.b) && eqf4(self.distance, o.distance) && eqf4(self.impulse, o.impulse) && self.lifeTime == o.lifeTime;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec3Hash(self.a);
    hash = hash * 31 + GEVec3Hash(self.b);
    hash = hash * 31 + float4Hash(self.distance);
    hash = hash * 31 + float4Hash(self.impulse);
    hash = hash * 31 + self.lifeTime;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"a=%@", GEVec3Description(self.a)];
    [description appendFormat:@", b=%@", GEVec3Description(self.b)];
    [description appendFormat:@", distance=%f", self.distance];
    [description appendFormat:@", impulse=%f", self.impulse];
    [description appendFormat:@", lifeTime=%u", self.lifeTime];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGIndexFunFilteredIterable
static ODClassType* _EGIndexFunFilteredIterable_type;
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
    if(self == [EGIndexFunFilteredIterable class]) _EGIndexFunFilteredIterable_type = [ODClassType classTypeWithCls:[EGIndexFunFilteredIterable class]];
}

- (id<CNIterator>)iterator {
    return [EGIndexFunFilteredIterator indexFunFilteredIteratorWithMaxCount:_maxCount f:_f];
}

- (id<CNMIterable>)mCopy {
    NSMutableArray* arr = [NSMutableArray mutableArray];
    [self forEach:^void(id item) {
        [arr appendItem:item];
    }];
    return arr;
}

- (NSUInteger)count {
    id<CNIterator> i = [self iterator];
    NSUInteger n = 0;
    while([i hasNext]) {
        [i next];
        n++;
    }
    return n;
}

- (id)head {
    return [[self iterator] next];
}

- (id)headOpt {
    if([self isEmpty]) return nil;
    else return [self head];
}

- (BOOL)isEmpty {
    return !([[self iterator] hasNext]);
}

- (void)forEach:(void(^)(id))each {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        each([i next]);
    }
}

- (void)parForEach:(void(^)(id))each {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        id v = [i next];
        [CNDispatchQueue.aDefault asyncF:^void() {
            each(v);
        }];
    }
}

- (BOOL)goOn:(BOOL(^)(id))on {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        if(!(on([i next]))) return NO;
    }
    return YES;
}

- (BOOL)containsItem:(id)item {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        if([[i next] isEqual:i]) return YES;
    }
    return NO;
}

- (CNChain*)chain {
    return [CNChain chainWithCollection:self];
}

- (id)findWhere:(BOOL(^)(id))where {
    __block id ret = nil;
    [self goOn:^BOOL(id x) {
        if(where(x)) {
            ret = x;
            return NO;
        } else {
            return YES;
        }
    }];
    return ret;
}

- (BOOL)existsWhere:(BOOL(^)(id))where {
    __block BOOL ret = NO;
    [self goOn:^BOOL(id x) {
        if(where(x)) {
            ret = YES;
            return NO;
        } else {
            return YES;
        }
    }];
    return ret;
}

- (BOOL)allConfirm:(BOOL(^)(id))confirm {
    __block BOOL ret = YES;
    [self goOn:^BOOL(id x) {
        if(!(confirm(x))) {
            ret = NO;
            return NO;
        } else {
            return YES;
        }
    }];
    return ret;
}

- (id)convertWithBuilder:(id<CNBuilder>)builder {
    [self forEach:^void(id x) {
        [builder appendItem:x];
    }];
    return [builder build];
}

- (ODClassType*)type {
    return [EGIndexFunFilteredIterable type];
}

+ (ODClassType*)type {
    return _EGIndexFunFilteredIterable_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"maxCount=%lu", (unsigned long)self.maxCount];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGIndexFunFilteredIterator
static ODClassType* _EGIndexFunFilteredIterator_type;
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
    if(self == [EGIndexFunFilteredIterator class]) _EGIndexFunFilteredIterator_type = [ODClassType classTypeWithCls:[EGIndexFunFilteredIterator class]];
}

- (BOOL)hasNext {
    return __next != nil;
}

- (id)next {
    id ret = ((id)(__next));
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

- (ODClassType*)type {
    return [EGIndexFunFilteredIterator type];
}

+ (ODClassType*)type {
    return _EGIndexFunFilteredIterator_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"maxCount=%lu", (unsigned long)self.maxCount];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGPhysicsWorld
static ODClassType* _EGPhysicsWorld_type;

+ (instancetype)physicsWorld {
    return [[EGPhysicsWorld alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __bodiesMap = [NSMutableDictionary mutableDictionary];
        __bodies = (@[]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGPhysicsWorld class]) _EGPhysicsWorld_type = [ODClassType classTypeWithCls:[EGPhysicsWorld class]];
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
    [__bodiesMap removeForKey:[body data]];
    NSArray* bs = __bodies;
    __bodies = [bs subItem:body];
}

- (BOOL)removeItem:(id)item {
    id __tmp_0;
    {
        id<EGPhysicsBody> body = [__bodiesMap takeKey:item];
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
    return [__bodiesMap optKey:item];
}

- (void)clear {
    for(id<EGPhysicsBody> body in __bodies) {
        [self _removeBody:body];
    }
    __bodies = (@[]);
    [__bodiesMap clear];
}

- (id<CNIterable>)bodies {
    return __bodies;
}

- (ODClassType*)type {
    return [EGPhysicsWorld type];
}

+ (ODClassType*)type {
    return _EGPhysicsWorld_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


