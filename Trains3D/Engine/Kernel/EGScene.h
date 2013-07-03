#import "objd.h"
#import "EGTypes.h"
#import "EGProcessor.h"

@class EGScene;

@interface EGScene : NSObject
@property (nonatomic, readonly) id controller;
@property (nonatomic, readonly) id view;
@property (nonatomic, readonly) id processor;

+ (id)sceneWithController:(id)controller view:(id)view processor:(id)processor;
- (id)initWithController:(id)controller view:(id)view processor:(id)processor;
- (void)drawWithViewSize:(CGSize)viewSize;
- (void)processEvent:(EGEvent*)event;
- (void)updateWithDelta:(CGFloat)delta;
@end


