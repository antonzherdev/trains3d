#import "objd.h"

@class TRNotifications;

@interface TRNotifications : NSObject
+ (id)notifications;
- (id)init;
- (ODClassType*)type;
- (void)notifyNotification:(NSString*)notification;
- (BOOL)isEmpty;
- (id)take;
+ (ODClassType*)type;
@end


