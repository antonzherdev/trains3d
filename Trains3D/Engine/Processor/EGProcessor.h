#import "objd.h"
#import "EGTypes.h"

@class EGEvent;

@protocol EGProcessor
- (void)processEvent:(EGEvent*)event;
@end


@protocol EGMouseProcessor
- (void)downEvent:(EGEvent*)event;
- (void)dragEvent:(EGEvent*)event;
- (void)upEvent:(EGEvent*)event;
@end


@interface EGEvent : NSObject
@property (nonatomic, readonly) CGSize viewSize;

+ (id)eventWithViewSize:(CGSize)viewSize;
- (id)initWithViewSize:(CGSize)viewSize;
- (BOOL)isLeftMouseDown;
- (BOOL)isLeftMouseDrag;
- (BOOL)isLeftMouseUp;
- (void)leftMouseProcessor:(id)processor;
@end


