#import "TRAppDelegate.h"
#import "TRLevel.h"
#import "TRLevelView.h"
#import "TRLevelProcessor.h"
#import "TRRailroad.h"
#import "EGScene.h"
#import "EGLayer.h"
#import "EGMapIso.h"
#import "TRScore.h"
#import "TRTrain.h"
#import "TRLevelFactory.h"
#import "TRRailPoint.h"

@implementation TRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    TRLevel *level = [TRLevelFactory levelWithNumber:1];
//    [level runSample];
    EGScene *scene = [TRLevelFactory sceneForLevel:level];
    TRRailroad *railroad = level.railroad;
//    [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(0, 0) form:[TRRailForm leftRight]]];
//    [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, 0) form:[TRRailForm leftBottom]]];
//    [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, -1) form:[TRRailForm topRight]]];
//    [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, -1) form:[TRRailForm leftTop]]];
//    [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, 0) form:[TRRailForm bottomTop]]];
//    [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, 1) form:[TRRailForm bottomRight]]];
//    [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(3, 1) form:[TRRailForm leftTop]]];
//    [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(3, 2) form:[TRRailForm leftBottom]]];
    _view.director.scene = scene;
    [_view.director displayStats];
}


@end
