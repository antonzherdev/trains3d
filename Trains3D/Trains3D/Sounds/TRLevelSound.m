#import "TRLevelSound.h"

#import "TRLevel.h"
#import "TRTreeSound.h"
#import "TRTrainSound.h"
#import "SDSound.h"
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
    self = [super initWithPlayers:(@[[TRTreeSound treeSoundWithForest:level.forest], [TRTrainSound trainSoundWithLevel:level], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"TrainPreparing.wav" volume:0.2] notificationHandle:TRLevel.expectedTrainNotification], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"TrainRun.wav" volume:0.2] notificationHandle:TRLevel.prepareToRunTrainNotification], [EGNotificationSoundPlayer notificationSoundPlayerWithSound:[SDSound applyFile:@"CityBuild.wav" volume:0.15] notificationHandle:TRLevel.buildCityNotification condition:^BOOL(TRCity* _) {
    return [[level cities] count] > 2;
}], [EGNotificationSoundPlayer applySound:[SDSound applyFile:@"RefuseBuild.wav" volume:0.2] notificationHandle:TRRailroadBuilder.refuseBuildNotification]])];
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


