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
+ (EGDirector*)current;
- (id)scene;
- (void)setScene:(EGScene*(^)())scene;
- (void)lock;
- (void)unlock;
- (void)_init;
- (void)drawWithSize:(GEVec2)size;
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


