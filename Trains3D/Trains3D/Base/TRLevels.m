#import "TRLevels.h"

#import "TRLevelFactory.h"
#import "TRStrings.h"
#import "TRGameDirector.h"
#import "TRScore.h"
#import "CNFuture.h"
#import "PGPlatformPlat.h"
#import "PGPlatform.h"
#import "TRRailroad.h"
@implementation TRLevels
static NSInteger _TRLevels_level1TrainComingPeriod = 5;
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
static CNClassType* _TRLevels_type;

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
        _TRLevels_type = [CNClassType classTypeWithCls:[TRLevels class]];
        _TRLevels_level1 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 3) theme:TRLevelTheme_forest trainComingPeriod:((NSUInteger)(_TRLevels_level1TrainComingPeriod)) scoreRules:[TRLevels scoreRulesWithInitialScore:30000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.2 blastness:0.05 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@1.0, [TRLevels showHelpText:[[TRStr Loc] helpConnectTwoCities]]), tuple(@2.0, [TRLevels awaitCitiesConnectedA:0 b:1]), tuple(@1.0, [TRLevels trainCars:[CNRange applyI:2] speed:[CNRange applyI:30]]), tuple(numf(((CGFloat)(_TRLevels_level1TrainComingPeriod + 7))), [TRLevels showTrainHelp]), tuple(@0.0, [TRLevels awaitBy:[TRLevels noTrains]]), tuple(@1.0, [TRLevels createNewCity]), tuple(@1.0, [TRLevels showHelpText:[[TRStr Loc] helpNewCity]]), tuple(@20.0, [TRLevels trainCars:[CNRange applyI:1] speed:[CNRange applyI:30]]), tuple(numf(((CGFloat)(_TRLevels_level1TrainComingPeriod + 3))), [TRLevels showTrainHelpWithSwitches]), tuple(@0.0, [TRLevels awaitBy:[TRLevels noTrains]]), tuple(@2.0, [TRLevels trainCars:[CNRange applyI:3] speed:[CNRange applyI:30]]), tuple(@1.0, [TRLevels showHelpText:[[TRStr Loc] helpRules]])])];
        _TRLevels_level2 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 3) theme:TRLevelTheme_forest trainComingPeriod:7 scoreRules:[TRLevels scoreRulesWithInitialScore:50000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.2 blastness:0.1 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@1.0, [TRLevels showHelpKey:@"help.tozoom" text:[[TRStr Loc] helpToMakeZoom]]), tuple(@9.0, [TRLevels slowTrain]), tuple(@5.0, [TRLevels showHelpKey:@"help.remove" text:[[TRStr Loc] helpToRemove]]), tuple(@6.0, [TRLevels createNewCity]), tuple(@11.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@11.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels slowTrain]), tuple(@11.0, [TRLevels slowTrain])])];
        _TRLevels_level3 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 3) theme:TRLevelTheme_forest trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:50000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:0.0 windStrength:0.3 blastness:0.3 blastMinLength:1.0 blastMaxLength:5.0 blastStrength:0.6 precipitation:[TRLevels lightRain]] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@1.0, [TRLevels showHelpKey:@"help.linesAdvice" text:[[TRStr Loc] linesAdvice]]), tuple(@5.0, [TRLevels slowTrain]), tuple(@15.0, [TRLevels slowTrain]), tuple(@11.0, [TRLevels createNewCity]), tuple(@13.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@11.0, [TRLevels createNewCity]), tuple(@13.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@11.0, [TRLevels createNewCity]), tuple(@13.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@11.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@18.0, [TRLevels slowTrain]), tuple(@15.0, [TRLevels slowTrain])])];
        _TRLevels_level4 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 3) theme:TRLevelTheme_forest trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.1 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@1.0, [TRLevels showHelpKey:@"help.rewind" text:[[TRStr Loc] helpRewind]]), tuple(@9.0, [TRLevels slowTrain]), tuple(@15.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@0.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@11.0, [TRLevels createNewCity]), tuple(@13.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@5.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@15.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@0.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@11.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@11.0, [TRLevels slowTrain]), tuple(@15.0, [TRLevels slowTrain])])];
        _TRLevels_level5 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 5) theme:TRLevelTheme_forest trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:70000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.05 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.1 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels slowTrain]), tuple(@13.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@5.0, [TRLevels createNewCity]), tuple(@12.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@5.0, [TRLevels createNewCity]), tuple(@18.0, [TRLevels slowTrain]), tuple(@15.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@28.0, [TRLevels slowTrain]), tuple(@11.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@11.0, [TRLevels slowTrain]), tuple(@25.0, [TRLevels slowTrain]), tuple(@5.0, [TRLevels slowTrain]), tuple(@11.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels slowTrain]), tuple(@5.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@2.0, [TRLevels slowTrain]), tuple(@11.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@30.0, [TRLevels slowTrain]), tuple(@11.0, [TRLevels slowTrain]), tuple(@20.0, [TRLevels slowTrain]), tuple(@11.0, [TRLevels slowTrain]), tuple(@15.0, [TRLevels slowTrain])])];
        _TRLevels_level6 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 5) theme:TRLevelTheme_winter trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.05 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.1 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels train]), tuple(@13.0, [TRLevels train]), tuple(@30.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@22.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@60.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@20.0, [TRLevels train])])];
        _TRLevels_level7 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 5) theme:TRLevelTheme_winter trainComingPeriod:((NSUInteger)(_TRLevels_stdTrainComingPeriod)) scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.05 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.1 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels expressTrain]), tuple(numf(((CGFloat)(_TRLevels_stdTrainComingPeriod + 3))), [TRLevels showHelpKey:@"help.express" text:[[TRStr Loc] helpExpressTrain]]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@13.0, [TRLevels train]), tuple(@23.0, [TRLevels train]), tuple(@23.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@35.0, [TRLevels train]), tuple(@50.0, [TRLevels verySlowTrain]), tuple(@18.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@13.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels verySlowTrain]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@12.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@22.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@50.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@60.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain])])];
        _TRLevels_level8 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 5) theme:TRLevelTheme_winter trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:0.0 windStrength:0.3 blastness:0.3 blastMinLength:1.0 blastMaxLength:5.0 blastStrength:0.6 precipitation:[TRLevels snow]] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels train]), tuple(@17.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@25.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@0.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@22.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@40.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@22.0, [TRLevels expressTrain]), tuple(@50.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@12.0, [TRLevels train]), tuple(@22.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@5.0, [TRLevels train]), tuple(@25.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@0.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@60.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@25.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train])])];
        _TRLevels_level9 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 5) theme:TRLevelTheme_leafForest trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.1 blastness:0.05 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.05 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@10.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@22.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@12.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@40.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@25.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@60.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@50.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@60.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train])])];
        _TRLevels_level10 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 5) theme:TRLevelTheme_leafForest trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:0.0 windStrength:0.4 blastness:0.5 blastMinLength:1.0 blastMaxLength:5.0 blastStrength:0.9 precipitation:[TRLevels rain]] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels train]), tuple(@17.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels verySlowTrain]), tuple(@20.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@5.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@40.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train])])];
        _TRLevels_level11 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 5) theme:TRLevelTheme_leafForest trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.2 blastness:0.1 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.2 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:500 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@30.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@25.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@17.0, [TRLevels train]), tuple(@25.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels expressTrain]), tuple(@5.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@50.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain])])];
        _TRLevels_level12 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 5) theme:TRLevelTheme_palm trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.3 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:400 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels expressTrain]), tuple(@17.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@23.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@18.0, [TRLevels train]), tuple(@18.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels expressTrain]), tuple(@25.0, [TRLevels verySlowTrain]), tuple(@13.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels train]), tuple(@0.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@40.0, [TRLevels expressTrain]), tuple(@3.0, [TRLevels expressTrain]), tuple(@17.0, [TRLevels train]), tuple(@17.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@18.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@5.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@18.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@50.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@50.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train])])];
        _TRLevels_level13 = [TRLevelRules levelRulesWithMapSize:[TRLevels bigSize] theme:TRLevelTheme_palm trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:70000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.3 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:400 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels expressTrain]), tuple(@17.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@20.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels expressTrain]), tuple(@3.0, [TRLevels verySlowTrain]), tuple(@17.0, [TRLevels train]), tuple(@17.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels expressTrain]), tuple(@7.0, [TRLevels train]), tuple(@18.0, [TRLevels train]), tuple(@5.0, [TRLevels verySlowTrain]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@5.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@0.0, [TRLevels verySlowTrain]), tuple(@50.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@50.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@20.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels expressTrain]), tuple(@60.0, [TRLevels train]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train])])];
        _TRLevels_level14 = [TRLevelRules levelRulesWithMapSize:[TRLevels bigSize] theme:TRLevelTheme_palm trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:70000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.1 blastness:0.1 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.1 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:400 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@30.0, [TRLevels crazyTrain]), tuple(@20.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@20.0, [TRLevels verySlowTrain]), tuple(@13.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels train]), tuple(@7.0, [TRLevels verySlowTrain]), tuple(@18.0, [TRLevels train]), tuple(@5.0, [TRLevels verySlowTrain]), tuple(@40.0, [TRLevels train]), tuple(@5.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@0.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@20.0, [TRLevels crazyTrain]), tuple(@50.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@1.0, [TRLevels expressTrain]), tuple(@1.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@30.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@1.0, [TRLevels expressTrain]), tuple(@50.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@50.0, [TRLevels expressTrain]), tuple(@1.0, [TRLevels expressTrain]), tuple(@2.0, [TRLevels expressTrain]), tuple(@3.0, [TRLevels expressTrain]), tuple(@4.0, [TRLevels expressTrain]), tuple(@60.0, [TRLevels train]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels crazyTrain])])];
        _TRLevels_level15 = [TRLevelRules levelRulesWithMapSize:[TRLevels bigSize] theme:TRLevelTheme_palm trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:70000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:0.0 windStrength:0.3 blastness:0.3 blastMinLength:1.0 blastMaxLength:5.0 blastStrength:0.7 precipitation:[TRLevels rain]] repairerSpeed:20 sporadicDamagePeriod:400 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@18.0, [TRLevels verySlowTrain]), tuple(@20.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@20.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@25.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@40.0, [TRLevels expressTrain]), tuple(@1.0, [TRLevels expressTrain]), tuple(@5.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@12.0, [TRLevels train]), tuple(@35.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels crazyTrain]), tuple(@15.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@40.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@20.0, [TRLevels train]), tuple(@50.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels train]), tuple(@4.0, [TRLevels train]), tuple(@3.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@60.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@60.0, [TRLevels train]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@50.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain])])];
        _TRLevels_level16 = [TRLevelRules levelRulesWithMapSize:[TRLevels bigSize] theme:TRLevelTheme_palm trainComingPeriod:10 scoreRules:[TRLevels scoreRulesWithInitialScore:70000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.1 blastness:0.1 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.1 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:380 events:(@[tuple(@0.0, [TRLevels create2Cities]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels crazyTrain]), tuple(@15.0, [TRLevels train]), tuple(@15.0, [TRLevels createNewCity]), tuple(@15.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@15.0, [TRLevels createNewCity]), tuple(@10.0, [TRLevels train]), tuple(@5.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels crazyTrain]), tuple(@40.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@15.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@40.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@40.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels train]), tuple(@15.0, [TRLevels expressTrain]), tuple(@15.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels train]), tuple(@10.0, [TRLevels createNewCity]), tuple(@40.0, [TRLevels train]), tuple(@10.0, [TRLevels verySlowTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@50.0, [TRLevels expressTrain]), tuple(@10.0, [TRLevels expressTrain]), tuple(@5.0, [TRLevels train]), tuple(@4.0, [TRLevels expressTrain]), tuple(@3.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@60.0, [TRLevels train]), tuple(@0.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@0.0, [TRLevels expressTrain]), tuple(@20.0, [TRLevels train]), tuple(@0.0, [TRLevels expressTrain]), tuple(@60.0, [TRLevels train]), tuple(@0.0, [TRLevels crazyTrain]), tuple(@20.0, [TRLevels train]), tuple(@0.0, [TRLevels crazyTrain]), tuple(@20.0, [TRLevels train]), tuple(@0.0, [TRLevels crazyTrain]), tuple(@10.0, [TRLevels createNewCity]), tuple(@50.0, [TRLevels verySlowTrain]), tuple(@0.0, [TRLevels verySlowTrain]), tuple(@0.0, [TRLevels verySlowTrain]), tuple(@0.0, [TRLevels verySlowTrain]), tuple(@60.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@0.0, [TRLevels train]), tuple(@60.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@0.0, [TRLevels expressTrain]), tuple(@60.0, [TRLevels crazyTrain]), tuple(@0.0, [TRLevels crazyTrain]), tuple(@0.0, [TRLevels crazyTrain]), tuple(@0.0, [TRLevels crazyTrain])])];
        _TRLevels_rules = (@[_TRLevels_level1, _TRLevels_level2, _TRLevels_level3, _TRLevels_level4, _TRLevels_level5, _TRLevels_level6, _TRLevels_level7, _TRLevels_level8, _TRLevels_level9, _TRLevels_level10, _TRLevels_level11, _TRLevels_level12, _TRLevels_level13, _TRLevels_level14, _TRLevels_level15, _TRLevels_level16]);
    }
}

