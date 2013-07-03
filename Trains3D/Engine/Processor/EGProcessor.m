#import "EGProcessor.h"

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

- (BOOL)isLeftMouseDown {
    @throw @"Method isLeftMouseDown is abstact";
}

- (BOOL)isLeftMouseDrag {
    @throw @"Method isLeftMouseDrag is abstact";
}

- (BOOL)isLeftMouseUp {
    @throw @"Method isLeftMouseUp is abstact";
}

- (void)leftMouseProcessor:(id)processor {
    if([self isLeftMouseDown]) {
        [processor downEvent:self];
    }
    else {
        if([self isLeftMouseDrag]) {
            [processor dragEvent:self];
        }
        else {
            if([self isLeftMouseUp]) {
                [processor upEvent:self];
            }
        }
    }
}

@end


