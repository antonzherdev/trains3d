#import "objd.h"
#import "EGTypes.h"
@protocol EGProcessor;
@protocol EGMouseProcessor;
@protocol EGTouchProcessor;
@class EGEvent;
@class EG;
@class EGContext;
@class EGMutableMatrix;

@class EGLayer;

@interface EGLayer : NSObject
@property (nonatomic, readonly) id<EGView> view;
@property (nonatomic, readonly) id processor;

+ (id)layerWithView:(id<EGView>)view processor:(id)processor;
- (id)initWithView:(id<EGView>)view processor:(id)processor;
- (ODClassType*)type;
- (void)drawWithViewSize:(EGSize)viewSize;
- (BOOL)processEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


