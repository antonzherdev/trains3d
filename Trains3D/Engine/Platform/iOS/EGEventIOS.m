#import "EGEventIOS.h"
#import "EGOpenGLViewIOS.h"


@implementation EGEventIOS {
    EGRecognizerType* _tp;
    EGEventPhase* _phase;
    GEVec2 _location;
    __weak EGOpenGLViewIOS * _view;
}

@synthesize view = _view;

- (instancetype)initWithTp:(EGRecognizerType *)tp phase:(EGEventPhase *)phase location:(GEVec2)location view:(__weak EGOpenGLViewIOS *)view camera:(id)camera {
    self = [super initWithViewSize:[view viewSize] camera:camera];
    if (self) {
        _tp = tp;
        _phase = phase;
        _location = location;
        _view = view;
    }

    return self;
}

+ (instancetype)eventIOsWithTp:(EGRecognizerType *)tp phase:(EGEventPhase *)phase location:(GEVec2)location view:(__weak EGOpenGLViewIOS *)view  camera:(id)camera {
    return [[self alloc] initWithTp:tp phase:phase location:location view:view camera:camera];
}

- (GEVec2)locationInView {
    return _location;
//    UIView *view = [_view view];
//    CGPoint point;
//    if(_event != nil) {
//        UITouch* touch = [[_event touchesForView:view] anyObject];
//        point = [touch locationInView:view];
//    } else {
//        point = [_recognizer locationInView:view];
//    }
//    CGFloat scale = [[UIScreen mainScreen] scale];
//    float sy = [_view viewSize].y;
//    return GEVec2Make(scale* (float) point.x, sy - scale*(float) point.y);
}

- (EGEvent *)setCamera:(id)camera {
    return [[EGEventIOS alloc] initWithTp:_tp phase:_phase location:_location view:_view camera:camera];
}

- (EGEventPhase *)phase {
    return _phase;
}

- (EGRecognizerType *)recognizerType {
    return _tp;
}

@end