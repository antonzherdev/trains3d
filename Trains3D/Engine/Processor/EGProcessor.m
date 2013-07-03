#import "EGProcessor.h"

@implementation EGEvent{
    CGSize _viewSize;
    id _camera;
}
@synthesize viewSize = _viewSize;
@synthesize camera = _camera;

+ (id)eventWithViewSize:(CGSize)viewSize camera:(id)camera {
    return [[EGEvent alloc] initWithViewSize:viewSize camera:camera];
}

- (id)initWithViewSize:(CGSize)viewSize camera:(id)camera {
    self = [super init];
    if(self) {
        _viewSize = viewSize;
        _camera = camera;
    }
    
    return self;
}

- (EGEvent*)setCamera:(id)camera {
    @throw @"Method set is abstact";
}

- (CGPoint)locationInView {
    @throw @"Method locationInView is abstact";
}

- (CGPoint)location {
    return [self locationForDepth:0];
}

- (CGPoint)locationForDepth:(CGFloat)depth {
    if([_camera isEmpty]) {
        return [self locationInView];
    }
    else {
        return [[_camera get] translateViewPoint:[self locationInView] withViewSize:_viewSize];
    }
}

- (BOOL)isLeftMouseDown {
    @throw @"Method isLeftMouseDown is abstact";
}

- (BOOL)isLeftMouseDrag {
    @throw @"Method isLeftMouseDrag is abstact";
}

- (BOOL)isLeftMouseUp {
    @throw @"Method isLeftMouseUp is abstact";
}

- (void)leftMouseProcessor:(id)processor {
    if([self isLeftMouseDown]) {
        [processor downEvent:self];
    }
    else {
        if([self isLeftMouseDrag]) {
            [processor dragEvent:self];
        }
        else {
            if([self isLeftMouseUp]) {
                [processor upEvent:self];
            }
        }
    }
}

@end


