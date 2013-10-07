#import "SDSound.h"

@implementation SDSound{
    AVAudioPlayer* _player;
}
static ODClassType* _SDSound_type;

+ (id)sound {
    return [[SDSound alloc] init];
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
        [player prepareToPlay];
        [player pause];
    }

    return self;
}

+ (id)soundWithPlayer:(AVAudioPlayer *)player {
    return [[self alloc] initWithPlayer:player];
}


+ (void)initialize {
    [super initialize];
    _SDSound_type = [ODClassType classTypeWithCls:[SDSound class]];
}

+ (SDSound*)applyFile:(NSString*)file {
    NSError * error;
    NSURL *url = [NSURL fileURLWithPath:[CNBundle fileNameForResource:file]];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if(error != nil) @throw [error description];
    return [SDSound soundWithPlayer:player];
}

- (BOOL)isPlaying {
    return [_player isPlaying];
}

- (CGFloat)duration {
    return _player.duration;
}

- (void)play {
    [_player play];
}

- (void)playLoops:(NSUInteger)loops {
    _player.numberOfLoops = loops - 1;
    [_player play];
}

- (void)playAlways {
    _player.numberOfLoops = -1;
    [_player play];
}

- (void)pause {
    [_player pause];
}

- (void)stop {
    [_player pause];
    _player.currentTime = 0;
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
    return [SDSound type];
}

+ (ODClassType*)type {
    return _SDSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

+ (SDSound *)applyFile:(NSString *)string volume:(float)volume {
    SDSound *sound = [SDSound applyFile:string];
    sound.volume = volume;
    return sound;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


