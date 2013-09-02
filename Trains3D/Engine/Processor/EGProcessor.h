#import "objd.h"
#import "EGTypes.h"

@class EGEvent;
@protocol EGProcessor;
@protocol EGMouseProcessor;
@protocol EGTouchProcessor;

@protocol EGProcessor<NSObject>
- (BOOL)processEvent:(EGEvent*)event;
@end


@protocol EGMouseProcessor<NSObject>
- (BOOL)mouseDownEvent:(EGEvent*)event;
- (BOOL)mouseDragEvent:(EGEvent*)event;
- (BOOL)mouseUpEvent:(EGEvent*)event;
@end


@protocol EGTouchProcessor<NSObject>
- (BOOL)touchBeganEvent:(EGEvent*)event;
- (BOOL)touchMovedEvent:(EGEvent*)event;
- (BOOL)touchEndedEvent:(EGEvent*)event;
- (BOOL)touchCanceledEvent:(EGEvent*)event;
@end


@interface EGEvent : NSObject
@property (nonatomic, readonly) EGSize viewSize;
@property (nonatomic, readonly) id camera;

+ (id)eventWithViewSize:(EGSize)viewSize camera:(id)camera;
- (id)initWithViewSize:(EGSize)viewSize camera:(id)camera;
- (ODClassType*)type;
- (EGEvent*)setCamera:(id)camera;
- (EGPoint)locationInView;
- (EGPoint)location;
- (EGPoint)locationForDepth:(CGFloat)depth;
- (BOOL)isLeftMouseDown;
- (BOOL)isLeftMouseDrag;
- (BOOL)isLeftMouseUp;
- (BOOL)leftMouseProcessor:(id<EGMouseProcessor>)processor;
- (BOOL)isTouchBegan;
- (BOOL)isTouchMoved;
- (BOOL)isTouchEnded;
- (BOOL)isTouchCanceled;
- (BOOL)touchProcessor:(id<EGTouchProcessor>)processor;
+ (ODClassType*)type;
@end


