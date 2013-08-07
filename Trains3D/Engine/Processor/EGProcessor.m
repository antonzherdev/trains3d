#import "EGProcessor.h"

@implementation EGEvent{
    EGSize _viewSize;
    id _camera;
}
@synthesize viewSize = _viewSize;
@synthesize camera = _camera;

+ (id)eventWithViewSize:(EGSize)viewSize camera:(id)camera {
    return [[EGEvent alloc] initWithViewSize:viewSize camera:camera];
}

- (id)initWithViewSize:(EGSize)viewSize camera:(id)camera {
    self = [super init];
    if(self) {
        _viewSize = viewSize;
        _camera = camera;
    }
    
    return self;
}

- (EGEvent*)setCamera:(id)camera {
    @throw @"Method set is abstract";
}

- (EGPoint)locationInView {
    @throw @"Method locationInView is abstract";
}

- (EGPoint)location {
    return [self locationForDepth:0];
}

- (EGPoint)locationForDepth:(double)depth {
    if([_camera isEmpty]) return [self locationInView];
    else return [[_camera get] translateWithViewSize:_viewSize viewPoint:[self locationInView]];
}

- (BOOL)isLeftMouseDown {
    @throw @"Method isLeftMouseDown is abstract";
}

- (BOOL)isLeftMouseDrag {
    @throw @"Method isLeftMouseDrag is abstract";
}

- (BOOL)isLeftMouseUp {
    @throw @"Method isLeftMouseUp is abstract";
}

- (BOOL)leftMouseProcessor:(id<EGMouseProcessor>)processor {
    if([self isLeftMouseDown]) {
        return [processor mouseDownEvent:self];
    } else {
        if([self isLeftMouseDrag]) {
            return [processor mouseDragEvent:self];
        } else {
            if([self isLeftMouseUp]) return [processor mouseUpEvent:self];
            else return NO;
        }
    }
}

- (BOOL)isTouchBegan {
    @throw @"Method isTouchBegan is abstract";
}

- (BOOL)isTouchMoved {
    @throw @"Method isTouchMoved is abstract";
}

- (BOOL)isTouchEnded {
    @throw @"Method isTouchEnded is abstract";
}

- (BOOL)isTouchCanceled {
    @throw @"Method isTouchCanceled is abstract";
}

- (BOOL)touchProcessor:(id<EGTouchProcessor>)processor {
    if([self isTouchBegan]) {
        return [processor touchBeganEvent:self];
    } else {
        if([self isTouchMoved]) {
            return [processor touchMovedEvent:self];
        } else {
            if([self isTouchEnded]) {
                return [processor touchEndedEvent:self];
            } else {
                if([self isTouchCanceled]) return [processor touchCanceledEvent:self];
                else return NO;
            }
        }
    }
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


