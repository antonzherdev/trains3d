#import "EGScene.h"

@implementation EGScene{
    id _controller;
    NSArray* _layers;
}
@synthesize controller = _controller;
@synthesize layers = _layers;

+ (id)sceneWithController:(id)controller layers:(NSArray*)layers {
    return [[EGScene alloc] initWithController:controller layers:layers];
}

- (id)initWithController:(id)controller layers:(NSArray*)layers {
    self = [super init];
    if(self) {
        _controller = controller;
        _layers = layers;
    }
    
    return self;
}

- (void)drawWithViewSize:(CGSize)viewSize {
    [_layers forEach:^void(EGLayer* _) {
        [_ drawWithViewSize:viewSize];
    }];
}

- (BOOL)processEvent:(EGEvent*)event {
    return unumb([[_layers reverse] fold:^id(id r_, EGLayer* layer) {
        BOOL r = unumb(r_);
        return numb(r || [layer processEvent:event]);
    } withStart:@NO]);
}

- (void)updateWithDelta:(CGFloat)delta {
    [_controller updateWithDelta:delta];
}

@end


