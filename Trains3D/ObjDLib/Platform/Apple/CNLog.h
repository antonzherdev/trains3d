#import "objdcore.h"
#import "CNObject.h"
#if TARGET_OS_IPHONE
#import <Crashlytics/Crashlytics.h>
#endif

static inline void cnLogInfoText(NSString* text) {
#if TARGET_OS_IPHONE
#if DEBUG
    NSLog(@"%@", text);
#else
    CLSLog(@"%@", text);
#endif
#else
    NSLog(@"%@", text);
#endif
}

static inline void cnLogParInfoText(NSString* text) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cnLogInfoText(text);
    });
}

