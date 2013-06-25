#import "EGScene.h"

@implementation EGScene{
    id _controller;
    id _view;
}
@synthesize controller = _controller;
@synthesize view = _view;

+ (id)sceneWithController:(id)controller view:(id)view {
    return [[EGScene alloc] initWithController:controller view:view];
}

- (id)initWithController:(id)controller view:(id)view {
    self = [super init];
    if(self) {
        _controller = controller;
        _view = view;
    }
    
    return self;
}

- (void)drawWithViewSize:(CGSize)viewSize {
    [_view drawController:_controller viewSize:viewSize];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_controller updateWithDelta:delta];
}

@end


