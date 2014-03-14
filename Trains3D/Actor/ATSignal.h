#import "objd.h"
#import "ATObserver.h"

@class ATSignal;

@interface ATSignal : NSObject<ATObservableBase> {
@private
    CNAtomicObject* __observers;
}
+ (instancetype)signal;
- (instancetype)init;
- (ODClassType*)type;
- (void)postData:(id)data;
- (void)post;
+ (ODClassType*)type;
@end


