#import "ATTypedActor.h"

#import "ATMailbox.h"
#import "ATActor.h"
@implementation ATTypedActor{
    __weak id __actor;
    BOOL __setup;
}
static ODClassType* _ATTypedActor_type;

+ (instancetype)typedActor {
    return [[ATTypedActor alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __actor = nil;
        __setup = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATTypedActor class]) _ATTypedActor_type = [ODClassType classTypeWithCls:[ATTypedActor class]];
}

- (CNFuture*)futureF:(id(^)())f {
    return [ATTypedActorFuture typedActorFutureWithReceiver:self prompt:NO f:f];
}

- (CNFuture*)promptF:(id(^)())f {
    return [ATTypedActorFuture typedActorFutureWithReceiver:self prompt:YES f:f];
}

- (id)actor {
    if(__actor == nil) @synchronized(self) {
        if(__setup) @throw @"Incorrect actor using";
        ATTypedActor* act = [ATActors typedActor:self];
        __actor = act;
        __setup = YES;
        return act;
    }
    else return __actor;
}

- (CNFuture*)lockAndOnSuccessFuture:(CNFuture*)future f:(id(^)(id))f {
    __block id res;
    ATTypedActorFuture* fut = [ATTypedActorFuture typedActorFutureWithReceiver:self prompt:NO f:^id() {
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
    return fut;
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


