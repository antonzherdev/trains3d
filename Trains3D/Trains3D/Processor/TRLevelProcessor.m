#import "TRLevelProcessor.h"

#import "TRLevel.h"
#import "TRRailroadBuilderProcessor.h"
#import "TRRailroad.h"
#import "TRSwitchProcessor.h"
@implementation TRLevelProcessor{
    TRLevel* _level;
    TRRailroadBuilderProcessor* _railroadBuilderProcessor;
    TRSwitchProcessor* _switchProcessor;
}
static ODClassType* _TRLevelProcessor_type;
@synthesize level = _level;

+ (id)levelProcessorWithLevel:(TRLevel*)level {
    return [[TRLevelProcessor alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _railroadBuilderProcessor = [TRRailroadBuilderProcessor railroadBuilderProcessorWithBuilder:_level.railroad.builder];
        _switchProcessor = [TRSwitchProcessor switchProcessorWithLevel:_level];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelProcessor_type = [ODClassType classTypeWithCls:[TRLevelProcessor class]];
}

- (BOOL)processEvent:(EGEvent*)event {
    return [_switchProcessor processEvent:event] || [_railroadBuilderProcessor processEvent:event];
}

- (ODClassType*)type {
    return [TRLevelProcessor type];
}

+ (ODClassType*)type {
    return _TRLevelProcessor_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelProcessor* o = ((TRLevelProcessor*)(other));
    return [self.level isEqual:o.level];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


