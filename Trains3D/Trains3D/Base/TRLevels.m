#import "TRLevels.h"

#import "TRLevel.h"
#import "TRLevelFactory.h"
#import "TRWeather.h"
#import "TRStrings.h"
#import "TRTrain.h"
#import "TRCar.h"
#import "TRGameDirector.h"
#import "TRScore.h"
#import "TRCity.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
@implementation TRLevels
static NSInteger _TRLevels_level1TrainComingPeriod = 4;
static TRLevelRules* _TRLevels_level1;
static TRLevelRules* _TRLevels_level2;
static TRLevelRules* _TRLevels_level3;
static TRLevelRules* _TRLevels_level4;
static TRLevelRules* _TRLevels_level5;
static TRLevelRules* _TRLevels_level6;
static NSInteger _TRLevels_stdTrainComingPeriod = 10;
static TRLevelRules* _TRLevels_level7;
static TRLevelRules* _TRLevels_level8;
static TRLevelRules* _TRLevels_level9;
static TRLevelRules* _TRLevels_level10;
static TRLevelRules* _TRLevels_level11;
static TRLevelRules* _TRLevels_level12;
static TRLevelRules* _TRLevels_level13;
static TRLevelRules* _TRLevels_level14;
static TRLevelRules* _TRLevels_level15;
static TRLevelRules* _TRLevels_level16;
static NSArray* _TRLevels_rules;
static ODClassType* _TRLevels_type;

