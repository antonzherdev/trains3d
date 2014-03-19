#import "objd.h"
#import "GEVec.h"
@class ATVar;
@class ATReact;
@class EGTime;
@class ATConcurrentQueue;
@class EGScene;
@class EGRecognizerType;
@class EGGlobal;
@class EGContext;
@class EGEnablingState;
@class EGStat;
@protocol EGEvent;
@class SDSoundDirector;

@class EGDirector;

@interface EGDirector : NSObject {
@private
    id __scene;
    BOOL __isStarted;
    ATVar* __isPaused;
    ATReact* _isPaused;
    id __lazyScene;
    EGTime* _time;
    GEVec2 __lastViewSize;
    CGFloat __timeSpeed;
    CNFuture* __updateFuture;
    id __stat;
    ATConcurrentQueue* __defers;
}
@property (nonatomic, readonly) ATReact* isPaused;
@property (nonatomic, readonly) EGTime* time;

+ (instancetype)director;
- (instancetype)init;
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
- (id)stat;
- (BOOL)isDisplayingStats;
- (void)displayStats;
- (void)cancelDisplayingStats;
- (void)onGLThreadF:(void(^)())f;
+ (CNNotificationHandle*)reshapeNotification;
+ (ODClassType*)type;
@end


