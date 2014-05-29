#import "objd.h"
#import "GEVec.h"
#import "EGController.h"
#import "EGInput.h"
@class EGMatrixModel;
@protocol EGSoundPlayer;
@class CNObserver;
@class EGDirector;
@class CNReact;
@class CNFuture;
@class CNChain;
@class EGPlatform;
@class EGOS;
@class EGGlobal;
@class EGContext;
@class EGCullFace;
@class EGSceneRenderTarget;
@class EGMatrixStack;
@class EGEnvironment;
@class EGLight;
@class EGShadowRenderTarget;
@class EGShadowMap;
@class EGMMatrixModel;
@class GEMat4;

@class EGCamera_impl;
@class EGScene;
@class EGLayers;
@class EGSingleLayer;
@class EGLayer;
@class EGLayerView_impl;
@class EGSceneView_impl;
@protocol EGCamera;
@protocol EGLayerView;
@protocol EGSceneView;

@protocol EGCamera<NSObject>
- (NSUInteger)cullFace;
- (EGMatrixModel*)matrixModel;
- (CGFloat)viewportRatio;
- (NSString*)description;
@end


@interface EGCamera_impl : NSObject<EGCamera>
+ (instancetype)camera_impl;
- (instancetype)init;
@end


@interface EGScene : NSObject {
@protected
    GEVec4 _backgroundColor;
    id<EGController> _controller;
    EGLayers* _layers;
    id<EGSoundPlayer> _soundPlayer;
    CNObserver* _pauseObserve;
}
@property (nonatomic, readonly) GEVec4 backgroundColor;
@property (nonatomic, readonly) id<EGController> controller;
@property (nonatomic, readonly) EGLayers* layers;
@property (nonatomic, readonly) id<EGSoundPlayer> soundPlayer;

+ (instancetype)sceneWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(EGLayers*)layers soundPlayer:(id<EGSoundPlayer>)soundPlayer;
- (instancetype)initWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(EGLayers*)layers soundPlayer:(id<EGSoundPlayer>)soundPlayer;
- (CNClassType*)type;
+ (EGScene*)applySceneView:(id<EGSceneView>)sceneView;
- (void)prepareWithViewSize:(GEVec2)viewSize;
- (void)reshapeWithViewSize:(GEVec2)viewSize;
- (void)drawWithViewSize:(GEVec2)viewSize;
- (void)complete;
- (id<CNSet>)recognizersTypes;
- (BOOL)processEvent:(id<EGEvent>)event;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (void)start;
- (void)stop;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGLayers : NSObject {
@protected
    NSArray* __viewports;
}
+ (instancetype)layers;
- (instancetype)init;
- (CNClassType*)type;
+ (EGSingleLayer*)applyLayer:(EGLayer*)layer;
- (NSArray*)layers;
- (NSArray*)viewportsWithViewSize:(GEVec2)viewSize;
- (void)prepare;
- (void)draw;
- (void)complete;
- (id<CNSet>)recognizersTypes;
- (BOOL)processEvent:(id<EGEvent>)event;
- (void)updateWithDelta:(CGFloat)delta;
- (void)reshapeWithViewSize:(GEVec2)viewSize;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGSingleLayer : EGLayers {
@protected
    EGLayer* _layer;
    NSArray* _layers;
}
@property (nonatomic, readonly) EGLayer* layer;
@property (nonatomic, readonly) NSArray* layers;

+ (instancetype)singleLayerWithLayer:(EGLayer*)layer;
- (instancetype)initWithLayer:(EGLayer*)layer;
- (CNClassType*)type;
- (NSArray*)viewportsWithViewSize:(GEVec2)viewSize;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGLayer : EGUpdatable_impl {
@protected
    id<EGLayerView> _view;
    id<EGInputProcessor> _inputProcessor;
    BOOL _iOS6;
    EGRecognizersState* _recognizerState;
}
@property (nonatomic, readonly) id<EGLayerView> view;
@property (nonatomic, readonly) id<EGInputProcessor> inputProcessor;

+ (instancetype)layerWithView:(id<EGLayerView>)view inputProcessor:(id<EGInputProcessor>)inputProcessor;
- (instancetype)initWithView:(id<EGLayerView>)view inputProcessor:(id<EGInputProcessor>)inputProcessor;
- (CNClassType*)type;
+ (EGLayer*)applyView:(id<EGLayerView>)view;
- (void)prepareWithViewport:(GERect)viewport;
- (void)reshapeWithViewport:(GERect)viewport;
- (void)drawWithViewport:(GERect)viewport;
- (void)completeWithViewport:(GERect)viewport;
- (void)drawShadowForCamera:(id<EGCamera>)camera light:(EGLight*)light;
- (BOOL)processEvent:(id<EGEvent>)event viewport:(GERect)viewport;
- (void)updateWithDelta:(CGFloat)delta;
+ (GERect)viewportWithViewSize:(GEVec2)viewSize viewportLayout:(GERect)viewportLayout viewportRatio:(float)viewportRatio;
- (NSString*)description;
+ (CNClassType*)type;
@end


@protocol EGLayerView<EGUpdatable>
- (NSString*)name;
- (id<EGCamera>)camera;
- (void)prepare;
- (void)draw;
- (void)complete;
- (void)updateWithDelta:(CGFloat)delta;
- (EGEnvironment*)environment;
- (void)reshapeWithViewport:(GERect)viewport;
- (GERect)viewportWithViewSize:(GEVec2)viewSize;
- (NSString*)description;
@end


@interface EGLayerView_impl : EGUpdatable_impl<EGLayerView>
+ (instancetype)layerView_impl;
- (instancetype)init;
- (void)updateWithDelta:(CGFloat)delta;
@end


@protocol EGSceneView<EGLayerView, EGController, EGInputProcessor>
- (NSString*)description;
@end


@interface EGSceneView_impl : EGLayerView_impl<EGSceneView>
+ (instancetype)sceneView_impl;
- (instancetype)init;
@end


