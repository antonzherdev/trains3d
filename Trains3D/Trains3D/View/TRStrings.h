#import "objd.h"
@class TRTrain;
@class TRLevel;
@class EGLocalPlayerScore;
@class TRCityColor;
@class EGInterfaceIdiom;
@class EGPlatform;

@class TREnStrings;
@class TRRuStrings;
@class TRStr;
@protocol TRStrings;

@protocol TRStrings<NSObject>
- (NSString*)formatCost:(NSInteger)cost;
- (NSString*)levelNumber:(NSUInteger)number;
- (NSString*)startLevelNumber:(NSUInteger)number;
- (NSString*)railBuiltCost:(NSInteger)cost;
- (NSString*)trainArrivedTrain:(TRTrain*)train cost:(NSInteger)cost;
- (NSString*)trainDestroyedCost:(NSInteger)cost;
- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost;
- (NSString*)damageFixedPaymentCost:(NSInteger)cost;
- (NSString*)cityBuilt;
- (NSString*)resumeGame;
- (NSString*)restartLevel:(TRLevel*)level;
- (NSString*)replayLevel:(TRLevel*)level;
- (NSString*)goToNextLevel:(TRLevel*)level;
- (NSString*)chooseLevel;
- (NSString*)callRepairer;
- (NSString*)undo;
- (NSString*)victory;
- (NSString*)defeat;
- (NSString*)moneyOver;
- (NSString*)result;
- (NSString*)best;
- (NSString*)supportButton;
- (NSString*)supportEmailText;
- (NSString*)rateText;
- (NSString*)rateNow;
- (NSString*)rateProblem;
- (NSString*)rateLater;
- (NSString*)rateClose;
- (NSString*)topScore:(EGLocalPlayerScore*)score;
- (NSString*)leaderboard;
- (NSString*)tapToContinue;
- (NSString*)colorOrange;
- (NSString*)colorBlue;
- (NSString*)colorMint;
- (NSString*)colorYellow;
- (NSString*)colorRed;
- (NSString*)colorGreen;
- (NSString*)colorPink;
- (NSString*)colorBeige;
- (NSString*)colorPurple;
- (NSString*)colorGrey;
- (NSString*)helpConnectTwoCities;
- (NSString*)helpRules;
- (NSString*)helpNewCity;
- (NSString*)helpSporadicDamage;
- (NSString*)helpDamage;
- (NSString*)helpRepairer;
- (NSString*)helpCrazy;
- (NSString*)helpInZoom;
- (NSString*)helpExpressTrain;
- (NSString*)helpTrainTo:(NSString*)to;
- (NSString*)helpTrainWithSwitchesTo:(NSString*)to;
- (NSString*)helpToMakeZoom;
- (NSString*)linesAdvice;
@end


@interface TREnStrings : NSObject<TRStrings>
+ (id)enStrings;
- (id)init;
- (ODClassType*)type;
- (NSString*)levelNumber:(NSUInteger)number;
- (NSString*)railBuiltCost:(NSInteger)cost;
- (NSString*)trainArrivedTrain:(TRTrain*)train cost:(NSInteger)cost;
- (NSString*)trainDestroyedCost:(NSInteger)cost;
- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost;
- (NSString*)damageFixedPaymentCost:(NSInteger)cost;
- (NSString*)resumeGame;
- (NSString*)restartLevel:(TRLevel*)level;
- (NSString*)replayLevel:(TRLevel*)level;
- (NSString*)goToNextLevel:(TRLevel*)level;
- (NSString*)chooseLevel;
- (NSString*)callRepairer;
- (NSString*)undo;
- (NSString*)victory;
- (NSString*)defeat;
- (NSString*)moneyOver;
- (NSString*)cityBuilt;
- (NSString*)tapToContinue;
- (NSString*)colorOrange;
- (NSString*)colorGreen;
- (NSString*)colorPink;
- (NSString*)colorPurple;
- (NSString*)colorGrey;
- (NSString*)colorBlue;
- (NSString*)colorMint;
- (NSString*)colorRed;
- (NSString*)colorBeige;
- (NSString*)colorYellow;
- (NSString*)supportButton;
- (NSString*)supportEmailText;
- (NSString*)rateText;
- (NSString*)rateSignature;
- (NSString*)rateNow;
- (NSString*)rateProblem;
- (NSString*)rateLater;
- (NSString*)rateClose;
- (NSString*)helpConnectTwoCities;
- (NSString*)helpRules;
- (NSString*)helpNewCity;
- (NSString*)helpTrainTo:(NSString*)to;
- (NSString*)helpTrainWithSwitchesTo:(NSString*)to;
- (NSString*)helpExpressTrain;
- (NSString*)helpToMakeZoom;
- (NSString*)helpInZoom;
- (NSString*)helpSporadicDamage;
- (NSString*)helpDamage;
- (NSString*)helpCrazy;
- (NSString*)helpRepairer;
- (NSString*)result;
- (NSString*)best;
- (NSString*)topScore:(EGLocalPlayerScore*)score;
- (NSString*)leaderboard;
- (NSString*)linesAdvice;
+ (ODClassType*)type;
@end


@interface TRRuStrings : NSObject<TRStrings>
+ (id)ruStrings;
- (id)init;
- (ODClassType*)type;
- (NSString*)levelNumber:(NSUInteger)number;
- (NSString*)railBuiltCost:(NSInteger)cost;
- (NSString*)trainArrivedTrain:(TRTrain*)train cost:(NSInteger)cost;
- (NSString*)trainDestroyedCost:(NSInteger)cost;
- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost;
- (NSString*)damageFixedPaymentCost:(NSInteger)cost;
- (NSString*)resumeGame;
- (NSString*)restartLevel:(TRLevel*)level;
- (NSString*)replayLevel:(TRLevel*)level;
- (NSString*)goToNextLevel:(TRLevel*)level;
- (NSString*)chooseLevel;
- (NSString*)callRepairer;
- (NSString*)undo;
- (NSString*)victory;
- (NSString*)defeat;
- (NSString*)moneyOver;
- (NSString*)cityBuilt;
- (NSString*)tapToContinue;
- (NSString*)colorOrange;
- (NSString*)colorGreen;
- (NSString*)colorPink;
- (NSString*)colorPurple;
- (NSString*)colorGrey;
- (NSString*)colorBlue;
- (NSString*)colorMint;
- (NSString*)colorRed;
- (NSString*)colorBeige;
- (NSString*)colorYellow;
- (NSString*)helpConnectTwoCities;
- (NSString*)helpNewCity;
- (NSString*)helpTrainTo:(NSString*)to;
- (NSString*)helpTrainWithSwitchesTo:(NSString*)to;
- (NSString*)helpExpressTrain;
- (NSString*)helpToMakeZoom;
- (NSString*)helpInZoom;
- (NSString*)helpRules;
- (NSString*)helpSporadicDamage;
- (NSString*)helpDamage;
- (NSString*)helpRepairer;
- (NSString*)helpCrazy;
- (NSString*)linesAdvice;
- (NSString*)supportButton;
- (NSString*)supportEmailText;
- (NSString*)rateText;
- (NSString*)rateNow;
- (NSString*)rateProblem;
- (NSString*)rateLater;
- (NSString*)rateClose;
- (NSString*)result;
- (NSString*)best;
- (NSString*)topScore:(EGLocalPlayerScore*)score;
- (NSString*)leaderboard;
+ (ODClassType*)type;
@end


@interface TRStr : NSObject
- (ODClassType*)type;
+ (id<TRStrings>)Loc;
+ (ODClassType*)type;
@end


