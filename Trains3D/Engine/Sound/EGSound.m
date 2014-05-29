#import "EGSound.h"

#import "SDSound.h"
#import "CNObserver.h"
@implementation EGSoundPlayer_impl

+ (instancetype)soundPlayer_impl {
    return [[EGSoundPlayer_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (void)start {
}

- (void)stop {
}

- (void)pause {
}

- (void)resume {
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGBackgroundSoundPlayer
static CNClassType* _EGBackgroundSoundPlayer_type;
@synthesize sound = _sound;

+ (instancetype)backgroundSoundPlayerWithSound:(SDSimpleSound*)sound {
    return [[EGBackgroundSoundPlayer alloc] initWithSound:sound];
}

- (instancetype)initWithSound:(SDSimpleSound*)sound {
    self = [super init];
    if(self) _sound = sound;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBackgroundSoundPlayer class]) _EGBackgroundSoundPlayer_type = [CNClassType classTypeWithCls:[EGBackgroundSoundPlayer class]];
}

- (void)start {
    [_sound playAlways];
}

- (void)stop {
    [_sound stop];
}

- (void)pause {
    [_sound pause];
}

- (void)resume {
    [_sound resume];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BackgroundSoundPlayer(%@)", _sound];
}

- (CNClassType*)type {
    return [EGBackgroundSoundPlayer type];
}

+ (CNClassType*)type {
    return _EGBackgroundSoundPlayer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGSoundPlayersCollection
static CNClassType* _EGSoundPlayersCollection_type;
@synthesize players = _players;

+ (instancetype)soundPlayersCollectionWithPlayers:(NSArray*)players {
    return [[EGSoundPlayersCollection alloc] initWithPlayers:players];
}

- (instancetype)initWithPlayers:(NSArray*)players {
    self = [super init];
    if(self) _players = players;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSoundPlayersCollection class]) _EGSoundPlayersCollection_type = [CNClassType classTypeWithCls:[EGSoundPlayersCollection class]];
}

- (void)start {
    for(id<EGSoundPlayer> _ in _players) {
        [((id<EGSoundPlayer>)(_)) start];
    }
}

- (void)stop {
    for(id<EGSoundPlayer> _ in _players) {
        [((id<EGSoundPlayer>)(_)) stop];
    }
}

- (void)pause {
    for(id<EGSoundPlayer> _ in _players) {
        [((id<EGSoundPlayer>)(_)) pause];
    }
}

- (void)resume {
    for(id<EGSoundPlayer> _ in _players) {
        [((id<EGSoundPlayer>)(_)) resume];
    }
}

- (void)updateWithDelta:(CGFloat)delta {
    for(id<EGSoundPlayer> _ in _players) {
        [((id<EGSoundPlayer>)(_)) updateWithDelta:delta];
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SoundPlayersCollection(%@)", _players];
}

- (CNClassType*)type {
    return [EGSoundPlayersCollection type];
}

+ (CNClassType*)type {
    return _EGSoundPlayersCollection_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGSporadicSoundPlayer
static CNClassType* _EGSporadicSoundPlayer_type;
@synthesize sound = _sound;
@synthesize secondsBetween = _secondsBetween;

+ (instancetype)sporadicSoundPlayerWithSound:(SDSound*)sound secondsBetween:(CGFloat)secondsBetween {
    return [[EGSporadicSoundPlayer alloc] initWithSound:sound secondsBetween:secondsBetween];
}

- (instancetype)initWithSound:(SDSound*)sound secondsBetween:(CGFloat)secondsBetween {
    self = [super init];
    if(self) {
        _sound = sound;
        _secondsBetween = secondsBetween;
        __timeToNextPlaying = 0.0;
        _wasPlaying = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSporadicSoundPlayer class]) _EGSporadicSoundPlayer_type = [CNClassType classTypeWithCls:[EGSporadicSoundPlayer class]];
}

- (void)start {
    __timeToNextPlaying = cnFloatRndMinMax(0.0, _secondsBetween * 2);
}

- (void)stop {
    [_sound stop];
}

- (void)pause {
    [_sound pause];
}

- (void)resume {
    [_sound resume];
}

- (void)updateWithDelta:(CGFloat)delta {
    if(!([_sound isPlaying])) {
        __timeToNextPlaying -= delta;
        if(__timeToNextPlaying <= 0) {
            [_sound play];
            __timeToNextPlaying = cnFloatRndMinMax(0.0, _secondsBetween * 2);
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SporadicSoundPlayer(%@, %f)", _sound, _secondsBetween];
}

- (CNClassType*)type {
    return [EGSporadicSoundPlayer type];
}

+ (CNClassType*)type {
    return _EGSporadicSoundPlayer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGSignalSoundPlayer
static CNClassType* _EGSignalSoundPlayer_type;
@synthesize sound = _sound;
@synthesize signal = _signal;
@synthesize condition = _condition;

+ (instancetype)signalSoundPlayerWithSound:(SDSound*)sound signal:(id<CNObservableBase>)signal condition:(BOOL(^)(id))condition {
    return [[EGSignalSoundPlayer alloc] initWithSound:sound signal:signal condition:condition];
}

- (instancetype)initWithSound:(SDSound*)sound signal:(id<CNObservableBase>)signal condition:(BOOL(^)(id))condition {
    self = [super init];
    if(self) {
        _sound = sound;
        _signal = signal;
        _condition = [condition copy];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSignalSoundPlayer class]) _EGSignalSoundPlayer_type = [CNClassType classTypeWithCls:[EGSignalSoundPlayer class]];
}

- (void)start {
    __weak EGSignalSoundPlayer* _weakSelf = self;
    _obs = [_signal observeF:^void(id data) {
        EGSignalSoundPlayer* _self = _weakSelf;
        if(_self != nil) {
            if(_self->_condition(data)) [_self->_sound play];
        }
    }];
}

- (void)stop {
    [((CNObserver*)(_obs)) detach];
    _obs = nil;
    [_sound stop];
}

- (void)pause {
    [_sound pause];
}

- (void)resume {
    [_sound resume];
}

+ (EGSignalSoundPlayer*)applySound:(SDSound*)sound signal:(id<CNObservableBase>)signal {
    return [EGSignalSoundPlayer signalSoundPlayerWithSound:sound signal:signal condition:^BOOL(id _) {
        return YES;
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SignalSoundPlayer(%@, %@)", _sound, _signal];
}

- (CNClassType*)type {
    return [EGSignalSoundPlayer type];
}

+ (CNClassType*)type {
    return _EGSignalSoundPlayer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

