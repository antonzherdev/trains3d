#import "TRAppDelegate.h"
#import "TRGameDirector.h"

@implementation TRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSRect rect = [_window.contentView frame];
    self.view = [[EGOpenGLViewMac alloc] initWithFrame:rect];
    _window.contentView = self.view;

    _view.director.scene = [[TRGameDirector instance] restoreLastScene];
    [_view.director displayStats];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [[TRGameDirector instance] synchronize];
}


@end