+ (instancetype)levels {
    return [[TRLevels alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevels class]) {
        _TRLevels_type = [ODClassType classTypeWithCls:[TRLevels class]];
        _TRLevels_level1 = [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 3) theme:TRLevelTheme.forest trainComingPeriod:((NSUInteger)(_TRLevels_level1TrainComingPeriod)) scoreRules:[TRLevels scoreRulesWithInitialScore:20000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.2 blastness:0.05 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@1.0, [TRLevels showHelpText:[TRStr.Loc helpConnectTwoCities]]), tuple(@20.0, [TRLevels trainCars:[CNRange applyI:2] speed:[CNRange applyI:30]]), tuple(numf(((CGFloat)(_TRLevels_level1TrainComingPeriod + 7))), [TRLevels showTrainHelp]), tuple(@0.0, [TRLevels awaitBy:[TRLevels noTrains]]), tuple(@1.0, [TRLevels createNewCity]), tuple(@1.0, [TRLevels showHelpText:[TRStr.Loc helpNewCity]]), tuple(@20.0, [TRLevels trainCars:[CNRange applyI:1] speed:[CNRange applyI:30]]), tuple(numf(((CGFloat)(_TRLevels_level1TrainComingPeriod + 3))), [TRLevels showTrainHelpWithSwitches]), tuple(@0.0, [TRLevels awaitBy:[TRLevels noTrains]]), tuple(@2.0, [TRLevels trainCars:[CNRange applyI:3] speed:[CNRange applyI:30]]), tuple(@1.0, [TRLevels showHelpText:[TRStr.Loc helpRules]])])];
        _TRLevels_level2 = [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 3) theme:TRLevelTheme.forest trainComingPeriod:7 scoreRules:[TRLevels scoreRulesWithInitialScore:20000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.2 blastness:0.1 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@1.0, [TRLevels showHelpKey:@"help.tozoom" text:[TRStr.Loc helpToMakeZoom]]), tuple(@9.0, [TRLevels slowTrain]), tuple(@5.0, [TRLevels showHelpKey:@"help.remove" text:[TRStr.Loc helpToRemove]]), tuple(@15.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels slowTrain])])];
        _TRLevels_level3 = [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 3) theme:TRLevelTheme.forest trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:30000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:0.0 windStrength:0.3 blastness:0.3 blastMinLength:1.0 blastMaxLength:5.0 blastStrength:0.6 precipitation:[TRLevels lightRain]] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@1.0, [TRLevels showHelpKey:@"help.linesAdvice" text:[TRStr.Loc linesAdvice]]), tuple(@9.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@10.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain])])];
        _TRLevels_level4 = [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 3) theme:TRLevelTheme.forest trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:40000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.1 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@1.0, [TRLevels showHelpKey:@"help.rewind" text:[TRStr.Loc helpRewind]]), tuple(@12.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@35.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@15.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@40.0, [TRLevels slowTrain]), tuple(@0.0, [TRLevels slowTrain]), tuple(@40.0, [TRLevels slowTrain]), tuple(@5.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@40.0, [TRLevels slowTrain]), tuple(@5.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@40.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain])])];
        _TRLevels_level5 = [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 5) theme:TRLevelTheme.forest trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.05 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.1 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels slowTrain]), tuple(@17.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@50.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels slowTrain]), tuple(@15.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels slowTrain]), tuple(@22.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@40.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels slowTrain]), tuple(@15.0, [TRLevels slowTrain]), tuple(@60.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@40.0, [TRLevels slowTrain]), tuple(@5.0, [TRLevels slowTrain]), tuple(@15.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@60.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels slowTrain]), tuple(@60.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@15.0, [TRLevels slowTrain])])];
        _TRLevels_level6 = [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 5) theme:TRLevelTheme.winter trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.05 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.1 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels train]), tuple(@17.0, [TRLevels train]), tuple(@30.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@22.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@60.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@20.0, [TRLevels train])])];
        _TRLevels_level7 = [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 5) theme:TRLevelTheme.winter trainComingPeriod:((NSUInteger)(_TRLevels_stdTrainComingPeriod)) scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.05 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.1 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels expressTrain]), tuple(numf(((CGFloat)(_TRLevels_stdTrainComingPeriod + 3))), [TRLevels showHelpKey:@"help.express" text:[TRStr.Loc helpExpressTrain]]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@13.0, [TRLevels train]), tuple(@23.0, [TRLevels train]), tuple(@23.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@35.0, [TRLevels train]), tuple(@50.0, [TRLevels verySlowTrain]), tuple(@18.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@13.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels verySlowTrain]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@12.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@22.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@50.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@60.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain])])];
        _TRLevels_level8 = [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 5) theme:TRLevelTheme.winter trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:0.0 windStrength:0.3 blastness:0.3 blastMinLength:1.0 blastMaxLength:5.0 blastStrength:0.6 precipitation:[TRLevels snow]] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels train]), tuple(@17.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@25.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@0.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@22.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@40.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@22.0, [TRLevels expressTrain]), tuple(@50.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@12.0, [TRLevels train]), tuple(@22.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@5.0, [TRLevels train]), tuple(@25.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@0.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@60.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@25.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train])])];
        _TRLevels_level9 = [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 5) theme:TRLevelTheme.leafForest trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.1 blastness:0.05 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.05 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@10.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@22.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@12.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@40.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@25.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@60.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@50.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@60.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train])])];
        _TRLevels_level10 = [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 5) theme:TRLevelTheme.leafForest trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:0.0 windStrength:0.4 blastness:0.5 blastMinLength:1.0 blastMaxLength:5.0 blastStrength:0.9 precipitation:[TRLevels rain]] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels train]), tuple(@17.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels verySlowTrain]), tuple(@20.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@5.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@40.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train])])];
        _TRLevels_level11 = [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 5) theme:TRLevelTheme.leafForest trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.2 blastness:0.1 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.2 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:500 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@30.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@25.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@17.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels expressTrain]), tuple(@5.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@50.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain])])];
        _TRLevels_level12 = [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 5) theme:TRLevelTheme.palm trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.3 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:400 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels expressTrain]), tuple(@17.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@23.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@18.0, [TRLevels train]), tuple(@18.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels expressTrain]), tuple(@25.0, [TRLevels verySlowTrain]), tuple(@13.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels train]), tuple(@0.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@40.0, [TRLevels expressTrain]), tuple(@3.0, [TRLevels expressTrain]), tuple(@17.0, [TRLevels train]), tuple(@17.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@18.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@5.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@18.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@50.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@50.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train])])];
        _TRLevels_level13 = [TRLevelRules levelRulesWithMapSize:[TRLevels bigSize] theme:TRLevelTheme.palm trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:70000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.3 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:400 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels expressTrain]), tuple(@17.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels expressTrain]), tuple(@3.0, [TRLevels verySlowTrain]), tuple(@17.0, [TRLevels train]), tuple(@17.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels expressTrain]), tuple(@7.0, [TRLevels train]), tuple(@18.0, [TRLevels train]), tuple(@5.0, [TRLevels verySlowTrain]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@5.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@0.0, [TRLevels verySlowTrain]), tuple(@50.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@50.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels expressTrain]), tuple(@60.0, [TRLevels train]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train])])];
        _TRLevels_level14 = [TRLevelRules levelRulesWithMapSize:[TRLevels bigSize] theme:TRLevelTheme.palm trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:70000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.1 blastness:0.1 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.1 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:400 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@30.0, [TRLevels crazyTrain]), tuple(@20.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels verySlowTrain]), tuple(@13.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels train]), tuple(@7.0, [TRLevels verySlowTrain]), tuple(@18.0, [TRLevels train]), tuple(@5.0, [TRLevels verySlowTrain]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@0.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@20.0, [TRLevels crazyTrain]), tuple(@50.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@1.0, [TRLevels expressTrain]), tuple(@1.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@1.0, [TRLevels expressTrain]), tuple(@50.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@50.0, [TRLevels expressTrain]), tuple(@1.0, [TRLevels expressTrain]), tuple(@2.0, [TRLevels expressTrain]), tuple(@3.0, [TRLevels expressTrain]), tuple(@4.0, [TRLevels expressTrain]), tuple(@60.0, [TRLevels train]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels crazyTrain])])];
        _TRLevels_level15 = [TRLevelRules levelRulesWithMapSize:[TRLevels bigSize] theme:TRLevelTheme.palm trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:70000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:0.0 windStrength:0.3 blastness:0.3 blastMinLength:1.0 blastMaxLength:5.0 blastStrength:0.7 precipitation:[TRLevels rain]] repairerSpeed:20 sporadicDamagePeriod:400 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@18.0, [TRLevels verySlowTrain]), tuple(@20.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@25.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@40.0, [TRLevels expressTrain]), tuple(@1.0, [TRLevels expressTrain]), tuple(@5.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@12.0, [TRLevels train]), tuple(@35.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels crazyTrain]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@40.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@4.0, [TRLevels train]), tuple(@3.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@60.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@60.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@50.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain])])];
        _TRLevels_level16 = [TRLevelRules levelRulesWithMapSize:[TRLevels bigSize] theme:TRLevelTheme.palm trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:70000] rewindRules:TRLevelFactory.rewindRules weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.1 blastness:0.1 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.1 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:380 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels crazyTrain]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@15.0, [TRLevels createNewCity]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels crazyTrain]), tuple(@40.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@40.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@50.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@5.0, [TRLevels train]), tuple(@4.0, [TRLevels expressTrain]), tuple(@3.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@60.0, [TRLevels train]), tuple(@0.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@0.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@0.0, [TRLevels expressTrain]), tuple(@60.0, [TRLevels train]), tuple(@0.0, [TRLevels crazyTrain]), tuple(@20.0, [TRLevels train]), tuple(@0.0, [TRLevels crazyTrain]), tuple(@20.0, [TRLevels train]), tuple(@0.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@50.0, [TRLevels verySlowTrain]), tuple(@0.0, [TRLevels verySlowTrain]), tuple(@0.0, [TRLevels verySlowTrain]), tuple(@0.0, [TRLevels verySlowTrain]), tuple(@60.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@60.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@60.0, [TRLevels crazyTrain]), tuple(@0.0, [TRLevels crazyTrain]), tuple(@0.0, [TRLevels crazyTrain]), tuple(@0.0, [TRLevels crazyTrain])])];
        _TRLevels_rules = (@[_TRLevels_level1, _TRLevels_level2, _TRLevels_level3, _TRLevels_level4, _TRLevels_level5, _TRLevels_level6, _TRLevels_level7, _TRLevels_level8, _TRLevels_level9, _TRLevels_level10, _TRLevels_level11, _TRLevels_level12, _TRLevels_level13, _TRLevels_level14, _TRLevels_level15, _TRLevels_level16]);
    }
}

