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
    self = [super initWithPlayers:(@[[TRTreeSound treeSoundWithLevel:level], [TRTrainSound trainSoundWithLevel:level], [TRCollisionSound collisionSoundWithName:@"Crash1" notificationHandle:TRTrainsDynamicWorld.carsCollisionNotification volume:0.5], [TRCollisionSound collisionSoundWithName:@"GroundCrash1" notificationHandle:TRTrainsDynamicWorld.carAndGroundCollisionNotification volume:0.5], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"TrainPreparing.wav" volume:0.2] notificationHandle:TRLevel.expectedTrainNotification], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"TrainRun.wav" volume:0.1] notificationHandle:TRLevel.prepareToRunTrainNotification], [EGNotificationSoundPlayer notificationSoundPlayerWithSound:[SDSound applyFile:@"CityBuild.wav" volume:0.15] notificationHandle:TRLevel.buildCityNotification condition:^BOOL(TRCity* _) {
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
    float _volume;
    EGSoundParallel* _sound;
    id _obs;
}
static ODClassType* _TRCollisionSound_type;
@synthesize name = _name;
@synthesize notificationHandle = _notificationHandle;
@synthesize volume = _volume;
@synthesize sound = _sound;

+ (id)collisionSoundWithName:(NSString*)name notificationHandle:(CNNotificationHandle*)notificationHandle volume:(float)volume {
    return [[TRCollisionSound alloc] initWithName:name notificationHandle:notificationHandle volume:volume];
}

- (id)initWithName:(NSString*)name notificationHandle:(CNNotificationHandle*)notificationHandle volume:(float)volume {
    self = [super init];
    __weak TRCollisionSound* _weakSelf = self;
    if(self) {
        _name = name;
        _notificationHandle = notificationHandle;
        _volume = volume;
        _sound = [EGSoundParallel soundParallelWithLimit:10 create:^SDSound*() {
            return [SDSound applyFile:[NSString stringWithFormat:@"%@.wav", _weakSelf.name]];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCollisionSound_type = [ODClassType classTypeWithCls:[TRCollisionSound class]];
}

- (void)start {
    _obs = [CNOption applyValue:[_notificationHandle observeBy:^void(id impulse) {
        float imp = float4Abs(unumf4(impulse));
        if(imp > 0.3) {
            imp = imp * 0.5;
            if(imp > 1.0) imp = 1.0;
            [CNLog applyText:[NSString stringWithFormat:@"%@ - %f", _name, imp]];
            [_sound playWithVolume:imp * _volume];
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
    return [self.name isEqual:o.name] && [self.notificationHandle isEqual:o.notificationHandle] && eqf4(self.volume, o.volume);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.name hash];
    hash = hash * 31 + [self.notificationHandle hash];
    hash = hash * 31 + float4Hash(self.volume);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name=%@", self.name];
    [description appendFormat:@", notificationHandle=%@", self.notificationHandle];
    [description appendFormat:@", volume=%f", self.volume];
    [description appendString:@">"];
    return description;
}

@end


