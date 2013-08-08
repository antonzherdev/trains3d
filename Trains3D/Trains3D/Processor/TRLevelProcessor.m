#import "TRLevelProcessor.h"

#import "TRSwitchProcessor.h"
#import "TRLevel.h"
#import "TRLevelView.h"
#import "TRRailroad.h"
@implementation TRLevelProcessor{
    TRLevel* _level;
    TRRailroadBuilderProcessor* _railroadBuilderProcessor;
    TRSwitchProcessor* _switchProcessor;
}
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

- (BOOL)processEvent:(EGEvent*)event {
    return [_switchProcessor processEvent:event] || [_railroadBuilderProcessor processEvent:event];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelProcessor* o = ((TRLevelProcessor*)other);
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


