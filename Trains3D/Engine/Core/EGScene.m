#import "EGScene.h"

#import "EGContext.h"
#import "EGInput.h"
@implementation EGScene{
    id<EGController> _controller;
    id<CNSeq> _layers;
}
static ODClassType* _EGScene_type;
@synthesize controller = _controller;
@synthesize layers = _layers;

+ (id)sceneWithController:(id<EGController>)controller layers:(id<CNSeq>)layers {
    return [[EGScene alloc] initWithController:controller layers:layers];
}

- (id)initWithController:(id<EGController>)controller layers:(id<CNSeq>)layers {
    self = [super init];
    if(self) {
        _controller = controller;
        _layers = layers;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGScene_type = [ODClassType classTypeWithCls:[EGScene class]];
}

- (void)drawWithViewSize:(GEVec2)viewSize {
    [_layers forEach:^void(EGLayer* _) {
        [_ drawWithViewSize:viewSize];
    }];
}

- (BOOL)processEvent:(EGEvent*)event {
    return unumb([[[_layers chain] reverse] fold:^id(id r, EGLayer* layer) {
        return numb(unumb(r) || [layer processEvent:event]);
    } withStart:@NO]);
}

- (void)updateWithDelta:(CGFloat)delta {
    [_controller updateWithDelta:delta];
    [_layers forEach:^void(EGLayer* _) {
        [_ updateWithDelta:delta];
    }];
}

- (ODClassType*)type {
    return [EGScene type];
}

+ (ODClassType*)type {
    return _EGScene_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGScene* o = ((EGScene*)(other));
    return [self.controller isEqual:o.controller] && [self.layers isEqual:o.layers];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.controller hash];
    hash = hash * 31 + [self.layers hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"controller=%@", self.controller];
    [description appendFormat:@", layers=%@", self.layers];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGLayer{
    id<EGLayerView> _view;
    id _processor;
}
static ODClassType* _EGLayer_type;
@synthesize view = _view;
@synthesize processor = _processor;

+ (id)layerWithView:(id<EGLayerView>)view processor:(id)processor {
    return [[EGLayer alloc] initWithView:view processor:processor];
}

- (id)initWithView:(id<EGLayerView>)view processor:(id)processor {
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

- (void)drawWithViewSize:(GEVec2)viewSize {
    id<EGCamera> camera = [_view camera];
    [EGGlobal.context setViewport:[camera viewportWithViewSize:viewSize]];
    EGGlobal.matrix.value = [camera matrixModel];
    [camera focusForViewSize:viewSize];
    EGGlobal.context.environment = [_view environment];
    [_view drawView];
}

- (BOOL)processEvent:(EGEvent*)event {
    return unumb([[_processor mapF:^id(id<EGInputProcessor> p) {
        EGEvent* cameraEvent = [event setCamera:[CNOption applyValue:[_view camera]]];
        return numb([p processEvent:cameraEvent]);
    }] getOrValue:@NO]);
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


