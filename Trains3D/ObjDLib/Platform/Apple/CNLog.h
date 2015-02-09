#import "objdcore.h"
#import "CNObject.h"

#if TARGET_OS_MAC
    #define cnLogInfoText(text) NSLog(@"%@", text)
#else
    #ifdef DEBUG
        #define cnLogInfoText(text) NSLog(@"%@", text)
    #else
        #import <Crashlytics/Crashlytics.h>
        #define cnLogInfoText(text) CLSLog(@"%@", text)
    #endif
#endif


static inline void cnLogParInfoText(NSString* text) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cnLogInfoText(text);
    });
}

