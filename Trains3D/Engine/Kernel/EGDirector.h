#import "objd.h"
#import "EGVec.h"
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
- (void)drawWithSize:(EGVec2)size;
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


