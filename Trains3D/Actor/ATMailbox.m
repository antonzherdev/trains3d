#import "ATMailbox.h"

#import "ATConcurrentQueue.h"
#import "ATActor.h"
#import "ATTypedActor.h"
@implementation ATMailbox{
    CNAtomicBool* __scheduled;
    ATConcurrentQueue* __queue;
}
static ODClassType* _ATMailbox_type;

+ (instancetype)mailbox {
    return [[ATMailbox alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __scheduled = [CNAtomicBool atomicBool];
        __queue = [ATConcurrentQueue concurrentQueue];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATMailbox class]) _ATMailbox_type = [ODClassType classTypeWithCls:[ATMailbox class]];
}

- (void)sendMessage:(id<ATActorMessage>)message {
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
    [CNDispatchQueue.aDefault asyncF:^void() {
        autoreleasePoolStart();
        [self processQueue];
        autoreleasePoolEnd();
    }];
}

- (void)processQueue {
    NSInteger left = 5;
    while(left > 0) {
        id message = [__queue dequeue];
        if([message isDefined]) [((id<ATActorMessage>)([message get])) process];
        else break;
        left--;
    }
    if([__queue isEmpty]) {
        [__scheduled setNewValue:NO];
        memoryBarrier();
        if(!([__queue isEmpty])) [self trySchedule];
    } else {
        [self schedule];
    }
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
    return self.receiver == o.receiver && [self.f isEqual:o.f] && self.prompt == o.prompt;
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


