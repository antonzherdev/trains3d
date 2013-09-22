#import "objd.h"
#import "GEVec.h"
@class EGMatrixModel;
@class EGEvent;
@class EGGlobal;
@class EGContext;
@class EGMatrixStack;
@class GEMat4;
@class EGEventCamera;
@protocol EGInputProcessor;
@class EGEnvironment;

@class EGScene;
@class EGLayer;
@class EGLayersLayout;
@class EGSimpleLayout;
@class EGVerticalLayout;
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
@property (nonatomic, readonly) EGLayersLayout* layersLayout;

+ (id)sceneWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layersLayout:(EGLayersLayout*)layersLayout;
- (id)initWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layersLayout:(EGLayersLayout*)layersLayout;
- (ODClassType*)type;
- (void)drawWithViewSize:(GEVec2)viewSize;
- (BOOL)processEvent:(EGEvent*)event;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface EGLayer : NSObject<EGController>
@property (nonatomic, readonly) id<EGLayerView> view;
@property (nonatomic, readonly) id processor;

+ (id)layerWithView:(id<EGLayerView>)view processor:(id)processor;
- (id)initWithView:(id<EGLayerView>)view processor:(id)processor;
- (ODClassType*)type;
- (void)drawWithViewport:(GERect)viewport;
- (BOOL)processEvent:(EGEvent*)event viewport:(GERect)viewport;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface EGLayersLayout : NSObject
@property (nonatomic, readonly) GERect viewportLayout;

+ (id)layersLayoutWithViewportLayout:(GERect)viewportLayout;
- (id)initWithViewportLayout:(GERect)viewportLayout;
- (ODClassType*)type;
- (void)drawWithViewSize:(GEVec2)viewSize;
- (void)drawWithViewport:(GERect)viewport;
- (void)goViewport:(GERect)viewport f:(void(^)(EGLayersLayout*, GERect))f;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)processEvent:(EGEvent*)event viewport:(GERect)viewport;
- (void)updateWithDelta:(CGFloat)delta;
- (GERect)viewportWithViewSize:(GEVec2)viewSize;
- (float)viewportRatio;
+ (EGSimpleLayout*)applyLayer:(EGLayer*)layer;
+ (GERect)defaultViewportLayout;
+ (ODClassType*)type;
@end


@interface EGSimpleLayout : EGLayersLayout
@property (nonatomic, readonly) EGLayer* layer;

+ (id)simpleLayoutWithLayer:(EGLayer*)layer viewportLayout:(GERect)viewportLayout;
- (id)initWithLayer:(EGLayer*)layer viewportLayout:(GERect)viewportLayout;
- (ODClassType*)type;
- (float)viewportRatio;
- (void)drawWithViewport:(GERect)viewport;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)processEvent:(EGEvent*)event viewport:(GERect)viewport;
+ (EGSimpleLayout*)applyLayer:(EGLayer*)layer;
+ (ODClassType*)type;
@end


@interface EGVerticalLayout : EGLayersLayout
@property (nonatomic, readonly) id<CNSeq> items;
@property (nonatomic, readonly) float viewportRatio;

+ (id)verticalLayoutWithItems:(id<CNSeq>)items viewportLayout:(GERect)viewportLayout;
- (id)initWithItems:(id<CNSeq>)items viewportLayout:(GERect)viewportLayout;
- (ODClassType*)type;
- (void)goViewport:(GERect)viewport f:(void(^)(EGLayersLayout*, GERect))f;
- (void)updateWithDelta:(CGFloat)delta;
+ (EGVerticalLayout*)applyItems:(id<CNSeq>)items;
+ (ODClassType*)type;
@end


@protocol EGLayerView<EGController>
- (id<EGCamera>)camera;
- (void)drawView;
- (EGEnvironment*)environment;
- (void)updateWithDelta:(CGFloat)delta;
@end


