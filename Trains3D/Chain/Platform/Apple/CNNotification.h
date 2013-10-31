#import "objdcore.h"
#import "ODObject.h"
@class ODClassType;

@class CNNotificationCenter;
@class CNNotificationObserver;

@interface CNNotificationCenter : NSObject
+ (id)notificationCenter;
- (id)init;
- (ODClassType*)type;
- (CNNotificationObserver*)addObserverName:(NSString*)name block:(void(^)(id))block;
- (void)postName:(NSString*)name data:(id)data;
+ (CNNotificationCenter*)aDefault;
+ (ODClassType*)type;
@end


@interface CNNotificationObserver : NSObject
- (instancetype)initWithObserverHandle:(id)observerHandle;

+ (instancetype)observerWithObserverHandle:(id)observerHandle;

- (ODClassType*)type;
- (void)detach;
+ (ODClassType*)type;
@end