+ (TRLevel*)levelWithNumber:(NSUInteger)number {
    if(number > [_TRLevels_rules count]) return [TRLevel levelWithNumber:[_TRLevels_rules count] rules:[_TRLevels_rules applyIndex:[_TRLevels_rules count] - 1]];
    else return [TRLevel levelWithNumber:number rules:[_TRLevels_rules applyIndex:number - 1]];
}

+ (CNTuple*)trainCars:(CNRange*)cars speed:(CNRange*)speed {
    return tuple([TRLevelEventType value:TRLevelEventType_train], (^void(TRLevel* level) {
        [level runTrainWithGenerator:[TRTrainGenerator trainGeneratorWithTrainType:TRTrainType_simple carsCount:cars speed:speed carTypes:(@[[TRCarType value:TRCarType_car], [TRCarType value:TRCarType_engine]])]];
    }));
}

+ (CNTuple*)expressTrainCars:(CNRange*)cars speed:(CNRange*)speed {
    return tuple([TRLevelEventType value:TRLevelEventType_train], (^void(TRLevel* level) {
        [level runTrainWithGenerator:[TRTrainGenerator trainGeneratorWithTrainType:TRTrainType_fast carsCount:cars speed:speed carTypes:(@[[TRCarType value:TRCarType_expressCar], [TRCarType value:TRCarType_expressEngine]])]];
    }));
}

