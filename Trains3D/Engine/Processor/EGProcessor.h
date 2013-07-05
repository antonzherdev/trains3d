#import "objd.h"
#import "EGTypes.h"

@class EGEvent;

@protocol EGProcessor
- (BOOL)processEvent:(EGEvent*)event;
@end


@protocol EGMouseProcessor
- (BOOL)downEvent:(EGEvent*)event;
- (BOOL)dragEvent:(EGEvent*)event;
- (BOOL)upEvent:(EGEvent*)event;
@end


@interface EGEvent : NSObject
@property (nonatomic, readonly) CGSize viewSize;
@property (nonatomic, readonly) id camera;

+ (id)eventWithViewSize:(CGSize)viewSize camera:(id)camera;
- (id)initWithViewSize:(CGSize)viewSize camera:(id)camera;
- (EGEvent*)setCamera:(id)camera;
- (CGPoint)locationInView;
- (CGPoint)location;
- (CGPoint)locationForDepth:(CGFloat)depth;
- (BOOL)isLeftMouseDown;
- (BOOL)isLeftMouseDrag;
- (BOOL)isLeftMouseUp;
- (BOOL)leftMouseProcessor:(id)processor;
@end


