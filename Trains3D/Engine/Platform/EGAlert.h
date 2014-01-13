#import "objd.h"

@class EGAlert;

@interface EGAlert : NSObject
+ (id)alert;
- (id)init;
- (ODClassType*)type;

+ (void)showErrorTitle:(NSString *)title message:(NSString *)message callback:(void (^)())callback;
+ (ODClassType*)type;

+ (void)showErrorTitle:(NSString *)error message:(NSString *)message;
@end


