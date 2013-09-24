#import "objd.h"
#import "GEVec.h"
#import "GELine.h"
@class GEMat4;

@class EGEventCamera;
@class EGEvent;
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


@interface EGEventCamera : NSObject
@property (nonatomic, readonly) GEMat4* matrix;
@property (nonatomic, readonly) GERect viewport;

+ (id)eventCameraWithMatrix:(GEMat4*)matrix viewport:(GERect)viewport;
- (id)initWithMatrix:(GEMat4*)matrix viewport:(GERect)viewport;
- (ODClassType*)type;
- (GEMat4*)inverseMatrix;
+ (ODClassType*)type;
@end


@interface EGEvent : NSObject
@property (nonatomic, readonly) GEVec2 viewSize;
@property (nonatomic, readonly) id camera;

+ (id)eventWithViewSize:(GEVec2)viewSize camera:(id)camera;
- (id)initWithViewSize:(GEVec2)viewSize camera:(id)camera;
- (ODClassType*)type;
- (GELine3)segment;
- (EGEvent*)setCamera:(id)camera;
- (GEVec2)locationInView;
- (GEVec2)location;
- (GEVec2)locationForDepth:(CGFloat)depth;
- (BOOL)checkViewport;
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


