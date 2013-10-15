#import "objd.h"
#import "GEVec.h"
@class EGMatrixModel;
@class EGEvent;
@protocol EGSoundPlayer;
@class EGGlobal;
@class EGContext;
@class EGEnablingState;
@class EGPlatform;
@class EGEnvironment;
@class EGLight;
@class EGSceneRenderTarget;
@class EGMatrixStack;
@class EGShadowRenderTarget;
@class EGShadowMap;
@class GEMat4;
@protocol EGInputProcessor;
@class EGEventCamera;

@class EGScene;
@class EGLayers;
@class EGSingleLayer;
@class EGLayer;
@protocol EGController;
@protocol EGCamera;
@protocol EGLayerView;

@protocol EGController<NSObject>
- (void)updateWithDelta:(CGFloat)delta;
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

+ (id)sceneWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(EGLayers*)layers soundPlayer:(id)soundPlayer;
- (id)initWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(EGLayers*)layers soundPlayer:(id)soundPlayer;
- (ODClassType*)type;
- (void)prepareWithViewSize:(GEVec2)viewSize;
- (void)drawWithViewSize:(GEVec2)viewSize;
- (BOOL)processEvent:(EGEvent*)event;
- (void)updateWithDelta:(CGFloat)delta;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
+ (ODClassType*)type;
@end


@interface EGLayers : NSObject
+ (id)layers;
- (id)init;
- (ODClassType*)type;
+ (EGSingleLayer*)applyLayer:(EGLayer*)layer;
- (id<CNSeq>)layers;
- (id<CNSeq>)viewportsWithViewSize:(GEVec2)viewSize;
- (void)prepareWithViewSize:(GEVec2)viewSize;
- (void)drawWithViewSize:(GEVec2)viewSize;
- (BOOL)processEvent:(EGEvent*)event;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface EGSingleLayer : EGLayers
@property (nonatomic, readonly) EGLayer* layer;
@property (nonatomic, readonly) id<CNSeq> layers;

+ (id)singleLayerWithLayer:(EGLayer*)layer;
- (id)initWithLayer:(EGLayer*)layer;
- (ODClassType*)type;
- (id<CNSeq>)viewportsWithViewSize:(GEVec2)viewSize;
+ (ODClassType*)type;
@end


@interface EGLayer : NSObject<EGController>
@property (nonatomic, readonly) id<EGLayerView> view;
@property (nonatomic, readonly) id inputProcessor;

+ (id)layerWithView:(id<EGLayerView>)view inputProcessor:(id)inputProcessor;
- (id)initWithView:(id<EGLayerView>)view inputProcessor:(id)inputProcessor;
- (ODClassType*)type;
+ (EGLayer*)applyView:(id<EGLayerView>)view;
- (void)prepareWithViewport:(GERect)viewport;
- (void)drawWithViewport:(GERect)viewport;
- (void)drawShadowForCamera:(id<EGCamera>)camera light:(EGLight*)light;
- (BOOL)processEvent:(EGEvent*)event viewport:(GERect)viewport;
- (void)updateWithDelta:(CGFloat)delta;
- (GERect)viewportWithViewSize:(GEVec2)viewSize;
- (GERect)viewportWithViewSize:(GEVec2)viewSize viewportLayout:(GERect)viewportLayout;
+ (ODClassType*)type;
@end


@protocol EGLayerView<EGController>
- (NSString*)name;
- (id<EGCamera>)camera;
- (id<EGCamera>)cameraWithViewport:(GERect)viewport;
- (void)prepare;
- (void)draw;
- (EGEnvironment*)environment;
- (void)updateWithDelta:(CGFloat)delta;
@end


