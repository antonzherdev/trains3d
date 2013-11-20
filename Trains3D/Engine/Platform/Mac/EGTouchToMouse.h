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
