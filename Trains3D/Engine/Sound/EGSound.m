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
        [_ start];
    }];
}

- (void)stop {
    [_players forEach:^void(id<EGSoundPlayer> _) {
        [_ stop];
    }];
}

- (void)pause {
    [_players forEach:^void(id<EGSoundPlayer> _) {
        [_ pause];
    }];
}

- (void)resume {
    [_players forEach:^void(id<EGSoundPlayer> _) {
        [_ resume];
    }];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_players forEach:^void(id<EGSoundPlayer> _) {
        [_ updateWithDelta:delta];
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


