#import "objd.h"
#import "EGInput.h"

@class EGTouchToMouse;
@class EGDirectorMac;
@class EGOpenGLViewMac;

@interface EGTouchToMouse : NSObject

+ (id)touchToMouseWithDirector:(EGDirectorMac*)director;
- (id)initWithDirector:(EGDirectorMac*)director;

- (void)touchBeganEvent:(NSEvent *)event;
- (void)touchMovedEvent:(NSEvent*)event;
- (void)touchEndedEvent:(NSEvent*)event;
- (void)touchCanceledEvent:(NSEvent*)event;
@end


@interface EGEventEmulateMouseMove : EGEvent
- (id)initWithType:(NSUInteger)type locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize camera:(id)camera;

+ (id)eventWithType:(NSUInteger)type locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize camera:(id)camera;

@end