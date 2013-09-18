#import "objd.h"
#import "GEVec.h"
@class EGMatrixModel;
@class EGEvent;
@class EGGlobal;
@class EGContext;
@class EGMatrixStack;
@protocol EGProcessor;
@class EGEnvironment;

@class EGScene;
@class EGLayer;
@protocol EGController;
@protocol EGCamera;
@protocol EGLayerView;

@protocol EGController<NSObject>
- (void)updateWithDelta:(CGFloat)delta;
@end


@protocol EGCamera<NSObject>
- (void)focusForViewSize:(GEVec2)viewSize;
- (GEVec2)translateWithViewSize:(GEVec2)viewSize viewPoint:(GEVec2)viewPoint;
- (GERecti)viewportWithViewSize:(GEVec2)viewSize;
- (EGMatrixModel*)matrixModel;
@end


@interface EGScene : NSObject
@property (nonatomic, readonly) id<EGController> controller;
@property (nonatomic, readonly) id<CNSeq> layers;

+ (id)sceneWithController:(id<EGController>)controller layers:(id<CNSeq>)layers;
- (id)initWithController:(id<EGController>)controller layers:(id<CNSeq>)layers;
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
- (void)drawWithViewSize:(GEVec2)viewSize;
- (BOOL)processEvent:(EGEvent*)event;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@protocol EGLayerView<EGController>
- (id<EGCamera>)camera;
- (void)drawView;
- (EGEnvironment*)environment;
- (void)updateWithDelta:(CGFloat)delta;
@end


