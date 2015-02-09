#import "objd.h"
#import "PGVec.h"
#import "TRLevel.h"
#import "TRCity.h"
#import "TRRailPoint.h"
#import "TRTrain.h"
#import "TRCar.h"
@class TRLevels;
@class TRLevelFactory;
@class TRWeatherRules;
@class PGDirector;
@class TRSceneFactory;
@class TRRail;
@class TRRailroad;
@class TRRailroadState;
@class TRSwitchState;
@class TRSwitch;
@class CNFuture;

@class TRDemo;

@interface TRDemo : NSObject
+ (instancetype)demo;
- (instancetype)init;
- (CNClassType*)type;
+ (CNTuple*)createCitiesCount:(NSInteger)count;
+ (void)startNumber:(NSInteger)number;
+ (void)restartLevel;
+ (CNTuple*)end;
+ (CNTuple*)createCitiesCount:(NSInteger)count;
+ (CNTuple*)buildRailroadRails:(NSArray*)rails;
+ (CNTuple*)createCitiesCities:(NSArray*)cities;
+ (CNTuple*)setSwitchesStateSwitches:(NSArray*)switches;
+ (CNTuple*)trainCars:(NSInteger)cars speed:(NSInteger)speed from:(TRCityColorR)from to:(TRCityColorR)to;
+ (CNTuple*)crazyCars:(NSInteger)cars speed:(NSInteger)speed from:(TRCityColorR)from to:(TRCityColorR)to;
+ (CNTuple*)expressCars:(NSInteger)cars speed:(NSInteger)speed from:(TRCityColorR)from to:(TRCityColorR)to;
- (NSString*)description;
+ (TRLevelRules*)demoLevel0;
+ (TRLevelRules*)demoLevel1;
+ (TRLevelRules*)demoLevel2;
+ (TRLevelRules*)demoLevel3;
+ (CNClassType*)type;
@end


