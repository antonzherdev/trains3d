#import "EGCollision.h"

#import "EGCollisionBody.h"
@implementation EGCollision{
    CNPair* _bodies;
    id<CNSeq> _contacts;
}
static ODClassType* _EGCollision_type;
@synthesize bodies = _bodies;
@synthesize contacts = _contacts;

+ (id)collisionWithBodies:(CNPair*)bodies contacts:(id<CNSeq>)contacts {
    return [[EGCollision alloc] initWithBodies:bodies contacts:contacts];
}

- (id)initWithBodies:(CNPair*)bodies contacts:(id<CNSeq>)contacts {
    self = [super init];
    if(self) {
        _bodies = bodies;
        _contacts = contacts;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCollision_type = [ODClassType classTypeWithCls:[EGCollision class]];
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


@implementation EGCrossPoint{
    EGCollisionBody* _body;
    GEVec3 _point;
}
static ODClassType* _EGCrossPoint_type;
@synthesize body = _body;
@synthesize point = _point;

+ (id)crossPointWithBody:(EGCollisionBody*)body point:(GEVec3)point {
    return [[EGCrossPoint alloc] initWithBody:body point:point];
}

- (id)initWithBody:(EGCollisionBody*)body point:(GEVec3)point {
    self = [super init];
    if(self) {
        _body = body;
        _point = point;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCrossPoint_type = [ODClassType classTypeWithCls:[EGCrossPoint class]];
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


@implementation EGContact{
    GEVec3 _a;
    GEVec3 _b;
}
static ODClassType* _EGContact_type;
@synthesize a = _a;
@synthesize b = _b;

+ (id)contactWithA:(GEVec3)a b:(GEVec3)b {
    return [[EGContact alloc] initWithA:a b:b];
}

- (id)initWithA:(GEVec3)a b:(GEVec3)b {
    self = [super init];
    if(self) {
        _a = a;
        _b = b;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGContact_type = [ODClassType classTypeWithCls:[EGContact class]];
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
    return GEVec3Eq(self.a, o.a) && GEVec3Eq(self.b, o.b);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec3Hash(self.a);
    hash = hash * 31 + GEVec3Hash(self.b);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"a=%@", GEVec3Description(self.a)];
    [description appendFormat:@", b=%@", GEVec3Description(self.b)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGIndexFunFilteredIterable{
    NSUInteger _maxCount;
    id(^_f)(NSUInteger);
}
static ODClassType* _EGIndexFunFilteredIterable_type;
@synthesize maxCount = _maxCount;
@synthesize f = _f;

+ (id)indexFunFilteredIterableWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f {
    return [[EGIndexFunFilteredIterable alloc] initWithMaxCount:maxCount f:f];
}

- (id)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f {
    self = [super init];
    if(self) {
        _maxCount = maxCount;
        _f = f;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGIndexFunFilteredIterable_type = [ODClassType classTypeWithCls:[EGIndexFunFilteredIterable class]];
}

- (id<CNIterator>)iterator {
    return [EGIndexFunFilteredIterator indexFunFilteredIteratorWithMaxCount:_maxCount f:_f];
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
    if([self isEmpty]) return [CNOption none];
    else return [CNOption applyValue:[self head]];
}

- (BOOL)isEmpty {
    return !([[self iterator] hasNext]);
}

- (CNChain*)chain {
    return [CNChain chainWithCollection:self];
}

- (void)forEach:(void(^)(id))each {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        each([i next]);
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

- (NSString*)description {
    return [[self chain] toStringWithStart:@"[" delimiter:@", " end:@"]"];
}

- (NSUInteger)hash {
    NSUInteger ret = 13;
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        ret = ret * 31 + [[i next] hash];
    }
    return ret;
}

- (id)findWhere:(BOOL(^)(id))where {
    __block id ret = [CNOption none];
    [self goOn:^BOOL(id x) {
        if(where(ret)) {
            ret = [CNOption applyValue:x];
            NO;
        }
        return YES;
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGIndexFunFilteredIterable* o = ((EGIndexFunFilteredIterable*)(other));
    return self.maxCount == o.maxCount && [self.f isEqual:o.f];
}

@end


@implementation EGIndexFunFilteredIterator{
    NSUInteger _maxCount;
    id(^_f)(NSUInteger);
    NSUInteger _i;
    id __next;
}
static ODClassType* _EGIndexFunFilteredIterator_type;
@synthesize maxCount = _maxCount;
@synthesize f = _f;

+ (id)indexFunFilteredIteratorWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f {
    return [[EGIndexFunFilteredIterator alloc] initWithMaxCount:maxCount f:f];
}

- (id)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f {
    self = [super init];
    if(self) {
        _maxCount = maxCount;
        _f = f;
        _i = 0;
        __next = [self roll];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGIndexFunFilteredIterator_type = [ODClassType classTypeWithCls:[EGIndexFunFilteredIterator class]];
}

- (BOOL)hasNext {
    return [__next isDefined];
}

- (id)next {
    id ret = [__next get];
    __next = [self roll];
    return ret;
}

- (id)roll {
    id ret = [CNOption none];
    while([ret isEmpty] && _i < _maxCount) {
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGIndexFunFilteredIterator* o = ((EGIndexFunFilteredIterator*)(other));
    return self.maxCount == o.maxCount && [self.f isEqual:o.f];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.maxCount;
    hash = hash * 31 + [self.f hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"maxCount=%li", self.maxCount];
    [description appendString:@">"];
    return description;
}

@end


