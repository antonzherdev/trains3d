#import "ATFuture.h"

#import "ATTry.h"
@implementation ATFuture
static ODClassType* _ATFuture_type;

+ (id)future {
    return [[ATFuture alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATFuture class]) _ATFuture_type = [ODClassType classTypeWithCls:[ATFuture class]];
}

- (id)result {
    @throw @"Method result is abstract";
}

- (id)waitResultPeriod:(CGFloat)period {
    @throw @"Method waitResult is abstract";
}

- (ATTry*)waitResult {
    @throw @"Method waitResult is abstract";
}

- (void)onCompleteF:(void(^)(ATTry*))f {
    @throw @"Method onComplete is abstract";
}

- (void)onSuccessF:(void(^)(id))f {
    [self onCompleteF:^void(ATTry* t) {
        if([t isSuccess]) f([t get]);
    }];
}

- (void)onFailureF:(void(^)(id))f {
    [self onCompleteF:^void(ATTry* t) {
        if([t isFailure]) f([t reason]);
    }];
}

- (ODClassType*)type {
    return [ATFuture type];
}

+ (ODClassType*)type {
    return _ATFuture_type;
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


@implementation ATPromise{
    id __value;
    id<CNSeq> __onCompletes;
    NSLock* _completeLock;
}
static ODClassType* _ATPromise_type;

+ (id)promise {
    return [[ATPromise alloc] init];
}

- (id)init {
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
    if(self == [ATPromise class]) _ATPromise_type = [ODClassType classTypeWithCls:[ATPromise class]];
}

- (id)result {
    return __value;
}

- (void)successValue:(id)value {
    ATSuccess* suc = [ATSuccess successWithGet:value];
    __value = [CNOption applyValue:suc];
    [_completeLock lock];
    [__onCompletes forEach:^void(void(^f)(ATTry*)) {
        f(suc);
    }];
    [_completeLock unlock];
}

- (void)failureReason:(id)reason {
    ATFailure* fail = [ATFailure failureWithReason:reason];
    __value = [CNOption applyValue:fail];
    [_completeLock lock];
    [__onCompletes forEach:^void(void(^f)(ATTry*)) {
        f(fail);
    }];
    [_completeLock unlock];
}

- (void)onCompleteF:(void(^)(ATTry*))f {
    if([__value isDefined]) {
        f([__value get]);
    } else {
        [_completeLock lock];
        __onCompletes = [__onCompletes addItem:f];
        [_completeLock unlock];
    }
}

- (id)waitResultPeriod:(CGFloat)period {
    NSConditionLock* lock = [NSConditionLock conditionLockWithCondition:0];
    [self onCompleteF:^void(ATTry* _) {
        [lock lock];
        [lock unlockWithCondition:1];
    }];
    [lock lockWhenCondition:1 period:period];
    [lock unlock];
    return __value;
}

- (ATTry*)waitResult {
    NSConditionLock* lock = [NSConditionLock conditionLockWithCondition:0];
    [self onCompleteF:^void(ATTry* _) {
        [lock lock];
        [lock unlockWithCondition:1];
    }];
    [lock lockWhenCondition:1];
    [lock unlock];
    return [__value get];
}

- (ODClassType*)type {
    return [ATPromise type];
}

+ (ODClassType*)type {
    return _ATPromise_type;
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


@implementation ATTypedActorFuture{
    id(^_f)();
    BOOL _prompt;
}
static ODClassType* _ATTypedActorFuture_type;
@synthesize f = _f;
@synthesize prompt = _prompt;

+ (id)typedActorFutureWithF:(id(^)())f prompt:(BOOL)prompt {
    return [[ATTypedActorFuture alloc] initWithF:f prompt:prompt];
}

- (id)initWithF:(id(^)())f prompt:(BOOL)prompt {
    self = [super init];
    if(self) {
        _f = f;
        _prompt = prompt;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATTypedActorFuture class]) _ATTypedActorFuture_type = [ODClassType classTypeWithCls:[ATTypedActorFuture class]];
}

- (void)execute {
    [self successValue:((id(^)())(_f))()];
}

- (ODClassType*)type {
    return [ATTypedActorFuture type];
}

+ (ODClassType*)type {
    return _ATTypedActorFuture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    ATTypedActorFuture* o = ((ATTypedActorFuture*)(other));
    return [self.f isEqual:o.f] && self.prompt == o.prompt;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.f hash];
    hash = hash * 31 + self.prompt;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"prompt=%d", self.prompt];
    [description appendString:@">"];
    return description;
}

@end


