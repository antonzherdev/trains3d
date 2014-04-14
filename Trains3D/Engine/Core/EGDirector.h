#import "objd.h"
#import "GEVec.h"
@class EGScene;
@class ATVar;
@class ATReact;
@class EGTime;
@class EGStat;
@class ATConcurrentQueue;
@class EGRecognizerType;
@class EGGlobal;
@class EGContext;
@class EGEnablingState;
@protocol EGEvent;
@class SDSoundDirector;

@class EGDirector;

@interface EGDirector : NSObject {
@protected
    EGScene* __scene;
    BOOL __isStarted;
    ATVar* __isPaused;
    ATReact* _isPaused;
    EGScene*(^__lazyScene)();
    EGTime* _time;
    GEVec2 __lastViewSize;
    CGFloat __timeSpeed;
    CNFuture* __updateFuture;
    EGStat* __stat;
    ATConcurrentQueue* __defers;
}
@property (nonatomic, readonly) ATReact* isPaused;
@property (nonatomic, readonly) EGTime* time;

+ (instancetype)director;
- (instancetype)init;
- (ODClassType*)type;
+ (EGDirector*)current;
- (EGScene*)scene;
- (void)setScene:(EGScene*(^)())scene;
- (void)clearRecognizers;
- (void)registerRecognizerType:(EGRecognizerType*)recognizerType;
- (CGFloat)scale;
- (void)lock;
- (void)unlock;
- (void)redraw;
- (void)_init;
- (GEVec2)viewSize;
- (void)reshapeWithSize:(GEVec2)size;
- (void)drawFrame;
- (void)processFrame;
- (void)prepare;
- (void)draw;
- (void)complete;
- (void)processEvent:(id<EGEvent>)event;
- (BOOL)isStarted;
- (void)start;
- (void)stop;
- (void)pause;
- (void)becomeActive;
- (void)resignActive;
- (void)resume;
- (CGFloat)timeSpeed;
- (void)setTimeSpeed:(CGFloat)timeSpeed;
- (void)tick;
- (EGStat*)stat;
- (BOOL)isDisplayingStats;
- (void)displayStats;
- (void)cancelDisplayingStats;
- (void)onGLThreadF:(void(^)())f;
+ (CNNotificationHandle*)reshapeNotification;
+ (ODClassType*)type;
@end


