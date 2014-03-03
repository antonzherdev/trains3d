#import "ATMailbox.h"

#import "ATConcurrentQueue.h"
#import "ATActor.h"
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
    [__queue enqueueItem:message];
    [self schedulePrompt:[message prompt]];
}

- (void)schedulePrompt:(BOOL)prompt {
    if(!([__scheduled getAndSetNewValue:YES])) {
        if(prompt && [__queue count] == 1) [self processQueue];
        else [CNDispatchQueue.aDefault asyncF:^void() {
            [self processQueue];
        }];
    }
}

- (void)processQueue {
    id message = [__queue dequeue];
    if([message isDefined]) {
        [((id<ATActorMessage>)([message get])) process];
        [__scheduled setNewValue:NO];
        memoryBarrier();
        [self schedulePrompt:NO];
    } else {
        [__scheduled setNewValue:NO];
        memoryBarrier();
        if(!([__queue isEmpty])) [self schedulePrompt:NO];
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


