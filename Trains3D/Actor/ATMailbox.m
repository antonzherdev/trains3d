#import "ATMailbox.h"

#import "ATConcurrentQueue.h"
#import "ATActor.h"
@implementation ATMailbox
static ODClassType* _ATMailbox_type;

+ (instancetype)mailbox {
    return [[ATMailbox alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __stopped = NO;
        __scheduled = [CNAtomicBool atomicBool];
        __queue = [ATConcurrentQueue concurrentQueue];
        __locked = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATMailbox class]) _ATMailbox_type = [ODClassType classTypeWithCls:[ATMailbox class]];
}

- (void)sendMessage:(id<ATActorMessage>)message {
    if(__stopped) return ;
    if([message prompt]) {
        if(!([__scheduled getAndSetNewValue:YES])) {
            if([__queue isEmpty]) {
                [message process];
                memoryBarrier();
                if([__queue isEmpty]) {
                    [__scheduled setNewValue:NO];
                    memoryBarrier();
                    if(!([__queue isEmpty])) [self trySchedule];
                } else {
                    [self schedule];
                }
            } else {
                [__queue enqueueItem:message];
                [self schedule];
            }
        } else {
            [__queue enqueueItem:message];
            [self trySchedule];
        }
    } else {
        [__queue enqueueItem:message];
        [self trySchedule];
    }
}

- (void)trySchedule {
    if(!([__scheduled getAndSetNewValue:YES])) [self schedule];
}

- (void)schedule {
    if(!(__stopped)) [CNDispatchQueue.aDefault asyncF:^void() {
        autoreleasePoolStart();
        [self processQueue];
        autoreleasePoolEnd();
    }];
}

- (void)processQueue {
    NSInteger left = 5;
    __locked = NO;
    while(left > 0) {
        id<ATActorMessage> msg = [__queue dequeueWhen:^BOOL(id<ATActorMessage> message) {
            if([((id<ATActorMessage>)(message)) process]) {
                return YES;
            } else {
                __locked = YES;
                return NO;
            }
        }];
        if(msg == nil) break;
        left--;
    }
    if(__locked) {
    } else {
        if([__queue isEmpty]) {
            [__scheduled setNewValue:NO];
            memoryBarrier();
            if(!([__queue isEmpty])) [self trySchedule];
        } else {
            [self schedule];
        }
    }
}

- (void)unlock {
    if(__locked) {
        __locked = NO;
        memoryBarrier();
        [self schedule];
    }
}

- (void)stop {
    __stopped = YES;
    memoryBarrier();
    [__queue clear];
}

- (BOOL)isEmpty {
    return [__queue isEmpty];
}

- (ODClassType*)type {
    return [ATMailbox type];
}

+ (ODClassType*)type {
    return _ATMailbox_type;
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


@implementation ATActorFuture
static ODClassType* _ATActorFuture_type;
@synthesize receiver = _receiver;
@synthesize prompt = _prompt;
@synthesize f = _f;

+ (instancetype)actorFutureWithReceiver:(ATActor*)receiver prompt:(BOOL)prompt f:(id(^)())f {
    return [[ATActorFuture alloc] initWithReceiver:receiver prompt:prompt f:f];
}

- (instancetype)initWithReceiver:(ATActor*)receiver prompt:(BOOL)prompt f:(id(^)())f {
    self = [super init];
    if(self) {
        _receiver = receiver;
        _prompt = prompt;
        _f = [f copy];
        __completed = NO;
        __locked = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATActorFuture class]) _ATActorFuture_type = [ODClassType classTypeWithCls:[ATActorFuture class]];
}

- (BOOL)process {
    if(__completed) {
        return YES;
    } else {
        if(__locked) return NO;
        else return [self successValue:_f()];
    }
}

- (void)lock {
    __locked = YES;
}

- (void)unlock {
    if(__locked) {
        __locked = NO;
        memoryBarrier();
        [_receiver.mailbox unlock];
    }
}

- (BOOL)isLocked {
    return __locked;
}

- (BOOL)completeValue:(CNTry*)value {
    BOOL ret = [super completeValue:value];
    if(ret) {
        __completed = YES;
        __locked = NO;
    }
    return ret;
}

- (ODClassType*)type {
    return [ATActorFuture type];
}

+ (ODClassType*)type {
    return _ATActorFuture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"receiver=%@", self.receiver];
    [description appendFormat:@", prompt=%d", self.prompt];
    [description appendString:@">"];
    return description;
}

@end


