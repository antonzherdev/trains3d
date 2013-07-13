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
@property (nonatomic, readonly) BOOL started;
@property (nonatomic, readonly) BOOL paused;
@property (nonatomic, readonly) EGTime* time;
@property (nonatomic, readonly) EGContext* context;
@property (nonatomic, readonly) EGStat* stat;
@property (nonatomic) BOOL displayStats;

+ (id)director;
- (id)init;
- (void)drawWithSize:(EGSize)size;
- (void)processEvent:(EGEvent*)event;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)tick;
+ (EGDirector*)current;
@end


