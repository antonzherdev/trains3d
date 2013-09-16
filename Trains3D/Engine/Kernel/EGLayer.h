#import "objd.h"
#import "EGTypes.h"
#import "GEVec.h"
@class EG;
@class EGContext;
@class EGEvent;
@protocol EGProcessor;

@class EGLayer;

@interface EGLayer : NSObject<EGController>
@property (nonatomic, readonly) id<EGView> view;
@property (nonatomic, readonly) id processor;

+ (id)layerWithView:(id<EGView>)view processor:(id)processor;
- (id)initWithView:(id<EGView>)view processor:(id)processor;
- (ODClassType*)type;
- (void)drawWithViewSize:(GEVec2)viewSize;
- (BOOL)processEvent:(EGEvent*)event;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODType*)type;
@end


