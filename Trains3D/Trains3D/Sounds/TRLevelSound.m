#import "TRLevelSound.h"

#import "TRTreeSound.h"
#import "SDSound.h"
#import "TRLevel.h"
#import "TRTrainCollisions.h"
#import "TRRailroadBuilder.h"
#import "TRSwitchProcessor.h"
#import "TRRailroad.h"
#import "TRTrain.h"
@implementation TRLevelSound
static ODClassType* _TRLevelSound_type;
@synthesize level = _level;

+ (instancetype)levelSoundWithLevel:(TRLevel*)level {
    return [[TRLevelSound alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super initWithPlayers:(@[[TRTreeSound treeSoundWithLevel:level], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"CrashBack.wav" volume:0.7] notificationHandle:TRLevel.crashNotification], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"CrashBack.wav" volume:0.7] notificationHandle:TRLevel.knockDownNotification], [TRCollisionSound collisionSoundWithName:@"Crash1" notificationHandle:TRTrainsDynamicWorld.carsCollisionNotification impulseK:0.5 volume:1.0], [TRCollisionSound collisionSoundWithName:@"GroundCrash1" notificationHandle:TRTrainsDynamicWorld.carAndGroundCollisionNotification impulseK:0.3 volume:0.7], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"SporadicDamage.wav" volume:0.15] notificationHandle:TRLevel.sporadicDamageNotification], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"TrainPreparing.wav" volume:0.2] notificationHandle:TRLevel.expectedTrainNotification], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"TrainRun.wav" volume:0.1] notificationHandle:TRLevel.prepareToRunTrainNotification], [EGNotificationSoundPlayer notificationSoundPlayerWithSound:[SDSound applyFile:@"CityBuild.wav" volume:0.15] notificationHandle:TRLevel.buildCityNotification condition:^BOOL(TRLevel* _0, TRCity* _1) {
    return [[level cities] count] > 2;
}], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"RefuseBuild.wav" volume:0.2] notificationHandle:TRRailroadBuilder.refuseBuildNotification], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"RefuseBuild.wav" volume:0.2] notificationHandle:TRSwitchProcessor.strangeClickNotification], [EGSignalSoundPlayer applySound:[SDSound applyFile:@"Click.wav" volume:0.3] signal:level.railroad.switchWasTurned], [EGSignalSoundPlayer applySound:[SDSound applyFile:@"Beep.wav" volume:0.3] signal:level.railroad.lightWasTurned], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"BuildMode.wav" volume:0.3] notificationHandle:TRRailroadBuilder.modeNotification], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"Fix.wav" volume:0.3] notificationHandle:TRLevel.fixDamageNotification], [EGNotificationSoundPlayer applySound:[SDSound parLimit:4 file:@"Choo.wav" volume:0.05] notificationHandle:TRTrain.chooNotification]])];
    if(self) _level = level;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelSound class]) _TRLevelSound_type = [ODClassType classTypeWithCls:[TRLevelSound class]];
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


@implementation TRCollisionSound
static ODClassType* _TRCollisionSound_type;
@synthesize name = _name;
@synthesize notificationHandle = _notificationHandle;
@synthesize impulseK = _impulseK;
@synthesize volume = _volume;
@synthesize sound = _sound;

+ (instancetype)collisionSoundWithName:(NSString*)name notificationHandle:(CNNotificationHandle*)notificationHandle impulseK:(float)impulseK volume:(float)volume {
    return [[TRCollisionSound alloc] initWithName:name notificationHandle:notificationHandle impulseK:impulseK volume:volume];
}

- (instancetype)initWithName:(NSString*)name notificationHandle:(CNNotificationHandle*)notificationHandle impulseK:(float)impulseK volume:(float)volume {
    self = [super init];
    if(self) {
        _name = name;
        _notificationHandle = notificationHandle;
        _impulseK = impulseK;
        _volume = volume;
        _sound = [SDSound parLimit:5 file:[NSString stringWithFormat:@"%@.wav", _name]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCollisionSound class]) _TRCollisionSound_type = [ODClassType classTypeWithCls:[TRCollisionSound class]];
}

- (void)start {
    __weak TRCollisionSound* _weakSelf = self;
    _obs = [CNOption applyValue:[_notificationHandle observeBy:^void(TRLevel* _, id impulse) {
        TRCollisionSound* _self = _weakSelf;
        float imp = _self->_impulseK * float4Abs(unumf4(impulse));
        if(imp > 0.1) {
            if(imp > 1.0) imp = 1.0;
            [_self->_sound playWithVolume:imp * _self->_volume];
        }
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
    return [self.name isEqual:o.name] && [self.notificationHandle isEqual:o.notificationHandle] && eqf4(self.impulseK, o.impulseK) && eqf4(self.volume, o.volume);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.name hash];
    hash = hash * 31 + [self.notificationHandle hash];
    hash = hash * 31 + float4Hash(self.impulseK);
    hash = hash * 31 + float4Hash(self.volume);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name=%@", self.name];
    [description appendFormat:@", notificationHandle=%@", self.notificationHandle];
    [description appendFormat:@", impulseK=%f", self.impulseK];
    [description appendFormat:@", volume=%f", self.volume];
    [description appendString:@">"];
    return description;
}

@end


