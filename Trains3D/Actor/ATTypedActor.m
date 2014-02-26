#import "ATTypedActor.h"

#import "ATActor.h"
@implementation ATTypedActor{
    id _actor;
}
static ODClassType* _ATTypedActor_type;
@synthesize actor = _actor;

+ (instancetype)typedActor {
    return [[ATTypedActor alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _actor = [ATActors typedActor:self];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATTypedActor class]) _ATTypedActor_type = [ODClassType classTypeWithCls:[ATTypedActor class]];
}

- (CNFuture*)futureF:(id(^)())f {
    return [ATTypedActorFuture typedActorFutureWithF:f prompt:NO];
}

- (CNFuture*)promptF:(id(^)())f {
    return [ATTypedActorFuture typedActorFutureWithF:f prompt:YES];
}

- (ODClassType*)type {
    return [ATTypedActor type];
}

+ (ODClassType*)type {
    return _ATTypedActor_type;
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


@implementation ATTypedActorMessage
static ODClassType* _ATTypedActorMessage_type;

+ (instancetype)typedActorMessage {
    return [[ATTypedActorMessage alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATTypedActorMessage class]) _ATTypedActorMessage_type = [ODClassType classTypeWithCls:[ATTypedActorMessage class]];
}

- (id<ATActor>)sender {
    return nil;
}

- (BOOL)prompt {
    @throw @"Method prompt is abstract";
}

- (void)processActor:(id)actor {
    @throw @"Method process is abstract";
}

- (ODClassType*)type {
    return [ATTypedActorMessage type];
}

+ (ODClassType*)type {
    return _ATTypedActorMessage_type;
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


@implementation ATTypedActorMessageVoid{
    NSInvocation* _invocation;
    BOOL _prompt;
}
static ODClassType* _ATTypedActorMessageVoid_type;
@synthesize invocation = _invocation;
@synthesize prompt = _prompt;

+ (instancetype)typedActorMessageVoidWithInvocation:(NSInvocation*)invocation prompt:(BOOL)prompt {
    return [[ATTypedActorMessageVoid alloc] initWithInvocation:invocation prompt:prompt];
}

- (instancetype)initWithInvocation:(NSInvocation*)invocation prompt:(BOOL)prompt {
    self = [super init];
    if(self) {
        _invocation = invocation;
        _prompt = prompt;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATTypedActorMessageVoid class]) _ATTypedActorMessageVoid_type = [ODClassType classTypeWithCls:[ATTypedActorMessageVoid class]];
}

- (void)processActor:(id)actor {
    [_invocation invokeWithTarget:actor];
}

- (ODClassType*)type {
    return [ATTypedActorMessageVoid type];
}

+ (ODClassType*)type {
    return _ATTypedActorMessageVoid_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    ATTypedActorMessageVoid* o = ((ATTypedActorMessageVoid*)(other));
    return [self.invocation isEqual:o.invocation] && self.prompt == o.prompt;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.invocation hash];
    hash = hash * 31 + self.prompt;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"invocation=%@", self.invocation];
    [description appendFormat:@", prompt=%d", self.prompt];
    [description appendString:@">"];
    return description;
}

@end


@implementation ATTypedActorMessageResult{
    ATTypedActorFuture* _future;
}
static ODClassType* _ATTypedActorMessageResult_type;
@synthesize future = _future;

+ (instancetype)typedActorMessageResultWithFuture:(ATTypedActorFuture*)future {
    return [[ATTypedActorMessageResult alloc] initWithFuture:future];
}

- (instancetype)initWithFuture:(ATTypedActorFuture*)future {
    self = [super init];
    if(self) _future = future;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATTypedActorMessageResult class]) _ATTypedActorMessageResult_type = [ODClassType classTypeWithCls:[ATTypedActorMessageResult class]];
}

- (BOOL)prompt {
    return _future.prompt;
}

- (void)processActor:(id)actor {
    [_future execute];
}

- (ODClassType*)type {
    return [ATTypedActorMessageResult type];
}

+ (ODClassType*)type {
    return _ATTypedActorMessageResult_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    ATTypedActorMessageResult* o = ((ATTypedActorMessageResult*)(other));
    return [self.future isEqual:o.future];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.future hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"future=%@", self.future];
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

+ (instancetype)typedActorFutureWithF:(id(^)())f prompt:(BOOL)prompt {
    return [[ATTypedActorFuture alloc] initWithF:f prompt:prompt];
}

- (instancetype)initWithF:(id(^)())f prompt:(BOOL)prompt {
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


