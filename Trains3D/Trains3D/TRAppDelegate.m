#import "TRAppDelegate.h"
#import "TRLevel.h"
#import "TRLevelView.h"
#import "TRLevelProcessor.h"
#import "TRRailroad.h"
#import "EGScene.h"
#import "EGLayer.h"

@implementation TRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    TRLevel *level = [TRLevel levelWithMapSize:EGISizeMake(5, 3)];
    [level runSample];
    EGScene *scene = [EGScene
            sceneWithController:level
                         layers:@[[EGLayer
                                 layerWithView:[TRLevelView levelViewWithLevel:level]
                                     processor:[TRLevelProcessor levelProcessorWithLevel:level]]]
    ];
    TRRailroad *railroad = level.railroad;
    [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(0, 0) form:[TRRailForm leftRight]]];
    [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(1, 0) form:[TRRailForm leftBottom]]];
    [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(1, -1) form:[TRRailForm topRight]]];
    [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(2, -1) form:[TRRailForm leftTop]]];
    [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(2, 0) form:[TRRailForm bottomTop]]];
    [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(2, 1) form:[TRRailForm bottomRight]]];
    [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(3, 1) form:[TRRailForm leftTop]]];
    [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(3, 2) form:[TRRailForm leftBottom]]];
    _view.director.scene = scene;
    _view.director.displayStats = YES;
}


@end
