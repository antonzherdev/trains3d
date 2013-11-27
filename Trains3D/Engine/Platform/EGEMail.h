#import "objd.h"

@class EGEMail;

#if TARGET_OS_IPHONE
#import <MessageUI/MFMailComposeViewController.h>

@interface EGEMail : NSObject <MFMailComposeViewControllerDelegate>
#else
@interface EGEMail : NSObject
#endif
+ (id)mail;
- (id)init;
- (ODClassType*)type;
- (void)showInterfaceTo:(NSString*)to;
+ (EGEMail*)instance;
+ (ODClassType*)type;
@end


