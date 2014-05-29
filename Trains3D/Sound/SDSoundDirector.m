#import "SDSoundDirector.h"

#import "CNObserver.h"
@implementation SDSoundDirector
static SDSoundDirector* _SDSoundDirector_instance;
static CNClassType* _SDSoundDirector_type;
@synthesize enabledChanged = _enabledChanged;
@synthesize timeSpeedChanged = _timeSpeedChanged;

+ (instancetype)soundDirector {
    return [[SDSoundDirector alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __enabled = YES;
        _enabledChanged = [CNSignal signal];
        __timeSpeed = 1.0;
        _timeSpeedChanged = [CNSignal signal];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [SDSoundDirector class]) {
        _SDSoundDirector_type = [CNClassType classTypeWithCls:[SDSoundDirector class]];
        _SDSoundDirector_instance = [SDSoundDirector soundDirector];
    }
}

- (BOOL)enabled {
    return __enabled;
}

- (void)setEnabled:(BOOL)enabled {
    if(__enabled != enabled) {
        __enabled = enabled;
        [_enabledChanged postData:numb(enabled)];
    }
}

- (CGFloat)timeSpeed {
    return __timeSpeed;
}

- (void)setTimeSpeed:(CGFloat)timeSpeed {
    if(!(eqf(__timeSpeed, timeSpeed))) {
        __timeSpeed = timeSpeed;
        [_timeSpeedChanged postData:numf(timeSpeed)];
    }
}

- (NSString*)description {
    return @"SoundDirector";
}

- (CNClassType*)type {
    return [SDSoundDirector type];
}

+ (SDSoundDirector*)instance {
    return _SDSoundDirector_instance;
}

+ (CNClassType*)type {
    return _SDSoundDirector_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

