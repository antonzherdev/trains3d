#import "TRRailroadBuilderProcessor.h"

#import "TRRailroadBuilder.h"
#import "EGDirector.h"
#import "ATReact.h"
@implementation TRRailroadBuilderProcessor
static ODClassType* _TRRailroadBuilderProcessor_type;
@synthesize builder = _builder;

+ (instancetype)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder {
    return [[TRRailroadBuilderProcessor alloc] initWithBuilder:builder];
}

- (instancetype)initWithBuilder:(TRRailroadBuilder*)builder {
    self = [super init];
    if(self) _builder = builder;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadBuilderProcessor class]) _TRRailroadBuilderProcessor_type = [ODClassType classTypeWithCls:[TRRailroadBuilderProcessor class]];
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGPan apply] began:^BOOL(id<EGEvent> event) {
        [_builder eBeganLocation:[event location]];
        return YES;
    } changed:^void(id<EGEvent> event) {
        [_builder eChangedLocation:[event location]];
    } ended:^void(id<EGEvent> event) {
        [_builder eEnded];
    }]];
}

- (BOOL)isProcessorActive {
    return !(unumb([[EGDirector current].isPaused value]));
}

- (ODClassType*)type {
    return [TRRailroadBuilderProcessor type];
}

+ (ODClassType*)type {
    return _TRRailroadBuilderProcessor_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"builder=%@", self.builder];
    [description appendString:@">"];
    return description;
}

@end


