#import "EGEventMac.h"
#import "EGOpenGLView.h"


@implementation EGEventMac {
    NSEvent* _event;
    NSEventType _type;
    __weak EGOpenGLView* _view;
}

@synthesize event = _event;
@synthesize view = _view;

- (id)initWithEvent:(NSEvent *)event type:(NSUInteger)type view:(EGOpenGLView *)view camera:(id)camera {
    self = [super initWithViewSize:[view viewSize] camera: camera];
    if (self) {
        _event = event;
        _type=type;
        _view = view;
    }

    return self;
}

+ (id)eventMacWithEvent:(NSEvent *)event type:(NSUInteger)type view:(EGOpenGLView *)view camera:(id)camera {
    return [[self alloc] initWithEvent:event type:type view:view camera:camera];
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

- (BOOL)isTouchBegan {
    return _type == EGEventTouchBegan;
}

- (BOOL)isTouchMoved {
    return _type == EGEventTouchMoved;
}

- (BOOL)isTouchEnded {
    return _type == EGEventTouchEnded;
}

- (BOOL)isTouchCanceled {
    return _type == EGEventTouchCanceled;
}

- (GEVec2)locationInView {
    NSPoint point = [_view convertPoint:[_event locationInWindow] fromView:nil];
    return GEVec2Make((float) point.x, (float) point.y);
}

- (EGEvent *)setCamera:(id)camera {
    return [EGEventMac eventMacWithEvent:_event type:_type view:_view camera:camera];
}


@end