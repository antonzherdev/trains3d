#import "TRHistory.h"

#import "TRLevel.h"
#import "ATReact.h"
#import "EGSchedule.h"
NSString* TRRewindRulesDescription(TRRewindRules self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRRewindRules: "];
    [description appendFormat:@"savingPeriod=%f", self.savingPeriod];
    [description appendFormat:@", limit=%lu", (unsigned long)self.limit];
    [description appendFormat:@", rewindPeriod=%f", self.rewindPeriod];
    [description appendFormat:@", rewindSpeed=%f", self.rewindSpeed];
    [description appendString:@">"];
    return description;
}
TRRewindRules trRewindRulesDefault() {
    static TRRewindRules _ret = (TRRewindRules){0.2, 1000, 15.0, 15.0};
    return _ret;
}
ODPType* trRewindRulesType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[TRRewindRulesWrap class] name:@"TRRewindRules" size:sizeof(TRRewindRules) wrap:^id(void* data, NSUInteger i) {
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

- (NSString*)description {
    return TRRewindRulesDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRewindRulesWrap* o = ((TRRewindRulesWrap*)(other));
    return TRRewindRulesEq(_value, o.value);
}

- (NSUInteger)hash {
    return TRRewindRulesHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



@implementation TRHistory
static ODClassType* _TRHistory_type;
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
        _canRewind = [ATVar applyInitial:@NO];
        _rewindCounter = [EGCounter applyLength:_rules.rewindPeriod];
        __states = [CNMList list];
        if([self class] == [TRHistory class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRHistory class]) _TRHistory_type = [ODClassType classTypeWithCls:[TRHistory class]];
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
                    __rewindNextTime = ((TRLevelState*)([__states head])).time;
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
                [[_level state] onSuccessF:^void(TRLevelState* state) {
                    [self addState:state];
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
    [_canRewind setValue:numb(!([__states isEmpty]) && __time - ((TRLevelState*)([__states last])).time > _rules.rewindPeriod)];
}

- (void)_init {
    [_rewindCounter finish];
}

- (CNFuture*)rewind {
    return [self promptF:^id() {
        if(!(unumb([[_rewindCounter isRunning] value])) && unumb([_canRewind value])) {
            __rewindNextTime = ((TRLevelState*)([__states head])).time;
            [_rewindCounter restart];
        }
        return nil;
    }];
}

- (ODClassType*)type {
    return [TRHistory type];
}

+ (ODClassType*)type {
    return _TRHistory_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendFormat:@", rules=%@", TRRewindRulesDescription(self.rules)];
    [description appendString:@">"];
    return description;
}

@end


