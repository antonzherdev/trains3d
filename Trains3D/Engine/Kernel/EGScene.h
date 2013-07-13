#import "objd.h"
#import "EGTypes.h"
@class EGProcessor;
@class EGMouseProcessor;
@class EGTouchProcessor;
@class EGEvent;
@class EGLayer;

@class EGScene;

@interface EGScene : NSObject
@property (nonatomic, readonly) id controller;
@property (nonatomic, readonly) NSArray* layers;

+ (id)sceneWithController:(id)controller layers:(NSArray*)layers;
- (id)initWithController:(id)controller layers:(NSArray*)layers;
- (void)drawWithViewSize:(EGSize)viewSize;
- (BOOL)processEvent:(EGEvent*)event;
- (void)updateWithDelta:(double)delta;
@end


