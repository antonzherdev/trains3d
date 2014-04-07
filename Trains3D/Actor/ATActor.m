#import "ATActor.h"

#import "ATMailbox.h"
@implementation ATActor
static ODClassType* _ATActor_type;
@synthesize mailbox = _mailbox;

+ (instancetype)actor {
    return [[ATActor alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _mailbox = [ATMailbox mailbox];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATActor class]) _ATActor_type = [ODClassType classTypeWithCls:[ATActor class]];
}

- (CNFuture*)futureF:(id(^)())f {
    ATActorFuture* fut = [ATActorFuture actorFutureWithReceiver:self prompt:NO f:f];
    [_mailbox sendMessage:fut];
    return fut;
}

- (CNFuture*)promptF:(id(^)())f {
    ATActorFuture* fut = [ATActorFuture actorFutureWithReceiver:self prompt:YES f:f];
    [_mailbox sendMessage:fut];
    return fut;
}

- (CNFuture*)futureJoinF:(CNFuture*(^)())f {
    CNPromise* ret = [CNPromise apply];
    ATActorFuture* fut = [ATActorFuture actorFutureWithReceiver:self prompt:NO f:^id() {
        {
            CNFuture* nf = f();
            [nf onCompleteF:^void(CNTry* _) {
                [ret completeValue:_];
            }];
        }
        return nil;
    }];
    [_mailbox sendMessage:fut];
    return ret;
}

- (CNFuture*)promptJoinF:(CNFuture*(^)())f {
    CNPromise* ret = [CNPromise apply];
    ATActorFuture* fut = [ATActorFuture actorFutureWithReceiver:self prompt:YES f:^id() {
        {
            CNFuture* nf = f();
            [nf onCompleteF:^void(CNTry* _) {
                [ret completeValue:_];
            }];
        }
        return nil;
    }];
    [_mailbox sendMessage:fut];
    return ret;
}

- (CNFuture*)onSuccessFuture:(CNFuture*)future f:(id(^)(id))f {
    __block id res;
    ATActorFuture* fut = [ATActorFuture actorFutureWithReceiver:self prompt:NO f:^id() {
        return f(res);
    }];
    [future onCompleteF:^void(CNTry* tr) {
        if([tr isFailure]) {
            [fut completeValue:tr];
        } else {
            res = [tr get];
            [_mailbox sendMessage:fut];
        }
    }];
    return fut;
}

- (CNFuture*)lockAndOnSuccessFuture:(CNFuture*)future f:(id(^)(id))f {
    __block id res;
    ATActorFuture* fut = [ATActorFuture actorFutureWithReceiver:self prompt:NO f:^id() {
        return f(res);
    }];
    [fut lock];
    [future onCompleteF:^void(CNTry* tr) {
        if([tr isFailure]) {
            [fut completeValue:tr];
        } else {
            res = [tr get];
            [fut unlock];
        }
    }];
    [_mailbox sendMessage:fut];
    return fut;
}

- (CNFuture*)dummy {
    return [self futureF:^id() {
        return nil;
    }];
}

- (ODClassType*)type {
    return [ATActor type];
}

+ (ODClassType*)type {
    return _ATActor_type;
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


