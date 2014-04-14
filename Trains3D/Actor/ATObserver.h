#import "objd.h"

@class ATObserver;
@class ATSignal;
@protocol ATObservable;
@protocol ATObservableBase;

@protocol ATObservable<NSObject>
- (void)attachObserver:(ATObserver*)observer;
- (void)detachObserver:(ATObserver*)observer;
- (ATObserver*)observeF:(void(^)(id))f;
@end


@protocol ATObservableBase<ATObservable>
- (void)attachObserver:(ATObserver*)observer;
- (void)detachObserver:(ATObserver*)observer;
- (void)notifyValue:(id)value;
- (BOOL)hasObservers;
@end


@interface ATObserver : NSObject {
@protected
    id<ATObservable> _observable;
    void(^_f)(id);
}
@property (nonatomic, readonly) id<ATObservable> observable;
@property (nonatomic, readonly) void(^f)(id);

+ (instancetype)observerWithObservable:(id<ATObservable>)observable f:(void(^)(id))f;
- (instancetype)initWithObservable:(id<ATObservable>)observable f:(void(^)(id))f;
- (ODClassType*)type;
- (void)detach;
- (void)dealloc;
+ (ODClassType*)type;
@end


@interface ATSignal : NSObject<ATObservableBase> {
@protected
    CNAtomicObject* __observers;
}
+ (instancetype)signal;
- (instancetype)init;
- (ODClassType*)type;
- (void)postData:(id)data;
- (void)post;
+ (ODClassType*)type;
@end


