#import "objdcore.h"
#import "ODObject.h"
@class CNNotificationCenter;
@class ODClassType;

@class CNNotificationHandle;

@interface CNNotificationHandle : NSObject
@property (nonatomic, readonly) NSString* name;

+ (id)notificationHandleWithName:(NSString*)name;
- (id)initWithName:(NSString*)name;
- (ODClassType*)type;
- (void)postData:(id)data;
- (void)post;
- (void)observeBy:(void(^)(id))by;
+ (ODClassType*)type;
@end


