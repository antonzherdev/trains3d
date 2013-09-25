#import "objd.h"

@class TREnStrings;
@class TRRuStrings;
@class TRStr;
@protocol TRStrings;

@protocol TRStrings<NSObject>
- (NSString*)railBuiltCost:(NSInteger)cost;
- (NSString*)trainArrivedCost:(NSInteger)cost;
- (NSString*)trainDestroyedCost:(NSInteger)cost;
- (NSString*)trainDelayedFineCost:(NSInteger)cost;
- (NSString*)resumeGame;
- (NSString*)restartLevel;
- (NSString*)mainMenu;
- (NSString*)formatCost:(NSInteger)cost;
@end


@interface TREnStrings : NSObject<TRStrings>
+ (id)enStrings;
- (id)init;
- (ODClassType*)type;
- (NSString*)railBuiltCost:(NSInteger)cost;
- (NSString*)trainArrivedCost:(NSInteger)cost;
- (NSString*)trainDestroyedCost:(NSInteger)cost;
- (NSString*)trainDelayedFineCost:(NSInteger)cost;
- (NSString*)resumeGame;
- (NSString*)restartLevel;
- (NSString*)mainMenu;
+ (ODClassType*)type;
@end


@interface TRRuStrings : NSObject<TRStrings>
+ (id)ruStrings;
- (id)init;
- (ODClassType*)type;
- (NSString*)railBuiltCost:(NSInteger)cost;
- (NSString*)trainArrivedCost:(NSInteger)cost;
- (NSString*)trainDestroyedCost:(NSInteger)cost;
- (NSString*)trainDelayedFineCost:(NSInteger)cost;
- (NSString*)resumeGame;
- (NSString*)restartLevel;
- (NSString*)mainMenu;
+ (ODClassType*)type;
@end


@interface TRStr : NSObject
- (ODClassType*)type;
+ (id<TRStrings>)Loc;
+ (ODClassType*)type;
@end


