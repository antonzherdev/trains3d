#import "NSNull+CNOption.h"


@implementation NSNull (CNOption)
- (void)forEach:(cnP)f {}

- (id)getOrElse:(cnF0)f {
    return f();
}

- (id)getOrValue:(id)value {
    return value;
}

- (BOOL)isEmpty {
    return YES;
}

- (BOOL)isDefined {
    return NO;
}

- (id)map:(cnF)f {
    return self;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if(signature != nil) return signature;
    signature = [NSMethodSignature signatureWithObjCTypes:"@"];
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {

}

@end