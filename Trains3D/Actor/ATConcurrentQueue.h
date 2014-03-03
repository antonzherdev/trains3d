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
- (NSInteger)count;
- (void)enqueueItem:(id)item;
- (id)dequeue;
- (id)peek;
- (BOOL)isEmpty;
+ (ODClassType*)type;
@end


