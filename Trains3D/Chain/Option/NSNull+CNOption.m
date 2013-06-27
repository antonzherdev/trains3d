#import "NSNull+CNOption.h"


@implementation NSNull (CNOption)
- (void)foreach:(void (^)(id))f {}

- (id)or:(cnF0)f {
    return f();
}

- (id)orValue:(id)value {
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