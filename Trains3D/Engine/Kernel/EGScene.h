#import "objd.h"
#import "EGTypes.h"
@protocol EGProcessor;
@protocol EGMouseProcessor;
@protocol EGTouchProcessor;
@class EGEvent;
@class EGLayer;
#import "EGVec.h"

@class EGScene;

@interface EGScene : NSObject
@property (nonatomic, readonly) id<EGController> controller;
@property (nonatomic, readonly) id<CNSeq> layers;

+ (id)sceneWithController:(id<EGController>)controller layers:(id<CNSeq>)layers;
- (id)initWithController:(id<EGController>)controller layers:(id<CNSeq>)layers;
- (ODClassType*)type;
- (void)drawWithViewSize:(EGVec2)viewSize;
- (BOOL)processEvent:(EGEvent*)event;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


