#import <Cocoa/Cocoa.h>

#import "EGDirector.h"

@interface EGOpenGLView : NSOpenGLView
@property (readonly, nonatomic) EGDirector * director;

- (void)lockOpenGLContext;

- (void)unlockOpenGLContext;
@end