#import "ATTypedActor.h"

#import "ATMailbox.h"
#import "ATFuture.h"

@implementation ATTypedActor{
    id _actor;
    ATMailbox* _mailbox;
}
static ODClassType* _ATTypedActor_type;
@synthesize actor = _actor;
@synthesize mailbox = _mailbox;

+ (id)typedActorWithActor:(id)actor mailbox:(ATMailbox*)mailbox {
    return [[ATTypedActor alloc] initWithActor:actor mailbox:mailbox];
}

- (id)initWithActor:(id)actor mailbox:(ATMailbox*)mailbox {
    if(self) {
        _actor = actor;
        _mailbox = mailbox;
    }

    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return YES; // [_actor respondsToSelector:aSelector];
}

-(NSMethodSignature*)methodSignatureForHOMSelector:(SEL)aSelector {
    return [_actor methodSignatureForSelector:aSelector];
}


-(NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector {
    return [self methodSignatureForHOMSelector:aSelector];
}

+ (BOOL)instancesRespondToSelector:(SEL)aSelector {
    return YES;
}

-(void)forwardInvocation:(NSInvocation*)invocationToForward
{
    BOOL sync = invocationToForward.methodSignature.methodReturnLength > 0;
    ATPromise *result = [ATPromise promise];
    ATMessage *message = [ATMessage messageWithSender:nil message:invocationToForward result:result sync:sync];
    [_mailbox sendMessage:message receiver:self];
    if(sync) {
        [result waitPeriod:1];
    }
}


+ (void)initialize {
    if(self == [ATTypedActor class]) _ATTypedActor_type = [ODClassType classTypeWithCls:[ATTypedActor class]];
}

- (void)processMessage:(ATMessage*)message {
    NSInvocation *invocation = (NSInvocation *) message.message;
    [invocation invokeWithTarget:_actor];
    [message.result successValue:@0];
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
    ATTypedActor* o = ((ATTypedActor*)(other));
    return [self.actor isEqual:o.actor] && [self.mailbox isEqual:o.mailbox];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.actor hash];
    hash = hash * 31 + [self.mailbox hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"actor=%@", self.actor];
    [description appendFormat:@", mailbox=%@", self.mailbox];
    [description appendString:@">"];
    return description;
}

@end


