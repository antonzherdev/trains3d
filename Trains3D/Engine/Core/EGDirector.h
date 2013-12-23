#import "objd.h"
#import "GEVec.h"
@class EGTime;
@class EGScene;
@class EGGlobal;
@class EGContext;
@class EGRecognizerType;
@class EGEnablingState;
@class EGMatrixStack;
@class EGStat;
@protocol EGEvent;

@class EGDirector;

@interface EGDirector : NSObject
@property (nonatomic, readonly) EGTime* time;
@property (nonatomic) CGFloat timeSpeed;

+ (id)director;
- (id)init;
- (ODClassType*)type;
+ (EGDirector*)current;
- (id)scene;
- (void)setScene:(EGScene*(^)())scene;
- (void)clearRecognizers;
- (void)registerRecognizerType:(EGRecognizerType*)recognizerType;
- (CGFloat)scale;
- (void)lock;
- (void)unlock;
- (void)redraw;
- (void)_init;
- (GEVec2)viewSize;
- (void)drawWithSize:(GEVec2)size;
- (void)processEvent:(id<EGEvent>)event;
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
+ (CNNotificationHandle*)reshapeNotification;
+ (ODClassType*)type;
@end


