#import "objd.h"
#import "EGVec.h"
@protocol EGCamera;

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
@property (nonatomic, readonly) EGVec2 viewSize;
@property (nonatomic, readonly) id camera;

+ (id)eventWithViewSize:(EGVec2)viewSize camera:(id)camera;
- (id)initWithViewSize:(EGVec2)viewSize camera:(id)camera;
- (ODClassType*)type;
- (EGEvent*)setCamera:(id)camera;
- (EGVec2)locationInView;
- (EGVec2)location;
- (EGVec2)locationForDepth:(CGFloat)depth;
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


