#import "objd.h"
#import "EGTypes.h"
#import "EGProcessor.h"
#import "EGLayer.h"

@class EGScene;

@interface EGScene : NSObject
@property (nonatomic, readonly) id controller;
@property (nonatomic, readonly) NSArray* layers;

+ (id)sceneWithController:(id)controller layers:(NSArray*)layers;
- (id)initWithController:(id)controller layers:(NSArray*)layers;
- (void)drawWithViewSize:(CGSize)viewSize;
- (BOOL)processEvent:(EGEvent*)event;
- (void)updateWithDelta:(CGFloat)delta;
@end


