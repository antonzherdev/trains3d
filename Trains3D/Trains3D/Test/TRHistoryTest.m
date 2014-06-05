#import "TRHistoryTest.h"

#import "TRLevelFactory.h"
#import "TRLevel.h"
#import "CNFuture.h"
#import "CNDispatchQueue.h"
#import "CNReact.h"
@implementation TRHistoryTest
static TRRewindRules _TRHistoryTest_rules;
static CNClassType* _TRHistoryTest_type;

+ (instancetype)historyTest {
    return [[TRHistoryTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRHistoryTest class]) {
        _TRHistoryTest_type = [CNClassType classTypeWithCls:[TRHistoryTest class]];
        _TRHistoryTest_rules = [TRLevelFactory rewindRules];
    }
}

- (void)testStore {
    TRLevel* level = [TRLevelFactory levelWithMapSize:PGVec2iMake(5, 5)];
    TRHistory* his = level->_history;
    assertEquals(@0, numi(((NSInteger)([((CNMList*)([[his states] getResultAwait:1.0])) count]))));
    [self updateLevel:level time:0.01];
    assertEquals(@1, numi(((NSInteger)([((CNMList*)([[his states] getResultAwait:1.0])) count]))));
    [self updateLevel:level time:_TRHistoryTest_rules.savingPeriod - 0.02];
    assertEquals(@1, numi(((NSInteger)([((CNMList*)([[his states] getResultAwait:1.0])) count]))));
    [self updateLevel:level time:0.02];
    assertEquals(@2, numi(((NSInteger)([((CNMList*)([[his states] getResultAwait:1.0])) count]))));
}

- (void)updateLevel:(TRLevel*)level time:(CGFloat)time {
    CGFloat step = 0.05;
    CGFloat t = time;
    while(t > step) {
        [[level _updateWithDelta:step] getResultAwait:1.0];
        [CNThread sleepPeriod:0.002];
        t -= step;
    }
    if(time > 0) {
        [level _updateWithDelta:t];
        [CNThread sleepPeriod:0.002];
    }
}

- (void)testLimit {
    TRLevel* level = [TRLevelFactory levelWithMapSize:PGVec2iMake(5, 5)];
    [self updateLevel:level time:_TRHistoryTest_rules.savingPeriod * (_TRHistoryTest_rules.limit + 10)];
    assertEquals(numui(_TRHistoryTest_rules.limit), numui([((CNMList*)([[level->_history states] getResultAwait:1.0])) count]));
}

- (void)testRewind {
    TRLevel* level = [TRLevelFactory levelWithMapSize:PGVec2iMake(5, 5)];
    [self updateLevel:level time:_TRHistoryTest_rules.rewindPeriod + _TRHistoryTest_rules.savingPeriod * 10];
    CGFloat t1 = unumf([[level time] getResultAwait:1.0]);
    [[level->_history rewind] getResultAwait:1.0];
    [self updateLevel:level time:_TRHistoryTest_rules.savingPeriod / _TRHistoryTest_rules.rewindSpeed];
    CGFloat t2 = unumf([[level time] getResultAwait:1.0]);
    assertTrue(t2 < t1);
    [self updateLevel:level time:_TRHistoryTest_rules.rewindPeriod / _TRHistoryTest_rules.rewindSpeed];
    CGFloat t3 = unumf([[level time] getResultAwait:1.0]);
    assertTrue(t3 < t2);
    [self updateLevel:level time:_TRHistoryTest_rules.savingPeriod / _TRHistoryTest_rules.rewindSpeed];
    CGFloat t4 = unumf([[level time] getResultAwait:1.0]);
    assertTrue(t4 > t3);
}

- (void)testCanRewind {
    TRLevel* level = [TRLevelFactory levelWithMapSize:PGVec2iMake(5, 5)];
    assertFalse(unumb([level->_history->_canRewind value]));
    [self updateLevel:level time:_TRHistoryTest_rules.rewindPeriod - 0.01];
    assertFalse(unumb([level->_history->_canRewind value]));
    [self updateLevel:level time:_TRHistoryTest_rules.savingPeriod * 2];
    assertTrue(unumb([level->_history->_canRewind value]));
    [[level->_history rewind] getResultAwait:1.0];
    [self updateLevel:level time:(_TRHistoryTest_rules.savingPeriod * 2 + 0.01) / _TRHistoryTest_rules.rewindSpeed];
    assertFalse(unumb([level->_history->_canRewind value]));
}

- (NSString*)description {
    return @"HistoryTest";
}

- (CNClassType*)type {
    return [TRHistoryTest type];
}

+ (TRRewindRules)rules {
    return _TRHistoryTest_rules;
}

+ (CNClassType*)type {
    return _TRHistoryTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

