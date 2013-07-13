#import "EGScene.h"

#import "EGProcessor.h"
#import "EGLayer.h"
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

- (void)drawWithViewSize:(EGSize)viewSize {
    [_layers forEach:^void(EGLayer* _) {
        [_ drawWithViewSize:viewSize];
    }];
}

- (BOOL)processEvent:(EGEvent*)event {
    return unumb([[_layers reverse] fold:^id(id r, EGLayer* layer) {
        return numb(unumb(r) || [layer processEvent:event]);
    } withStart:@NO]);
}

- (void)updateWithDelta:(double)delta {
    [_controller updateWithDelta:delta];
}

@end


