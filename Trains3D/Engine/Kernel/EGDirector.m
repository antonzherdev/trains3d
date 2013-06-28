#import "EGDirector.h"

@implementation EGDirector{
    EGScene* _scene;
    BOOL _started;
    BOOL _paused;
    EGTime* _time;
    EGStat* _stat;
}
@synthesize scene = _scene;
@synthesize started = _started;
@synthesize paused = _paused;
@synthesize time = _time;
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
    }
    
    return self;
}

- (void)drawWithSize:(CGSize)size {
    egClear();
    [_scene drawWithViewSize:size];
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

@end


