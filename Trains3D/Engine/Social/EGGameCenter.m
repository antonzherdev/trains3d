#import "EGGameCenter.h"

@implementation EGLocalPlayerScore
static CNClassType* _EGLocalPlayerScore_type;
@synthesize value = _value;
@synthesize rank = _rank;
@synthesize maxRank = _maxRank;

+ (instancetype)localPlayerScoreWithValue:(long)value rank:(NSUInteger)rank maxRank:(NSUInteger)maxRank {
    return [[EGLocalPlayerScore alloc] initWithValue:value rank:rank maxRank:maxRank];
}

- (instancetype)initWithValue:(long)value rank:(NSUInteger)rank maxRank:(NSUInteger)maxRank {
    self = [super init];
    if(self) {
        _value = value;
        _rank = rank;
        _maxRank = maxRank;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGLocalPlayerScore class]) _EGLocalPlayerScore_type = [CNClassType classTypeWithCls:[EGLocalPlayerScore class]];
}

- (CGFloat)percent {
    return (((CGFloat)(_rank)) - 1) / _maxRank;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"LocalPlayerScore(%ld, %lu, %lu)", _value, (unsigned long)_rank, (unsigned long)_maxRank];
}

- (CNClassType*)type {
    return [EGLocalPlayerScore type];
}

+ (CNClassType*)type {
    return _EGLocalPlayerScore_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

