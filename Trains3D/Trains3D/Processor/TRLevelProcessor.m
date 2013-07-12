#import "TRLevelProcessor.h"

#import "EGProcessor.h"
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
        _switchProcessor = [TRSwitchProcessor switchProcessorWithRailroad:_level.railroad];
    }
    
    return self;
}

- (BOOL)processEvent:(EGEvent*)event {
    return [_switchProcessor processEvent:event] || [_railroadBuilderProcessor processEvent:event];
}

@end


