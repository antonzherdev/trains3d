#import "objd.h"

@class SDSoundDirector;

@interface SDSoundDirector : NSObject
@property (nonatomic, readonly) CNNotificationHandle* enabledChangedNotification;
@property (nonatomic, readonly) CNNotificationHandle* timeSpeedChangeNotification;

+ (id)soundDirector;
- (id)init;
- (ODClassType*)type;
- (BOOL)enabled;
- (void)setEnabled:(BOOL)enabled;
- (CGFloat)timeSpeed;
- (void)setTimeSpeed:(CGFloat)timeSpeed;
+ (SDSoundDirector*)instance;
+ (ODClassType*)type;
@end


