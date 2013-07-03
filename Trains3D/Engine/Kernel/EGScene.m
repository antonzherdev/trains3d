#import "EGScene.h"

@implementation EGScene{
    id _controller;
    id _view;
    id _processor;
}
@synthesize controller = _controller;
@synthesize view = _view;
@synthesize processor = _processor;

+ (id)sceneWithController:(id)controller view:(id)view processor:(id)processor {
    return [[EGScene alloc] initWithController:controller view:view processor:processor];
}

- (id)initWithController:(id)controller view:(id)view processor:(id)processor {
    self = [super init];
    if(self) {
        _controller = controller;
        _view = view;
        _processor = processor;
    }
    
    return self;
}

- (void)drawWithViewSize:(CGSize)viewSize {
    [_view drawController:_controller viewSize:viewSize];
}

- (void)processEvent:(EGEvent*)event {
    [_processor processEvent:event];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_controller updateWithDelta:delta];
}

@end


