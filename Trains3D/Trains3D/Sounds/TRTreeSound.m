#import "TRTreeSound.h"

#import "SDSound.h"
#import "TRTree.h"
#import "TRWeather.h"
@implementation TRTreeSound{
    TRForest* _forest;
}
static ODClassType* _TRTreeSound_type;
@synthesize forest = _forest;

+ (id)treeSoundWithForest:(TRForest*)forest {
    return [[TRTreeSound alloc] initWithForest:forest];
}

- (id)initWithForest:(TRForest*)forest {
    self = [super initWithPlayers:(@[[TRWindSound windSoundWithForest:forest], [EGSporadicSoundPlayer sporadicSoundPlayerWithSound:[SDSound applyFile:@"Nightingale.mp3" volume:0.15] secondsBetween:300.0], [EGSporadicSoundPlayer sporadicSoundPlayerWithSound:[SDSound applyFile:@"Crow.mp3" volume:0.4] secondsBetween:150.0], [EGSporadicSoundPlayer sporadicSoundPlayerWithSound:[SDSound applyFile:@"Crows.mp3" volume:0.4] secondsBetween:300.0]])];
    if(self) _forest = forest;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTreeSound_type = [ODClassType classTypeWithCls:[TRTreeSound class]];
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


@implementation TRWindSound{
    TRForest* _forest;
}
static ODClassType* _TRWindSound_type;
@synthesize forest = _forest;

+ (id)windSoundWithForest:(TRForest*)forest {
    return [[TRWindSound alloc] initWithForest:forest];
}

- (id)initWithForest:(TRForest*)forest {
    self = [super initWithSound:[SDSound applyFile:@"Rustle.mp3" volume:0.0]];
    if(self) _forest = forest;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRWindSound_type = [ODClassType classTypeWithCls:[TRWindSound class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    GEVec2 w = [_forest.weather wind];
    self.sound.volume = geVec2LengthSquare(w);
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