+ (TRLevel*)levelWithNumber:(NSUInteger)number {
    if(number > [_TRLevels_rules count]) return [TRLevel levelWithNumber:[_TRLevels_rules count] rules:[_TRLevels_rules applyIndex:[_TRLevels_rules count] - 1]];
    else return [TRLevel levelWithNumber:number rules:[_TRLevels_rules applyIndex:number - 1]];
}

+ (void(^)(TRLevel*))trainCars:(CNRange*)cars speed:(CNRange*)speed {
    return ^void(TRLevel* level) {
        [level runTrainWithGenerator:[TRTrainGenerator trainGeneratorWithTrainType:TRTrainType.simple carsCount:cars speed:speed carTypes:(@[TRCarType.car, TRCarType.engine])]];
    };
}

+ (void(^)(TRLevel*))expressTrainCars:(CNRange*)cars speed:(CNRange*)speed {
    return ^void(TRLevel* level) {
        [level runTrainWithGenerator:[TRTrainGenerator trainGeneratorWithTrainType:TRTrainType.fast carsCount:cars speed:speed carTypes:(@[TRCarType.expressCar, TRCarType.expressEngine])]];
    };
}

+ (void(^)(TRLevel*))crazyTrainCars:(CNRange*)cars speed:(CNRange*)speed {
    return ^void(TRLevel* level) {
        [level runTrainWithGenerator:[TRTrainGenerator trainGeneratorWithTrainType:TRTrainType.crazy carsCount:cars speed:speed carTypes:(@[TRCarType.car, TRCarType.engine])]];
    };
}

