#import "objd.h"
#import "GEVec.h"
@class EGScene;
@class EGTime;
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGStat;
@class EGEvent;

@class EGDirector;

@interface EGDirector : NSObject
@property (nonatomic, retain) EGScene* scene;
@property (nonatomic, readonly) EGTime* time;

+ (id)director;
- (id)init;
- (ODClassType*)type;
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
+ (ODType*)type;
@end


