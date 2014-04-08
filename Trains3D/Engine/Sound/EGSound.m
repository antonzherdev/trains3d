#import "EGSound.h"

#import "SDSound.h"
#import "ATObserver.h"
@implementation EGBackgroundSoundPlayer
static ODClassType* _EGBackgroundSoundPlayer_type;
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
    if(self == [EGBackgroundSoundPlayer class]) _EGBackgroundSoundPlayer_type = [ODClassType classTypeWithCls:[EGBackgroundSoundPlayer class]];
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

- (void)updateWithDelta:(CGFloat)delta {
}

- (ODClassType*)type {
    return [EGBackgroundSoundPlayer type];
}

+ (ODClassType*)type {
    return _EGBackgroundSoundPlayer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"sound=%@", self.sound];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSoundPlayersCollection
static ODClassType* _EGSoundPlayersCollection_type;
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
    if(self == [EGSoundPlayersCollection class]) _EGSoundPlayersCollection_type = [ODClassType classTypeWithCls:[EGSoundPlayersCollection class]];
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

- (ODClassType*)type {
    return [EGSoundPlayersCollection type];
}

+ (ODClassType*)type {
    return _EGSoundPlayersCollection_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"players=%@", self.players];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSporadicSoundPlayer
static ODClassType* _EGSporadicSoundPlayer_type;
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
    if(self == [EGSporadicSoundPlayer class]) _EGSporadicSoundPlayer_type = [ODClassType classTypeWithCls:[EGSporadicSoundPlayer class]];
}

- (void)start {
    __timeToNextPlaying = odFloatRndMinMax(0.0, _secondsBetween * 2);
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
            __timeToNextPlaying = odFloatRndMinMax(0.0, _secondsBetween * 2);
        }
    }
}

- (ODClassType*)type {
    return [EGSporadicSoundPlayer type];
}

+ (ODClassType*)type {
    return _EGSporadicSoundPlayer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"sound=%@", self.sound];
    [description appendFormat:@", secondsBetween=%f", self.secondsBetween];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGNotificationSoundPlayer
static ODClassType* _EGNotificationSoundPlayer_type;
@synthesize sound = _sound;
@synthesize notificationHandle = _notificationHandle;
@synthesize condition = _condition;

+ (instancetype)notificationSoundPlayerWithSound:(SDSound*)sound notificationHandle:(CNNotificationHandle*)notificationHandle condition:(BOOL(^)(id, id))condition {
    return [[EGNotificationSoundPlayer alloc] initWithSound:sound notificationHandle:notificationHandle condition:condition];
}

- (instancetype)initWithSound:(SDSound*)sound notificationHandle:(CNNotificationHandle*)notificationHandle condition:(BOOL(^)(id, id))condition {
    self = [super init];
    if(self) {
        _sound = sound;
        _notificationHandle = notificationHandle;
        _condition = [condition copy];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGNotificationSoundPlayer class]) _EGNotificationSoundPlayer_type = [ODClassType classTypeWithCls:[EGNotificationSoundPlayer class]];
}

+ (EGNotificationSoundPlayer*)applySound:(SDSound*)sound notificationHandle:(CNNotificationHandle*)notificationHandle {
    return [EGNotificationSoundPlayer notificationSoundPlayerWithSound:sound notificationHandle:notificationHandle condition:^BOOL(id _0, id _1) {
        return YES;
    }];
}

- (void)start {
    __weak EGNotificationSoundPlayer* _weakSelf = self;
    _obs = [_notificationHandle observeBy:^void(id sender, id data) {
        EGNotificationSoundPlayer* _self = _weakSelf;
        if(_self->_condition(sender, data)) [_self->_sound play];
    }];
}

- (void)stop {
    [((CNNotificationObserver*)(_obs)) detach];
    _obs = nil;
    [_sound stop];
}

- (void)pause {
    [_sound pause];
}

- (void)resume {
    [_sound resume];
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (ODClassType*)type {
    return [EGNotificationSoundPlayer type];
}

+ (ODClassType*)type {
    return _EGNotificationSoundPlayer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"sound=%@", self.sound];
    [description appendFormat:@", notificationHandle=%@", self.notificationHandle];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSignalSoundPlayer
static ODClassType* _EGSignalSoundPlayer_type;
@synthesize sound = _sound;
@synthesize signal = _signal;
@synthesize condition = _condition;

+ (instancetype)signalSoundPlayerWithSound:(SDSound*)sound signal:(ATSignal*)signal condition:(BOOL(^)(id))condition {
    return [[EGSignalSoundPlayer alloc] initWithSound:sound signal:signal condition:condition];
}

- (instancetype)initWithSound:(SDSound*)sound signal:(ATSignal*)signal condition:(BOOL(^)(id))condition {
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
    if(self == [EGSignalSoundPlayer class]) _EGSignalSoundPlayer_type = [ODClassType classTypeWithCls:[EGSignalSoundPlayer class]];
}

- (void)start {
    __weak EGSignalSoundPlayer* _weakSelf = self;
    _obs = [_signal observeF:^void(id data) {
        EGSignalSoundPlayer* _self = _weakSelf;
        if(_self->_condition(data)) [_self->_sound play];
    }];
}

- (void)stop {
    [((ATObserver*)(_obs)) detach];
    _obs = nil;
    [_sound stop];
}

- (void)pause {
    [_sound pause];
}

- (void)resume {
    [_sound resume];
}

+ (EGSignalSoundPlayer*)applySound:(SDSound*)sound signal:(ATSignal*)signal {
    return [EGSignalSoundPlayer signalSoundPlayerWithSound:sound signal:signal condition:^BOOL(id _) {
        return YES;
    }];
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (ODClassType*)type {
    return [EGSignalSoundPlayer type];
}

+ (ODClassType*)type {
    return _EGSignalSoundPlayer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"sound=%@", self.sound];
    [description appendFormat:@", signal=%@", self.signal];
    [description appendString:@">"];
    return description;
}

@end