+ (CNTuple*)crazyTrainCars:(CNRange*)cars speed:(CNRange*)speed {
    return tuple([TRLevelEventType value:TRLevelEventType_train], (^void(TRLevel* level) {
        [level runTrainWithGenerator:[TRTrainGenerator trainGeneratorWithTrainType:TRTrainType_crazy carsCount:cars speed:speed carTypes:(@[[TRCarType value:TRCarType_car], [TRCarType value:TRCarType_engine]])]];
    }));
}

+ (CNTuple*)showHelpText:(NSString*)text {
    return tuple([TRLevelEventType value:TRLevelEventType_help], ^void(TRLevel* level) {
        [level showHelpText:text];
    });
}

+ (CNTuple*)showHelpKey:(NSString*)key text:(NSString*)text {
    return tuple([TRLevelEventType value:TRLevelEventType_help], ^void(TRLevel* level) {
        [[TRGameDirector instance] showHelpKey:key text:text];
    });
}

+ (CNTuple*)createNewCity {
    return tuple([TRLevelEventType value:TRLevelEventType_city], ^void(TRLevel* level) {
        [TRLevels createNewCityLevel:level];
    });
}

+ (void)createNewCityLevel:(TRLevel*)level {
    [level createNewCity];
}

+ (CNTuple*)create2Cities {
    return tuple([TRLevelEventType value:TRLevelEventType_twoCities], ^void(TRLevel* level) {
        [level create2Cities];
    });
}

