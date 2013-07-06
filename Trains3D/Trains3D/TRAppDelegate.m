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
    _view.director.scene = scene;
    _view.director.displayStats = YES;
}


@end
