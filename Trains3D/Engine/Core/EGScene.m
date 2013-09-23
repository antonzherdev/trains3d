#import "EGScene.h"

#import "EGContext.h"
#import "EGInput.h"
#import "GEMat4.h"
@implementation EGScene{
    GEVec4 _backgroundColor;
    id<EGController> _controller;
    EGLayersLayout* _layersLayout;
}
static ODClassType* _EGScene_type;
@synthesize backgroundColor = _backgroundColor;
@synthesize controller = _controller;
@synthesize layersLayout = _layersLayout;

+ (id)sceneWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layersLayout:(EGLayersLayout*)layersLayout {
    return [[EGScene alloc] initWithBackgroundColor:backgroundColor controller:controller layersLayout:layersLayout];
}

- (id)initWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layersLayout:(EGLayersLayout*)layersLayout {
    self = [super init];
    if(self) {
        _backgroundColor = backgroundColor;
        _controller = controller;
        _layersLayout = layersLayout;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGScene_type = [ODClassType classTypeWithCls:[EGScene class]];
}

- (void)drawWithViewSize:(GEVec2)viewSize {
    [_layersLayout drawWithViewSize:viewSize];
}

- (BOOL)processEvent:(EGEvent*)event {
    return [_layersLayout processEvent:event];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_controller updateWithDelta:delta];
    [_layersLayout updateWithDelta:delta];
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
    return GEVec4Eq(self.backgroundColor, o.backgroundColor) && [self.controller isEqual:o.controller] && [self.layersLayout isEqual:o.layersLayout];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec4Hash(self.backgroundColor);
    hash = hash * 31 + [self.controller hash];
    hash = hash * 31 + [self.layersLayout hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"backgroundColor=%@", GEVec4Description(self.backgroundColor)];
    [description appendFormat:@", controller=%@", self.controller];
    [description appendFormat:@", layersLayout=%@", self.layersLayout];
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

- (void)drawWithViewport:(GERect)viewport {
    EGGlobal.context.environment = [_view environment];
    id<EGCamera> camera = [_view camera];
    [EGGlobal.context setViewport:geRectiApplyRect(viewport)];
    EGGlobal.matrix.value = [camera matrixModelWithViewport:viewport];
    [camera focus];
    [_view drawView];
}

- (BOOL)processEvent:(EGEvent*)event viewport:(GERect)viewport {
    return unumb([[_processor mapF:^id(id<EGInputProcessor> p) {
        EGEventCamera* cam = [EGEventCamera eventCameraWithInverseMatrix:[[[[_view camera] matrixModelWithViewport:viewport] wcp] inverse] viewport:viewport];
        EGEvent* e = [event setCamera:[CNOption applyValue:cam]];
        return numb([p processEvent:e]);
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


@implementation EGLayersLayout{
    GERect _viewportLayout;
}
static GERect _EGLayersLayout_defaultViewportLayout;
static ODClassType* _EGLayersLayout_type;
@synthesize viewportLayout = _viewportLayout;

+ (id)layersLayoutWithViewportLayout:(GERect)viewportLayout {
    return [[EGLayersLayout alloc] initWithViewportLayout:viewportLayout];
}

- (id)initWithViewportLayout:(GERect)viewportLayout {
    self = [super init];
    if(self) _viewportLayout = viewportLayout;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGLayersLayout_type = [ODClassType classTypeWithCls:[EGLayersLayout class]];
    _EGLayersLayout_defaultViewportLayout = geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0);
}

- (void)drawWithViewSize:(GEVec2)viewSize {
    [self drawWithViewport:[self viewportWithViewSize:viewSize]];
}

- (void)drawWithViewport:(GERect)viewport {
    [self goViewport:viewport f:^void(EGLayersLayout* item, GERect vp) {
        [item drawWithViewport:vp];
    }];
}

- (void)goViewport:(GERect)viewport f:(void(^)(EGLayersLayout*, GERect))f {
    @throw @"Method go is abstract";
}

- (BOOL)processEvent:(EGEvent*)event {
    return [self processEvent:event viewport:[self viewportWithViewSize:event.viewSize]];
}

- (BOOL)processEvent:(EGEvent*)event viewport:(GERect)viewport {
    __block BOOL r = NO;
    [self goViewport:viewport f:^void(EGLayersLayout* item, GERect vp) {
        r = r || [item processEvent:event viewport:vp];
    }];
    return r;
}

- (void)updateWithDelta:(CGFloat)delta {
    @throw @"Method updateWith is abstract";
}

- (GERect)viewportWithViewSize:(GEVec2)viewSize {
    GERect layout = _viewportLayout;
    float vpr = [self viewportRatio];
    GEVec2 size = geVec2MulVec2(viewSize, layout.size);
    GEVec2 vpSize = ((size.x / size.y < vpr) ? GEVec2Make(size.x, size.x / vpr) : GEVec2Make(size.y * vpr, size.y));
    GEVec2 po = geVec2AddF(geVec2DivI(layout.origin, 2), 0.5);
    return GERectMake(geVec2MulVec2(geVec2SubVec2(viewSize, vpSize), po), vpSize);
}

- (float)viewportRatio {
    @throw @"Method viewportRatio is abstract";
}

+ (EGSimpleLayout*)applyLayer:(EGLayer*)layer {
    return [EGSimpleLayout simpleLayoutWithLayer:layer viewportLayout:_EGLayersLayout_defaultViewportLayout];
}

- (ODClassType*)type {
    return [EGLayersLayout type];
}

+ (GERect)defaultViewportLayout {
    return _EGLayersLayout_defaultViewportLayout;
}

+ (ODClassType*)type {
    return _EGLayersLayout_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGLayersLayout* o = ((EGLayersLayout*)(other));
    return GERectEq(self.viewportLayout, o.viewportLayout);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GERectHash(self.viewportLayout);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"viewportLayout=%@", GERectDescription(self.viewportLayout)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSimpleLayout{
    EGLayer* _layer;
}
static ODClassType* _EGSimpleLayout_type;
@synthesize layer = _layer;

+ (id)simpleLayoutWithLayer:(EGLayer*)layer viewportLayout:(GERect)viewportLayout {
    return [[EGSimpleLayout alloc] initWithLayer:layer viewportLayout:viewportLayout];
}

- (id)initWithLayer:(EGLayer*)layer viewportLayout:(GERect)viewportLayout {
    self = [super initWithViewportLayout:viewportLayout];
    if(self) _layer = layer;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSimpleLayout_type = [ODClassType classTypeWithCls:[EGSimpleLayout class]];
}

- (float)viewportRatio {
    return ((float)([[_layer.view camera] viewportRatio]));
}

- (void)drawWithViewport:(GERect)viewport {
    [_layer drawWithViewport:viewport];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_layer updateWithDelta:delta];
}

- (BOOL)processEvent:(EGEvent*)event viewport:(GERect)viewport {
    return [_layer processEvent:event viewport:viewport];
}

+ (EGSimpleLayout*)applyLayer:(EGLayer*)layer {
    return [EGSimpleLayout simpleLayoutWithLayer:layer viewportLayout:[EGSimpleLayout defaultViewportLayout]];
}

- (ODClassType*)type {
    return [EGSimpleLayout type];
}

+ (ODClassType*)type {
    return _EGSimpleLayout_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSimpleLayout* o = ((EGSimpleLayout*)(other));
    return [self.layer isEqual:o.layer] && GERectEq(self.viewportLayout, o.viewportLayout);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.layer hash];
    hash = hash * 31 + GERectHash(self.viewportLayout);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"layer=%@", self.layer];
    [description appendFormat:@", viewportLayout=%@", GERectDescription(self.viewportLayout)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGVerticalLayout{
    id<CNSeq> _items;
    float _viewportRatio;
}
static ODClassType* _EGVerticalLayout_type;
@synthesize items = _items;
@synthesize viewportRatio = _viewportRatio;

+ (id)verticalLayoutWithItems:(id<CNSeq>)items viewportLayout:(GERect)viewportLayout {
    return [[EGVerticalLayout alloc] initWithItems:items viewportLayout:viewportLayout];
}

- (id)initWithItems:(id<CNSeq>)items viewportLayout:(GERect)viewportLayout {
    self = [super initWithViewportLayout:viewportLayout];
    if(self) {
        _items = items;
        _viewportRatio = ((float)(unumf([[_items chain] foldStart:@0.0 by:^id(id r, EGLayersLayout* item) {
            if(eqf(unumi(r), 0)) {
                return numf(((CGFloat)([item viewportRatio])));
            } else {
                float b = [item viewportRatio];
                return numf((2 * unumi(r) * b) / (unumf(r) + b));
            }
        }])));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGVerticalLayout_type = [ODClassType classTypeWithCls:[EGVerticalLayout class]];
}

- (void)goViewport:(GERect)viewport f:(void(^)(EGLayersLayout*, GERect))f {
    __block CGFloat h = 0.0;
    __block float y = geRectY(viewport);
    [_items forEach:^void(EGLayersLayout* item) {
        GERect v = [item viewportWithViewSize:GEVec2Make(viewport.size.x, viewport.size.y - h)];
        f(item, GERectMake(GEVec2Make(geRectX(viewport), y), v.size));
        y += geRectHeight(v);
        h += ((CGFloat)(geRectHeight(v)));
    }];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_items forEach:^void(EGLayersLayout* _) {
        [_ updateWithDelta:delta];
    }];
}

+ (EGVerticalLayout*)applyItems:(id<CNSeq>)items {
    return [EGVerticalLayout verticalLayoutWithItems:items viewportLayout:[EGVerticalLayout defaultViewportLayout]];
}

- (ODClassType*)type {
    return [EGVerticalLayout type];
}

+ (ODClassType*)type {
    return _EGVerticalLayout_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVerticalLayout* o = ((EGVerticalLayout*)(other));
    return [self.items isEqual:o.items] && GERectEq(self.viewportLayout, o.viewportLayout);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.items hash];
    hash = hash * 31 + GERectHash(self.viewportLayout);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"items=%@", self.items];
    [description appendFormat:@", viewportLayout=%@", GERectDescription(self.viewportLayout)];
    [description appendString:@">"];
    return description;
}

@end


