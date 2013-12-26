#import "SDSoundDirector.h"

@implementation SDSoundDirector{
    BOOL __enabled;
    CNNotificationHandle* _enabledChangedNotification;
}
static SDSoundDirector* _SDSoundDirector_instance;
static ODClassType* _SDSoundDirector_type;
@synthesize enabledChangedNotification = _enabledChangedNotification;

+ (id)soundDirector {
    return [[SDSoundDirector alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        __enabled = YES;
        _enabledChangedNotification = [CNNotificationHandle notificationHandleWithName:@"soundEnabledChangedNotification"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _SDSoundDirector_type = [ODClassType classTypeWithCls:[SDSoundDirector class]];
    _SDSoundDirector_instance = [SDSoundDirector soundDirector];
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


