#import "objd.h"

@class TRNotifications;
@protocol TRNotification;

@interface TRNotifications : NSObject
+ (id)notifications;
- (id)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@protocol TRNotification<NSObject>
@end


