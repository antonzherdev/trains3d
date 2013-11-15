#import "TRLevelSound.h"

#import "TRTreeSound.h"
#import "TRTrainSound.h"
#import "TRCollisions.h"
#import "SDSound.h"
#import "TRLevel.h"
#import "TRRailroad.h"
@implementation TRLevelSound{
    TRLevel* _level;
}
static ODClassType* _TRLevelSound_type;
@synthesize level = _level;

+ (id)levelSoundWithLevel:(TRLevel*)level {
    return [[TRLevelSound alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super initWithPlayers:(@[[TRTreeSound treeSoundWithLevel:level], [TRTrainSound trainSoundWithLevel:level], [TRCollisionSound collisionSoundWithName:@"Crash1" notificationHandle:TRTrainsDynamicWorld.carsCollisionNotification], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"TrainPreparing.wav" volume:0.2] notificationHandle:TRLevel.expectedTrainNotification], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"TrainRun.wav" volume:0.1] notificationHandle:TRLevel.prepareToRunTrainNotification], [EGNotificationSoundPlayer notificationSoundPlayerWithSound:[SDSound applyFile:@"CityBuild.wav" volume:0.15] notificationHandle:TRLevel.buildCityNotification condition:^BOOL(TRCity* _) {
    return [[level cities] count] > 2;
}], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"RefuseBuild.wav" volume:0.2] notificationHandle:TRRailroadBuilder.refuseBuildNotification], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"Click.wav" volume:0.3] notificationHandle:TRSwitch.turnNotification], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"Beep.wav" volume:0.3] notificationHandle:TRRailLight.turnNotification]])];
    if(self) _level = level;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelSound_type = [ODClassType classTypeWithCls:[TRLevelSound class]];
}

- (ODClassType*)type {
    return [TRLevelSound type];
}

+ (ODClassType*)type {
    return _TRLevelSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelSound* o = ((TRLevelSound*)(other));
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


@implementation TRCollisionSound{
    NSString* _name;
    CNNotificationHandle* _notificationHandle;
    SDSound* _sound;
    id _obs;
}
static ODClassType* _TRCollisionSound_type;
@synthesize name = _name;
@synthesize notificationHandle = _notificationHandle;
@synthesize sound = _sound;

+ (id)collisionSoundWithName:(NSString*)name notificationHandle:(CNNotificationHandle*)notificationHandle {
    return [[TRCollisionSound alloc] initWithName:name notificationHandle:notificationHandle];
}

- (id)initWithName:(NSString*)name notificationHandle:(CNNotificationHandle*)notificationHandle {
    self = [super init];
    if(self) {
        _name = name;
        _notificationHandle = notificationHandle;
        _sound = [SDSound applyFile:[NSString stringWithFormat:@"%@.wav", _name]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCollisionSound_type = [ODClassType classTypeWithCls:[TRCollisionSound class]];
}

- (void)start {
    _obs = [CNOption applyValue:[_notificationHandle observeBy:^void(id impulse) {
        _sound.volume = float4Abs(unumf4(impulse));
        [_sound play];
    }]];
}

- (void)stop {
    [_obs forEach:^void(CNNotificationObserver* _) {
        [((CNNotificationObserver*)(_)) detach];
    }];
    _obs = [CNOption none];
}

- (void)pause {
}

- (void)resume {
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (ODClassType*)type {
    return [TRCollisionSound type];
}

+ (ODClassType*)type {
    return _TRCollisionSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRCollisionSound* o = ((TRCollisionSound*)(other));
    return [self.name isEqual:o.name] && [self.notificationHandle isEqual:o.notificationHandle];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.name hash];
    hash = hash * 31 + [self.notificationHandle hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name=%@", self.name];
    [description appendFormat:@", notificationHandle=%@", self.notificationHandle];
    [description appendString:@">"];
    return description;
}

@end


