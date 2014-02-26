#import "ATTypedActorWrap.h"

#import "ATMailbox.h"
#import "ATTypedActor.h"

@implementation ATTypedActorWrap {
    id _actor;
    ATMailbox* _mailbox;
}
static ODClassType* _ATTypedActor_type;
@synthesize actor = _actor;
@synthesize mailbox = _mailbox;

+ (id)typedActorWrapWithActor:(id)actor mailbox:(ATMailbox*)mailbox {
    return [[ATTypedActorWrap alloc] initWithActor:actor mailbox:mailbox];
}

- (id)initWithActor:(id)actor mailbox:(ATMailbox*)mailbox {
    if(self) {
        _actor = actor;
        _mailbox = mailbox;
    }

    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self respondsToSelector:aSelector] || [_actor respondsToSelector:aSelector];
}

-(NSMethodSignature*)methodSignatureForHOMSelector:(SEL)aSelector {
    return [_actor methodSignatureForSelector:aSelector];
}


-(NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector {
    return [self methodSignatureForHOMSelector:aSelector];
}

//+ (BOOL)instancesRespondToSelector:(SEL)aSelector {
//    return YES;
//}

-(void)forwardInvocation:(NSInvocation*)invocationToForward
{
    BOOL sync = invocationToForward.methodSignature.methodReturnLength > 0;
    if(sync) {
        [invocationToForward invokeWithTarget:_actor];
        void* fRef;
        [invocationToForward getReturnValue:&fRef];
        id f = (__bridge id)fRef ;
        if([f isMemberOfClass:[ATTypedActorFuture class]]) {
            ATTypedActorMessageResult *message = [ATTypedActorMessageResult typedActorMessageResultWithFuture:f];
            [_mailbox sendMessage:message receiver:self];
        }
    } else {
        ATTypedActorMessageVoid *message = [ATTypedActorMessageVoid typedActorMessageVoidWithInvocation:invocationToForward prompt:NO];
        [_mailbox sendMessage:message receiver:self];
    }
}


+ (void)initialize {
    if(self == [ATTypedActorWrap class]) _ATTypedActor_type = [ODClassType classTypeWithCls:[ATTypedActorWrap class]];
}

- (void)processMessage:(id<ATActorMessage>) message {
    [(ATTypedActorMessage *) message processActor:_actor];
}

- (ODClassType*)type {
    return [ATTypedActorWrap type];
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
    ATTypedActorWrap * o = ((ATTypedActorWrap *)(other));
    return [self.actor isEqual:o.actor] && [self.mailbox isEqual:o.mailbox];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.actor hash];
    hash = hash * 31 + [self.mailbox hash];
    return hash;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"W#%@", _actor];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"W#%@", _actor];
}

@end


