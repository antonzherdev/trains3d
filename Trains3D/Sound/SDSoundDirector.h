#import "objd.h"

@class SDSoundDirector;

@interface SDSoundDirector : NSObject {
@private
    BOOL __enabled;
    CNNotificationHandle* _enabledChangedNotification;
    CGFloat __timeSpeed;
    CNNotificationHandle* _timeSpeedChangeNotification;
}
@property (nonatomic, readonly) CNNotificationHandle* enabledChangedNotification;
@property (nonatomic, readonly) CNNotificationHandle* timeSpeedChangeNotification;

+ (instancetype)soundDirector;
- (instancetype)init;
- (ODClassType*)type;
- (BOOL)enabled;
- (void)setEnabled:(BOOL)enabled;
- (CGFloat)timeSpeed;
- (void)setTimeSpeed:(CGFloat)timeSpeed;
+ (SDSoundDirector*)instance;
+ (ODClassType*)type;
@end


