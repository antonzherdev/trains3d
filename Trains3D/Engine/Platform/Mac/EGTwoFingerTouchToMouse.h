#import "objd.h"
#import "EGProcessor.h"

@class EGTwoFingerTouchToMouse;

@interface EGTwoFingerTouchToMouse : NSObject
@property (nonatomic, readonly) id processor;

+ (id)twoFingerTouchToMouseWithProcessor:(id)processor;
- (id)initWithProcessor:(id)processor;
- (BOOL)touchBeganEvent:(EGEvent*)event;
- (BOOL)touchMovedEvent:(EGEvent*)event;
- (BOOL)touchEndedEvent:(EGEvent*)event;
- (BOOL)touchCanceledEvent:(EGEvent*)event;
@end


@interface EGEventEmulateMouseMove : EGEvent
- (id)initWithType:(NSUInteger)type locationInView:(EGPoint)locationInView viewSize:(EGSize)viewSize camera:(id)camera;

+ (id)eventWithType:(NSUInteger)type locationInView:(EGPoint)locationInView viewSize:(EGSize)viewSize camera:(id)camera;

@end