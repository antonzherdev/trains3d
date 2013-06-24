#import "EGDirector.h"

@implementation EGDirector{
    EGScene* _scene;
    BOOL _started;
    BOOL _paused;
    EGTime* _time;
    CGSize _lastSize;
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

- (void)draw {
    [_scene draw];
    [_stat draw];
}

- (void)reshapeWithSize:(CGSize)size {
    [_scene reshapeWithSize:size];
    _lastSize = size;
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

- (void)setScene:(EGScene*)scene {
    _scene = scene;
    [scene reshapeWithSize:_lastSize];
}

- (BOOL)displayStats {
    return _stat == nil;
}

- (void)setDisplayStats:(BOOL)displayStats {
    _stat = displayStats ? [EGStat stat] : nil;
}

@end


