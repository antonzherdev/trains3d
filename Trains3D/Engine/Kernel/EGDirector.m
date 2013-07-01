#import "EGDirector.h"

@implementation EGDirector{
    EGScene* _scene;
    BOOL _started;
    BOOL _paused;
    EGTime* _time;
    EGContext* _context;
    EGStat* _stat;
}
static EGDirector* _current;
@synthesize scene = _scene;
@synthesize started = _started;
@synthesize paused = _paused;
@synthesize time = _time;
@synthesize context = _context;
@synthesize stat = _stat;

+ (id)director {
    return [[EGDirector alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _started = NO;
        _paused = NO;
        _time = [EGTime time];
        _current = self;
        _context = [EGContext context];
    }
    
    return self;
}

- (void)drawWithSize:(CGSize)size {
    egClear();
    glEnable(GL_DEPTH_TEST);
    [_scene drawWithViewSize:size];
    glDisable(GL_DEPTH_TEST);
    [_stat draw];
}

- (void)start {
    _started = YES;
    [_time start];
}

- (void)stop {
    _started = NO;
}

- (void)pause {
    _paused = YES;
}

- (void)resume {
    if(_paused) {
        _paused = NO;
        [_time start];
    }
}

- (void)tick {
    [_time tick];
    [_stat tickWithDelta:_time.delta];
}

- (BOOL)displayStats {
    return _stat == nil;
}

- (void)setDisplayStats:(BOOL)displayStats {
    _stat = displayStats ? [EGStat stat] : nil;
}

+ (EGDirector*)current {
    return _current;
}

@end


