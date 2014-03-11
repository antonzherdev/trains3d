#import "TRRailroadBuilderProcessor.h"

#import "TRRailroadBuilder.h"
#import "EGDirector.h"
@implementation TRRailroadBuilderProcessor{
    TRRailroadBuilder* _builder;
}
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
        [_builder beganLocation:[event location]];
        return YES;
    } changed:^void(id<EGEvent> event) {
        [_builder changedLocation:[event location]];
    } ended:^void(id<EGEvent> event) {
        [_builder ended];
    }]];
}

- (BOOL)isProcessorActive {
    return !([[EGDirector current] isPaused]);
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailroadBuilderProcessor* o = ((TRRailroadBuilderProcessor*)(other));
    return [self.builder isEqual:o.builder];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.builder hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"builder=%@", self.builder];
    [description appendString:@">"];
    return description;
}

@end


