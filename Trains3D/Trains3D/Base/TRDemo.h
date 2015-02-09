#import "objd.h"
#import "PGVec.h"
#import "TRLevel.h"
@class TRLevels;
@class TRLevelFactory;
@class TRWeatherRules;
@class PGDirector;
@class TRSceneFactory;

@class TRDemo;

@interface TRDemo : NSObject
+ (instancetype)demo;
- (instancetype)init;
- (CNClassType*)type;
+ (void)start;
- (NSString*)description;
+ (TRLevelRules*)demoLevel1;
+ (CNClassType*)type;
@end


