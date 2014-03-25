#import "EGScene.h"

#import "GL.h"
#import "EGMatrixModel.h"
#import "ATObserver.h"
#import "EGDirector.h"
#import "EGSound.h"
#import "ATReact.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "EGContext.h"
#import "EGShadow.h"
#import "GEMat4.h"
@implementation EGScene
static ODClassType* _EGScene_type;
@synthesize backgroundColor = _backgroundColor;
@synthesize controller = _controller;
@synthesize layers = _layers;
@synthesize soundPlayer = _soundPlayer;

+ (instancetype)sceneWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(EGLayers*)layers soundPlayer:(id)soundPlayer {
    return [[EGScene alloc] initWithBackgroundColor:backgroundColor controller:controller layers:layers soundPlayer:soundPlayer];
}

- (instancetype)initWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(EGLayers*)layers soundPlayer:(id)soundPlayer {
    self = [super init];
    __weak EGScene* _weakSelf = self;
    if(self) {
        _backgroundColor = backgroundColor;
        _controller = controller;
        _layers = layers;
        _soundPlayer = soundPlayer;
        _pauseObserve = [[EGDirector current].isPaused observeF:^void(id p) {
            EGScene* _self = _weakSelf;
            if(unumb(p)) [_self->_soundPlayer forEach:^void(id<EGSoundPlayer> _) {
                [((id<EGSoundPlayer>)(_)) pause];
            }];
            else [_self->_soundPlayer forEach:^void(id<EGSoundPlayer> _) {
                [((id<EGSoundPlayer>)(_)) resume];
            }];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGScene class]) _EGScene_type = [ODClassType classTypeWithCls:[EGScene class]];
}

+ (EGScene*)applySceneView:(id<EGSceneView>)sceneView {
    return [EGScene sceneWithBackgroundColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) controller:sceneView layers:[EGLayers applyLayer:[EGLayer layerWithView:sceneView inputProcessor:[CNOption applyValue:sceneView]]] soundPlayer:[CNOption none]];
}

- (void)prepareWithViewSize:(GEVec2)viewSize {
    [_layers prepare];
}

- (void)reshapeWithViewSize:(GEVec2)viewSize {
    [_layers reshapeWithViewSize:viewSize];
}

- (void)drawWithViewSize:(GEVec2)viewSize {
    [_layers draw];
}

- (void)complete {
    [_layers complete];
}

- (id<CNSet>)recognizersTypes {
    return [_layers recognizersTypes];
}

- (BOOL)processEvent:(id<EGEvent>)event {
    return [_layers processEvent:event];
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [CNFuture applyF:^id() {
        [_controller updateWithDelta:delta];
        [_layers updateWithDelta:delta];
        [_soundPlayer forEach:^void(id<EGSoundPlayer> _) {
            [((id<EGSoundPlayer>)(_)) updateWithDelta:delta];
        }];
        return nil;
    }];
}

- (void)start {
    [_soundPlayer forEach:^void(id<EGSoundPlayer> _) {
        [((id<EGSoundPlayer>)(_)) start];
    }];
    [_controller start];
}

- (void)stop {
    [_soundPlayer forEach:^void(id<EGSoundPlayer> _) {
        [((id<EGSoundPlayer>)(_)) stop];
    }];
    [_controller stop];
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

+ (instancetype)layers {
    return [[EGLayers alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) __viewports = (@[]);
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGLayers class]) _EGLayers_type = [ODClassType classTypeWithCls:[EGLayers class]];
}

+ (EGSingleLayer*)applyLayer:(EGLayer*)layer {
    return [EGSingleLayer singleLayerWithLayer:layer];
}

- (id<CNImSeq>)layers {
    @throw @"Method layers is abstract";
}

- (id<CNImSeq>)viewportsWithViewSize:(GEVec2)viewSize {
    @throw @"Method viewportsWith is abstract";
}

- (void)prepare {
    [__viewports forEach:^void(CNTuple* p) {
        [((EGLayer*)(((CNTuple*)(p)).a)) prepareWithViewport:uwrap(GERect, ((CNTuple*)(p)).b)];
    }];
}

- (void)draw {
    [__viewports forEach:^void(CNTuple* p) {
        [((EGLayer*)(((CNTuple*)(p)).a)) drawWithViewport:uwrap(GERect, ((CNTuple*)(p)).b)];
    }];
}

