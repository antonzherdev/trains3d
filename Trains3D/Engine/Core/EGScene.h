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
@property (nonatomic, readonly) id<CNSeq> layers;

+ (id)sceneWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(id<CNSeq>)layers;
- (id)initWithBackgroundColor:(GEVec4)backgroundColor controller:(id<EGController>)controller layers:(id<CNSeq>)layers;
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
- (GERect)viewportWithViewSize:(GEVec2)viewSize;
+ (ODClassType*)type;
@end


@protocol EGLayerView<EGController>
- (id<EGCamera>)camera;
- (void)drawView;
- (EGEnvironment*)environment;
- (void)updateWithDelta:(CGFloat)delta;
@end


