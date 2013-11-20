#import "EGEventMac.h"
#import "EGOpenGLViewMac.h"


@implementation EGEventMac {
    NSEvent* _event;
    NSEventType _type;
    __weak EGOpenGLViewMac * _view;
    EGRecognizerType* _tp;
    EGEventPhase* _phase;
    GEVec2 _location;
}

@synthesize event = _event;
@synthesize view = _view;

- (id)initWithEvent:(NSEvent *)event location:(GEVec2)location type:(NSUInteger)type view:(EGOpenGLViewMac *)view camera:(id)camera {
    self = [super initWithViewSize:[view viewSize] camera: camera];
    if (self) {
        _event = event;
        _type = type;
        _view = view;
        if(type == NSLeftMouseDown) {
            _tp = [EGPan leftMouse];
            _phase = [EGEventPhase began];
        } else if(type == NSLeftMouseDragged) {
            _tp = [EGPan leftMouse];
            _phase = [EGEventPhase changed];
        } else if(type == NSLeftMouseUp) {
            _tp = [EGPan leftMouse];
            _phase = [EGEventPhase ended];
        } else if(type == EGLeftMouseCanceled) {
            _tp = [EGPan leftMouse];
            _phase = [EGEventPhase canceled];
        } else if(type == EGEventTap) {
            _tp = [EGTap tapWithFingers:1 taps:(NSUInteger) event.clickCount];
            _phase = [EGEventPhase on];
        }
        _location=location;
    }

    return self;
}

+ (id)eventMacWithEvent:(NSEvent *)event location:(GEVec2)location type:(NSUInteger)type view:(EGOpenGLViewMac *)view camera:(id)camera {
    return [[self alloc] initWithEvent:event location:location type:type view:view camera:camera];
}

- (EGRecognizerType *)recognizerType {
    return _tp;
}

- (EGEventPhase *)phase {
    return _phase;
}


- (GEVec2)locationInView {
    return _location;
}

- (EGEvent *)setCamera:(id)camera {
    return [EGEventMac eventMacWithEvent:_event location:_location type:_type view:_view camera:camera];
}

- (BOOL)isTap {
    return _type == EGEventTap;
}

@end