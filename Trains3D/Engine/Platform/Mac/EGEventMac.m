#import "EGEventMac.h"


@implementation EGEventMac {
    NSEvent* _event;
    NSEventType _type;
    CGPoint _locationInView;
}
- (id)initWithEvent:(NSEvent *)event locationInView:(CGPoint)locationInView viewSize:(CGSize)viewSize camera:(id)camera {
    self = [super initWithViewSize:viewSize camera: camera];
    if (self) {
        _event = event;
        _type = [event type];
        _locationInView = locationInView;
    }

    return self;
}

+ (id)eventMacWithEvent:(NSEvent *)event locationInView:(CGPoint)locationInWindow viewSize:(CGSize)viewSize camera:(id)camera {
    return [[self alloc] initWithEvent:event locationInView:locationInWindow viewSize:viewSize camera:camera];
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

- (EGEvent *)setCamera:(id)camera {
    return [EGEventMac eventMacWithEvent:_event locationInView:_locationInView viewSize:self.viewSize camera:camera];
}

- (CGPoint)locationInView {
    return _locationInView;
}


@end