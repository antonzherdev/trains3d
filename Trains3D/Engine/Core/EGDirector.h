#import "objd.h"
#import "GEVec.h"
@class EGTime;
@class ATConcurrentQueue;
@class EGScene;
@class EGRecognizerType;
@class EGGlobal;
@class EGContext;
@class ATVar;
@class EGEnablingState;
@class EGStat;
@protocol EGEvent;
@class SDSoundDirector;

@class EGDirector;

@interface EGDirector : NSObject {
@private
    id __scene;
    BOOL __isStarted;
    BOOL __isPaused;
    id __lazyScene;
    EGTime* _time;
    GEVec2 __lastViewSize;
    CGFloat __timeSpeed;
    id __stat;
    ATConcurrentQueue* __defers;
}
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
- (void)prepare;
- (void)draw;
- (void)processEvent:(id<EGEvent>)event;
- (BOOL)isStarted;
- (void)start;
- (void)stop;
- (BOOL)isPaused;
- (void)pause;
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


