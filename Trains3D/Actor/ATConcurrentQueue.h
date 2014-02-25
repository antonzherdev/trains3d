#import "objd.h"

@class ATConcurrentQueueNode;
@class ATConcurrentQueue;

@interface ATConcurrentQueueNode : NSObject
@property (nonatomic, retain) id item;
@property (nonatomic, retain) ATConcurrentQueueNode* next;

+ (id)concurrentQueueNode;
- (id)init;
- (ODClassType*)type;
+ (ATConcurrentQueueNode*)applyItem:(id)item;
+ (ODClassType*)type;
@end


@interface ATConcurrentQueue : NSObject<CNQueue>
+ (id)concurrentQueue;
- (id)init;
- (ODClassType*)type;
- (void)enqueueItem:(id)item;
- (id)dequeue;
- (id)peek;
- (BOOL)isEmpty;
+ (ODClassType*)type;
@end


