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
    return [ATTypedActorFuture typedActorFutureWithReceiver:self f:f prompt:NO];
}

- (CNFuture*)promptF:(id(^)())f {
    return [ATTypedActorFuture typedActorFutureWithReceiver:self f:f prompt:YES];
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
    ATTypedActor* _receiver;
    id(^_f)();
    BOOL _prompt;
}
static ODClassType* _ATTypedActorFuture_type;
@synthesize receiver = _receiver;
@synthesize f = _f;
@synthesize prompt = _prompt;

+ (instancetype)typedActorFutureWithReceiver:(ATTypedActor*)receiver f:(id(^)())f prompt:(BOOL)prompt {
    return [[ATTypedActorFuture alloc] initWithReceiver:receiver f:f prompt:prompt];
}

- (instancetype)initWithReceiver:(ATTypedActor*)receiver f:(id(^)())f prompt:(BOOL)prompt {
    self = [super init];
    if(self) {
        _receiver = receiver;
        _f = [f copy];
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
    return [self.receiver isEqual:o.receiver] && [self.f isEqual:o.f] && self.prompt == o.prompt;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.receiver hash];
    hash = hash * 31 + [self.f hash];
    hash = hash * 31 + self.prompt;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"receiver=%@", self.receiver];
    [description appendFormat:@", prompt=%d", self.prompt];
    [description appendString:@">"];
    return description;
}

@end


