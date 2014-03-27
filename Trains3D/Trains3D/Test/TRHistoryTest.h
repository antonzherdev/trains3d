#import "objd.h"
#import "TSTestCase.h"
#import "TRHistory.h"
#import "GEVec.h"
@class TRLevelFactory;
@class TRLevel;
@class ATVar;

@class TRHistoryTest;

@interface TRHistoryTest : TSTestCase
+ (instancetype)historyTest;
- (instancetype)init;
- (ODClassType*)type;
- (void)testStore;
- (void)testLimit;
- (void)testRewind;
- (void)testCanRewind;
+ (TRRewindRules)rules;
+ (ODClassType*)type;
@end


