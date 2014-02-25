#import "ATConcurrentQueue.h"

@implementation ATConcurrentQueueNode{
    id _item;
    ATConcurrentQueueNode* _next;
}
static ODClassType* _ATConcurrentQueueNode_type;
@synthesize item = _item;
@synthesize next = _next;

+ (id)concurrentQueueNode {
    return [[ATConcurrentQueueNode alloc] init];
}

- (id)init {
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
}
static ODClassType* _ATConcurrentQueue_type;

+ (id)concurrentQueue {
    return [[ATConcurrentQueue alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        __head = [ATConcurrentQueueNode concurrentQueueNode];
        __tail = __head;
        _hLock = [NSLock lock];
        _tLock = [NSLock lock];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATConcurrentQueue class]) _ATConcurrentQueue_type = [ODClassType classTypeWithCls:[ATConcurrentQueue class]];
}

- (void)enqueueItem:(id)item {
    ATConcurrentQueueNode* node = [ATConcurrentQueueNode applyItem:item];
    [_tLock lock];
    __tail.next = node;
    __tail = node;
    [_tLock unlock];
}

- (id)dequeue {
    [_hLock lock];
    ATConcurrentQueueNode* node = __head;
    ATConcurrentQueueNode* newHead = node.next;
    if(newHead == nil) {
        [_hLock unlock];
        return nil;
    }
    id item = node.item;
    __head = newHead;
    [_hLock unlock];
    return [CNOption applyValue:item];
}

- (id)peek {
    [_hLock lock];
    ATConcurrentQueueNode* node = __head;
    ATConcurrentQueueNode* newHead = node.next;
    if(newHead == nil) {
        [_hLock unlock];
        return nil;
    }
    id item = node.item;
    [_hLock unlock];
    return [CNOption applyValue:item];
}

- (BOOL)isEmpty {
    [_hLock lock];
    BOOL ret = __head.next == nil;
    [_hLock unlock];
    return ret;
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


