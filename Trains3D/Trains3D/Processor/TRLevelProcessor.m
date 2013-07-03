#import "TRLevelProcessor.h"

@implementation TRLevelProcessor{
    TRLevel* _level;
    TRRailroadBuilderProcessor* _railroadBuilderProcessor;
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
    }
    
    return self;
}

- (void)processEvent:(EGEvent*)event {
    [_railroadBuilderProcessor processEvent:event];
}

@end


