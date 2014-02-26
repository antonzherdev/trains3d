#import "TRTreeSound.h"

#import "TRLevel.h"
#import "TRWeather.h"
#import "SDSound.h"
#import "TRTree.h"
@implementation TRTreeSound{
    TRLevel* _level;
}
static ODClassType* _TRTreeSound_type;
@synthesize level = _level;

+ (instancetype)treeSoundWithLevel:(TRLevel*)level {
    return [[TRTreeSound alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super initWithPlayers:(([level.rules.weatherRules isRain]) ? (@[[TRWindSound windSoundWithForest:level.forest], [TRRainSound rainSoundWithWeather:level.weather]]) : (([level.rules.weatherRules isSnow]) ? (@[[TRWindSound windSoundWithForest:level.forest]]) : ((level.rules.theme == TRLevelTheme.forest || level.rules.theme == TRLevelTheme.leafForest) ? (@[[TRWindSound windSoundWithForest:level.forest], [EGSporadicSoundPlayer sporadicSoundPlayerWithSound:[SDSound applyFile:@"Nightingale.mp3" volume:0.1] secondsBetween:120.0], [EGSporadicSoundPlayer sporadicSoundPlayerWithSound:[SDSound applyFile:@"Crow.mp3" volume:0.1] secondsBetween:240.0], [EGSporadicSoundPlayer sporadicSoundPlayerWithSound:[SDSound applyFile:@"Crows.mp3" volume:0.03] secondsBetween:240.0], [EGSporadicSoundPlayer sporadicSoundPlayerWithSound:[SDSound applyFile:@"Woodpecker.mp3" volume:0.4] secondsBetween:120.0], [EGSporadicSoundPlayer sporadicSoundPlayerWithSound:[SDSound applyFile:@"Cuckoo.mp3" volume:0.4] secondsBetween:240.0], [EGSporadicSoundPlayer sporadicSoundPlayerWithSound:[SDSound applyFile:@"Grouse.mp3" volume:0.35] secondsBetween:240.0]]) : ((level.rules.theme == TRLevelTheme.palm) ? (@[[TRWindSound windSoundWithForest:level.forest], [EGBackgroundSoundPlayer backgroundSoundPlayerWithSound:[SDSound applyFile:@"Tropical.mp3" volume:0.07]], [EGSporadicSoundPlayer sporadicSoundPlayerWithSound:[SDSound applyFile:@"Parrot.mp3" volume:0.1] secondsBetween:240.0], [EGSporadicSoundPlayer sporadicSoundPlayerWithSound:[SDSound applyFile:@"Parrots.mp3" volume:0.07] secondsBetween:240.0], [EGSporadicSoundPlayer sporadicSoundPlayerWithSound:[SDSound applyFile:@"Parrots2.mp3" volume:0.1] secondsBetween:240.0], [EGSporadicSoundPlayer sporadicSoundPlayerWithSound:[SDSound applyFile:@"Kaka.mp3" volume:0.1] secondsBetween:240.0]]) : (@[[TRWindSound windSoundWithForest:level.forest], [EGSporadicSoundPlayer sporadicSoundPlayerWithSound:[SDSound applyFile:@"Crow.mp3" volume:0.1] secondsBetween:60.0], [EGSporadicSoundPlayer sporadicSoundPlayerWithSound:[SDSound applyFile:@"Crows.mp3" volume:0.03] secondsBetween:120.0]])))))];
    if(self) _level = level;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTreeSound class]) _TRTreeSound_type = [ODClassType classTypeWithCls:[TRTreeSound class]];
}

- (ODClassType*)type {
    return [TRTreeSound type];
}

+ (ODClassType*)type {
    return _TRTreeSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTreeSound* o = ((TRTreeSound*)(other));
    return [self.level isEqual:o.level];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRWindSound{
    TRForest* _forest;
}
static ODClassType* _TRWindSound_type;
@synthesize forest = _forest;

+ (instancetype)windSoundWithForest:(TRForest*)forest {
    return [[TRWindSound alloc] initWithForest:forest];
}

- (instancetype)initWithForest:(TRForest*)forest {
    self = [super initWithSound:[SDSound applyFile:@"Rustle.mp3" volume:0.0]];
    if(self) _forest = forest;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRWindSound class]) _TRWindSound_type = [ODClassType classTypeWithCls:[TRWindSound class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    GEVec2 w = [_forest.weather wind];
    self.sound.volume = geVec2LengthSquare(w) * 2;
}

- (ODClassType*)type {
    return [TRWindSound type];
}

+ (ODClassType*)type {
    return _TRWindSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRWindSound* o = ((TRWindSound*)(other));
    return [self.forest isEqual:o.forest];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.forest hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"forest=%@", self.forest];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRainSound{
    TRWeather* _weather;
}
static ODClassType* _TRRainSound_type;
@synthesize weather = _weather;

+ (instancetype)rainSoundWithWeather:(TRWeather*)weather {
    return [[TRRainSound alloc] initWithWeather:weather];
}

- (instancetype)initWithWeather:(TRWeather*)weather {
    self = [super initWithSound:[SDSound applyFile:@"Rain.mp3" volume:0.0]];
    if(self) _weather = weather;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRainSound class]) _TRRainSound_type = [ODClassType classTypeWithCls:[TRRainSound class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    GEVec2 w = [_weather wind];
    self.sound.volume = ((float)(0.05 + geVec2LengthSquare(w) * 2));
}

- (ODClassType*)type {
    return [TRRainSound type];
}

+ (ODClassType*)type {
    return _TRRainSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRainSound* o = ((TRRainSound*)(other));
    return [self.weather isEqual:o.weather];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.weather hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"weather=%@", self.weather];
    [description appendString:@">"];
    return description;
}

@end


