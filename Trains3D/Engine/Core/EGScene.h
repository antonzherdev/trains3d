#import "objd.h"
#import "GEVec.h"
#import "EGTypes.h"
@class EGEvent;
@class EGGlobal;
@class EGContext;
@protocol EGProcessor;

@class EGScene;
@class EGLayer;
@protocol EGLayerView;

@interface EGScene : NSObject
@property (nonatomic, readonly) id<EGController> controller;
@property (nonatomic, readonly) id<CNSeq> layers;

+ (id)sceneWithController:(id<EGController>)controller layers:(id<CNSeq>)layers;
- (id)initWithController:(id<EGController>)controller layers:(id<CNSeq>)layers;
- (ODClassType*)type;
- (void)drawWithViewSize:(GEVec2)viewSize;
- (BOOL)processEvent:(EGEvent*)event;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODType*)type;
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
+ (ODType*)type;
@end


@protocol EGLayerView<EGController>
- (id<EGCamera>)camera;
- (void)drawView;
- (EGEGEnvironment*)environment;
- (void)updateWithDelta:(CGFloat)delta;
@end


