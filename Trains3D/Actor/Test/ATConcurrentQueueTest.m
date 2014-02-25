#import "ATConcurrentQueueTest.h"
#import "ATConcurrentQueue.h"

@implementation ATConcurrentQueueTest
static ODClassType* _ATConcurrentQueueTest_type;

+ (id)concurrentQueueTest {
    return [[ATConcurrentQueueTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}


- (void)testSerialFillUnfill {
//    int thingsIn = 10000000;
    int thingsIn = 1000000;
    ATConcurrentQueue* queue = [[ATConcurrentQueue alloc] init];
    for (int i = 0; i < thingsIn; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [queue enqueueItem:[NSString stringWithFormat:@"%d", i]];
        });
    }

    NSLog(@"so far, so good.");

    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        __block int thingsOut = 0;
        __block int emptyPollCount = 0;
        while (![queue isEmpty]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if ([queue dequeue] != nil) {
                    OSAtomicIncrement32Barrier(&thingsOut);
                } else {
                    OSAtomicIncrement32Barrier(&emptyPollCount);
                }
            });
        }
        usleep(1000000); //sleep to drain the global queue
        STAssertEquals(thingsOut, thingsIn, @"Number of things");
        NSLog(@"done! out=%d, in=%d, overshot=%d", thingsOut, thingsIn, emptyPollCount);
    });
}

- (void)randomFillUnfill:(double)loadFactor {
    //First, randomly fill/unfill the queue, given some probability of poll/offer
    dispatch_queue_t dispatch_queue = dispatch_queue_create("test-random-fill-unfill-queue", DISPATCH_QUEUE_CONCURRENT);
    int operations = 1000000;
//    int operations = 10000000;
    ATConcurrentQueue* queue = [[ATConcurrentQueue alloc] init];
    __block int thingsIn = 0;
    __block int thingsOut = 0;
    srand((unsigned int) time(NULL));
    for (int i = 0; i < operations; i++) {
        OSMemoryBarrier();
        dispatch_async(dispatch_queue, ^{
            int count = i;
            if (rand() >= (RAND_MAX * loadFactor) && ![queue isEmpty]) {
                if ([queue dequeue] != nil) {
                    OSAtomicIncrement32Barrier(&thingsOut);
                }
            } else {
                [queue enqueueItem:[NSString stringWithFormat:@"%d", i]];
                OSAtomicIncrement32Barrier(&thingsIn);
            }
            if (count % (operations / 10) == 0) {
                NSLog(@"%0.f%% complete (%d of %d)", 100*(double)count / (double)operations, count, operations);
            }
        });
    }
    //Drain the dispatch queue of all async poll/offers
    dispatch_barrier_sync(dispatch_queue, ^{
        NSLog(@"Drain dispatch queue");
        NSLog(@"Estimated remaining elements = %d", thingsIn - thingsOut);
    });
    //Dispatch a bunch of polls until queue reports empty on main thread
    dispatch_async(dispatch_queue, ^{
        while ([queue dequeue] != nil) {
            OSAtomicIncrement32Barrier(&thingsOut);
        }
    });
    //Finally, drain the dispatch queue once again and take score
    dispatch_barrier_sync(dispatch_queue, ^{
        STAssertEquals(thingsOut, thingsIn, @"Number of things");
        if (thingsOut != thingsIn) {
            NSLog(@"Oddly enough, queue says it's got %@", [queue peek]);
        }
        NSLog(@"done! out=%d, in=%d", thingsOut, thingsIn);
    });
//    dispatch_release(dispatch_queue);
}


- (void)testRandomFillUnfill {
    NSLog(@"Starting next test: random fill c=0.25");
    [self randomFillUnfill:0.25];
    NSLog(@"Starting next test: random fill c=0.50");
    [self randomFillUnfill:0.50];
    NSLog(@"Starting next test: random fill c=0.75");
    [self randomFillUnfill:0.75];
}


+ (void)initialize {
    [super initialize];
    if(self == [ATConcurrentQueueTest class]) _ATConcurrentQueueTest_type = [ODClassType classTypeWithCls:[ATConcurrentQueueTest class]];
}

- (ODClassType*)type {
    return [ATConcurrentQueueTest type];
}

+ (ODClassType*)type {
    return _ATConcurrentQueueTest_type;
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


