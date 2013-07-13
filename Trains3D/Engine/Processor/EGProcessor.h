#import "objd.h"
#import "EGTypes.h"

@class EGEvent;

@protocol EGProcessor
- (BOOL)processEvent:(EGEvent*)event;
@end


@protocol EGMouseProcessor
- (BOOL)mouseDownEvent:(EGEvent*)event;
- (BOOL)mouseDragEvent:(EGEvent*)event;
- (BOOL)mouseUpEvent:(EGEvent*)event;
@end


@protocol EGTouchProcessor
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
- (EGEvent*)setCamera:(id)camera;
- (EGPoint)locationInView;
- (EGPoint)location;
- (EGPoint)locationForDepth:(double)depth;
- (BOOL)isLeftMouseDown;
- (BOOL)isLeftMouseDrag;
- (BOOL)isLeftMouseUp;
- (BOOL)leftMouseProcessor:(id)processor;
- (BOOL)isTouchBegan;
- (BOOL)isTouchMoved;
- (BOOL)isTouchEnded;
- (BOOL)isTouchCanceled;
- (BOOL)touchProcessor:(id)processor;
@end