- (void)complete {
    [__viewports forEach:^void(CNTuple* p) {
        [((EGLayer*)(((CNTuple*)(p)).a)) completeWithViewport:uwrap(GERect, ((CNTuple*)(p)).b)];
    }];
}

- (id<CNSet>)recognizersTypes {
    return [[[[[[self layers] chain] flatMap:^id(EGLayer* _) {
        return ((EGLayer*)(_)).inputProcessor;
    }] flatMap:^id<CNImSeq>(id<EGInputProcessor> _) {
        return [((id<EGInputProcessor>)(_)) recognizers].items;
    }] map:^EGRecognizerType*(EGRecognizer* _) {
        return ((EGRecognizer*)(_)).tp;
    }] toSet];
}

- (BOOL)processEvent:(id<EGEvent>)event {
    __block BOOL r = NO;
    [[[__viewports chain] reverse] forEach:^void(CNTuple* p) {
        r = r || [((EGLayer*)(((CNTuple*)(p)).a)) processEvent:event viewport:uwrap(GERect, ((CNTuple*)(p)).b)];
    }];
    return r;
}

- (void)updateWithDelta:(CGFloat)delta {
    [[self layers] forEach:^void(EGLayer* _) {
        [((EGLayer*)(_)) updateWithDelta:delta];
    }];
}

