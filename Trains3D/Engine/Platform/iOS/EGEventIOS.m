#import "EGEventIOS.h"
#import "EGOpenGLViewIOS.h"


@implementation EGEventIOS {
    UIEvent* _event;
    EGEventIOSType _type;
    __weak EGOpenGLViewIOS * _view;
}

@synthesize event = _event;
@synthesize view = _view;

- (id)initWithEvent:(UIEvent *)event type:(EGEventIOSType)type view:(EGOpenGLViewIOS *)view camera:(id)camera {
    self = [super initWithViewSize:[view viewSize] camera: camera];
    if (self) {
        _event = event;
        _type=type;
        _view = view;
    }

    return self;
}

+ (id)eventIOSWithEvent:(UIEvent *)event type:(EGEventIOSType)type view:(EGOpenGLViewIOS *)view camera:(id)camera {
    return [[self alloc] initWithEvent:event type:type view:view camera:camera];
}

- (BOOL)isLeftMouseDown {
    return NO;
}

- (BOOL)isLeftMouseDrag {
    return NO;
}

- (BOOL)isLeftMouseUp {
    return NO;
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
    UIView *view = [_view view];
    UITouch* touch = [[_event touchesForView:view] anyObject];
    CGPoint point = [touch locationInView:view];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat scale = [[UIScreen mainScreen] scale];
    return GEVec2Make(scale* (float) point.y, scale*(float) point.x);
}

- (EGEvent *)setCamera:(id)camera {
    return [EGEventIOS eventIOSWithEvent:_event type:_type view:_view camera:camera];
}


@end