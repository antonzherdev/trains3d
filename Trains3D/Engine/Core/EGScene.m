#import "EGScene.h"

#import "GL.h"
#import "EGContext.h"
#import "EGInput.h"
#import "EGShadow.h"
#import "GEMat4.h"
@implementation EGScene{
    GEVec4 _backgroundColor;
    id<EGController> _controller;
    EGLayers* _layers;
}
static ODClassType* _EGScene_type;
@synthesize backgroundColor = _backgroundColor;
@synthesize controller = _controller;
@synthesize layers = _layers;

+ (id)sceneWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(EGLayers*)layers {
    return [[EGScene alloc] initWithBackgroundColor:backgroundColor controller:controller layers:layers];
}

- (id)initWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(EGLayers*)layers {
    self = [super init];
    if(self) {
        _backgroundColor = backgroundColor;
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
    [_layers drawWithViewSize:viewSize];
}

- (BOOL)processEvent:(EGEvent*)event {
    return [_layers processEvent:event];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_controller updateWithDelta:delta];
    [_layers updateWithDelta:delta];
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
    return GEVec4Eq(self.backgroundColor, o.backgroundColor) && [self.controller isEqual:o.controller] && [self.layers isEqual:o.layers];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec4Hash(self.backgroundColor);
    hash = hash * 31 + [self.controller hash];
    hash = hash * 31 + [self.layers hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"backgroundColor=%@", GEVec4Description(self.backgroundColor)];
    [description appendFormat:@", controller=%@", self.controller];
    [description appendFormat:@", layers=%@", self.layers];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGLayers
static ODClassType* _EGLayers_type;

+ (id)layers {
    return [[EGLayers alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGLayers_type = [ODClassType classTypeWithCls:[EGLayers class]];
}

+ (EGSingleLayer*)applyLayer:(EGLayer*)layer {
    return [EGSingleLayer singleLayerWithLayer:layer];
}

- (id<CNSeq>)layers {
    @throw @"Method layers is abstract";
}

- (id<CNSeq>)viewportsWithViewSize:(GEVec2)viewSize {
    @throw @"Method viewportsWith is abstract";
}

- (void)drawWithViewSize:(GEVec2)viewSize {
    [[self viewportsWithViewSize:viewSize] forEach:^void(CNTuple* p) {
        [((EGLayer*)(p.a)) drawWithViewport:uwrap(GERect, p.b)];
    }];
}

- (BOOL)processEvent:(EGEvent*)event {
    __block BOOL r = NO;
    [[self viewportsWithViewSize:event.viewSize] forEach:^void(CNTuple* p) {
        r = r || [((EGLayer*)(p.a)) processEvent:event viewport:uwrap(GERect, p.b)];
    }];
    return r;
}

- (void)updateWithDelta:(CGFloat)delta {
    [[self layers] forEach:^void(EGLayer* _) {
        [_ updateWithDelta:delta];
    }];
}

- (ODClassType*)type {
    return [EGLayers type];
}

+ (ODClassType*)type {
    return _EGLayers_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSingleLayer{
    EGLayer* _layer;
    id<CNSeq> _layers;
}
static ODClassType* _EGSingleLayer_type;
@synthesize layer = _layer;
@synthesize layers = _layers;

+ (id)singleLayerWithLayer:(EGLayer*)layer {
    return [[EGSingleLayer alloc] initWithLayer:layer];
}

- (id)initWithLayer:(EGLayer*)layer {
    self = [super init];
    if(self) {
        _layer = layer;
        _layers = (@[_layer]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSingleLayer_type = [ODClassType classTypeWithCls:[EGSingleLayer class]];
}

- (id<CNSeq>)viewportsWithViewSize:(GEVec2)viewSize {
    return (@[tuple(_layer, wrap(GERect, [_layer viewportWithViewSize:viewSize]))]);
}

- (ODClassType*)type {
    return [EGSingleLayer type];
}

+ (ODClassType*)type {
    return _EGSingleLayer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSingleLayer* o = ((EGSingleLayer*)(other));
    return [self.layer isEqual:o.layer];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.layer hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"layer=%@", self.layer];
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

+ (EGLayer*)applyView:(id<EGLayerView>)view {
    return [EGLayer layerWithView:view processor:[ODObject asKindOfProtocol:@protocol(EGInputProcessor) object:view]];
}

- (void)drawWithViewport:(GERect)viewport {
    EGEnvironment* env = [_view environment];
    EGGlobal.context.environment = env;
    id<EGCamera> camera = [_view cameraWithViewport:viewport];
    NSUInteger cullFace = [camera cullFace];
    if(cullFace != GL_NONE) glEnable(GL_CULL_FACE);
    id<CNSeq> shadowLights = [[[env.lights chain] filter:^BOOL(EGLight* _) {
        return _.hasShadows;
    }] toArray];
    [[[env.lights chain] filter:^BOOL(EGLight* _) {
        return _.hasShadows;
    }] forEach:^void(EGLight* light) {
        EGGlobal.context.renderTarget = [EGShadowRenderTarget shadowRenderTargetWithShadowLight:light];
        EGGlobal.matrix.value = [light shadowMatrixModel:[camera matrixModel]];
        [light shadowMap].biasDepthCp = [EGShadowMap.biasMatrix mulMatrix:[EGGlobal.matrix.value cp]];
        [[light shadowMap] applyDraw:^void() {
            glClear(GL_DEPTH_BUFFER_BIT);
            if(cullFace != GL_NONE) glCullFace(((cullFace == GL_BACK) ? GL_FRONT : GL_BACK));
            [_view draw];
        }];
    }];
    EGGlobal.context.renderTarget = [EGSceneRenderTarget sceneRenderTarget];
    [EGGlobal.context setViewport:geRectIApplyRect(viewport)];
    EGGlobal.matrix.value = [camera matrixModel];
    if(cullFace != GL_NONE) glCullFace(cullFace);
    [_view draw];
    if(cullFace != GL_NONE) glDisable(GL_CULL_FACE);
}

- (BOOL)processEvent:(EGEvent*)event viewport:(GERect)viewport {
    return unumb([[_processor mapF:^id(id<EGInputProcessor> p) {
        if([p isProcessorActive]) {
            EGEventCamera* cam = [EGEventCamera eventCameraWithMatrix:[[[_view cameraWithViewport:viewport] matrixModel] wcp] viewport:viewport];
            EGEvent* e = [event setCamera:[CNOption applyValue:cam]];
            return numb([p processEvent:e]);
        } else {
            return @NO;
        }
    }] getOrValue:@NO]);
}

- (void)updateWithDelta:(CGFloat)delta {
    [_view updateWithDelta:delta];
}

- (GERect)viewportWithViewSize:(GEVec2)viewSize {
    return [self viewportWithViewSize:viewSize viewportLayout:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0)];
}

- (GERect)viewportWithViewSize:(GEVec2)viewSize viewportLayout:(GERect)viewportLayout {
    GERect layout = viewportLayout;
    CGFloat vpr = [[_view camera] viewportRatio];
    GEVec2 size = geVec2MulVec2(viewSize, viewportLayout.size);
    GEVec2 vpSize = ((eqf4(size.x, 0) && eqf4(size.y, 0)) ? GEVec2Make(viewSize.x, viewSize.y) : ((eqf4(size.x, 0)) ? GEVec2Make(viewSize.x, size.y) : ((eqf4(size.y, 0)) ? GEVec2Make(size.x, viewSize.y) : ((size.x / size.y < vpr) ? GEVec2Make(size.x, size.x / vpr) : GEVec2Make(size.y * vpr, size.y)))));
    GEVec2 po = geVec2AddF(geVec2DivI(viewportLayout.p0, 2), 0.5);
    return GERectMake(geVec2MulVec2(geVec2SubVec2(viewSize, vpSize), po), vpSize);
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


