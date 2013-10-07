#import "objd.h"
#import "EGInput.h"

@class EGTouchToMouse;

@interface EGTouchToMouse : NSObject<EGTouchProcessor>
@property (nonatomic, readonly) id processor;

+ (id)touchToMouseWithProcessor:(id)processor;
- (id)initWithProcessor:(id)processor;
- (BOOL)touchBeganEvent:(EGEvent*)event;
- (BOOL)touchMovedEvent:(EGEvent*)event;
- (BOOL)touchEndedEvent:(EGEvent*)event;
- (BOOL)touchCanceledEvent:(EGEvent*)event;
@end


@interface EGEventEmulateMouseMove : EGEvent
- (id)initWithType:(NSUInteger)type locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize camera:(id)camera;

+ (id)eventWithType:(NSUInteger)type locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize camera:(id)camera;

@end