#import "ATMailbox.h"

#import "ATAtomicBool.h"
#import "ATActor.h"
#import "ATConcurrentQueue.h"
#import "ATFuture.h"
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

- (void)sendMessage:(ATMessage*)message receiver:(id<ATActor>)receiver {
    [__queue enqueueItem:message];
    __actor = receiver;
    [self scheduleSync:message.sync];
}

- (void)scheduleSync:(BOOL)sync {
    if(!([__scheduled getAndSetNewValue:YES])) {
        if(sync) [self processQueue];
        else [CNDispatchQueue.aDefault asyncF:^void() {
            [self processQueue];
        }];
    }
}

- (void)processQueue {
    id message = [__queue dequeue];
    if([message isDefined]) {
        [__actor processMessage:[message get]];
        if([__queue isEmpty]) __actor = nil;
        else [self scheduleSync:NO];
    } else {
        __actor = nil;
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


@implementation ATMessage{
    id<ATActor> _sender;
    id _message;
    ATPromise* _result;
    BOOL _sync;
}
static ODClassType* _ATMessage_type;
@synthesize sender = _sender;
@synthesize message = _message;
@synthesize result = _result;
@synthesize sync = _sync;

+ (id)messageWithSender:(id<ATActor>)sender message:(id)message result:(ATPromise*)result sync:(BOOL)sync {
    return [[ATMessage alloc] initWithSender:sender message:message result:result sync:sync];
}

- (id)initWithSender:(id<ATActor>)sender message:(id)message result:(ATPromise*)result sync:(BOOL)sync {
    self = [super init];
    if(self) {
        _sender = sender;
        _message = message;
        _result = result;
        _sync = sync;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATMessage class]) _ATMessage_type = [ODClassType classTypeWithCls:[ATMessage class]];
}

- (ODClassType*)type {
    return [ATMessage type];
}

+ (ODClassType*)type {
    return _ATMessage_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    ATMessage* o = ((ATMessage*)(other));
    return [self.sender isEqual:o.sender] && [self.message isEqual:o.message] && self.result == o.result && self.sync == o.sync;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.sender hash];
    hash = hash * 31 + [self.message hash];
    hash = hash * 31 + [self.result hash];
    hash = hash * 31 + self.sync;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"sender=%@", self.sender];
    [description appendFormat:@", message=%@", self.message];
    [description appendFormat:@", result=%@", self.result];
    [description appendFormat:@", sync=%d", self.sync];
    [description appendString:@">"];
    return description;
}

@end


