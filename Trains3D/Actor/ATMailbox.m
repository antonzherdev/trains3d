#import "ATMailbox.h"

#import "ATAtomicBool.h"
#import "ATActor.h"
#import "ATConcurrentQueue.h"
@implementation ATMailbox{
    ATAtomicBool* __scheduled;
    id<ATActor> __actor;
    ATConcurrentQueue* __queue;
}
static ODClassType* _ATMailbox_type;

+ (id)mailbox {
    return [[ATMailbox alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        __scheduled = [ATAtomicBool atomicBool];
        __actor = nil;
        __queue = [ATConcurrentQueue concurrentQueue];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATMailbox class]) _ATMailbox_type = [ODClassType classTypeWithCls:[ATMailbox class]];
}

- (void)sendMessage:(id<ATActorMessage>)message receiver:(id<ATActor>)receiver {
    [__queue enqueueItem:message];
    __actor = receiver;
    [self schedulePrompt:[message prompt]];
}

- (void)schedulePrompt:(BOOL)prompt {
    if(!([__scheduled getAndSetNewValue:YES])) {
        if(prompt) [self processQueue];
        else [CNDispatchQueue.aDefault asyncF:^void() {
            [self processQueue];
        }];
    }
}

- (void)processQueue {
    id message = [__queue dequeue];
    if([message isDefined]) {
        [__actor processMessage:[message get]];
        [__scheduled setNewValue:NO];
        [self schedulePrompt:NO];
    } else {
        __actor = nil;
        [__scheduled setNewValue:NO];
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


