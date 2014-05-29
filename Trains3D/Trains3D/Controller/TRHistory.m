#import "TRHistory.h"

#import "TRLevel.h"
#import "CNReact.h"
#import "EGSchedule.h"
#import "CNFuture.h"
NSString* trRewindRulesDescription(TRRewindRules self) {
    return [NSString stringWithFormat:@"RewindRules(%f, %lu, %f, %f)", self.savingPeriod, (unsigned long)self.limit, self.rewindPeriod, self.rewindSpeed];
}
BOOL trRewindRulesIsEqualTo(TRRewindRules self, TRRewindRules to) {
    return eqf(self.savingPeriod, to.savingPeriod) && self.limit == to.limit && eqf(self.rewindPeriod, to.rewindPeriod) && eqf(self.rewindSpeed, to.rewindSpeed);
}
NSUInteger trRewindRulesHash(TRRewindRules self) {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.savingPeriod);
    hash = hash * 31 + self.limit;
    hash = hash * 31 + floatHash(self.rewindPeriod);
    hash = hash * 31 + floatHash(self.rewindSpeed);
    return hash;
}
TRRewindRules trRewindRulesDefault() {
    static TRRewindRules _ret = (TRRewindRules){0.2, 1000, 15.0, 15.0};
    return _ret;
}
CNPType* trRewindRulesType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[TRRewindRulesWrap class] name:@"TRRewindRules" size:sizeof(TRRewindRules) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRRewindRules, ((TRRewindRules*)(data))[i]);
    }];
    return _ret;
}
@implementation TRRewindRulesWrap{
    TRRewindRules _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRRewindRules)value {
    return [[TRRewindRulesWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRRewindRules)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation TRHistory
static CNClassType* _TRHistory_type;
@synthesize level = _level;
@synthesize rules = _rules;
@synthesize canRewind = _canRewind;
@synthesize rewindCounter = _rewindCounter;

+ (instancetype)historyWithLevel:(TRLevel*)level rules:(TRRewindRules)rules {
    return [[TRHistory alloc] initWithLevel:level rules:rules];
}

- (instancetype)initWithLevel:(TRLevel*)level rules:(TRRewindRules)rules {
    self = [super init];
    if(self) {
        _level = level;
        _rules = rules;
        __timeToNext = 0.0;
        __time = 0.0;
        __rewindNextTime = 0.0;
        _canRewind = [CNVar varWithInitial:@NO];
        _rewindCounter = [EGCounter applyLength:rules.rewindPeriod];
        __states = [CNMList list];
        if([self class] == [TRHistory class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRHistory class]) _TRHistory_type = [CNClassType classTypeWithCls:[TRHistory class]];
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [self promptF:^id() {
        if(unumb([[_rewindCounter isRunning] value])) {
            CGFloat d = delta * _rules.rewindSpeed;
            [_rewindCounter updateWithDelta:d];
            __timeToNext += d;
            while(__timeToNext > _rules.savingPeriod) {
                __timeToNext -= _rules.savingPeriod;
            }
            __time -= d;
            if(__time <= __rewindNextTime) {
                TRLevelState* st;
                while(__time <= __rewindNextTime) {
                    st = ((TRLevelState*)(nonnil([__states takeHead])));
                    {
                        TRLevelState* __tmpp0_0t_5t_1_1 = [__states head];
                        if(__tmpp0_0t_5t_1_1 != nil) __rewindNextTime = ((TRLevelState*)([__states head])).time;
                        else __rewindNextTime = 0.0;
                    }
                }
                {
                    TRLevelState* _ = st;
                    if(_ != nil) [_level restoreState:_];
                }
            }
        } else {
            __time += delta;
            __timeToNext -= delta;
            if(__timeToNext <= 0) {
                __timeToNext += _rules.savingPeriod;
                [[_level state] onCompleteF:^void(CNTry* t) {
                    if([t isSuccess]) {
                        TRLevelState* state = [t get];
                        [self addState:state];
                    }
                }];
            }
        }
        [self updateCanRewind];
        return nil;
    }];
}

- (CNFuture*)states {
    return [self promptF:^CNMList*() {
        return __states;
    }];
}

- (CNFuture*)addState:(TRLevelState*)state {
    return [self promptF:^id() {
        [__states prependItem:state];
        if([__states count] > _rules.limit) [__states removeLast];
        [self updateCanRewind];
        return nil;
    }];
}

- (void)updateCanRewind {
    [_canRewind setValue:numb(!([__states isEmpty]) && __time - ({
        TRLevelState* __tmp_0p0bab = [__states last];
        ((__tmp_0p0bab != nil) ? ((TRLevelState*)([__states last])).time : 0.0);
    }) > _rules.rewindPeriod)];
}

- (void)_init {
    [_rewindCounter finish];
}

- (CNFuture*)rewind {
    return [self promptF:^id() {
        if(!(unumb([[_rewindCounter isRunning] value])) && unumb([_canRewind value])) {
            {
                TRLevelState* __tmpp0t_0 = [__states head];
                if(__tmpp0t_0 != nil) __rewindNextTime = ((TRLevelState*)([__states head])).time;
                else __rewindNextTime = 0.0;
            }
            [_rewindCounter restart];
        }
        return nil;
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"History(%@, %@)", _level, trRewindRulesDescription(_rules)];
}

- (CNClassType*)type {
    return [TRHistory type];
}

+ (CNClassType*)type {
    return _TRHistory_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

