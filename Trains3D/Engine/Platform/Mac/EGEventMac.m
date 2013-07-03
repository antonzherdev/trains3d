#import "EGEventMac.h"


@implementation EGEventMac {
    NSEvent* _event;
    NSEventType _type;
}
- (id)initWithEvent:(NSEvent *)event viewSize:(CGSize)viewSize {
    self = [super initWithViewSize:viewSize];
    if (self) {
        _event = event;
        _type = [event type];
    }

    return self;
}

+ (id)eventMacWithEvent:(NSEvent *)event viewSize:(CGSize)viewSize{
    return [[self alloc] initWithEvent:event viewSize:viewSize];
}

- (BOOL)isLeftMouseDown {
    return _type == NSLeftMouseDown;
}

- (BOOL)isLeftMouseDrag {
    return _type == NSLeftMouseDragged;
}

- (BOOL)isLeftMouseUp {
    return _type == NSLeftMouseUp;
}

@end