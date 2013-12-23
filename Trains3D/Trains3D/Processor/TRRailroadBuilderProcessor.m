#import "TRRailroadBuilderProcessor.h"

#import "TRRailroad.h"
#import "TRRailPoint.h"
#import "EGDirector.h"
@implementation TRRailroadBuilderProcessor{
    TRRailroadBuilder* _builder;
    id _startedPoint;
    BOOL _firstTry;
    id _fixedStart;
}
static CNNotificationHandle* _TRRailroadBuilderProcessor_refuseBuildNotification;
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
        _firstTry = YES;
        _fixedStart = [CNOption none];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRailroadBuilderProcessor_type = [ODClassType classTypeWithCls:[TRRailroadBuilderProcessor class]];
    _TRRailroadBuilderProcessor_refuseBuildNotification = [CNNotificationHandle notificationHandleWithName:@"refuseBuildNotification"];
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGPan apply] began:^BOOL(id<EGEvent> event) {
        _startedPoint = [CNOption applyValue:wrap(GEVec2, [event location])];
        _firstTry = YES;
        return YES;
    } changed:^void(id<EGEvent> event) {
        GELine2 line = geLine2ApplyP0P1(uwrap(GEVec2, [_startedPoint get]), [event location]);
        float len = geVec2Length(line.u);
        if(len > 0.5) {
            GEVec2 nu = geVec2SetLength(line.u, 1.0);
            GELine2 nl = (([_fixedStart isDefined]) ? GELine2Make(line.p0, nu) : GELine2Make(geVec2SubVec2(line.p0, geVec2MulF(nu, 0.25)), nu));
            GEVec2 mid = geLine2Mid(nl);
            GEVec2i tile = geVec2Round(mid);
            id railOpt = [[[[[[[[[self possibleRailsAroundTile:tile] map:^CNTuple*(TRRail* rail) {
                return tuple(rail, numf([self distanceBetweenRail:rail paintLine:nl]));
            }] filter:^BOOL(CNTuple* _) {
                return unumf(((CNTuple*)(_)).b) < (([_fixedStart isDefined]) ? 0.8 : 0.6);
            }] sortBy] ascBy:^id(CNTuple* _) {
                return ((CNTuple*)(_)).b;
            }] endSort] topNumbers:4] filter:^BOOL(CNTuple* _) {
                return [_builder canAddRail:((CNTuple*)(_)).a];
            }] headOpt];
            if([railOpt isDefined]) {
                _firstTry = YES;
                TRRail* rail = ((CNTuple*)([railOpt get])).a;
                if([_builder tryBuildRail:rail]) {
                    if(len > (([_fixedStart isDefined]) ? 1.6 : 1)) {
                        [_builder fix];
                        GELine2 rl = [rail line];
                        float la0 = geVec2LengthSquare(geVec2SubVec2(rl.p0, line.p0));
                        float la1 = geVec2LengthSquare(geVec2SubVec2(rl.p0, geLine2P1(line)));
                        float lb0 = geVec2LengthSquare(geVec2SubVec2(geLine2P1(rl), line.p0));
                        float lb1 = geVec2LengthSquare(geVec2SubVec2(geLine2P1(rl), geLine2P1(line)));
                        BOOL end0 = la0 < lb0;
                        BOOL end1 = la1 > lb1;
                        BOOL end = ((end0 == end1) ? end0 : la1 > la0);
                        _startedPoint = ((end) ? [CNOption applyValue:wrap(GEVec2, geLine2P1(rl))] : [CNOption applyValue:wrap(GEVec2, rl.p0)]);
                        TRRailConnector* con = ((end) ? rail.form.end : rail.form.start);
                        _fixedStart = [CNOption applyValue:tuple(wrap(GEVec2i, [con nextTile:rail.tile]), [con otherSideConnector])];
                    }
                }
            } else {
                if(_firstTry) {
                    _firstTry = NO;
                    [_TRRailroadBuilderProcessor_refuseBuildNotification post];
                }
            }
        } else {
            _firstTry = YES;
            [_builder clear];
        }
    } ended:^void(id<EGEvent> event) {
        [_builder fix];
        _firstTry = YES;
        _startedPoint = [CNOption none];
        _fixedStart = [CNOption none];
    }]];
}

- (CGFloat)distanceBetweenRail:(TRRail*)rail paintLine:(GELine2)paintLine {
    GELine2 railLine = [rail line];
    if([_fixedStart isDefined]) {
        return ((CGFloat)(geVec2LengthSquare(geVec2SubVec2(((GEVec2Eq(paintLine.p0, railLine.p0)) ? geLine2P1(railLine) : railLine.p0), geLine2P1(paintLine)))));
    } else {
        float p0d = float4MinB(geVec2Length(geVec2SubVec2(railLine.p0, paintLine.p0)), geVec2Length(geVec2SubVec2(railLine.p0, geLine2P1(paintLine))));
        float p1d = float4MinB(geVec2Length(geVec2SubVec2(geLine2P1(railLine), paintLine.p0)), geVec2Length(geVec2SubVec2(geLine2P1(railLine), geLine2P1(paintLine))));
        float d = float4Abs(geVec2DotVec2(railLine.u, geLine2N(paintLine))) * 0.5 + p0d + p1d;
        NSUInteger c = [[[[rail.form connectors] chain] filter:^BOOL(TRRailConnector* connector) {
            return !([[_builder.railroad contentInTile:[((TRRailConnector*)(connector)) nextTile:rail.tile] connector:[((TRRailConnector*)(connector)) otherSideConnector]] isEmpty]);
        }] count];
        CGFloat k = ((c == 1) ? 0.5 : ((c == 2) ? 0.4 : 1.0));
        return k * d;
    }
}

- (CNChain*)possibleRailsAroundTile:(GEVec2i)tile {
    if([_fixedStart isDefined]) return [[[[TRRailForm values] chain] filter:^BOOL(TRRailForm* _) {
        return [((TRRailForm*)(_)) containsConnector:((CNTuple*)([_fixedStart get])).b];
    }] map:^TRRail*(TRRailForm* _) {
        return [TRRail railWithTile:uwrap(GEVec2i, ((CNTuple*)([_fixedStart get])).a) form:_];
    }];
    else return [[[[self tilesAroundTile:tile] chain] mul:[TRRailForm values]] map:^TRRail*(CNTuple* p) {
        return [TRRail railWithTile:uwrap(GEVec2i, ((CNTuple*)(p)).a) form:((CNTuple*)(p)).b];
    }];
}

- (id<CNSeq>)tilesAroundTile:(GEVec2i)tile {
    return (@[wrap(GEVec2i, tile), wrap(GEVec2i, geVec2iAddVec2i(tile, GEVec2iMake(1, 0))), wrap(GEVec2i, geVec2iAddVec2i(tile, GEVec2iMake(-1, 0))), wrap(GEVec2i, geVec2iAddVec2i(tile, GEVec2iMake(0, 1))), wrap(GEVec2i, geVec2iAddVec2i(tile, GEVec2iMake(0, -1))), wrap(GEVec2i, geVec2iAddVec2i(tile, GEVec2iMake(1, 1))), wrap(GEVec2i, geVec2iAddVec2i(tile, GEVec2iMake(-1, 1))), wrap(GEVec2i, geVec2iAddVec2i(tile, GEVec2iMake(1, -1))), wrap(GEVec2i, geVec2iAddVec2i(tile, GEVec2iMake(-1, -1)))]);
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

+ (CNNotificationHandle*)refuseBuildNotification {
    return _TRRailroadBuilderProcessor_refuseBuildNotification;
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


