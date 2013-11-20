#import "EGTouchToMouse.h"
#import "EGEventMac.h"
#import "EGOpenGLViewMac.h"
#import "EGDirectorMac.h"

@implementation EGTouchToMouse {
    EGDirectorMac* _director;
    BOOL _touching;
    NSTouch* _startTouches[2];
    GEVec2 _touchStartPoint;
    GEVec2 _touchStartScreenPoint;
    GEVec2 _touchLastPoint;
}

+ (id)touchToMouseWithDirector:(EGDirectorMac*)director {
    return [[EGTouchToMouse alloc] initWithDirector:director];
}

- (id)initWithDirector:(EGDirectorMac*)director {
    self = [super init];
    if(self) {
        _director = director;
        _touching = NO;
    }
    
    return self;
}

- (void)touchBeganEvent:(NSEvent *)event {
    NSSet* touches = [event touchesMatchingPhase:NSTouchPhaseTouching inView:_director.view];
    if(touches.count == 2) {
        _touching = YES;
        NSArray *array = [touches allObjects];
        _startTouches[0] = [array objectAtIndex:0];
        _startTouches[1] = [array objectAtIndex:1];
        CGPoint eventLocation = CGEventGetLocation([event CGEvent]);
        _touchStartScreenPoint.x = (float) eventLocation.x;
        _touchStartScreenPoint.y = (float) eventLocation.y;
        NSPoint sp = [event locationInWindow];
        _touchStartPoint.x = (float) sp.x;
        _touchStartPoint.y = (float) sp.y;
        [_director processEvent:[EGEventMac eventMacWithEvent:event location:_touchStartPoint type:NSLeftMouseDown view:_director.view camera:nil]];
    }
}

- (void)touchMovedEvent:(NSEvent*)event {
    if(!_touching) return;

    NSSet* touches = [event touchesMatchingPhase:NSTouchPhaseTouching inView:_director.view];
    NSTouch *touch0 = [self findTouch:_startTouches[0] inTouches:touches];
    if(touch0 == nil) return ;
    NSTouch *touch1 = [self findTouch:_startTouches[1] inTouches:touches];
    if(touch1 == nil) return ;

    NSPoint np1 = _startTouches[0].normalizedPosition;
    NSPoint np2 = _startTouches[1].normalizedPosition;
    NSPoint p1 = touch0.normalizedPosition;
    NSPoint p2 = touch1.normalizedPosition;
    CGFloat w = touch0.deviceSize.width;
    CGFloat h = touch0.deviceSize.height;
    GEVec2 delta = GEVec2Make(
            (float) (3*((MIN(p1.x, p2.x) * w) - (MIN(np1.x, np2.x)* w))),
            (float) (3*((MIN(p1.y, p2.y) * h) - (MIN(np1.y, np2.y)* h)))
    );

    _touchLastPoint = geVec2AddVec2(_touchStartPoint, delta);
    CGPoint cursor = CGPointMake(_touchStartScreenPoint.x + delta.x, _touchStartScreenPoint.y - delta.y);
    CGWarpMouseCursorPosition(cursor);
    [_director processEvent:[EGEventMac eventMacWithEvent:event location:_touchLastPoint type:NSLeftMouseDragged view:_director.view camera:nil]];
}

- (NSTouch *)findTouch:(NSTouch *)touch inTouches:(NSSet *)touches {
    for(NSTouch * t in touches) {
        if([t.identity isEqual:touch.identity]) {
            return t;
        }
    }
    return nil;
}


- (void)touchEndedEvent:(NSEvent*)event {
    if(!_touching) return;

    _touching = NO;
    _startTouches[0] = nil;
    _startTouches[1] = nil;
    [_director processEvent:[EGEventMac eventMacWithEvent:event location:_touchLastPoint type:NSLeftMouseUp view:_director.view camera:nil]];
}

- (void)touchCanceledEvent:(NSEvent*)event {
    if(!_touching) return;

    _touching = NO;
    _startTouches[0] = nil;
    _startTouches[1] = nil;
    [_director processEvent:[EGEventMac eventMacWithEvent:event location:_touchLastPoint type:EGLeftMouseCanceled view:_director.view camera:nil]];
}
@end


@implementation EGEventEmulateMouseMove {
    NSUInteger _type;
    GEVec2 _locationInView;
}
- (id)initWithType:(NSUInteger)type locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize camera:(id)camera{
    self = [super initWithViewSize:viewSize camera:camera];
    if (self) {
        _locationInView = locationInView;
        _type=type;
    }

    return self;
}

+ (id)eventWithType:(NSUInteger)type locationInView:(GEVec2)locationInView  viewSize:(GEVec2)viewSize camera:(id)camera {
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

- (GEVec2)locationInView {
    return _locationInView;
}


@end