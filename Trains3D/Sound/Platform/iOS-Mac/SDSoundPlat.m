#import "SDSoundPlat.h"
#import "SDSoundDirector.h"

@implementation SDSimpleSoundPlat {
    AVAudioPlayer* _player;
    BOOL _enabled;
    double _startedAt;
    BOOL _needResume;
    BOOL _wasPaused;
    BOOL _played;
    CNNotificationObserver *_observer;
    CNNotificationObserver *_observer2;
}
static ODClassType* _SDSound_type;
static NSOperationQueue * _queue;

+ (id)sound {
    return [[SDSimpleSoundPlat alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        @throw @"Unsupported";
    }
    
    return self;
}

- (id)initWithPlayer:(AVAudioPlayer *)player {
    self = [super init];
    if (self) {
        _player = player;
        _wasPaused = YES;
        _player.enableRate = YES;
        _enabled = SDSoundDirector.instance.enabled;
        _player.rate = (float) SDSoundDirector.instance.timeSpeed;
        __weak SDSimpleSoundPlat *ws = self;
        _observer = [SDSoundDirector.instance.enabledChangedNotification observeBy:^(id sender, id en) {
            ws.enabled = unumb(en);
        }];
        _observer2 = [SDSoundDirector.instance.timeSpeedChangeNotification observeBy:^(id sender, id sp) {
            ws.rate = (float) unumf(sp);
        }];
        _needResume = NO;

        [player prepareToPlay];
        [player pause];
    }

    return self;
}

- (void)setRate:(float)rate {
    _player.rate = rate;
}

- (void)setEnabled:(BOOL)enabled {
    if(_enabled != enabled) {
        _enabled = enabled;
        if(!_enabled) {
            _played = NO;
            if(_player.isPlaying) {
                _wasPaused = NO;
                [_player pause];
                [self fixStart];
            } else {
                _wasPaused = YES;
            }
        } else {
            [self updateCurrentTime];
            if(!_wasPaused && !_played) [self play];
        }
    }
}

+ (id)soundWithPlayer:(AVAudioPlayer *)player {
    return [[self alloc] initWithPlayer:player];
}


+ (void)initialize {
    [super initialize];
    _queue = [[NSOperationQueue alloc] init];
    _queue.maxConcurrentOperationCount = 1;
    #if TARGET_OS_IPHONE
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&error];
    if(error != nil) NSLog(@"%@", error);
    #endif
    _SDSound_type = [ODClassType classTypeWithCls:[SDSimpleSoundPlat class]];
}

+ (SDSimpleSoundPlat *)simpleSoundPlatWithFile:(NSString*)file {
    NSError * error;
    NSURL *url = [NSURL fileURLWithPath:[OSBundle fileNameForResource:file]];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if(error != nil) @throw [error description];
    return [SDSimpleSoundPlat soundWithPlayer:player];
}

- (BOOL)isPlaying {
    return [_player isPlaying];
}

- (CGFloat)duration {
    return _player.duration;
}

- (void)play {
    if(_enabled) {
        [_queue addOperation:[[NSInvocationOperation alloc] initWithTarget:_player selector:@selector(play) object:nil]];
    } else {
        [self fixStart];
        _wasPaused = NO;
    }
}

- (void)fixStart {
    _startedAt = clock() / CLOCKS_PER_SEC;
}

- (void)playLoops:(NSUInteger)loops {
    _player.numberOfLoops = loops - 1;
    [self play];
}

- (void)playAlways {
    _player.numberOfLoops = -1;
    [self play];
}

- (void)pause {
    if(_player.isPlaying) {
        _needResume = YES;
        if(_enabled) [_queue addOperation:[[NSInvocationOperation alloc] initWithTarget:_player selector:@selector(pause) object:nil]];
        else {
            [self updateCurrentTime];
            _wasPaused = YES;
        }
    }
}

- (void)resume {
    if(_needResume) {
        _needResume = NO;
        if(_enabled) [_queue addOperation:[[NSInvocationOperation alloc] initWithTarget:_player selector:@selector(play) object:nil]];
        else {
            [self fixStart];
            _wasPaused = NO;
        }

    }
}


- (void)updateCurrentTime {
    if(_wasPaused || _played) return;

    NSTimeInterval time = _player.currentTime + (clock() / CLOCKS_PER_SEC) - _startedAt;
    if(time > _player.duration) {
        long cycles = (long)(time/_player.duration);
        if(_player.numberOfLoops == -1) {
            _player.currentTime = time - (_player.duration * cycles);
        } else if(_player.numberOfLoops >= cycles) {
            _player.numberOfLoops -= cycles;
            _player.currentTime = time - (_player.duration * cycles);
        } else {
            _player.numberOfLoops = 0;
            _player.currentTime = 0;
            _played = YES;
        }
    }
}

- (void)stop {
    if(_enabled) {
        [_queue addOperation:[[NSInvocationOperation alloc] initWithTarget:_player selector:@selector(pause) object:nil]];
        _player.currentTime = 0;
    } else {
        _player.currentTime = 0;
        _wasPaused = YES;
    }
}

- (float)pan {
    return _player.pan;
}

- (void)setPan:(float)pan {
    _player.pan = pan;
}

- (float)volume {
    return _player.volume;
}

- (void)setVolume:(float)volume {
    _player.volume = volume;
}

- (CGFloat)time {
    return _player.currentTime;
}

- (void)setTime:(CGFloat)time {
    _player.currentTime = time;
}


- (ODClassType*)type {
    return [SDSimpleSoundPlat type];
}

+ (ODClassType*)type {
    return _SDSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}


@end


