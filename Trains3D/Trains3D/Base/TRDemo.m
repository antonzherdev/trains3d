#import "TRDemo.h"

#import "TRLevels.h"
#import "TRLevelFactory.h"
#import "TRWeather.h"
#import "PGDirector.h"
#import "TRSceneFactory.h"
@implementation TRDemo
static TRLevelRules* _TRDemo_demoLevel1;
static CNClassType* _TRDemo_type;

+ (instancetype)demo {
    return [[TRDemo alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRDemo class]) {
        _TRDemo_type = [CNClassType classTypeWithCls:[TRDemo class]];
        _TRDemo_demoLevel1 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 5) theme:TRLevelTheme_leafForest trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:0.0 windStrength:0.4 blastness:0.5 blastMinLength:1.0 blastMaxLength:5.0 blastStrength:0.9 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@1.0, ([TRLevels buildRailroadRails:(@[tuple3(@1, @1, @0)])])), tuple(@10.0, [TRLevels train]), tuple(@17.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels verySlowTrain]), tuple(@20.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@5.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@40.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train])])];
    }
}

+ (void)start {
    [[PGDirector current] setScene:^PGScene*() {
        return [TRSceneFactory sceneForLevel:[TRLevel levelWithNumber:1 rules:_TRDemo_demoLevel1]];
    }];
}

- (NSString*)description {
    return @"Demo";
}

- (CNClassType*)type {
    return [TRDemo type];
}

+ (TRLevelRules*)demoLevel1 {
    return _TRDemo_demoLevel1;
}

+ (CNClassType*)type {
    return _TRDemo_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

