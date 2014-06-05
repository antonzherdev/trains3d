#import "TRTreeSound.h"

#import "TRWeather.h"
#import "PGSound.h"
#import "TRTree.h"
@implementation TRTreeSound
static CNClassType* _TRTreeSound_type;
@synthesize level = _level;

+ (instancetype)treeSoundWithLevel:(TRLevel*)level {
    return [[TRTreeSound alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super initWithPlayers:(([level->_rules->_weatherRules isRain]) ? ((NSArray*)((@[((PGBackgroundSoundPlayer*)([TRWindSound windSoundWithForest:level->_forest])), ((PGBackgroundSoundPlayer*)([TRRainSound rainSoundWithWeather:level->_weather]))]))) : (([level->_rules->_weatherRules isSnow]) ? ((NSArray*)((@[[TRWindSound windSoundWithForest:level->_forest]]))) : ((level->_rules->_theme == TRLevelTheme_forest || level->_rules->_theme == TRLevelTheme_leafForest) ? ((NSArray*)((@[((id<PGSoundPlayer>)([TRWindSound windSoundWithForest:level->_forest])), ((id<PGSoundPlayer>)([PGSporadicSoundPlayer sporadicSoundPlayerWithSound:[PGSound applyFile:@"Nightingale.mp3" volume:0.1] secondsBetween:120.0])), ((id<PGSoundPlayer>)([PGSporadicSoundPlayer sporadicSoundPlayerWithSound:[PGSound applyFile:@"Crow.mp3" volume:0.1] secondsBetween:240.0])), ((id<PGSoundPlayer>)([PGSporadicSoundPlayer sporadicSoundPlayerWithSound:[PGSound applyFile:@"Crows.mp3" volume:0.03] secondsBetween:240.0])), ((id<PGSoundPlayer>)([PGSporadicSoundPlayer sporadicSoundPlayerWithSound:[PGSound applyFile:@"Woodpecker.mp3" volume:0.4] secondsBetween:120.0])), ((id<PGSoundPlayer>)([PGSporadicSoundPlayer sporadicSoundPlayerWithSound:[PGSound applyFile:@"Cuckoo.mp3" volume:0.4] secondsBetween:240.0]))]))) : ((level->_rules->_theme == TRLevelTheme_palm) ? ((NSArray*)((@[((id<PGSoundPlayer>)([TRWindSound windSoundWithForest:level->_forest])), ((id<PGSoundPlayer>)([PGBackgroundSoundPlayer backgroundSoundPlayerWithSound:[PGSound applyFile:@"Tropical.mp3" volume:0.07]])), ((id<PGSoundPlayer>)([PGSporadicSoundPlayer sporadicSoundPlayerWithSound:[PGSound applyFile:@"Parrot.mp3" volume:0.1] secondsBetween:240.0])), ((id<PGSoundPlayer>)([PGSporadicSoundPlayer sporadicSoundPlayerWithSound:[PGSound applyFile:@"Parrots.mp3" volume:0.07] secondsBetween:240.0])), ((id<PGSoundPlayer>)([PGSporadicSoundPlayer sporadicSoundPlayerWithSound:[PGSound applyFile:@"Parrots2.mp3" volume:0.1] secondsBetween:240.0])), ((id<PGSoundPlayer>)([PGSporadicSoundPlayer sporadicSoundPlayerWithSound:[PGSound applyFile:@"Kaka.mp3" volume:0.1] secondsBetween:240.0]))]))) : (@[((id<PGSoundPlayer>)([TRWindSound windSoundWithForest:level->_forest])), ((id<PGSoundPlayer>)([PGSporadicSoundPlayer sporadicSoundPlayerWithSound:[PGSound applyFile:@"Crow.mp3" volume:0.1] secondsBetween:60.0])), ((id<PGSoundPlayer>)([PGSporadicSoundPlayer sporadicSoundPlayerWithSound:[PGSound applyFile:@"Crows.mp3" volume:0.03] secondsBetween:120.0]))])))))];
    if(self) _level = level;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTreeSound class]) _TRTreeSound_type = [CNClassType classTypeWithCls:[TRTreeSound class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"TreeSound(%@)", _level];
}

- (CNClassType*)type {
    return [TRTreeSound type];
}

+ (CNClassType*)type {
    return _TRTreeSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRWindSound
static CNClassType* _TRWindSound_type;
@synthesize forest = _forest;

+ (instancetype)windSoundWithForest:(TRForest*)forest {
    return [[TRWindSound alloc] initWithForest:forest];
}

- (instancetype)initWithForest:(TRForest*)forest {
    self = [super initWithSound:[PGSound applyFile:@"Rustle.mp3" volume:0.0]];
    if(self) _forest = forest;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRWindSound class]) _TRWindSound_type = [CNClassType classTypeWithCls:[TRWindSound class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    PGVec2 w = [_forest->_weather wind];
    [self.sound setVolume:pgVec2LengthSquare(w) * 2];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"WindSound(%@)", _forest];
}

- (CNClassType*)type {
    return [TRWindSound type];
}

+ (CNClassType*)type {
    return _TRWindSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRRainSound
static CNClassType* _TRRainSound_type;
@synthesize weather = _weather;

+ (instancetype)rainSoundWithWeather:(TRWeather*)weather {
    return [[TRRainSound alloc] initWithWeather:weather];
}

- (instancetype)initWithWeather:(TRWeather*)weather {
    self = [super initWithSound:[PGSound applyFile:@"Rain.mp3" volume:0.0]];
    if(self) _weather = weather;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRainSound class]) _TRRainSound_type = [CNClassType classTypeWithCls:[TRRainSound class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    PGVec2 w = [_weather wind];
    [self.sound setVolume:((float)(0.05 + pgVec2LengthSquare(w) * 2))];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RainSound(%@)", _weather];
}

- (CNClassType*)type {
    return [TRRainSound type];
}

+ (CNClassType*)type {
    return _TRRainSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

