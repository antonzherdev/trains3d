#import "SDSoundDirector.h"

@implementation SDSoundDirector{
    BOOL __enabled;
    CNNotificationHandle* _enabledChangedNotification;
    CGFloat __timeSpeed;
    CNNotificationHandle* _timeSpeedChangeNotification;
}
static SDSoundDirector* _SDSoundDirector_instance;
static ODClassType* _SDSoundDirector_type;
@synthesize enabledChangedNotification = _enabledChangedNotification;
@synthesize timeSpeedChangeNotification = _timeSpeedChangeNotification;

+ (instancetype)soundDirector {
    return [[SDSoundDirector alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __enabled = YES;
        _enabledChangedNotification = [CNNotificationHandle notificationHandleWithName:@"soundEnabledChangedNotification"];
        __timeSpeed = 1.0;
        _timeSpeedChangeNotification = [CNNotificationHandle notificationHandleWithName:@"soundTimeSpeedChangeNotification"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [SDSoundDirector class]) {
        _SDSoundDirector_type = [ODClassType classTypeWithCls:[SDSoundDirector class]];
        _SDSoundDirector_instance = [SDSoundDirector soundDirector];
    }
}

- (BOOL)enabled {
    return __enabled;
}

- (void)setEnabled:(BOOL)enabled {
    if(__enabled != enabled) {
        __enabled = enabled;
        [_enabledChangedNotification postSender:self data:numb(enabled)];
    }
}

- (CGFloat)timeSpeed {
    return __timeSpeed;
}

- (void)setTimeSpeed:(CGFloat)timeSpeed {
    if(!(eqf(__timeSpeed, timeSpeed))) {
        __timeSpeed = timeSpeed;
        [_timeSpeedChangeNotification postSender:self data:numf(timeSpeed)];
    }
}

- (ODClassType*)type {
    return [SDSoundDirector type];
}

+ (SDSoundDirector*)instance {
    return _SDSoundDirector_instance;
}

+ (ODClassType*)type {
    return _SDSoundDirector_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


