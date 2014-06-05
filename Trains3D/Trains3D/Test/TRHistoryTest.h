#import "objd.h"
#import "TSTestCase.h"
#import "TRHistory.h"
#import "PGVec.h"
@class TRLevelFactory;
@class TRLevel;
@class CNFuture;
@class CNThread;
@class CNVar;

@class TRHistoryTest;

@interface TRHistoryTest : TSTestCase
+ (instancetype)historyTest;
- (instancetype)init;
- (CNClassType*)type;
- (void)testStore;
- (void)testLimit;
- (void)testRewind;
- (void)testCanRewind;
- (NSString*)description;
+ (TRRewindRules)rules;
+ (CNClassType*)type;
@end


