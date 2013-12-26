#import "objd.h"

@class SDSoundDirector;

@interface SDSoundDirector : NSObject
@property (nonatomic, readonly) CNNotificationHandle* enabledChangedNotification;

+ (id)soundDirector;
- (id)init;
- (ODClassType*)type;
- (BOOL)enabled;
- (void)setEnabled:(BOOL)enabled;
+ (SDSoundDirector*)instance;
+ (ODClassType*)type;
@end


