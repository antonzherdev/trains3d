#import "TRAppDelegate.h"
#import "TRLevel.h"
#import "TRLevelView.h"
#import "TRLevelProcessor.h"

@implementation TRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    TRLevel *level = [TRLevel levelWithMapSize:EGISizeMake(5, 3)];
    [level.railroad tryAddRail:[TRRail railWithTile:EGIPointMake(1, 3) start:EGIPointMake(-1, 0) end:EGIPointMake(1, 0)]];
    EGScene *scene = [EGScene
            sceneWithController:level
                         layers:@[[EGLayer
                                 layerWithView:[TRLevelView levelViewWithLevel:level]
                                     processor:[TRLevelProcessor levelProcessorWithLevel:level]]]
    ];
    _view.director.scene = scene;
    _view.director.displayStats = YES;
}


@end
