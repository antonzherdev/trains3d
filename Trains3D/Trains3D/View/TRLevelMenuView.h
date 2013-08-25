#import "objd.h"
#import "EGTypes.h"
@class EGCamera2D;
#import "EGGL.h"
@class EGSchedule;
@class EGAnimation;
@class TRLevelRules;
@class TRLevel;
@class TRScoreRules;
@class TRScore;
@class TRTrainScore;
@class TRCityAngle;
@class TRCity;
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRObstacleType;
@class TRObstacle;
@class TRRailroad;
@class TRRailroadBuilder;
@class TRColor;

@class TRLevelMenuView;

@interface TRLevelMenuView : NSObject<EGView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<EGCamera> camera;

+ (id)levelMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (void)drawView;
@end


