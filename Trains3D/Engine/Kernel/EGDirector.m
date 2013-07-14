#import "EGDirector.h"

#import "EGScene.h"
#import "EGTime.h"
#import "EGStat.h"
#import "EGGL.h"
#import "EGContext.h"
#import "EGProcessor.h"
@implementation EGDirector{
    EGScene* _scene;
    BOOL __isStarted;
    BOOL __isPaused;
    EGTime* _time;
    EGContext* _context;
    EGStat* __stat;
}
static EGDirector* _current;
@synthesize scene = _scene;
@synthesize time = _time;
@synthesize context = _context;

+ (id)director {
    return [[EGDirector alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        __isStarted = NO;
        __isPaused = NO;
        _time = [EGTime time];
        _current = self;
        _context = [EGContext context];
        __stat = [CNOption none];
    }
    
    return self;
}

- (void)drawWithSize:(EGSize)size {
    egClear();
    glEnable(GL_DEPTH_TEST);
    [_scene drawWithViewSize:size];
    glDisable(GL_DEPTH_TEST);
    [__stat forEach:^void(EGStat* _) {
        [_ draw];
    }];
}

- (void)processEvent:(EGEvent*)event {
    [_scene processEvent:event];
}

- (BOOL)isStarted {
    return __isStarted;
}

- (void)start {
    __isStarted = YES;
    [_time start];
}

- (void)stop {
    __isStarted = NO;
}

- (BOOL)isPaused {
    return __isPaused;
}

- (void)pause {
    __isPaused = YES;
}

- (void)resume {
    if(__isPaused) {
        __isPaused = NO;
        [_time start];
    }
}

- (void)tick {
    [_time tick];
    [_scene updateWithDelta:_time.delta];
    [__stat forEach:^void(EGStat* _) {
        [_ tickWithDelta:_time.delta];
    }];
}

- (EGStat*)stat {
    return __stat;
}

- (BOOL)isDisplayingStats {
    return [__stat isDefined];
}

- (void)displayStats {
    __stat = [CNOption opt:[EGStat stat]];
}

- (void)cancelDisplayingStats {
    __stat = [CNOption none];
}

+ (EGDirector*)current {
    return _current;
}

@end


