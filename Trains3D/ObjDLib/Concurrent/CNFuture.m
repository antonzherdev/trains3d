#import "objd.h"
#import "CNFuture.h"

#import "CNDispatchQueue.h"
#import "CNTry.h"
#import "CNCollection.h"
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

- (void)forSuccessAwait:(CGFloat)await f:(void(^)(id))f {
    id r = [self waitResultPeriod:await];
    if([r isDefined]) {
        CNTry* tr = [r get];
        if([tr isSuccess]) f([tr get]);
    }
}

- (void)flatForSuccessAwait:(CGFloat)await f:(void(^)(id))f {
    [self forSuccessAwait:await f:^void(id tr) {
        [((id<CNTraversable>)(tr)) forEach:f];
    }];
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

- (void)completeValue:(CNTry*)value {
}

- (void)successValue:(id)value {
}

- (void)failureReason:(id)reason {
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


@implementation CNDefaultPromise{
    id __value;
    id<CNSeq> __onCompletes;
    NSLock* _completeLock;
}
static ODClassType* _CNDefaultPromise_type;

+ (instancetype)defaultPromise {
    return [[CNDefaultPromise alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __value = [CNOption none];
        __onCompletes = (@[]);
        _completeLock = [NSLock lock];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNDefaultPromise class]) _CNDefaultPromise_type = [ODClassType classTypeWithCls:[CNDefaultPromise class]];
}

- (id)result {
    return __value;
}

- (void)completeValue:(CNTry*)value {
    [_completeLock lock];
    if([__value isEmpty]) {
        __value = [CNOption applyValue:value];
        [__onCompletes forEach:^void(void(^f)(CNTry*)) {
            f(value);
        }];
    }
    [_completeLock unlock];
}

- (void)successValue:(id)value {
    [_completeLock lock];
    if([__value isEmpty]) {
        CNSuccess* suc = [CNSuccess successWithGet:value];
        __value = [CNOption applyValue:suc];
        [__onCompletes forEach:^void(void(^f)(CNTry*)) {
            f(suc);
        }];
    }
    [_completeLock unlock];
}

- (void)failureReason:(id)reason {
    [_completeLock lock];
    if([__value isEmpty]) {
        CNFailure* fail = [CNFailure failureWithReason:reason];
        __value = [CNOption applyValue:fail];
        [__onCompletes forEach:^void(void(^f)(CNTry*)) {
            f(fail);
        }];
    }
    [_completeLock unlock];
}

- (void)onCompleteF:(void(^)(CNTry*))f {
    if([__value isDefined]) {
        f([__value get]);
    } else {
        [_completeLock lock];
        if([__value isDefined]) f([__value get]);
        else __onCompletes = [__onCompletes addItem:f];
        [_completeLock unlock];
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


@implementation CNKeptPromise{
    CNTry* _value;
}
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


