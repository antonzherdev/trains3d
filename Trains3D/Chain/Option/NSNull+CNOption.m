#import "NSNull+CNOption.h"


@implementation NSNull (CNOption)
- (void)forEach:(cnP)f {}

- (id)getOrElse:(cnF0)f {
    return f();
}

- (id)getOr:(id)value {
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

- (id)flatMap:(cnF)f {
    return self;
}


- (id)get {
    @throw @"Get from empty";
}

- (id)asKindOfClass:(Class)pClass1 {
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