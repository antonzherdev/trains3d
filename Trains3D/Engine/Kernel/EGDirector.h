#import "objd.h"
@class EGScene;
@class EGTime;
@class EGStat;
#import "EGTypes.h"
@class EGContext;
@class EGProcessor;
@class EGMouseProcessor;
@class EGTouchProcessor;
@class EGEvent;

@class EGDirector;

@interface EGDirector : NSObject
@property (nonatomic, retain) EGScene* scene;
@property (nonatomic, readonly) EGTime* time;
@property (nonatomic, readonly) EGContext* context;

+ (id)director;
- (id)init;
- (void)drawWithSize:(EGSize)size;
- (void)processEvent:(EGEvent*)event;
- (BOOL)isStarted;
- (void)start;
- (void)stop;
- (BOOL)isPaused;
- (void)pause;
- (void)resume;
- (void)tick;
- (EGStat*)stat;
- (BOOL)isDisplayingStats;
- (void)displayStats;
- (void)cancelDisplayingStats;
+ (EGDirector*)current;
@end


