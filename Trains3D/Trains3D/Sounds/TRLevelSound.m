#import "TRLevelSound.h"

#import "TRTreeSound.h"
#import "PGSound.h"
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
    self = [super initWithPlayers:(@[((id<PGSoundPlayer>)([TRTreeSound treeSoundWithLevel:level])), ((id<PGSoundPlayer>)([PGSignalSoundPlayer applySound:[PGSound applyFile:@"CrashBack.wav" volume:0.7] signal:[TRLevel crashed]])), ((id<PGSoundPlayer>)([PGSignalSoundPlayer applySound:[PGSound applyFile:@"CrashBack.wav" volume:0.7] signal:[TRLevel knockedDown]])), ((id<PGSoundPlayer>)([TRCollisionSound collisionSoundWithName:@"Crash1" signal:[TRTrainsDynamicWorld carsCollision] impulseK:0.5 volume:1.0])), ((id<PGSoundPlayer>)([TRCollisionSound collisionSoundWithName:@"GroundCrash1" signal:[TRTrainsDynamicWorld carAndGroundCollision] impulseK:0.3 volume:0.7])), ((id<PGSoundPlayer>)([PGSignalSoundPlayer applySound:[PGSound applyFile:@"SporadicDamage.wav" volume:0.15] signal:[TRLevel sporadicDamaged]])), ((id<PGSoundPlayer>)([PGSignalSoundPlayer applySound:[PGSound applyFile:@"TrainPreparing.wav" volume:0.2] signal:level->_trainIsExpected])), ((id<PGSoundPlayer>)([PGSignalSoundPlayer applySound:[PGSound applyFile:@"TrainRun.wav" volume:0.1] signal:level->_trainIsAboutToRun])), ((id<PGSoundPlayer>)([PGSignalSoundPlayer signalSoundPlayerWithSound:[PGSound applyFile:@"CityBuild.wav" volume:0.15] signal:level->_cityWasBuilt condition:^BOOL(TRCity* _) {
    return ((TRCity*)(_))->_color > 1;
}])), ((id<PGSoundPlayer>)([PGSignalSoundPlayer applySound:[PGSound applyFile:@"RefuseBuild.wav" volume:0.2] signal:level->_builder->_buildingWasRefused])), ((id<PGSoundPlayer>)([PGSignalSoundPlayer applySound:[PGSound applyFile:@"RefuseBuild.wav" volume:0.2] signal:[TRSwitchProcessor strangeClick]])), ((id<PGSoundPlayer>)([PGSignalSoundPlayer applySound:[PGSound applyFile:@"Click.wav" volume:0.3] signal:level->_railroad->_switchWasTurned])), ((id<PGSoundPlayer>)([PGSignalSoundPlayer applySound:[PGSound applyFile:@"Beep.wav" volume:0.3] signal:level->_railroad->_lightWasTurned])), ((id<PGSoundPlayer>)([PGSignalSoundPlayer applySound:[PGSound applyFile:@"BuildMode.wav" volume:0.3] signal:level->_builder->_mode])), ((id<PGSoundPlayer>)([PGSignalSoundPlayer applySound:[PGSound applyFile:@"Fix.wav" volume:0.3] signal:[TRLevel fixedDamage]])), ((id<PGSoundPlayer>)([PGSignalSoundPlayer applySound:[PGSound parLimit:4 file:@"Choo.wav" volume:0.05] signal:[TRTrain choo]]))])];
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
        _sound = [PGSound parLimit:5 file:[NSString stringWithFormat:@"%@.wav", name]];
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

