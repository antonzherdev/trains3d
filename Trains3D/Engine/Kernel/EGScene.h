#import "objd.h"
#import "EGTypes.h"
@protocol EGProcessor;
@protocol EGMouseProcessor;
@protocol EGTouchProcessor;
@class EGEvent;
@class EGLayer;

@class EGScene;

@interface EGScene : NSObject
@property (nonatomic, readonly) id<EGController> controller;
@property (nonatomic, readonly) id<CNList> layers;

+ (id)sceneWithController:(id<EGController>)controller layers:(id<CNList>)layers;
- (id)initWithController:(id<EGController>)controller layers:(id<CNList>)layers;
- (void)drawWithViewSize:(EGSize)viewSize;
- (BOOL)processEvent:(EGEvent*)event;
- (void)updateWithDelta:(double)delta;
@end


