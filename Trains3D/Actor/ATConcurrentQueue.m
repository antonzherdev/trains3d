#import "ATConcurrentQueue.h"

@implementation ATConcurrentQueueNode
static ODClassType* _ATConcurrentQueueNode_type;
@synthesize item = _item;
@synthesize next = _next;

+ (instancetype)concurrentQueueNode {
    return [[ATConcurrentQueueNode alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATConcurrentQueueNode class]) _ATConcurrentQueueNode_type = [ODClassType classTypeWithCls:[ATConcurrentQueueNode class]];
}

+ (ATConcurrentQueueNode*)applyItem:(id)item {
    ATConcurrentQueueNode* ret = [ATConcurrentQueueNode concurrentQueueNode];
    ret.item = item;
    return ret;
}

- (ODClassType*)type {
    return [ATConcurrentQueueNode type];
}

+ (ODClassType*)type {
    return _ATConcurrentQueueNode_type;
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


@implementation ATConcurrentQueue
static ODClassType* _ATConcurrentQueue_type;

+ (instancetype)concurrentQueue {
    return [[ATConcurrentQueue alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __head = [ATConcurrentQueueNode concurrentQueueNode];
        __tail = __head;
        _hLock = [NSLock lock];
        _tLock = [NSLock lock];
        __count = [CNAtomicInt atomicInt];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATConcurrentQueue class]) _ATConcurrentQueue_type = [ODClassType classTypeWithCls:[ATConcurrentQueue class]];
}

- (int)count {
    return [__count intValue];
}

- (void)enqueueItem:(id)item {
    ATConcurrentQueueNode* node = [ATConcurrentQueueNode applyItem:item];
    [_tLock lock];
    __tail.next = node;
    __tail = node;
    [__count incrementAndGet];
    [_tLock unlock];
}

- (id)dequeue {
    [_hLock lock];
    id ret;
    {
        ATConcurrentQueueNode* newHead = __head.next;
        if(newHead != nil) {
            id item = newHead.item;
            newHead.item = nil;
            __head = newHead;
            [__count decrementAndGet];
            ret = item;
        } else {
            ret = nil;
        }
    }
    [_hLock unlock];
    return ret;
}

- (id)dequeueWhen:(BOOL(^)(id))when {
    [_hLock lock];
    id ret;
    {
        ATConcurrentQueueNode* newHead = __head.next;
        if(newHead != nil) {
            id item = newHead.item;
            if(when(((id)(item)))) {
                newHead.item = nil;
                __head = newHead;
                [__count decrementAndGet];
                ret = item;
            } else {
                ret = nil;
            }
        } else {
            ret = nil;
        }
    }
    [_hLock unlock];
    return ret;
}

- (void)clear {
    [_hLock lock];
    __head = __tail;
    __head.item = nil;
    [__count setNewValue:0];
    [_hLock unlock];
}

- (id)peek {
    [_hLock lock];
    ATConcurrentQueueNode* node = __head;
    ATConcurrentQueueNode* newHead = node.next;
    if(newHead == nil) {
        [_hLock unlock];
        return nil;
    }
    id item = ((ATConcurrentQueueNode*)(newHead)).item;
    [_hLock unlock];
    return item;
}

- (BOOL)isEmpty {
    return [__count intValue] == 0;
}

- (ODClassType*)type {
    return [ATConcurrentQueue type];
}

+ (ODClassType*)type {
    return _ATConcurrentQueue_type;
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


