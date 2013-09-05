#import "EGLayer.h"

#import "EGProcessor.h"
#import "EG.h"
@implementation EGLayer{
    id<EGView> _view;
    id _processor;
}
static ODClassType* _EGLayer_type;
@synthesize view = _view;
@synthesize processor = _processor;

+ (id)layerWithView:(id<EGView>)view processor:(id)processor {
    return [[EGLayer alloc] initWithView:view processor:processor];
}

- (id)initWithView:(id<EGView>)view processor:(id)processor {
    self = [super init];
    if(self) {
        _view = view;
        _processor = processor;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGLayer_type = [ODClassType classTypeWithCls:[EGLayer class]];
}

- (void)drawWithViewSize:(EGVec2)viewSize {
    [[_view camera] focusForViewSize:viewSize];
    EG.context.eyeDirection = [[_view camera] eyeDirection];
    EG.context.environment = [_view environment];
    [_view drawView];
}

- (BOOL)processEvent:(EGEvent*)event {
    EGEvent* cameraEvent = [event setCamera:[CNOption opt:[_view camera]]];
    return unumb([[_processor map:^id(id<EGProcessor> _) {
        return numb([_ processEvent:cameraEvent]);
    }] getOr:@NO]);
}

- (void)updateWithDelta:(CGFloat)delta {
    [_view updateWithDelta:delta];
}

- (ODClassType*)type {
    return [EGLayer type];
}

+ (ODClassType*)type {
    return _EGLayer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGLayer* o = ((EGLayer*)(other));
    return [self.view isEqual:o.view] && [self.processor isEqual:o.processor];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.view hash];
    hash = hash * 31 + [self.processor hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"view=%@", self.view];
    [description appendFormat:@", processor=%@", self.processor];
    [description appendString:@">"];
    return description;
}

@end


