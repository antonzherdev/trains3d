#import "TRAppDelegate.h"
#import "TRLevel.h"
#import "TRLevelView.h"
#import "TRRailroad.h"
#import "EGScene.h"
#import "EGMapIso.h"
#import "TRScore.h"
#import "TRTrain.h"
#import "TRLevelFactory.h"
#import "TRRailPoint.h"

@implementation TRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSRect rect = [_window.contentView frame];
    self.view = [[EGOpenGLView alloc] initWithFrame:rect];
    _window.contentView = self.view;


    TRLevel *level = [TRLevelFactory levelWithNumber:1];
//    [level runSample];
    EGScene *scene = [TRLevelFactory sceneForLevel:level];
//    TRRailroad *railroad = level.railroad;
//    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 0) form:[TRRailForm leftRight]]];
//    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 0) form:[TRRailForm leftBottom]]];
//    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, -1) form:[TRRailForm topRight]]];
//    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, -1) form:[TRRailForm leftTop]]];
//    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 0) form:[TRRailForm bottomTop]]];
//    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 1) form:[TRRailForm bottomRight]]];
//    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 1) form:[TRRailForm leftTop]]];
//    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 2) form:[TRRailForm leftBottom]]];
    _view.director.scene = scene;
    [_view.director displayStats];
}


@end
