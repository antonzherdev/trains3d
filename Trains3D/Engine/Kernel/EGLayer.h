#import "objd.h"
#import "EGTypes.h"
#import "EGProcessor.h"

@class EGLayer;

@interface EGLayer : NSObject
@property (nonatomic, readonly) id view;
@property (nonatomic, readonly) id processor;

+ (id)layerWithView:(id)view processor:(id)processor;
- (id)initWithView:(id)view processor:(id)processor;
- (void)drawWithViewSize:(CGSize)viewSize;
- (BOOL)processEvent:(EGEvent*)event;
@end


