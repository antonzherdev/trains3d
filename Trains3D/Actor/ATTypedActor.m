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
    return [ATTypedActorFuture typedActorFutureWithActor:self f:f prompt:NO];
}

- (CNFuture*)promptF:(id(^)())f {
    return [ATTypedActorFuture typedActorFutureWithActor:self f:f prompt:YES];
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


@implementation ATTypedActorFuture{
    ATTypedActor* _actor;
    id(^_f)();
    BOOL _prompt;
}
static ODClassType* _ATTypedActorFuture_type;
@synthesize actor = _actor;
@synthesize f = _f;
@synthesize prompt = _prompt;

+ (instancetype)typedActorFutureWithActor:(ATTypedActor*)actor f:(id(^)())f prompt:(BOOL)prompt {
    return [[ATTypedActorFuture alloc] initWithActor:actor f:f prompt:prompt];
}

- (instancetype)initWithActor:(ATTypedActor*)actor f:(id(^)())f prompt:(BOOL)prompt {
    self = [super init];
    if(self) {
        _actor = actor;
        _f = f;
        _prompt = prompt;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATTypedActorFuture class]) _ATTypedActorFuture_type = [ODClassType classTypeWithCls:[ATTypedActorFuture class]];
}

- (void)process {
    [self successValue:((id(^)())(_f))()];
}

- (id<ATActor>)sender {
    return nil;
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
    return [self.actor isEqual:o.actor] && [self.f isEqual:o.f] && self.prompt == o.prompt;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.actor hash];
    hash = hash * 31 + [self.f hash];
    hash = hash * 31 + self.prompt;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"actor=%@", self.actor];
    [description appendFormat:@", prompt=%d", self.prompt];
    [description appendString:@">"];
    return description;
}

@end


