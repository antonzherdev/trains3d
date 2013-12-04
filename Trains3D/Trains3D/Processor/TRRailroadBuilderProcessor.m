#import "TRRailroadBuilderProcessor.h"

#import "TRRailroad.h"
#import "TRRailPoint.h"
#import "EGDirector.h"
@implementation TRRailroadBuilderProcessor{
    TRRailroadBuilder* _builder;
    id _startedPoint;
}
static ODClassType* _TRRailroadBuilderProcessor_type;
@synthesize builder = _builder;

+ (id)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder {
    return [[TRRailroadBuilderProcessor alloc] initWithBuilder:builder];
}

- (id)initWithBuilder:(TRRailroadBuilder*)builder {
    self = [super init];
    if(self) {
        _builder = builder;
        _startedPoint = [CNOption none];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRailroadBuilderProcessor_type = [ODClassType classTypeWithCls:[TRRailroadBuilderProcessor class]];
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGPan apply] began:^BOOL(id<EGEvent> event) {
        _startedPoint = [CNOption applyValue:wrap(GEVec2, [event location])];
        return YES;
    } changed:^void(id<EGEvent> event) {
        GELine2 line = geLine2ApplyP0P1(uwrap(GEVec2, [_startedPoint get]), [event location]);
        if(geVec2LengthSquare(line.u) > 0.25) {
            GELine2 nl = geLine2SetLength(line, 0.5);
            GEVec2 mid = geLine2Mid(nl);
            GEVec2i tile = geVec2Round(mid);
            TRRailConnector* start = [[self connectorsByDistanceFromPoint:geVec2SubVec2(line.p0, geVec2ApplyVec2i(tile))] head];
            id<CNSeq> ends = [self connectorsByDistanceFromPoint:geVec2SubVec2(geLine2P1(line), geVec2ApplyVec2i(tile))];
            TRRailConnector* end = [ends head];
            if(end == start) end = [ends applyIndex:1];
            if([_builder tryBuildRail:[TRRail railWithTile:tile form:[TRRailForm formForConnector1:start connector2:end]]]) {
                if(geVec2Length(line.u) > 1.5) {
                    [_builder fix];
                    _startedPoint = [CNOption applyValue:wrap(GEVec2, geVec2iAddVec2(tile, geVec2iMulF([end vec], 0.5)))];
                }
            }
        } else {
            [_builder clear];
        }
    } ended:^void(id<EGEvent> event) {
        [_builder fix];
        _startedPoint = [CNOption none];
    }]];
}

- (id<CNSeq>)connectorsByDistanceFromPoint:(GEVec2)point {
    return [[[[[[TRRailConnector values] chain] sortBy] ascBy:^id(TRRailConnector* connector) {
        return numf4(geVec2LengthSquare(geVec2SubVec2(geVec2iMulF([((TRRailConnector*)(connector)) vec], 0.5), point)));
    }] endSort] toArray];
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


