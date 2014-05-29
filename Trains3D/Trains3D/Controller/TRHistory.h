#import "objd.h"
#import "CNActor.h"
@class TRLevel;
@class CNVar;
@class EGCounter;
@class CNFuture;
@class CNReact;
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
NSString* trRewindRulesDescription(TRRewindRules self);
BOOL trRewindRulesIsEqualTo(TRRewindRules self, TRRewindRules to);
NSUInteger trRewindRulesHash(TRRewindRules self);
TRRewindRules trRewindRulesDefault();
CNPType* trRewindRulesType();
@interface TRRewindRulesWrap : NSObject
@property (readonly, nonatomic) TRRewindRules value;

+ (id)wrapWithValue:(TRRewindRules)value;
- (id)initWithValue:(TRRewindRules)value;
@end



@interface TRHistory : CNActor {
@protected
    __weak TRLevel* _level;
    TRRewindRules _rules;
    CGFloat __timeToNext;
    CGFloat __time;
    CGFloat __rewindNextTime;
    CNVar* _canRewind;
    EGCounter* _rewindCounter;
    CNMList* __states;
}
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) TRRewindRules rules;
@property (nonatomic, readonly) CNVar* canRewind;
@property (nonatomic, readonly) EGCounter* rewindCounter;

+ (instancetype)historyWithLevel:(TRLevel*)level rules:(TRRewindRules)rules;
- (instancetype)initWithLevel:(TRLevel*)level rules:(TRRewindRules)rules;
- (CNClassType*)type;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (CNFuture*)states;
- (void)_init;
- (CNFuture*)rewind;
- (NSString*)description;
+ (CNClassType*)type;
@end


