#import "objd.h"

@class ATConcurrentQueueNode;
@class ATConcurrentQueue;

@interface ATConcurrentQueueNode : NSObject
@property (nonatomic, retain) id item;
@property (nonatomic, retain) ATConcurrentQueueNode* next;

+ (instancetype)concurrentQueueNode;
- (instancetype)init;
- (ODClassType*)type;
+ (ATConcurrentQueueNode*)applyItem:(id)item;
+ (ODClassType*)type;
@end


@interface ATConcurrentQueue : NSObject<CNQueue>
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


