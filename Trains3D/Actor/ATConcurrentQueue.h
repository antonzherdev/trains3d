#import "objd.h"

@class ATConcurrentQueueNode;
@class ATConcurrentQueue;

@interface ATConcurrentQueueNode : NSObject {
@private
    id _item;
    ATConcurrentQueueNode* _next;
}
@property (nonatomic) id item;
@property (nonatomic) ATConcurrentQueueNode* next;

+ (instancetype)concurrentQueueNode;
- (instancetype)init;
- (ODClassType*)type;
+ (ATConcurrentQueueNode*)applyItem:(id)item;
+ (ODClassType*)type;
@end


@interface ATConcurrentQueue : NSObject<CNQueue> {
@private
    ATConcurrentQueueNode* __head;
    ATConcurrentQueueNode* __tail;
    NSLock* _hLock;
    NSLock* _tLock;
    CNAtomicInt* __count;
}
+ (instancetype)concurrentQueue;
- (instancetype)init;
- (ODClassType*)type;
- (int)count;
- (void)enqueueItem:(id)item;
- (id)dequeue;
- (id)dequeueWhen:(BOOL(^)(id))when;
- (void)clear;
- (id)peek;
- (BOOL)isEmpty;
+ (ODClassType*)type;
@end


