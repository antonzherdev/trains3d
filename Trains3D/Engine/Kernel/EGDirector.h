#import "objd.h"
#import "EGScene.h"
#import "EGTime.h"
#import "EGStat.h"
#import "EGTypes.h"

@interface EGDirector : NSObject
@property (nonatomic, retain) EGScene* scene;
@property (nonatomic, readonly) BOOL started;
@property (nonatomic, readonly) BOOL paused;
@property (nonatomic, readonly) EGTime* time;
@property (nonatomic, readonly) EGStat* stat;
@property (nonatomic) BOOL displayStats;

+ (id)director;
- (id)init;
- (void)drawWithSize:(CGSize)size;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)tick;
@end


