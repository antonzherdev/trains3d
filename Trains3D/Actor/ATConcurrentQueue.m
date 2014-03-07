#import "ATConcurrentQueue.h"

@implementation ATConcurrentQueueNode{
    id _item;
    ATConcurrentQueueNode* _next;
}
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


@implementation ATConcurrentQueue{
    ATConcurrentQueueNode* __head;
    ATConcurrentQueueNode* __tail;
    NSLock* _hLock;
    NSLock* _tLock;
    CNAtomicInt* __count;
}
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
    ATConcurrentQueueNode* node = __head;
    ATConcurrentQueueNode* newHead = node.next;
    if(newHead == nil) {
        [_hLock unlock];
        return [CNOption none];
    }
    id item = newHead.item;
    __head = newHead;
    [__count decrementAndGet];
    [_hLock unlock];
    return [CNOption applyValue:item];
}

- (id)dequeueWhen:(BOOL(^)(id))when {
    [_hLock lock];
    ATConcurrentQueueNode* node = __head;
    ATConcurrentQueueNode* newHead = node.next;
    if(newHead == nil) {
        [_hLock unlock];
        return [CNOption none];
    }
    id item = newHead.item;
    if(when(item)) {
        __head = newHead;
        [__count decrementAndGet];
        [_hLock unlock];
        return [CNOption applyValue:item];
    } else {
        [_hLock unlock];
        return [CNOption none];
    }
}

- (id)peek {
    [_hLock lock];
    ATConcurrentQueueNode* node = __head;
    ATConcurrentQueueNode* newHead = node.next;
    if(newHead == nil) {
        [_hLock unlock];
        return [CNOption none];
    }
    id item = newHead.item;
    [_hLock unlock];
    return [CNOption applyValue:item];
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


