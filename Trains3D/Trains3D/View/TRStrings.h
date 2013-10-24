#import "objd.h"
@class TRLevel;
@class EGPlatform;

@class TREnStrings;
@class TRRuStrings;
@class TRStr;
@protocol TRStrings;

@protocol TRStrings<NSObject>
- (NSString*)formatCost:(NSInteger)cost;
- (NSString*)startLevelNumber:(NSUInteger)number;
- (NSString*)railBuiltCost:(NSInteger)cost;
- (NSString*)trainArrivedCost:(NSInteger)cost;
- (NSString*)trainDestroyedCost:(NSInteger)cost;
- (NSString*)trainDelayedFineCost:(NSInteger)cost;
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
- (NSString*)colorOrange;
- (NSString*)colorGreen;
- (NSString*)colorPink;
- (NSString*)colorPurple;
- (NSString*)colorYellow;
- (NSString*)colorGrey;
- (NSString*)helpConnectTwoCities;
- (NSString*)helpNewCity;
- (NSString*)helpTrainTo:(NSString*)to;
- (NSString*)helpTrainWithSwitchesTo:(NSString*)to;
@end


@interface TREnStrings : NSObject<TRStrings>
+ (id)enStrings;
- (id)init;
- (ODClassType*)type;
- (NSString*)startLevelNumber:(NSUInteger)number;
- (NSString*)railBuiltCost:(NSInteger)cost;
- (NSString*)trainArrivedCost:(NSInteger)cost;
- (NSString*)trainDestroyedCost:(NSInteger)cost;
- (NSString*)trainDelayedFineCost:(NSInteger)cost;
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
- (NSString*)colorOrange;
- (NSString*)colorGreen;
- (NSString*)colorPink;
- (NSString*)colorPurple;
- (NSString*)colorYellow;
- (NSString*)colorGrey;
- (NSString*)helpConnectTwoCities;
- (NSString*)helpNewCity;
- (NSString*)helpTrainTo:(NSString*)to;
- (NSString*)helpTrainWithSwitchesTo:(NSString*)to;
+ (ODClassType*)type;
@end


@interface TRRuStrings : NSObject<TRStrings>
+ (id)ruStrings;
- (id)init;
- (ODClassType*)type;
- (NSString*)startLevelNumber:(NSUInteger)number;
- (NSString*)railBuiltCost:(NSInteger)cost;
- (NSString*)trainArrivedCost:(NSInteger)cost;
- (NSString*)trainDestroyedCost:(NSInteger)cost;
- (NSString*)trainDelayedFineCost:(NSInteger)cost;
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
- (NSString*)colorOrange;
- (NSString*)colorGreen;
- (NSString*)colorPink;
- (NSString*)colorPurple;
- (NSString*)colorYellow;
- (NSString*)colorGrey;
- (NSString*)helpConnectTwoCities;
- (NSString*)helpNewCity;
- (NSString*)helpTrainTo:(NSString*)to;
- (NSString*)helpTrainWithSwitchesTo:(NSString*)to;
+ (ODClassType*)type;
@end


@interface TRStr : NSObject
- (ODClassType*)type;
+ (id<TRStrings>)Loc;
+ (ODClassType*)type;
@end


