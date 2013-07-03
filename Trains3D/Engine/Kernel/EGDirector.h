#import "objd.h"
#import "EGScene.h"
#import "EGTime.h"
#import "EGStat.h"
#import "EGTypes.h"
#import "EGGL.h"
#import "EGContext.h"
#import "EGProcessor.h"

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
- (void)drawWithSize:(CGSize)size;
- (void)processEvent:(EGEvent*)event;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)tick;
+ (EGDirector*)current;
@end


