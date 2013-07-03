#import "EGEventMac.h"


@implementation EGEventMac {
    NSEvent* _event;
}
- (id)initWithEvent:(NSEvent *)event viewSize:(CGSize)viewSize {
    self = [super initWithViewSize:viewSize];
    if (self) {
        _event = event;
    }

    return self;
}

+ (id)eventMacWithEvent:(NSEvent *)event viewSize:(CGSize)viewSize{
    return [[self alloc] initWithEvent:event viewSize:viewSize];
}

@end