#import "TRAppDelegate.h"
#import "TRLevel.h"
#import "TRLevelFactory.h"
#import "TRSceneFactory.h"

@implementation TRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSRect rect = [_window.contentView frame];
    self.view = [[EGOpenGLViewMac alloc] initWithFrame:rect];
    _window.contentView = self.view;


    TRLevel *level = [TRLevelFactory levelWithNumber:3];
    EGScene *scene = [TRSceneFactory sceneForLevel:level];
    _view.director.scene = scene;
    [_view.director displayStats];
}


@end
