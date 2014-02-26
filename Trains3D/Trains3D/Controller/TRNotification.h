#import "objd.h"

@class TRNotifications;

@interface TRNotifications : NSObject
+ (instancetype)notifications;
- (instancetype)init;
- (ODClassType*)type;
- (void)notifyNotification:(NSString*)notification;
- (BOOL)isEmpty;
- (id)take;
+ (ODClassType*)type;
@end


