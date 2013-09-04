#import <Cocoa/Cocoa.h>

#import "EGDirector.h"

@interface EGOpenGLView : NSOpenGLView
@property (readonly, nonatomic) EGDirector * director;
@property (readonly, nonatomic) EGVec2 viewSize;

- (void)lockOpenGLContext;

- (void)unlockOpenGLContext;
@end