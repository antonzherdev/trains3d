#import "objd.h"
#import "GEVec.h"
@class EGMatrixModel;
@class EGEvent;
@class EGGlobal;
@class EGContext;
@class EGMatrixStack;
@class EGEnvironment;
@class EGLight;
@class EGShadowMap;
@class EGTexture;
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
- (void)focus;
- (EGMatrixModel*)matrixModel;
- (CGFloat)viewportRatio;
@end


@interface EGScene : NSObject
@property (nonatomic, readonly) GEVec4 backgroundColor;
@property (nonatomic, readonly) id<EGController> controller;
@property (nonatomic, readonly) EGLayers* layers;

+ (id)sceneWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(EGLayers*)layers;
- (id)initWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(EGLayers*)layers;
- (ODClassType*)type;
- (void)drawWithViewSize:(GEVec2)viewSize;
- (BOOL)processEvent:(EGEvent*)event;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface EGLayers : NSObject
+ (id)layers;
- (id)init;
- (ODClassType*)type;
+ (EGSingleLayer*)applyLayer:(EGLayer*)layer;
- (id<CNSeq>)layers;
- (id<CNSeq>)viewportsWithViewSize:(GEVec2)viewSize;
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
@property (nonatomic, readonly) id processor;
@property (nonatomic) NSInteger saveCounter;

+ (id)layerWithView:(id<EGLayerView>)view processor:(id)processor;
- (id)initWithView:(id<EGLayerView>)view processor:(id)processor;
- (ODClassType*)type;
+ (EGLayer*)applyView:(id<EGLayerView>)view;
- (void)drawWithViewport:(GERect)viewport;
- (BOOL)processEvent:(EGEvent*)event viewport:(GERect)viewport;
- (void)updateWithDelta:(CGFloat)delta;
- (GERect)viewportWithViewSize:(GEVec2)viewSize;
- (GERect)viewportWithViewSize:(GEVec2)viewSize viewportLayout:(GERect)viewportLayout;
+ (ODClassType*)type;
@end


@protocol EGLayerView<EGController>
- (id<EGCamera>)camera;
- (id<EGCamera>)cameraWithViewport:(GERect)viewport;
- (void)draw;
- (EGEnvironment*)environment;
- (void)updateWithDelta:(CGFloat)delta;
@end


