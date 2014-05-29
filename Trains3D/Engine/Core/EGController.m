#import "EGController.h"

@implementation EGUpdatable_impl

+ (instancetype)updatable_impl {
    return [[EGUpdatable_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (void)updateWithDelta:(CGFloat)delta {
    @throw @"Method updateWith is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGController_impl

+ (instancetype)controller_impl {
    return [[EGController_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (void)start {
}

- (void)stop {
}

- (void)updateWithDelta:(CGFloat)delta {
    @throw @"Method updateWith is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

