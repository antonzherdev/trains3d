#import "objd.h"
#import "GEVec.h"
#import "EGInput.h"
@class EGMatrixModel;
@protocol EGSoundPlayer;
@class EGPlatform;
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
@class EGDirector;

@class EGScene;
@class EGLayers;
@class EGSingleLayer;
@class EGLayer;
@protocol EGUpdatable;
@protocol EGController;
@protocol EGCamera;
@protocol EGLayerView;
@protocol EGSceneView;

@protocol EGUpdatable<NSObject>
- (void)updateWithDelta:(CGFloat)delta;
@end


@protocol EGController<EGUpdatable>
- (void)updateWithDelta:(CGFloat)delta;
- (void)start;
- (void)stop;
@end


@protocol EGCamera<NSObject>
- (NSUInteger)cullFace;
- (EGMatrixModel*)matrixModel;
- (CGFloat)viewportRatio;
@end


@interface EGScene : NSObject
@property (nonatomic, readonly) GEVec4 backgroundColor;
@property (nonatomic, readonly) id<EGController> controller;
@property (nonatomic, readonly) EGLayers* layers;
@property (nonatomic, readonly) id soundPlayer;

+ (instancetype)sceneWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(EGLayers*)layers soundPlayer:(id)soundPlayer;
- (instancetype)initWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(EGLayers*)layers soundPlayer:(id)soundPlayer;
- (ODClassType*)type;
+ (EGScene*)applySceneView:(id<EGSceneView>)sceneView;
- (void)prepareWithViewSize:(GEVec2)viewSize;
- (void)reshapeWithViewSize:(GEVec2)viewSize;
- (void)drawWithViewSize:(GEVec2)viewSize;
- (id<CNSet>)recognizersTypes;
- (BOOL)processEvent:(id<EGEvent>)event;
- (void)updateWithDelta:(CGFloat)delta;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
+ (ODClassType*)type;
@end


@interface EGLayers : NSObject
+ (instancetype)layers;
- (instancetype)init;
- (ODClassType*)type;
+ (EGSingleLayer*)applyLayer:(EGLayer*)layer;
- (id<CNImSeq>)layers;
- (id<CNImSeq>)viewportsWithViewSize:(GEVec2)viewSize;
- (void)prepare;
- (void)draw;
- (id<CNSet>)recognizersTypes;
- (BOOL)processEvent:(id<EGEvent>)event;
- (void)updateWithDelta:(CGFloat)delta;
- (void)reshapeWithViewSize:(GEVec2)viewSize;
+ (ODClassType*)type;
@end


@interface EGSingleLayer : EGLayers
@property (nonatomic, readonly) EGLayer* layer;
@property (nonatomic, readonly) id<CNImSeq> layers;

+ (instancetype)singleLayerWithLayer:(EGLayer*)layer;
- (instancetype)initWithLayer:(EGLayer*)layer;
- (ODClassType*)type;
- (id<CNImSeq>)viewportsWithViewSize:(GEVec2)viewSize;
+ (ODClassType*)type;
@end


@interface EGLayer : NSObject<EGUpdatable>
@property (nonatomic, readonly) id<EGLayerView> view;
@property (nonatomic, readonly) id inputProcessor;

+ (instancetype)layerWithView:(id<EGLayerView>)view inputProcessor:(id)inputProcessor;
- (instancetype)initWithView:(id<EGLayerView>)view inputProcessor:(id)inputProcessor;
- (ODClassType*)type;
+ (EGLayer*)applyView:(id<EGLayerView>)view;
- (void)prepareWithViewport:(GERect)viewport;
- (void)reshapeWithViewport:(GERect)viewport;
- (void)drawWithViewport:(GERect)viewport;
- (void)drawShadowForCamera:(id<EGCamera>)camera light:(EGLight*)light;
- (BOOL)processEvent:(id<EGEvent>)event viewport:(GERect)viewport;
- (void)updateWithDelta:(CGFloat)delta;
+ (GERect)viewportWithViewSize:(GEVec2)viewSize viewportLayout:(GERect)viewportLayout viewportRatio:(float)viewportRatio;
+ (ODClassType*)type;
@end


@protocol EGLayerView<EGUpdatable>
- (NSString*)name;
- (id<EGCamera>)camera;
- (void)prepare;
- (void)draw;
- (EGEnvironment*)environment;
- (void)updateWithDelta:(CGFloat)delta;
- (void)reshapeWithViewport:(GERect)viewport;
- (GERect)viewportWithViewSize:(GEVec2)viewSize;
@end


@protocol EGSceneView<EGLayerView, EGController , EGInputProcessor>
@end


