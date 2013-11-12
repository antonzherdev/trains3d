#import "EGSound.h"

#import "SDSound.h"
@implementation EGBackgroundSoundPlayer{
    SDSound* _sound;
}
static ODClassType* _EGBackgroundSoundPlayer_type;
@synthesize sound = _sound;

+ (id)backgroundSoundPlayerWithSound:(SDSound*)sound {
    return [[EGBackgroundSoundPlayer alloc] initWithSound:sound];
}

- (id)initWithSound:(SDSound*)sound {
    self = [super init];
    if(self) _sound = sound;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBackgroundSoundPlayer_type = [ODClassType classTypeWithCls:[EGBackgroundSoundPlayer class]];
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
    [_sound play];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBackgroundSoundPlayer* o = ((EGBackgroundSoundPlayer*)(other));
    return self.sound == o.sound;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.sound hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"sound=%@", self.sound];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSoundPlayersCollection{
    id<CNSeq> _players;
}
static ODClassType* _EGSoundPlayersCollection_type;
@synthesize players = _players;

+ (id)soundPlayersCollectionWithPlayers:(id<CNSeq>)players {
    return [[EGSoundPlayersCollection alloc] initWithPlayers:players];
}

- (id)initWithPlayers:(id<CNSeq>)players {
    self = [super init];
    if(self) _players = players;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSoundPlayersCollection_type = [ODClassType classTypeWithCls:[EGSoundPlayersCollection class]];
}

- (void)start {
    [_players forEach:^void(id<EGSoundPlayer> _) {
        [((id<EGSoundPlayer>)(_)) start];
    }];
}

- (void)stop {
    [_players forEach:^void(id<EGSoundPlayer> _) {
        [((id<EGSoundPlayer>)(_)) stop];
    }];
}

- (void)pause {
    [_players forEach:^void(id<EGSoundPlayer> _) {
        [((id<EGSoundPlayer>)(_)) pause];
    }];
}

- (void)resume {
    [_players forEach:^void(id<EGSoundPlayer> _) {
        [((id<EGSoundPlayer>)(_)) resume];
    }];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_players forEach:^void(id<EGSoundPlayer> _) {
        [((id<EGSoundPlayer>)(_)) updateWithDelta:delta];
    }];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSoundPlayersCollection* o = ((EGSoundPlayersCollection*)(other));
    return [self.players isEqual:o.players];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.players hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"players=%@", self.players];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSporadicSoundPlayer{
    SDSound* _sound;
    CGFloat _secondsBetween;
    CGFloat __timeToNextPlaying;
    BOOL _wasPlaying;
}
static ODClassType* _EGSporadicSoundPlayer_type;
@synthesize sound = _sound;
@synthesize secondsBetween = _secondsBetween;

+ (id)sporadicSoundPlayerWithSound:(SDSound*)sound secondsBetween:(CGFloat)secondsBetween {
    return [[EGSporadicSoundPlayer alloc] initWithSound:sound secondsBetween:secondsBetween];
}

- (id)initWithSound:(SDSound*)sound secondsBetween:(CGFloat)secondsBetween {
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
    _EGSporadicSoundPlayer_type = [ODClassType classTypeWithCls:[EGSporadicSoundPlayer class]];
}

- (void)start {
    __timeToNextPlaying = odFloatRndMinMax(0.0, _secondsBetween * 2);
}

- (void)stop {
    [_sound stop];
}

- (void)pause {
    _wasPlaying = [_sound isPlaying];
    [_sound pause];
}

- (void)resume {
    if(_wasPlaying) [_sound play];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSporadicSoundPlayer* o = ((EGSporadicSoundPlayer*)(other));
    return self.sound == o.sound && eqf(self.secondsBetween, o.secondsBetween);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.sound hash];
    hash = hash * 31 + floatHash(self.secondsBetween);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"sound=%@", self.sound];
    [description appendFormat:@", secondsBetween=%f", self.secondsBetween];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGNotificationSoundPlayer{
    SDSound* _sound;
    CNNotificationHandle* _notificationHandle;
    BOOL(^_condition)(id);
    id _obs;
    BOOL _wasPlaying;
}
static ODClassType* _EGNotificationSoundPlayer_type;
@synthesize sound = _sound;
@synthesize notificationHandle = _notificationHandle;
@synthesize condition = _condition;

+ (id)notificationSoundPlayerWithSound:(SDSound*)sound notificationHandle:(CNNotificationHandle*)notificationHandle condition:(BOOL(^)(id))condition {
    return [[EGNotificationSoundPlayer alloc] initWithSound:sound notificationHandle:notificationHandle condition:condition];
}

- (id)initWithSound:(SDSound*)sound notificationHandle:(CNNotificationHandle*)notificationHandle condition:(BOOL(^)(id))condition {
    self = [super init];
    if(self) {
        _sound = sound;
        _notificationHandle = notificationHandle;
        _condition = condition;
        _wasPlaying = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGNotificationSoundPlayer_type = [ODClassType classTypeWithCls:[EGNotificationSoundPlayer class]];
}

+ (EGNotificationSoundPlayer*)applySound:(SDSound*)sound notificationHandle:(CNNotificationHandle*)notificationHandle {
    return [EGNotificationSoundPlayer notificationSoundPlayerWithSound:sound notificationHandle:notificationHandle condition:^BOOL(id _) {
        return YES;
    }];
}

- (void)start {
    _obs = [CNOption applyValue:[_notificationHandle observeBy:^void(id value) {
        if(_condition(value)) [_sound play];
    }]];
}

- (void)stop {
    [_obs forEach:^void(CNNotificationObserver* _) {
        [((CNNotificationObserver*)(_)) detach];
    }];
    _obs = [CNOption none];
    [_sound stop];
}

- (void)pause {
    _wasPlaying = [_sound isPlaying];
    [_sound pause];
}

- (void)resume {
    if(_wasPlaying) [_sound play];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGNotificationSoundPlayer* o = ((EGNotificationSoundPlayer*)(other));
    return self.sound == o.sound && [self.notificationHandle isEqual:o.notificationHandle] && [self.condition isEqual:o.condition];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.sound hash];
    hash = hash * 31 + [self.notificationHandle hash];
    hash = hash * 31 + [self.condition hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"sound=%@", self.sound];
    [description appendFormat:@", notificationHandle=%@", self.notificationHandle];
    [description appendString:@">"];
    return description;
}

@end


