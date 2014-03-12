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

- (ODClassType*)type {
    return [ATActor type];
}

+ (ODClassType*)type {
    return _ATActor_type;
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


