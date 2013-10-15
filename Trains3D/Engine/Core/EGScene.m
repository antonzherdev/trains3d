#import "EGScene.h"

#import "GL.h"
#import "EGContext.h"
#import "EGInput.h"
#import "EGSound.h"
#import "EGPlatform.h"
#import "EGShadow.h"
#import "GEMat4.h"
@implementation EGScene{
    GEVec4 _backgroundColor;
    id<EGController> _controller;
    EGLayers* _layers;
    id _soundPlayer;
}
static ODClassType* _EGScene_type;
@synthesize backgroundColor = _backgroundColor;
@synthesize controller = _controller;
@synthesize layers = _layers;
@synthesize soundPlayer = _soundPlayer;

+ (id)sceneWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(EGLayers*)layers soundPlayer:(id)soundPlayer {
    return [[EGScene alloc] initWithBackgroundColor:backgroundColor controller:controller layers:layers soundPlayer:soundPlayer];
}

- (id)initWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(EGLayers*)layers soundPlayer:(id)soundPlayer {
    self = [super init];
    if(self) {
        _backgroundColor = backgroundColor;
        _controller = controller;
        _layers = layers;
        _soundPlayer = soundPlayer;
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
    [_soundPlayer forEach:^void(id<EGSoundPlayer> _) {
        [_ updateWithDelta:delta];
    }];
}

- (void)start {
    [_soundPlayer forEach:^void(id<EGSoundPlayer> _) {
        [_ start];
    }];
}

- (void)stop {
    [_soundPlayer forEach:^void(id<EGSoundPlayer> _) {
        [_ stop];
    }];
}

- (void)pause {
    [_soundPlayer forEach:^void(id<EGSoundPlayer> _) {
        [_ pause];
    }];
}

- (void)resume {
    [_soundPlayer forEach:^void(id<EGSoundPlayer> _) {
        [_ resume];
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
    return GEVec4Eq(self.backgroundColor, o.backgroundColor) && [self.controller isEqual:o.controller] && [self.layers isEqual:o.layers] && [self.soundPlayer isEqual:o.soundPlayer];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec4Hash(self.backgroundColor);
    hash = hash * 31 + [self.controller hash];
    hash = hash * 31 + [self.layers hash];
    hash = hash * 31 + [self.soundPlayer hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"backgroundColor=%@", GEVec4Description(self.backgroundColor)];
    [description appendFormat:@", controller=%@", self.controller];
    [description appendFormat:@", layers=%@", self.layers];
    [description appendFormat:@", soundPlayer=%@", self.soundPlayer];
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
    id<CNSeq> vps = [self viewportsWithViewSize:viewSize];
    egPushGroupMarker(@"Prepare");
    [vps forEach:^void(CNTuple* p) {
        [((EGLayer*)(p.a)) prepareWithViewport:uwrap(GERect, p.b)];
    }];
    egPopGroupMarker();
    egPushGroupMarker(@"Draw");
    glClear(GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT);
    [vps forEach:^void(CNTuple* p) {
        [((EGLayer*)(p.a)) drawWithViewport:uwrap(GERect, p.b)];
    }];
    egPopGroupMarker();
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
    id _inputProcessor;
}
static ODClassType* _EGLayer_type;
@synthesize view = _view;
@synthesize inputProcessor = _inputProcessor;

+ (id)layerWithView:(id<EGLayerView>)view inputProcessor:(id)inputProcessor {
    return [[EGLayer alloc] initWithView:view inputProcessor:inputProcessor];
}

- (id)initWithView:(id<EGLayerView>)view inputProcessor:(id)inputProcessor {
    self = [super init];
    if(self) {
        _view = view;
        _inputProcessor = inputProcessor;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGLayer_type = [ODClassType classTypeWithCls:[EGLayer class]];
}

+ (EGLayer*)applyView:(id<EGLayerView>)view {
    return [EGLayer layerWithView:view inputProcessor:[ODObject asKindOfProtocol:@protocol(EGInputProcessor) object:view]];
}

- (void)prepareWithViewport:(GERect)viewport {
    egPushGroupMarker([_view name]);
    EGEnvironment* env = [_view environment];
    EGGlobal.context.environment = env;
    id<EGCamera> camera = [_view cameraWithViewport:viewport];
    NSUInteger cullFace = [camera cullFace];
    if(cullFace != GL_NONE) [EGGlobal.context.cullFace enable];
    if(egPlatform().shadows) {
        id<CNSeq> shadowLights = [[[env.lights chain] filter:^BOOL(EGLight* _) {
            return _.hasShadows;
        }] toArray];
        [[[env.lights chain] filter:^BOOL(EGLight* _) {
            return _.hasShadows;
        }] forEach:^void(EGLight* light) {
            [self drawShadowForCamera:camera light:light];
        }];
    }
    EGGlobal.context.renderTarget = [EGSceneRenderTarget sceneRenderTarget];
    [EGGlobal.context setViewport:geRectIApplyRect(viewport)];
    EGGlobal.matrix.value = [camera matrixModel];
    if(cullFace != GL_NONE) glCullFace(cullFace);
    [_view prepare];
    if(cullFace != GL_NONE) [EGGlobal.context.cullFace disable];
    egCheckError();
    egPopGroupMarker();
}

- (void)drawWithViewport:(GERect)viewport {
    egPushGroupMarker([_view name]);
    EGEnvironment* env = [_view environment];
    EGGlobal.context.environment = env;
    id<EGCamera> camera = [_view cameraWithViewport:viewport];
    NSUInteger cullFace = [camera cullFace];
    if(cullFace != GL_NONE) [EGGlobal.context.cullFace enable];
    EGGlobal.context.renderTarget = [EGSceneRenderTarget sceneRenderTarget];
    [EGGlobal.context setViewport:geRectIApplyRect(viewport)];
    EGGlobal.matrix.value = [camera matrixModel];
    if(cullFace != GL_NONE) glCullFace(cullFace);
    [_view draw];
    if(cullFace != GL_NONE) [EGGlobal.context.cullFace disable];
    egCheckError();
    egPopGroupMarker();
}

- (void)drawShadowForCamera:(id<EGCamera>)camera light:(EGLight*)light {
    egPushGroupMarker(@"Shadow");
    EGGlobal.context.renderTarget = [EGShadowRenderTarget shadowRenderTargetWithShadowLight:light];
    EGGlobal.matrix.value = [light shadowMatrixModel:[camera matrixModel]];
    [light shadowMap].biasDepthCp = [EGShadowMap.biasMatrix mulMatrix:[EGGlobal.matrix.value cp]];
    [[light shadowMap] applyDraw:^void() {
        glClear(GL_DEPTH_BUFFER_BIT);
        NSUInteger cullFace = [camera cullFace];
        if(cullFace != GL_NONE) glCullFace(((cullFace == GL_BACK) ? GL_FRONT : GL_BACK));
        [_view draw];
    }];
    egCheckError();
    egPopGroupMarker();
}

- (BOOL)processEvent:(EGEvent*)event viewport:(GERect)viewport {
    return unumb([[_inputProcessor mapF:^id(id<EGInputProcessor> p) {
        if([p isProcessorActive]) {
            id<EGCamera> camera = [_view cameraWithViewport:viewport];
            EGGlobal.matrix.value = [camera matrixModel];
            EGEventCamera* cam = [EGEventCamera eventCameraWithMatrixModel:[camera matrixModel] viewport:viewport];
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
    return [self.view isEqual:o.view] && [self.inputProcessor isEqual:o.inputProcessor];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.view hash];
    hash = hash * 31 + [self.inputProcessor hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"view=%@", self.view];
    [description appendFormat:@", inputProcessor=%@", self.inputProcessor];
    [description appendString:@">"];
    return description;
}

@end


