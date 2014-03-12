#import "objd.h"
#import "CNFuture.h"

#import "CNDispatchQueue.h"
#import "CNTry.h"
#import "CNCollection.h"
#import "CNAtomic.h"
#import "CNTuple.h"
#import "ODType.h"
@implementation CNFuture
static ODClassType* _CNFuture_type;

+ (instancetype)future {
    return [[CNFuture alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNFuture class]) _CNFuture_type = [ODClassType classTypeWithCls:[CNFuture class]];
}

+ (CNFuture*)applyF:(id(^)())f {
    CNPromise* p = [CNPromise apply];
    [CNDispatchQueue.aDefault asyncF:^void() {
        [p successValue:((id(^)())(f))()];
    }];
    return p;
}

+ (CNFuture*)successfulResult:(id)result {
    return [CNKeptPromise keptPromiseWithValue:[CNSuccess successWithGet:result]];
}

- (id)result {
    @throw @"Method result is abstract";
}

- (BOOL)isCompleted {
    return [[self result] isDefined];
}

- (BOOL)isSucceeded {
    return [[self result] isDefined] && [((CNTry*)([[self result] get])) isSuccess];
}

- (BOOL)isFailed {
    return [[self result] isDefined] && [((CNTry*)([[self result] get])) isFailure];
}

- (void)onCompleteF:(void(^)(CNTry*))f {
    @throw @"Method onComplete is abstract";
}

- (void)onSuccessF:(void(^)(id))f {
    [self onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) f([t get]);
    }];
}

- (void)onFailureF:(void(^)(id))f {
    [self onCompleteF:^void(CNTry* t) {
        if([t isFailure]) f([t reason]);
    }];
}

- (CNFuture*)mapF:(id(^)(id))f {
    CNPromise* p = [CNPromise apply];
    [self onCompleteF:^void(CNTry* tr) {
        [p completeValue:[tr mapF:f]];
    }];
    return p;
}

- (CNFuture*)forF:(void(^)(id))f {
    CNPromise* p = [CNPromise apply];
    [self onCompleteF:^void(CNTry* tr) {
        if([tr isSuccess]) {
            f([tr get]);
            [p successValue:nil];
        } else {
            [p completeValue:tr];
        }
    }];
    return p;
}

- (CNFuture*)flatMapF:(CNFuture*(^)(id))f {
    CNPromise* p = [CNPromise apply];
    [self onCompleteF:^void(CNTry* tr) {
        if([tr isFailure]) {
            [p completeValue:((CNTry*)(tr))];
        } else {
            CNFuture* fut = f([tr get]);
            [fut onCompleteF:^void(CNTry* ftr) {
                [p completeValue:ftr];
            }];
        }
    }];
    return p;
}

- (id)waitResultPeriod:(CGFloat)period {
    NSConditionLock* lock = [NSConditionLock conditionLockWithCondition:0];
    [self onCompleteF:^void(CNTry* _) {
        [lock lock];
        [lock unlockWithCondition:1];
    }];
    if([lock lockWhenCondition:1 period:period]) [lock unlock];
    return [self result];
}

- (CNTry*)waitResult {
    NSConditionLock* lock = [NSConditionLock conditionLockWithCondition:0];
    [self onCompleteF:^void(CNTry* _) {
        [lock lock];
        [lock unlockWithCondition:1];
    }];
    [lock lockWhenCondition:1];
    [lock unlock];
    return [[self result] get];
}

- (void)waitAndOnSuccessAwait:(CGFloat)await f:(void(^)(id))f {
    id r = [self waitResultPeriod:await];
    if([r isDefined]) {
        CNTry* tr = [r get];
        if([tr isSuccess]) f([tr get]);
    }
}

- (void)waitAndOnSuccessFlatAwait:(CGFloat)await f:(void(^)(id))f {
    [self waitAndOnSuccessAwait:await f:^void(id tr) {
        [((id<CNTraversable>)(tr)) forEach:f];
    }];
}

- (id)getResultAwait:(CGFloat)await {
    return [((CNTry*)([[self waitResultPeriod:await] get])) get];
}

