#import "NSObject+CNOption.h"
#import "TRRailroad.h"


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

- (id)filter:(cnPredicate)f {
    return f(self) ? self : [CNOption none];
}


- (id)flatMap:(cnF)f {
    return f(self);
}


- (id)get {
    return self;
}


- (id)asKindOfClass:(Class)pClass {
    return [self isKindOfClass:pClass] ? self : [CNOption none];
}

+ (id)object {
    return [NSObject new] ;
}

@end