#import "objdcore.h"
#import "ODObject.h"
@class CNNotificationCenter;
@class CNNotificationObserver;
@class ODClassType;

@class CNNotificationHandle;

@interface CNNotificationHandle : NSObject
@property (nonatomic, readonly) NSString* name;

+ (id)notificationHandleWithName:(NSString*)name;
- (id)initWithName:(NSString*)name;
- (ODClassType*)type;
- (void)postData:(id)data;
- (void)post;
- (CNNotificationObserver*)observeBy:(void(^)(id))by;
+ (ODClassType*)type;
@end


