#import "EGAlert.h"

@implementation EGAlert
static CNClassType* _EGAlert_type;

+ (id)alert {
    return [[EGAlert alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGAlert_type = [CNClassType classTypeWithCls:[EGAlert class]];
}

+ (void)showErrorTitle:(NSString *)title message:(NSString *)message callback:(void (^)())callback {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:title];
    [alert setInformativeText:message];
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] completionHandler:^(NSModalResponse returnCode) {
        callback();
    }];
}

- (CNClassType*)type {
    return [EGAlert type];
}

+ (CNClassType*)type {
    return _EGAlert_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

+ (void)showErrorTitle:(NSString *)error message:(NSString *)message {
    [EGAlert showErrorTitle:error message:message callback:^{

    }];
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


