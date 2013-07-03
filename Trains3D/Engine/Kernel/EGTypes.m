#import "EGTypes.h"

@implementation EGEvent{
    CGSize _viewSize;
}
@synthesize viewSize = _viewSize;

+ (id)eventWithViewSize:(CGSize)viewSize {
    return [[EGEvent alloc] initWithViewSize:viewSize];
}

- (id)initWithViewSize:(CGSize)viewSize {
    self = [super init];
    if(self) {
        _viewSize = viewSize;
    }
    
    return self;
}

@end


