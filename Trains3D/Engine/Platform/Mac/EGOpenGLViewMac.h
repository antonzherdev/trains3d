#import <Cocoa/Cocoa.h>

#import "EGDirector.h"

@interface EGOpenGLViewMac : NSOpenGLView
@property (readonly, nonatomic) EGDirector * director;
@property (readonly, nonatomic) GEVec2 viewSize;

- (void)lockOpenGLContext;

- (void)unlockOpenGLContext;

- (void)redraw;

- (void)clearRecognizers;

- (void)registerRecognizerType:(EGRecognizerType *)type;
@end