#import "EGTwoFingerTouchToMouse.h"
#import "EGEventMac.h"
#import "EGOpenGLView.h"

@implementation EGTwoFingerTouchToMouse{
    id _processor;
    BOOL _touching;
    NSTouch* _startTouches[2];
    CGPoint _touchStartPoint;
    CGPoint _touchStartScreenPoint;
    CGPoint _touchLastPoint;
}
@synthesize processor = _processor;

+ (id)twoFingerTouchToMouseWithProcessor:(id)processor {
    return [[EGTwoFingerTouchToMouse alloc] initWithProcessor:processor];
}

- (id)initWithProcessor:(id)processor {
    self = [super init];
    if(self) {
        _processor = processor;
        _touching = NO;
    }
    
    return self;
}

- (BOOL)touchBeganEvent:(EGEvent*)event {
    NSEvent * e= [(EGEventMac*)event event];
    __weak NSView *view = [(EGEventMac*)event view];
    NSSet* touches = [e touchesMatchingPhase:NSTouchPhaseTouching inView:view];
    if(touches.count == 2) {
        _touching = YES;
        NSArray *array = [touches allObjects];
        _startTouches[0] = [array objectAtIndex:0];
        _startTouches[1] = [array objectAtIndex:1];
        _touchStartScreenPoint = CGEventGetLocation([e CGEvent]);
        _touchStartPoint = [event locationInView];
        [_processor mouseDownEvent:[EGEventEmulateMouseMove
                eventWithType:NSLeftMouseDown locationInView:_touchStartPoint viewSize:[event viewSize] camera:[event camera]]];
        return YES;
    }
    return NO;
}

- (BOOL)touchMovedEvent:(EGEvent*)event {
    if(!_touching) return NO;

    NSEvent * e= [(EGEventMac*)event event];
    __weak NSView *view = [(EGEventMac*)event view];
    NSSet* touches = [e touchesMatchingPhase:NSTouchPhaseTouching inView:view];
    NSTouch *touch0 = [self findTouch:_startTouches[0] inTouches:touches];
    if(touch0 == nil) return YES;
    NSTouch *touch1 = [self findTouch:_startTouches[1] inTouches:touches];
    if(touch1 == nil) return YES;

    NSPoint np1 = _startTouches[0].normalizedPosition;
    NSPoint np2 = _startTouches[1].normalizedPosition;
    NSPoint p1 = touch0.normalizedPosition;
    NSPoint p2 = touch1.normalizedPosition;
    CGFloat w = touch0.deviceSize.width;
    CGFloat h = touch0.deviceSize.height;
    CGPoint delta = egp(
            3*((MIN(p1.x, p2.x) * w) - (MIN(np1.x, np2.x)* w)),
            3*((MIN(p1.y, p2.y) * h) - (MIN(np1.y, np2.y)* h))
    );


    _touchLastPoint = egpAdd(_touchStartPoint, delta);
    CGPoint cursor = egp(_touchStartScreenPoint.x + delta.x, _touchStartScreenPoint.y - delta.y);
    CGWarpMouseCursorPosition(cursor);
    [_processor mouseDragEvent:[EGEventEmulateMouseMove
                 eventWithType:NSLeftMouseDragged locationInView:_touchLastPoint viewSize:[event viewSize] camera:[event camera]]];

    return YES;
}

- (NSTouch *)findTouch:(NSTouch *)touch inTouches:(NSSet *)touches {
    for(NSTouch * t in touches) {
        if([t.identity isEqual:touch.identity]) {
            return t;
        }
    }
    return nil;
}


- (BOOL)touchEndedEvent:(EGEvent*)event {
    if(!_touching) return NO;

    _touching = NO;
    _startTouches[0] = nil;
    _startTouches[1] = nil;
    [_processor mouseUpEvent:[EGEventEmulateMouseMove
            eventWithType:NSLeftMouseDragged locationInView:_touchLastPoint viewSize:[event viewSize] camera:[event camera]]];

    return YES;
}

- (BOOL)touchCanceledEvent:(EGEvent*)event {
    return YES;
}
@end


@implementation EGEventEmulateMouseMove {
    NSUInteger _type;
    CGPoint _locationInView;
}
- (id)initWithType:(NSUInteger)type locationInView:(CGPoint)locationInView viewSize:(CGSize)viewSize camera:(id)camera{
    self = [super initWithViewSize:viewSize camera:camera];
    if (self) {
        _locationInView = locationInView;
        _type=type;
    }

    return self;
}

+ (id)eventWithType:(NSUInteger)type locationInView:(CGPoint)locationInView  viewSize:(CGSize)viewSize camera:(id)camera {
    return [[self alloc] initWithType:type locationInView:locationInView viewSize:viewSize camera:camera];
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

- (CGPoint)locationInView {
    return _locationInView;
}


@end