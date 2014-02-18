#import "objdcore.h"
#import "ODObject.h"
#import "CNCollection.h"
@class ODClassType;
@class CNList;
@class CNOption;

@class CNImQueue;
@class CNQueueIterator;
@class CNMQueue;
@protocol CNQueue;

@protocol CNQueue<NSObject>
@end


@interface CNImQueue : NSObject<CNQueue>
@property (nonatomic, readonly) CNList* in;
@property (nonatomic, readonly) CNList* out;

+ (id)imQueueWithIn:(CNList*)in out:(CNList*)out;
- (id)initWithIn:(CNList*)in out:(CNList*)out;
- (ODClassType*)type;
+ (CNImQueue*)apply;
- (id<CNIterator>)iterator;
- (BOOL)isEmpty;
- (NSUInteger)count;
- (CNImQueue*)addItem:(id)item;
- (CNImQueue*)enqueueItem:(id)item;
- (CNTuple*)dequeue;
+ (ODClassType*)type;
@end


@interface CNQueueIterator : NSObject<CNIterator>
@property (nonatomic, readonly) CNList* in;
@property (nonatomic, readonly) CNList* out;

+ (id)queueIteratorWithIn:(CNList*)in out:(CNList*)out;
- (id)initWithIn:(CNList*)in out:(CNList*)out;
- (ODClassType*)type;
- (BOOL)hasNext;
- (id)next;
+ (ODClassType*)type;
@end


@interface CNMQueue : NSObject<CNQueue>
+ (id)queue;
- (id)init;
- (ODClassType*)type;
- (void)enqueueItem:(id)item;
- (id)dequeue;
- (NSUInteger)count;
+ (ODClassType*)type;
@end