- (void)reshapeWithViewSize:(GEVec2)viewSize {
    __viewports = [self viewportsWithViewSize:viewSize];
    [__viewports forEach:^void(CNTuple* p) {
        [((EGLayer*)(((CNTuple*)(p)).a)) reshapeWithViewport:uwrap(GERect, ((CNTuple*)(p)).b)];
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSingleLayer
static ODClassType* _EGSingleLayer_type;
@synthesize layer = _layer;
@synthesize layers = _layers;

+ (instancetype)singleLayerWithLayer:(EGLayer*)layer {
    return [[EGSingleLayer alloc] initWithLayer:layer];
}

- (instancetype)initWithLayer:(EGLayer*)layer {
    self = [super init];
    if(self) {
        _layer = layer;
        _layers = (@[_layer]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSingleLayer class]) _EGSingleLayer_type = [ODClassType classTypeWithCls:[EGSingleLayer class]];
}

- (id<CNImSeq>)viewportsWithViewSize:(GEVec2)viewSize {
    return (@[tuple(_layer, (wrap(GERect, [_layer.view viewportWithViewSize:viewSize])))]);
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"layer=%@", self.layer];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGLayer
static ODClassType* _EGLayer_type;
@synthesize view = _view;
@synthesize inputProcessor = _inputProcessor;

+ (instancetype)layerWithView:(id<EGLayerView>)view inputProcessor:(id)inputProcessor {
    return [[EGLayer alloc] initWithView:view inputProcessor:inputProcessor];
}

- (instancetype)initWithView:(id<EGLayerView>)view inputProcessor:(id)inputProcessor {
    self = [super init];
    if(self) {
        _view = view;
        _inputProcessor = inputProcessor;
        _iOS6 = [egPlatform() isIOSLessVersion:@"7"];
        _recognizerState = [EGRecognizersState recognizersStateWithRecognizers:[[_inputProcessor mapF:^EGRecognizers*(id<EGInputProcessor> _) {
            return [((id<EGInputProcessor>)(_)) recognizers];
        }] getOrElseF:^EGRecognizers*() {
            return [EGRecognizers recognizersWithItems:(@[])];
        }]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGLayer class]) _EGLayer_type = [ODClassType classTypeWithCls:[EGLayer class]];
}

+ (EGLayer*)applyView:(id<EGLayerView>)view {
    return [EGLayer layerWithView:view inputProcessor:[ODObject asKindOfProtocol:@protocol(EGInputProcessor) object:view]];
}

- (void)prepareWithViewport:(GERect)viewport {
    egPushGroupMarker(([NSString stringWithFormat:@"Prepare %@", [_view name]]));
    EGEnvironment* env = [_view environment];
    EGGlobal.context.environment = env;
    id<EGCamera> camera = [_view camera];
    NSUInteger cullFace = [camera cullFace];
    [EGGlobal.context.cullFace setValue:((unsigned int)(cullFace))];
    EGGlobal.context.renderTarget = [EGSceneRenderTarget sceneRenderTarget];
    [EGGlobal.context setViewport:geRectIApplyRect(viewport)];
    [EGGlobal.matrix setValue:[camera matrixModel]];
    [_view prepare];
    egPopGroupMarker();
    if(egPlatform().shadows) {
        [[[env.lights chain] filter:^BOOL(EGLight* _) {
            return ((EGLight*)(_)).hasShadows;
        }] forEach:^void(EGLight* light) {
            egPushGroupMarker(([NSString stringWithFormat:@"Shadow %@", [_view name]]));
            [EGGlobal.context.cullFace invertedF:^void() {
                [self drawShadowForCamera:camera light:light];
            }];
            egPopGroupMarker();
        }];
        if(_iOS6) glFinish();
    }
    egCheckError();
}

- (void)reshapeWithViewport:(GERect)viewport {
    [EGGlobal.context setViewport:geRectIApplyRect(viewport)];
    [_view reshapeWithViewport:viewport];
}

- (void)drawWithViewport:(GERect)viewport {
    egPushGroupMarker([_view name]);
    EGEnvironment* env = [_view environment];
    EGGlobal.context.environment = env;
    id<EGCamera> camera = [_view camera];
    [EGGlobal.context.cullFace setValue:((unsigned int)([camera cullFace]))];
    EGGlobal.context.renderTarget = [EGSceneRenderTarget sceneRenderTarget];
    [EGGlobal.context setViewport:geRectIApplyRect(viewport)];
    [EGGlobal.matrix setValue:[camera matrixModel]];
    [_view draw];
    egCheckError();
    egPopGroupMarker();
}

- (void)completeWithViewport:(GERect)viewport {
    [_view complete];
}

- (void)drawShadowForCamera:(id<EGCamera>)camera light:(EGLight*)light {
    EGGlobal.context.renderTarget = [EGShadowRenderTarget shadowRenderTargetWithShadowLight:light];
    [EGGlobal.matrix setValue:[light shadowMatrixModel:[camera matrixModel]]];
    [light shadowMap].biasDepthCp = [EGShadowMap.biasMatrix mulMatrix:[[EGGlobal.matrix value] cp]];
    if(EGGlobal.context.redrawShadows) [[light shadowMap] applyDraw:^void() {
        glClear(GL_DEPTH_BUFFER_BIT);
        [_view draw];
    }];
    egCheckError();
}

- (BOOL)processEvent:(id<EGEvent>)event viewport:(GERect)viewport {
    if([_inputProcessor isDefined] && [((id<EGInputProcessor>)([_inputProcessor get])) isProcessorActive]) {
        id<EGCamera> camera = [_view camera];
        [EGGlobal.matrix setValue:[camera matrixModel]];
        return [_recognizerState processEvent:[EGCameraEvent cameraEventWithEvent:event matrixModel:[camera matrixModel] viewport:viewport]];
    } else {
        return NO;
    }
}

- (void)updateWithDelta:(CGFloat)delta {
    [_view updateWithDelta:delta];
}

+ (GERect)viewportWithViewSize:(GEVec2)viewSize viewportLayout:(GERect)viewportLayout viewportRatio:(float)viewportRatio {
    GEVec2 size = geVec2MulVec2(viewSize, viewportLayout.size);
    GEVec2 vpSize = ((eqf4(size.x, 0) && eqf4(size.y, 0)) ? GEVec2Make(viewSize.x, viewSize.y) : ((eqf4(size.x, 0)) ? GEVec2Make(viewSize.x, size.y) : ((eqf4(size.y, 0)) ? GEVec2Make(size.x, viewSize.y) : ((size.x / size.y < viewportRatio) ? GEVec2Make(size.x, size.x / viewportRatio) : GEVec2Make(size.y * viewportRatio, size.y)))));
    GEVec2 po = geVec2AddF((geVec2DivI(viewportLayout.p, 2)), 0.5);
    return GERectMake((geVec2MulVec2((geVec2SubVec2(viewSize, vpSize)), po)), vpSize);
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"view=%@", self.view];
    [description appendFormat:@", inputProcessor=%@", self.inputProcessor];
    [description appendString:@">"];
    return description;
}

@end


