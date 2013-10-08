#import "EGTouchToMouse.h"

@implementation EGTouchToMouse {
    id _processor;
}
@synthesize processor = _processor;

+ (id)touchToMouseWithProcessor:(id)processor {
    return [[EGTouchToMouse alloc] initWithProcessor:processor];
}

- (id)initWithProcessor:(id)processor {
    self = [super init];
    if(self) {
        _processor = processor;
    }
    
    return self;
}

- (BOOL)touchBeganEvent:(EGEvent*)event {
    return [_processor mouseDownEvent:[EGEventEmulateMouseMove
            eventWithType:0 locationInView:[event locationInView] viewSize:[event viewSize] camera:[event camera]]];
}

- (BOOL)touchMovedEvent:(EGEvent*)event {
    return [_processor mouseDragEvent:[EGEventEmulateMouseMove
            eventWithType:1 locationInView:[event locationInView] viewSize:[event viewSize] camera:[event camera]]];;
}


- (BOOL)touchEndedEvent:(EGEvent*)event {
    return [_processor mouseUpEvent:[EGEventEmulateMouseMove
            eventWithType:2 locationInView:[event locationInView] viewSize:[event viewSize] camera:[event camera]]];;
}

- (BOOL)touchCanceledEvent:(EGEvent*)event {
    return NO;
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
    return _type == 0;
}

- (BOOL)isLeftMouseDrag {
    return _type == 1;
}

- (BOOL)isLeftMouseUp {
    return _type == 2;
}

- (GEVec2)locationInView {
    return _locationInView;
}


@end