+ (TRPrecipitation*)lightRain {
    return [TRPrecipitation precipitationWithTp:TRPrecipitationType_rain strength:0.5];
}

+ (TRPrecipitation*)rain {
    return [TRPrecipitation precipitationWithTp:TRPrecipitationType_rain strength:1.0];
}

+ (TRPrecipitation*)snow {
    return [TRPrecipitation precipitationWithTp:TRPrecipitationType_snow strength:1.0];
}

+ (CNTuple*)slowTrain {
    return [TRLevels trainCars:intTo(1, 4) speed:intTo(40, 40)];
}

+ (CNTuple*)train {
    return [TRLevels trainCars:intTo(1, 5) speed:intTo(20, 50)];
}

+ (CNTuple*)verySlowTrain {
    return [TRLevels trainCars:intTo(1, 2) speed:[CNRange applyI:15]];
}

+ (CNTuple*)expressTrain {
    return [TRLevels expressTrainCars:intTo(3, 5) speed:intTo(75, 100)];
}

+ (CNTuple*)crazyTrain {
    return [TRLevels crazyTrainCars:intTo(3, 5) speed:intTo(40, 60)];
}

+ (TRScoreRules*)scoreRulesWithInitialScore:(NSInteger)initialScore {
    return [TRLevelFactory scoreRulesWithInitialScore:initialScore];
}

