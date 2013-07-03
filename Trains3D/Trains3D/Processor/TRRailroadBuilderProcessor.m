#import "TRRailroadBuilderProcessor.h"

@implementation TRRailroadBuilderProcessor{
    TRRailroadBuilder* _builder;
    TRRailroadBuilderMouseProcessor* _mouseProcessor;
}
@synthesize builder = _builder;

+ (id)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder {
    return [[TRRailroadBuilderProcessor alloc] initWithBuilder:builder];
}

- (id)initWithBuilder:(TRRailroadBuilder*)builder {
    self = [super init];
    if(self) {
        _builder = builder;
        _mouseProcessor = [TRRailroadBuilderMouseProcessor railroadBuilderMouseProcessorWithBuilder:_builder];
    }
    
    return self;
}

- (void)processEvent:(EGEvent*)event {
    [event leftMouseProcessor:_mouseProcessor];
}

@end


@implementation TRRailroadBuilderMouseProcessor{
    TRRailroadBuilder* _builder;
    BOOL _downing;
}
@synthesize builder = _builder;

+ (id)railroadBuilderMouseProcessorWithBuilder:(TRRailroadBuilder*)builder {
    return [[TRRailroadBuilderMouseProcessor alloc] initWithBuilder:builder];
}

- (id)initWithBuilder:(TRRailroadBuilder*)builder {
    self = [super init];
    if(self) {
        _builder = builder;
        _downing = NO;
    }
    
    return self;
}

- (void)downEvent:(EGEvent*)event {
    _downing = YES;
}

- (void)dragEvent:(EGEvent*)event {
    if(_downing) {
    }
}

- (void)upEvent:(EGEvent*)event {
    if(_downing) {
        _downing = YES;
    }
}

@end


