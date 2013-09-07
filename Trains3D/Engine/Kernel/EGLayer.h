#import "objd.h"
#import "EGTypes.h"
@protocol EGProcessor;
@protocol EGMouseProcessor;
@protocol EGTouchProcessor;
@class EGEvent;
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
#import "EGVec.h"

@class EGLayer;

@interface EGLayer : NSObject<EGController>
@property (nonatomic, readonly) id<EGView> view;
@property (nonatomic, readonly) id processor;

+ (id)layerWithView:(id<EGView>)view processor:(id)processor;
- (id)initWithView:(id<EGView>)view processor:(id)processor;
- (ODClassType*)type;
- (void)drawWithViewSize:(EGVec2)viewSize;
- (BOOL)processEvent:(EGEvent*)event;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


