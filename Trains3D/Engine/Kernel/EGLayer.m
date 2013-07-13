#import "EGLayer.h"

#import "EGProcessor.h"
@implementation EGLayer{
    id _view;
    id _processor;
}
@synthesize view = _view;
@synthesize processor = _processor;

+ (id)layerWithView:(id)view processor:(id)processor {
    return [[EGLayer alloc] initWithView:view processor:processor];
}

- (id)initWithView:(id)view processor:(id)processor {
    self = [super init];
    if(self) {
        _view = view;
        _processor = processor;
    }
    
    return self;
}

- (void)drawWithViewSize:(EGSize)viewSize {
    [[_view camera] focusForViewSize:viewSize];
    [_view drawView];
}

- (BOOL)processEvent:(EGEvent*)event {
    EGEvent* cameraEvent = [event setCamera:[_view camera]];
    return unumb([[_processor map:^id(id _) {
        return numb([_ processEvent:cameraEvent]);
    }] getOr:@NO]);
}

@end


