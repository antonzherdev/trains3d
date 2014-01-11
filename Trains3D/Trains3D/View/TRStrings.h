#import "objd.h"
@class TRTrain;
@class TRTrainType;
@class TRCityColor;
@class TRLevel;
@class EGLocalPlayerScore;
@class EGPlatform;

@class TRStr;
@class TRStrings;
@class TREnStrings;
@class TRRuStrings;
@class TRJpStrings;
@class TRKoStrings;
@class TRChinaStrings;
@class TRPtStrings;
@class TRItStrings;

@interface TRStr : NSObject
- (ODClassType*)type;
+ (TRStrings*)Loc;
+ (ODClassType*)type;
@end


@interface TRStrings : NSObject
@property (nonatomic, readonly) NSString* language;

+ (id)stringsWithLanguage:(NSString*)language;
- (id)initWithLanguage:(NSString*)language;
- (ODClassType*)type;
- (NSString*)formatCost:(NSInteger)cost;
- (NSString*)notificationsCharSet;
- (NSString*)levelNumber:(NSUInteger)number;
- (NSString*)startLevelNumber:(NSUInteger)number;
- (NSString*)railBuiltCost:(NSInteger)cost;
- (NSString*)trainArrivedTrain:(TRTrain*)train cost:(NSInteger)cost;
- (NSString*)trainDestroyedCost:(NSInteger)cost;
- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost;
- (NSString*)damageFixedPaymentCost:(NSInteger)cost;
- (NSString*)cityBuilt;
- (NSString*)menuButtonsCharacterSet;
- (NSString*)resumeGame;
- (NSString*)restartLevel:(TRLevel*)level;
- (NSString*)replayLevel:(TRLevel*)level;
- (NSString*)goToNextLevel:(TRLevel*)level;
- (NSString*)chooseLevel;
- (NSString*)supportButton;
- (NSString*)shareButton;
- (NSString*)leaderboard;
- (NSString*)buyButton;
- (NSString*)victory;
- (NSString*)defeat;
- (NSString*)moneyOver;
- (NSString*)result;
- (NSString*)best;
- (NSString*)error;
- (NSString*)supportEmailText;
- (NSString*)rateText;
- (NSString*)rateNow;
- (NSString*)rateProblem;
- (NSString*)rateLater;
- (NSString*)rateClose;
- (NSString*)topScore:(EGLocalPlayerScore*)score;
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
- (NSString*)helpSlowMotion;
- (NSString*)shareTextUrl:(NSString*)url;
- (NSString*)shareSubject;
- (NSString*)twitterTextUrl:(NSString*)url;
+ (ODClassType*)type;
@end


@interface TREnStrings : TRStrings
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
- (NSString*)victory;
- (NSString*)defeat;
- (NSString*)moneyOver;
- (NSString*)cityBuilt;
- (NSString*)tapToContinue;
- (NSString*)error;
- (NSString*)buyButton;
- (NSString*)shareButton;
- (NSString*)supportButton;
- (NSString*)rateText;
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
- (NSString*)helpSlowMotion;
- (NSString*)linesAdvice;
- (NSString*)result;
- (NSString*)best;
- (NSString*)topScore:(EGLocalPlayerScore*)score;
- (NSString*)leaderboard;
- (NSString*)shareSubject;
- (NSString*)shareTextUrl:(NSString*)url;
- (NSString*)twitterTextUrl:(NSString*)url;
+ (ODClassType*)type;
@end


@interface TRRuStrings : TRStrings
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
- (NSString*)victory;
- (NSString*)defeat;
- (NSString*)moneyOver;
- (NSString*)cityBuilt;
- (NSString*)tapToContinue;
- (NSString*)error;
- (NSString*)buyButton;
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
- (NSString*)helpSlowMotion;
- (NSString*)shareButton;
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
- (NSString*)shareSubject;
- (NSString*)shareTextUrl:(NSString*)url;
- (NSString*)twitterTextUrl:(NSString*)url;
+ (ODClassType*)type;
@end


