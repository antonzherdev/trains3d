#import "EGGameCenter.h"

@implementation EGLocalPlayerScore{
    long _value;
    NSUInteger _rank;
    NSUInteger _maxRank;
}
static ODClassType* _EGLocalPlayerScore_type;
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
    if(self == [EGLocalPlayerScore class]) _EGLocalPlayerScore_type = [ODClassType classTypeWithCls:[EGLocalPlayerScore class]];
}

- (CGFloat)percent {
    return (((CGFloat)(_rank)) - 1) / _maxRank;
}

- (ODClassType*)type {
    return [EGLocalPlayerScore type];
}

+ (ODClassType*)type {
    return _EGLocalPlayerScore_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGLocalPlayerScore* o = ((EGLocalPlayerScore*)(other));
    return self.value == o.value && self.rank == o.rank && self.maxRank == o.maxRank;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.value;
    hash = hash * 31 + self.rank;
    hash = hash * 31 + self.maxRank;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"value=%ld", self.value];
    [description appendFormat:@", rank=%lu", (unsigned long)self.rank];
    [description appendFormat:@", maxRank=%lu", (unsigned long)self.maxRank];
    [description appendString:@">"];
    return description;
}

@end


