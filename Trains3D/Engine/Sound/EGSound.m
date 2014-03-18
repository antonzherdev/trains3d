#import "EGSound.h"

#import "SDSound.h"
@implementation EGBackgroundSoundPlayer
static ODClassType* _EGBackgroundSoundPlayer_type;
@synthesize sound = _sound;

+ (instancetype)backgroundSoundPlayerWithSound:(SDSound*)sound {
    return [[EGBackgroundSoundPlayer alloc] initWithSound:sound];
}

- (instancetype)initWithSound:(SDSound*)sound {
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


@implementation EGSoundPlayersCollection
static ODClassType* _EGSoundPlayersCollection_type;
@synthesize players = _players;

+ (instancetype)soundPlayersCollectionWithPlayers:(id<CNImSeq>)players {
    return [[EGSoundPlayersCollection alloc] initWithPlayers:players];
}

- (instancetype)initWithPlayers:(id<CNImSeq>)players {
    self = [super init];
    if(self) _players = players;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSoundPlayersCollection class]) _EGSoundPlayersCollection_type = [ODClassType classTypeWithCls:[EGSoundPlayersCollection class]];
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
        _wasPlaying = NO;
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
    _obs = [CNOption applyValue:[_notificationHandle observeBy:^void(id sender, id data) {
        EGNotificationSoundPlayer* _self = _weakSelf;
        if(_self->_condition(sender, data)) [_self->_sound play];
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


@implementation EGSoundParallel
static ODClassType* _EGSoundParallel_type;
@synthesize limit = _limit;
@synthesize create = _create;

+ (instancetype)soundParallelWithLimit:(NSInteger)limit create:(SDSound*(^)())create {
    return [[EGSoundParallel alloc] initWithLimit:limit create:create];
}

- (instancetype)initWithLimit:(NSInteger)limit create:(SDSound*(^)())create {
    self = [super init];
    if(self) {
        _limit = limit;
        _create = [create copy];
        _sounds = [NSMutableArray mutableArray];
        _paused = (@[]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSoundParallel class]) _EGSoundParallel_type = [ODClassType classTypeWithCls:[EGSoundParallel class]];
}

- (void)play {
    [[self sound] forEach:^void(SDSound* _) {
        [((SDSound*)(_)) play];
    }];
}

- (void)pause {
    _paused = [_paused addSeq:[[[_sounds chain] filter:^BOOL(SDSound* sound) {
        if([((SDSound*)(sound)) isPlaying]) {
            [((SDSound*)(sound)) pause];
            return YES;
        } else {
            return NO;
        }
    }] toArray]];
}

- (void)resume {
    [_paused forEach:^void(SDSound* _) {
        [((SDSound*)(_)) play];
    }];
    _paused = (@[]);
}

- (void)playWithVolume:(float)volume {
    [[self sound] forEach:^void(SDSound* s) {
        ((SDSound*)(s)).volume = volume;
        [((SDSound*)(s)) play];
    }];
}

- (id)sound {
    id s = [_sounds findWhere:^BOOL(SDSound* _) {
        return !([((SDSound*)(_)) isPlaying]);
    }];
    if([s isDefined]) {
        return s;
    } else {
        if([_sounds count] >= _limit) {
            return [CNOption none];
        } else {
            SDSound* newSound = ((SDSound*(^)())(_create))();
            [_sounds appendItem:newSound];
            return [CNOption applyValue:newSound];
        }
    }
}

- (ODClassType*)type {
    return [EGSoundParallel type];
}

+ (ODClassType*)type {
    return _EGSoundParallel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSoundParallel* o = ((EGSoundParallel*)(other));
    return self.limit == o.limit && [self.create isEqual:o.create];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.limit;
    hash = hash * 31 + [self.create hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"limit=%ld", (long)self.limit];
    [description appendString:@">"];
    return description;
}

@end