@interface TRJpStrings : TRStrings
+ (id)jpStrings;
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
- (NSString*)victory;
- (NSString*)defeat;
- (NSString*)moneyOver;
- (NSString*)cityBuilt;
- (NSString*)tapToContinue;
- (NSString*)error;
- (NSString*)buyButton;
- (NSString*)shareButton;
- (NSString*)supportButton;
- (NSString*)rateText;
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
- (NSString*)helpSlowMotion;
- (NSString*)linesAdvice;
- (NSString*)result;
- (NSString*)best;
- (NSString*)topScore:(EGLocalPlayerScore*)score;
- (NSString*)leaderboard;
- (NSString*)shareSubject;
- (NSString*)shareTextUrl:(NSString*)url;
- (NSString*)twitterTextUrl:(NSString*)url;
+ (ODClassType*)type;
@end


@interface TRKoStrings : TRStrings
+ (id)koStrings;
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
- (NSString*)victory;
- (NSString*)defeat;
- (NSString*)moneyOver;
- (NSString*)cityBuilt;
- (NSString*)tapToContinue;
- (NSString*)error;
- (NSString*)buyButton;
- (NSString*)shareButton;
- (NSString*)supportButton;
- (NSString*)rateText;
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
- (NSString*)helpSlowMotion;
- (NSString*)linesAdvice;
- (NSString*)result;
- (NSString*)best;
- (NSString*)topScore:(EGLocalPlayerScore*)score;
- (NSString*)leaderboard;
- (NSString*)shareSubject;
- (NSString*)shareTextUrl:(NSString*)url;
- (NSString*)twitterTextUrl:(NSString*)url;
+ (ODClassType*)type;
@end


@interface TRChinaStrings : TRStrings
+ (id)chinaStrings;
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
- (NSString*)victory;
- (NSString*)defeat;
- (NSString*)moneyOver;
- (NSString*)cityBuilt;
- (NSString*)tapToContinue;
- (NSString*)error;
- (NSString*)buyButton;
- (NSString*)shareButton;
- (NSString*)supportButton;
- (NSString*)rateText;
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
- (NSString*)helpSlowMotion;
- (NSString*)linesAdvice;
- (NSString*)result;
- (NSString*)best;
- (NSString*)topScore:(EGLocalPlayerScore*)score;
- (NSString*)leaderboard;
- (NSString*)shareSubject;
- (NSString*)shareTextUrl:(NSString*)url;
- (NSString*)twitterTextUrl:(NSString*)url;
+ (ODClassType*)type;
@end


@interface TRPtStrings : TRStrings
+ (id)ptStrings;
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
- (NSString*)victory;
- (NSString*)defeat;
- (NSString*)moneyOver;
- (NSString*)cityBuilt;
- (NSString*)tapToContinue;
- (NSString*)error;
- (NSString*)buyButton;
- (NSString*)shareButton;
- (NSString*)supportButton;
- (NSString*)rateText;
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
- (NSString*)helpSlowMotion;
- (NSString*)linesAdvice;
- (NSString*)result;
- (NSString*)best;
- (NSString*)topScore:(EGLocalPlayerScore*)score;
- (NSString*)leaderboard;
- (NSString*)shareSubject;
- (NSString*)shareTextUrl:(NSString*)url;
- (NSString*)twitterTextUrl:(NSString*)url;
+ (ODClassType*)type;
@end


@interface TRItStrings : TRStrings
+ (id)itStrings;
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
- (NSString*)victory;
- (NSString*)defeat;
- (NSString*)moneyOver;
- (NSString*)cityBuilt;
- (NSString*)tapToContinue;
- (NSString*)error;
- (NSString*)buyButton;
- (NSString*)shareButton;
- (NSString*)supportButton;
- (NSString*)rateText;
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
- (NSString*)helpSlowMotion;
- (NSString*)linesAdvice;
- (NSString*)result;
- (NSString*)best;
- (NSString*)topScore:(EGLocalPlayerScore*)score;
- (NSString*)leaderboard;
- (NSString*)shareSubject;
- (NSString*)shareTextUrl:(NSString*)url;
- (NSString*)twitterTextUrl:(NSString*)url;
+ (ODClassType*)type;
@end


