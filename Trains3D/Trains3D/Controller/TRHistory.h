#import "objd.h"
#import "ATActor.h"
@class TRLevel;
@class ATVar;
@class EGCounter;
@class ATReact;
@class TRLevelState;

@class TRHistory;
typedef struct TRRewindRules TRRewindRules;

struct TRRewindRules {
    CGFloat savingPeriod;
    NSUInteger limit;
    CGFloat rewindPeriod;
    CGFloat rewindSpeed;
};
static inline TRRewindRules TRRewindRulesMake(CGFloat savingPeriod, NSUInteger limit, CGFloat rewindPeriod, CGFloat rewindSpeed) {
    return (TRRewindRules){savingPeriod, limit, rewindPeriod, rewindSpeed};
}
static inline BOOL TRRewindRulesEq(TRRewindRules s1, TRRewindRules s2) {
    return eqf(s1.savingPeriod, s2.savingPeriod) && s1.limit == s2.limit && eqf(s1.rewindPeriod, s2.rewindPeriod) && eqf(s1.rewindSpeed, s2.rewindSpeed);
}
static inline NSUInteger TRRewindRulesHash(TRRewindRules self) {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.savingPeriod);
    hash = hash * 31 + self.limit;
    hash = hash * 31 + floatHash(self.rewindPeriod);
    hash = hash * 31 + floatHash(self.rewindSpeed);
    return hash;
}
NSString* TRRewindRulesDescription(TRRewindRules self);
ODPType* trRewindRulesType();
@interface TRRewindRulesWrap : NSObject
@property (readonly, nonatomic) TRRewindRules value;

+ (id)wrapWithValue:(TRRewindRules)value;
- (id)initWithValue:(TRRewindRules)value;
@end



@interface TRHistory : ATActor {
@private
    __weak TRLevel* _level;
    TRRewindRules _rules;
    CGFloat __timeToNext;
    CGFloat __time;
    CGFloat __rewindNextTime;
    ATVar* _canRewind;
    EGCounter* _rewindCounter;
    CNMList* __states;
}
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) TRRewindRules rules;
@property (nonatomic, readonly) ATVar* canRewind;
@property (nonatomic, readonly) EGCounter* rewindCounter;

+ (instancetype)historyWithLevel:(TRLevel*)level rules:(TRRewindRules)rules;
- (instancetype)initWithLevel:(TRLevel*)level rules:(TRRewindRules)rules;
- (ODClassType*)type;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (CNFuture*)states;
- (void)_init;
- (CNFuture*)rewind;
+ (ODClassType*)type;
@end


