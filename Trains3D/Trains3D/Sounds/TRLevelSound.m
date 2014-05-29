#import "TRLevelSound.h"

#import "TRTreeSound.h"
#import "SDSound.h"
#import "TRLevel.h"
#import "TRTrainCollisions.h"
#import "TRRailroadBuilder.h"
#import "TRSwitchProcessor.h"
#import "TRRailroad.h"
#import "TRTrain.h"
#import "CNObserver.h"
@implementation TRLevelSound
static CNClassType* _TRLevelSound_type;
@synthesize level = _level;

+ (instancetype)levelSoundWithLevel:(TRLevel*)level {
    return [[TRLevelSound alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super initWithPlayers:(@[((EGSoundPlayer_impl*)([TRTreeSound treeSoundWithLevel:level])), ((EGSoundPlayer_impl*)([EGSignalSoundPlayer applySound:[SDSound applyFile:@"CrashBack.wav" volume:0.7] signal:TRLevel.crashed])), ((EGSoundPlayer_impl*)([EGSignalSoundPlayer applySound:[SDSound applyFile:@"CrashBack.wav" volume:0.7] signal:TRLevel.knockedDown])), ((EGSoundPlayer_impl*)([TRCollisionSound collisionSoundWithName:@"Crash1" signal:TRTrainsDynamicWorld.carsCollision impulseK:0.5 volume:1.0])), ((EGSoundPlayer_impl*)([TRCollisionSound collisionSoundWithName:@"GroundCrash1" signal:TRTrainsDynamicWorld.carAndGroundCollision impulseK:0.3 volume:0.7])), ((EGSoundPlayer_impl*)([EGSignalSoundPlayer applySound:[SDSound applyFile:@"SporadicDamage.wav" volume:0.15] signal:TRLevel.sporadicDamaged])), ((EGSoundPlayer_impl*)([EGSignalSoundPlayer applySound:[SDSound applyFile:@"TrainPreparing.wav" volume:0.2] signal:level.trainIsExpected])), ((EGSoundPlayer_impl*)([EGSignalSoundPlayer applySound:[SDSound applyFile:@"TrainRun.wav" volume:0.1] signal:level.trainIsAboutToRun])), ((EGSoundPlayer_impl*)([EGSignalSoundPlayer signalSoundPlayerWithSound:[SDSound applyFile:@"CityBuild.wav" volume:0.15] signal:level.cityWasBuilt condition:^BOOL(TRCity* _) {
    return ((TRCity*)(_)).color > 1;
}])), ((EGSoundPlayer_impl*)([EGSignalSoundPlayer applySound:[SDSound applyFile:@"RefuseBuild.wav" volume:0.2] signal:level.builder.buildingWasRefused])), ((EGSoundPlayer_impl*)([EGSignalSoundPlayer applySound:[SDSound applyFile:@"RefuseBuild.wav" volume:0.2] signal:TRSwitchProcessor.strangeClick])), ((EGSoundPlayer_impl*)([EGSignalSoundPlayer applySound:[SDSound applyFile:@"Click.wav" volume:0.3] signal:level.railroad.switchWasTurned])), ((EGSoundPlayer_impl*)([EGSignalSoundPlayer applySound:[SDSound applyFile:@"Beep.wav" volume:0.3] signal:level.railroad.lightWasTurned])), ((EGSoundPlayer_impl*)([EGSignalSoundPlayer applySound:[SDSound applyFile:@"BuildMode.wav" volume:0.3] signal:level.builder.mode])), ((EGSoundPlayer_impl*)([EGSignalSoundPlayer applySound:[SDSound applyFile:@"Fix.wav" volume:0.3] signal:TRLevel.fixedDamage])), ((EGSoundPlayer_impl*)([EGSignalSoundPlayer applySound:[SDSound parLimit:4 file:@"Choo.wav" volume:0.05] signal:TRTrain.choo]))])];
    if(self) _level = level;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelSound class]) _TRLevelSound_type = [CNClassType classTypeWithCls:[TRLevelSound class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"LevelSound(%@)", _level];
}

- (CNClassType*)type {
    return [TRLevelSound type];
}

+ (CNClassType*)type {
    return _TRLevelSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRCollisionSound
static CNClassType* _TRCollisionSound_type;
@synthesize name = _name;
@synthesize signal = _signal;
@synthesize impulseK = _impulseK;
@synthesize volume = _volume;
@synthesize sound = _sound;

+ (instancetype)collisionSoundWithName:(NSString*)name signal:(CNSignal*)signal impulseK:(float)impulseK volume:(float)volume {
    return [[TRCollisionSound alloc] initWithName:name signal:signal impulseK:impulseK volume:volume];
}

- (instancetype)initWithName:(NSString*)name signal:(CNSignal*)signal impulseK:(float)impulseK volume:(float)volume {
    self = [super init];
    if(self) {
        _name = name;
        _signal = signal;
        _impulseK = impulseK;
        _volume = volume;
        _sound = [SDSound parLimit:5 file:[NSString stringWithFormat:@"%@.wav", name]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCollisionSound class]) _TRCollisionSound_type = [CNClassType classTypeWithCls:[TRCollisionSound class]];
}

- (void)start {
    __weak TRCollisionSound* _weakSelf = self;
    _obs = [_signal observeF:^void(id impulse) {
        TRCollisionSound* _self = _weakSelf;
        if(_self != nil) {
            float imp = _self->_impulseK * float4Abs(unumf4(impulse));
            if(imp > 0.1) {
                if(imp > 1.0) imp = 1.0;
                [_self->_sound playWithVolume:imp * _self->_volume];
            }
        }
    }];
}

- (void)stop {
    [((CNObserver*)(_obs)) detach];
    _obs = nil;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CollisionSound(%@, %@, %f, %f)", _name, _signal, _impulseK, _volume];
}

- (CNClassType*)type {
    return [TRCollisionSound type];
}

+ (CNClassType*)type {
    return _TRCollisionSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

