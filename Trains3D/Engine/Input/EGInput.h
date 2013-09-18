#import "objd.h"
#import "GEVec.h"
@protocol EGCamera;
@class EGMatrixModel;

@class EGEvent;
@class EGRectIndex;
@protocol EGInputProcessor;
@protocol EGMouseProcessor;
@protocol EGTouchProcessor;

@protocol EGInputProcessor<NSObject>
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
@property (nonatomic, readonly) GEVec2 viewSize;
@property (nonatomic, readonly) id camera;

+ (id)eventWithViewSize:(GEVec2)viewSize camera:(id)camera;
- (id)initWithViewSize:(GEVec2)viewSize camera:(id)camera;
- (ODClassType*)type;
- (EGEvent*)setCamera:(id)camera;
- (GEVec2)locationInView;
- (GEVec2)location;
- (GEVec2)locationForDepth:(CGFloat)depth;
- (GEVec3)line;
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


@interface EGRectIndex : NSObject
@property (nonatomic, readonly) id<CNSeq> rects;

+ (id)rectIndexWithRects:(id<CNSeq>)rects;
- (id)initWithRects:(id<CNSeq>)rects;
- (ODClassType*)type;
- (id)applyPoint:(GEVec2)point;
+ (ODClassType*)type;
@end


