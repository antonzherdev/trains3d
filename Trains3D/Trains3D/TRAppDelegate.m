#import "TRAppDelegate.h"
#import "TRLevel.h"
#import "TRLevelView.h"

@implementation TRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    EGScene *scene = [EGScene sceneWithController:[TRLevel levelWithMapSize:EGMapSizeMake(5, 3)] view:[TRLevelView levelView]];
    _view.director.scene = scene;
    _view.director.displayStats = YES;
}


@end