+ (CNTuple*)showTrainHelp {
    return tuple([TRLevelEventType value:TRLevelEventType_help], ^void(TRLevel* level) {
        [[level trains] onCompleteF:^void(CNTry* t) {
            if([t isSuccess]) {
                NSArray* trains = [t get];
                {
                    TRTrain* h = [((NSArray*)(trains)) head];
                    if(h != nil) [level showHelpText:[[TRStr Loc] helpTrainTo:[[TRCityColor value:((TRTrain*)(h))->_color] localName]]];
                }
            }
        }];
    });
}

+ (CNTuple*)showTrainHelpWithSwitches {
    return tuple([TRLevelEventType value:TRLevelEventType_help], ^void(TRLevel* level) {
        [[level trains] onCompleteF:^void(CNTry* t) {
            if([t isSuccess]) {
                NSArray* trains = [t get];
                {
                    TRTrain* h = [((NSArray*)(trains)) head];
                    if(h != nil) [level showHelpText:[[TRStr Loc] helpTrainWithSwitchesTo:[[TRCityColor value:((TRTrain*)(h))->_color] localName]]];
                }
            }
        }];
    });
}

+ (PGVec2i)bigSize {
    if(egPlatform()->_isPhone) return PGVec2iMake(5, 5);
    else return PGVec2iMake(7, 5);
}

+ (CNTuple*)awaitBy:(CNFuture*(^)(TRLevel*))by {
    return tuple([TRLevelEventType value:TRLevelEventType_await], ^void(TRLevel* level) {
        [level scheduleAwaitBy:by];
    });
}

+ (CNFuture*(^)(TRLevel*))noTrains {
    return ^CNFuture*(TRLevel* level) {
        return [[level trains] mapF:^id(NSArray* _) {
            return numb([((NSArray*)(_)) isEmpty]);
        }];
    };
}

+ (CNTuple*)awaitCitiesConnectedA:(unsigned int)a b:(unsigned int)b {
    return tuple([TRLevelEventType value:TRLevelEventType_await], (^void(TRLevel* level) {
        CNFuture* citiesFuture = [level cities];
        [level scheduleAwaitBy:^CNFuture*(TRLevel* l) {
            return [CNFuture mapA:citiesFuture b:[l->_railroad state] f:^id(NSArray* cities, TRRailroadState* rrState) {
                return numb([((TRRailroadState*)(rrState)) isConnectedA:[((TRCityState*)(cities[a]))->_city startPoint] b:[((TRCityState*)(cities[b]))->_city startPoint]]);
            }];
        }];
    }));
}

- (NSString*)description {
    return @"Levels";
}

- (CNClassType*)type {
    return [TRLevels type];
}

+ (CNClassType*)type {
    return _TRLevels_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

