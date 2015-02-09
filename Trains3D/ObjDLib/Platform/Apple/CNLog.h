#import "objdcore.h"
#import "CNObject.h"
#import <Crashlytics/Crashlytics.h>

//#define cnLogInfoText(text) CLS_LOG(@"%@", text)
#define cnLogInfoText(text) NSLog(@"%@", text)

static inline void cnLogParInfoText(NSString* text) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%@", text);
    });
}

