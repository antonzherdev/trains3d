#import "TRRailroadBuilderProcessor.h"

#import "CNReact.h"
@implementation TRRailroadBuilderProcessor
static CNClassType* _TRRailroadBuilderProcessor_type;
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
    if(self == [TRRailroadBuilderProcessor class]) _TRRailroadBuilderProcessor_type = [CNClassType classTypeWithCls:[TRRailroadBuilderProcessor class]];
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers recognizersWithItems:(@[[EGRecognizer applyTp:[EGPan apply] began:^BOOL(id<EGEvent> event) {
    if(((TRRailroadBuilderModeR)([[_builder.mode value] ordinal])) == TRRailroadBuilderMode_clear) {
        return NO;
    } else {
        [_builder eBeganLocation:[event location]];
        return YES;
    }
} changed:^void(id<EGEvent> event) {
    [_builder eChangedLocation:[event location]];
} ended:^void(id<EGEvent> event) {
    [_builder eEnded];
}], ((EGRecognizer*)([EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> event) {
    if(((TRRailroadBuilderModeR)([[_builder.mode value] ordinal])) == TRRailroadBuilderMode_clear) {
        [_builder eTapLocation:[event location]];
        return YES;
    } else {
        return NO;
    }
}]))])];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RailroadBuilderProcessor(%@)", _builder];
}

- (CNClassType*)type {
    return [TRRailroadBuilderProcessor type];
}

+ (CNClassType*)type {
    return _TRRailroadBuilderProcessor_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

