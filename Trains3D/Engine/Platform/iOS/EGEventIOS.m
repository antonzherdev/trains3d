#import "EGEventIOS.h"
#import "EGOpenGLViewIOS.h"


@implementation EGEventIOS {
    UIEvent* _event;
    UIGestureRecognizer* _recognizer;
    EGEventIOSType _type;
    __weak EGOpenGLViewIOS * _view;
}

@synthesize event = _event;
@synthesize recognizer = _recognizer;
@synthesize view = _view;

- (id)initWithEvent:(UIEvent *)event recognizer:(UIGestureRecognizer *)recognizer type:(EGEventIOSType)type view:(EGOpenGLViewIOS *)view camera:(id)camera {
    self = [super initWithViewSize:[view viewSize] camera: camera];
    if (self) {
        _event = event;
        _type=type;
        _view = view;
        _recognizer=recognizer;
    }

    return self;
}

+ (id)eventIOSWithEvent:(UIEvent *)event type:(EGEventIOSType)type view:(EGOpenGLViewIOS *)view camera:(id)camera {
    return [[self alloc] initWithEvent:event recognizer:nil type:type view:view camera:camera];
}

+ (id)eventIOSWithRecognizer:(UIGestureRecognizer *)recognizer type:(EGEventIOSType)type view:(EGOpenGLViewIOS *)view camera:(id)camera {
    return [[self alloc] initWithEvent:nil recognizer:recognizer type:type view:view camera:camera];
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
    CGPoint point;
    if(_event != nil) {
        UITouch* touch = [[_event touchesForView:view] anyObject];
        point = [touch locationInView:view];
    } else {
        point = [_recognizer locationInView:view];
    }
    CGFloat scale = [[UIScreen mainScreen] scale];
    float sy = [_view viewSize].y;
    return GEVec2Make(scale* (float) point.x, sy - scale*(float) point.y);
}

- (EGEvent *)setCamera:(id)camera {
    return [[EGEventIOS alloc] initWithEvent:_event recognizer:_recognizer type:_type view:_view camera:camera];
}

- (BOOL)isTap {
    return _type == EGEventTap;
}

@end