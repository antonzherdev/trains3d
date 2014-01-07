#import "EGAlert.h"

@interface EGAlertDelegate : NSObject<UIAlertViewDelegate>
- (instancetype)initWithCancelCallback:(void (^)())cancelCallback;

+ (instancetype)delegateWithCancelCallback:(void (^)())cancelCallback;

@end

@implementation EGAlertDelegate {
    void (^_cancelCallback)();
}

static NSArray* _curDelegates;
- (instancetype)initWithCancelCallback:(void (^)())cancelCallback {
    self = [super init];
    if (self) {
        _cancelCallback = cancelCallback;
    }

    return self;
}

+ (instancetype)delegateWithCancelCallback:(void (^)())cancelCallback {
    return [[self alloc] initWithCancelCallback:cancelCallback];
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    _cancelCallback();
    @synchronized (_curDelegates) {
        _curDelegates = [_curDelegates arrayByRemovingObject:self];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _cancelCallback();
    @synchronized (_curDelegates) {
        _curDelegates = [_curDelegates arrayByRemovingObject:self];
    }
}

@end

@implementation EGAlert
static ODClassType* _EGAlert_type;

+ (id)alert {
    return [[EGAlert alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGAlert_type = [ODClassType classTypeWithCls:[EGAlert class]];
    _curDelegates = [NSArray array];
}

+ (void)showErrorTitle:(NSString *)title message:(NSString *)message callback:(void (^)())callback {
    EGAlertDelegate *delegate = [EGAlertDelegate delegateWithCancelCallback:callback];
    @synchronized (_curDelegates) {
        _curDelegates = [_curDelegates arrayByAddingObject:delegate];
    }
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:delegate
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
}

- (ODClassType*)type {
    return [EGAlert type];
}

+ (ODClassType*)type {
    return _EGAlert_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


