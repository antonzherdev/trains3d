#import "NSObject+CNOption.h"


@implementation NSObject (CNOption)
- (void)foreach:(void (^)(id))f {
    f(self);
}

- (id)or:(cnF0)f {
    return self;
}

- (id)orValue:(id)value {
    return self;
}

- (BOOL)isEmpty {
    return NO;
}

- (BOOL)isDefined {
    return YES;
}

- (id)map:(cnF)f {
    return f(self);
}


@end