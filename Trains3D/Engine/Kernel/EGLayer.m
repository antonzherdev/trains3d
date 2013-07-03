#import "EGLayer.h"

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

- (void)drawWithViewSize:(CGSize)viewSize {
    [[_view camera] focusForViewSize:viewSize];
    [_view drawView];
}

- (BOOL)processEvent:(EGEvent*)event {
    return unumb([[_processor map:^id(id _) {
        return numb([_ processEvent:event]);
    }] getOrElse:^id() {
        return @NO;
    }]);
}

@end