- (CNFuture*)joinAnother:(CNFuture*)another {
    CNPromise* p = [CNPromise apply];
    __block id a = nil;
    __block id b = nil;
    CNAtomicInt* n = [CNAtomicInt atomicInt];
    [self onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            a = [t get];
            if([n incrementAndGet] == 2) [p successValue:[CNTuple tupleWithA:a b:b]];
        } else {
            [p completeValue:t];
        }
    }];
    [another onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            b = [t get];
            if([n incrementAndGet] == 2) [p successValue:[CNTuple tupleWithA:a b:b]];
        } else {
            [p completeValue:t];
        }
    }];
    return p;
}

- (ODClassType*)type {
    return [CNFuture type];
}

+ (ODClassType*)type {
    return _CNFuture_type;
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


@implementation CNPromise
static ODClassType* _CNPromise_type;

+ (instancetype)promise {
    return [[CNPromise alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNPromise class]) _CNPromise_type = [ODClassType classTypeWithCls:[CNPromise class]];
}

+ (CNPromise*)apply {
    return [CNDefaultPromise defaultPromise];
}

- (BOOL)completeValue:(CNTry*)value {
    @throw @"Method complete is abstract";
}

- (BOOL)successValue:(id)value {
    @throw @"Method success is abstract";
}

- (BOOL)failureReason:(id)reason {
    @throw @"Method failure is abstract";
}

- (ODClassType*)type {
    return [CNPromise type];
}

+ (ODClassType*)type {
    return _CNPromise_type;
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


@implementation CNDefaultPromise
static ODClassType* _CNDefaultPromise_type;

+ (instancetype)defaultPromise {
    return [[CNDefaultPromise alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) __state = [CNAtomicObject applyValue:(@[])];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNDefaultPromise class]) _CNDefaultPromise_type = [ODClassType classTypeWithCls:[CNDefaultPromise class]];
}

- (id)result {
    id v = [__state value];
    if([v isKindOfClass:[CNTry class]]) return [CNOption applyValue:((CNTry*)(v))];
    else return [CNOption none];
}

- (BOOL)completeValue:(CNTry*)value {
    while(YES) {
        id v = [__state value];
        if([v isKindOfClass:[CNTry class]]) {
            return NO;
        } else {
            if([__state compareAndSetOldValue:v newValue:value]) {
                [((id<CNImSeq>)(v)) forEach:^void(void(^f)(CNTry*)) {
                    f(value);
                }];
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)successValue:(id)value {
    return [self completeValue:[CNSuccess successWithGet:value]];
}

- (BOOL)failureReason:(id)reason {
    return [self completeValue:[CNFailure failureWithReason:[self result]]];
}

- (void)onCompleteF:(void(^)(CNTry*))f {
    while(YES) {
        id v = [__state value];
        if([v isKindOfClass:[CNTry class]]) {
            f(((CNTry*)(v)));
            return ;
        } else {
            id<CNImSeq> vv = ((id<CNImSeq>)(v));
            if([__state compareAndSetOldValue:vv newValue:[vv addItem:f]]) return ;
        }
    }
}

- (ODClassType*)type {
    return [CNDefaultPromise type];
}

+ (ODClassType*)type {
    return _CNDefaultPromise_type;
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


@implementation CNKeptPromise
static ODClassType* _CNKeptPromise_type;
@synthesize value = _value;

+ (instancetype)keptPromiseWithValue:(CNTry*)value {
    return [[CNKeptPromise alloc] initWithValue:value];
}

- (instancetype)initWithValue:(CNTry*)value {
    self = [super init];
    if(self) _value = value;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNKeptPromise class]) _CNKeptPromise_type = [ODClassType classTypeWithCls:[CNKeptPromise class]];
}

- (id)result {
    return [CNOption applyValue:_value];
}

- (void)onCompleteF:(void(^)(CNTry*))f {
    f(_value);
}

- (id)waitResultPeriod:(CGFloat)period {
    return [CNOption applyValue:_value];
}

- (CNTry*)waitResult {
    return _value;
}

- (ODClassType*)type {
    return [CNKeptPromise type];
}

+ (ODClassType*)type {
    return _CNKeptPromise_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNKeptPromise* o = ((CNKeptPromise*)(other));
    return [self.value isEqual:o.value];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.value hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"value=%@", self.value];
    [description appendString:@">"];
    return description;
}

@end


