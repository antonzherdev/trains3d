#import "TRAppDelegate.h"
#import "TRLevel.h"
#import "TRLevelView.h"
#import "TRLevelProcessor.h"

@implementation TRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    TRLevel *level = [TRLevel levelWithMapSize:EGMapSizeMake(5, 3)];
    [level.railroad tryAddRail:[TRRail railWithTile:EGMapPointMake(1, 3) start:CGPointMake(-0.5, 0) end:CGPointMake(0.5, 0)]];
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
