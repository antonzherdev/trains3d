#import "objd.h"
#import "GEVec.h"
@class EGTime;
@class EGScene;
@class EGGlobal;
@class EGContext;
@class EGEnablingState;
@class EGMatrixStack;
@class EGStat;
@class EGEvent;

@class EGDirector;

@interface EGDirector : NSObject
@property (nonatomic, readonly) EGTime* time;

+ (id)director;
- (id)init;
- (ODClassType*)type;
- (id)scene;
- (void)setScene:(EGScene*)scene;
- (void)lock;
- (void)unlock;
- (void)drawWithSize:(GEVec2)size;
- (void)beforeDraw;
- (void)processEvent:(EGEvent*)event;
- (BOOL)isStarted;
- (void)start;
- (void)stop;
- (BOOL)isPaused;
- (void)pause;
- (void)resume;
- (void)tick;
- (id)stat;
- (BOOL)isDisplayingStats;
- (void)displayStats;
- (void)cancelDisplayingStats;
+ (ODClassType*)type;
@end


