#import "NSObject+CNOption.h"


@implementation NSObject (CNOption)
- (void)forEach:(cnP)f {
    f(self);
}

- (id)getOrElse:(cnF0)f {
    return self;
}

- (id)getOr:(id)value {
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

- (id)flatMap:(cnF)f {
    return f(self);
}


- (id)get {
    return self;
}


@end