+ (void(^)(TRLevel*))showHelpText:(NSString*)text {
    return ^void(TRLevel* level) {
        [level showHelpText:text];
    };
}

+ (void(^)(TRLevel*))showHelpKey:(NSString*)key text:(NSString*)text {
    return ^void(TRLevel* level) {
        [TRGameDirector.instance showHelpKey:key text:text];
    };
}

+ (void(^)(TRLevel*))createNewCity {
    return ^void(TRLevel* level) {
        [TRLevels createNewCityLevel:level];
    };
}

+ (void)createNewCityLevel:(TRLevel*)level {
    [level createNewCity];
}

+ (void(^)(TRLevel*))create2Cities {
    return ^void(TRLevel* level) {
        [level create2Cities];
    };
}

+ (TRPrecipitation*)lightRain {
    return [TRPrecipitation precipitationWithTp:TRPrecipitationType.rain strength:0.5];
}

+ (TRPrecipitation*)rain {
    return [TRPrecipitation precipitationWithTp:TRPrecipitationType.rain strength:1.0];
}

+ (TRPrecipitation*)snow {
    return [TRPrecipitation precipitationWithTp:TRPrecipitationType.snow strength:1.0];
}

+ (void(^)(TRLevel*))slowTrain {
    return [TRLevels trainCars:intTo(1, 4) speed:intTo(35, 40)];
}

+ (void(^)(TRLevel*))train {
    return [TRLevels trainCars:intTo(1, 5) speed:intTo(20, 50)];
}

+ (void(^)(TRLevel*))verySlowTrain {
    return [TRLevels trainCars:intTo(1, 2) speed:[CNRange applyI:15]];
}

+ (void(^)(TRLevel*))expressTrain {
    return [TRLevels expressTrainCars:intTo(3, 5) speed:intTo(75, 100)];
}

+ (void(^)(TRLevel*))crazyTrain {
    return [TRLevels crazyTrainCars:intTo(3, 5) speed:intTo(40, 60)];
}

+ (TRScoreRules*)scoreRulesWithInitialScore:(NSInteger)initialScore {
    return [TRLevelFactory scoreRulesWithInitialScore:initialScore];
}

+ (void(^)(TRLevel*))showTrainHelp {
    return ^void(TRLevel* level) {
        [[level trains] onCompleteF:^void(CNTry* t) {
            if([t isSuccess]) {
                NSArray* trains = [t get];
                {
                    TRTrain* h = [((NSArray*)(trains)) head];
                    if(h != nil) [level showHelpText:[TRStr.Loc helpTrainTo:[h.color localName]]];
                }
            }
        }];
    };
}

+ (void(^)(TRLevel*))showTrainHelpWithSwitches {
    return ^void(TRLevel* level) {
        [[level trains] onCompleteF:^void(CNTry* t) {
            if([t isSuccess]) {
                NSArray* trains = [t get];
                {
                    TRTrain* h = [((NSArray*)(trains)) head];
                    if(h != nil) [level showHelpText:[TRStr.Loc helpTrainWithSwitchesTo:[h.color localName]]];
                }
            }
        }];
    };
}

+ (GEVec2i)bigSize {
    if(egPlatform().isPhone) return GEVec2iMake(5, 5);
    else return GEVec2iMake(7, 5);
}

+ (void(^)(TRLevel*))awaitBy:(CNFuture*(^)(TRLevel*))by {
    return ^void(TRLevel* level) {
        [level scheduleAwaitBy:by];
    };
}

+ (CNFuture*(^)(TRLevel*))noTrains {
    return ^CNFuture*(TRLevel* level) {
        return [[level trains] mapF:^id(NSArray* _) {
            return numb(!([((NSArray*)(_)) isEmpty]));
        }];
    };
}

- (ODClassType*)type {
    return [TRLevels type];
}

+ (ODClassType*)type {
    return _TRLevels_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


