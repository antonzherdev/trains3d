#import "TRRailroadBuilder.h"

#import "TRRailroad.h"
#import "TRLevel.h"
#import "TRRailPoint.h"
#import "EGMapIso.h"
#import "TRTree.h"
#import "TRScore.h"
#import "TRRailroadBuilderProcessor.h"
@implementation TRRailBuilding{
    TRRailBuildingType* _tp;
    TRRail* _rail;
    CGFloat _progress;
}
static ODClassType* _TRRailBuilding_type;
@synthesize tp = _tp;
@synthesize rail = _rail;
@synthesize progress = _progress;

+ (instancetype)railBuildingWithTp:(TRRailBuildingType*)tp rail:(TRRail*)rail {
    return [[TRRailBuilding alloc] initWithTp:tp rail:rail];
}

- (instancetype)initWithTp:(TRRailBuildingType*)tp rail:(TRRail*)rail {
    self = [super init];
    if(self) {
        _tp = tp;
        _rail = rail;
        _progress = 0.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailBuilding class]) _TRRailBuilding_type = [ODClassType classTypeWithCls:[TRRailBuilding class]];
}

- (BOOL)isDestruction {
    return _tp == TRRailBuildingType.destruction;
}

- (BOOL)isConstruction {
    return _tp == TRRailBuildingType.construction;
}

- (ODClassType*)type {
    return [TRRailBuilding type];
}

+ (ODClassType*)type {
    return _TRRailBuilding_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailBuilding* o = ((TRRailBuilding*)(other));
    return self.tp == o.tp && [self.rail isEqual:o.rail];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.tp ordinal];
    hash = hash * 31 + [self.rail hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tp=%@", self.tp];
    [description appendFormat:@", rail=%@", self.rail];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRailBuildingType
static TRRailBuildingType* _TRRailBuildingType_construction;
static TRRailBuildingType* _TRRailBuildingType_destruction;
static NSArray* _TRRailBuildingType_values;

+ (instancetype)railBuildingTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[TRRailBuildingType alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRailBuildingType_construction = [TRRailBuildingType railBuildingTypeWithOrdinal:0 name:@"construction"];
    _TRRailBuildingType_destruction = [TRRailBuildingType railBuildingTypeWithOrdinal:1 name:@"destruction"];
    _TRRailBuildingType_values = (@[_TRRailBuildingType_construction, _TRRailBuildingType_destruction]);
}

+ (TRRailBuildingType*)construction {
    return _TRRailBuildingType_construction;
}

+ (TRRailBuildingType*)destruction {
    return _TRRailBuildingType_destruction;
}

+ (NSArray*)values {
    return _TRRailBuildingType_values;
}

@end


@implementation TRRailroadBuilder{
    __weak TRLevel* _level;
    id _startedPoint;
    __weak TRRailroad* _railroad;
    BOOL _building;
    id __notFixedRailBuilding;
    BOOL __isLocked;
    CNMList* __buildingRails;
    BOOL __buildMode;
    BOOL __clearMode;
    BOOL _firstTry;
    id _fixedStart;
}
static CNNotificationHandle* _TRRailroadBuilder_changedNotification;
static CNNotificationHandle* _TRRailroadBuilder_buildModeNotification;
static CNNotificationHandle* _TRRailroadBuilder_clearModeNotification;
static CNNotificationHandle* _TRRailroadBuilder_refuseBuildNotification;
static ODClassType* _TRRailroadBuilder_type;
@synthesize level = _level;
@synthesize railroad = _railroad;
@synthesize building = _building;

+ (instancetype)railroadBuilderWithLevel:(TRLevel*)level {
    return [[TRRailroadBuilder alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _startedPoint = [CNOption none];
        _railroad = _level.railroad;
        _building = NO;
        __notFixedRailBuilding = [CNOption none];
        __isLocked = NO;
        __buildingRails = [CNMList list];
        __buildMode = NO;
        __clearMode = NO;
        _firstTry = YES;
        _fixedStart = [CNOption none];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadBuilder class]) {
        _TRRailroadBuilder_type = [ODClassType classTypeWithCls:[TRRailroadBuilder class]];
        _TRRailroadBuilder_changedNotification = [CNNotificationHandle notificationHandleWithName:@"Railroad builder changed"];
        _TRRailroadBuilder_buildModeNotification = [CNNotificationHandle notificationHandleWithName:@"buildModeNotification"];
        _TRRailroadBuilder_clearModeNotification = [CNNotificationHandle notificationHandleWithName:@"clearModeNotification"];
        _TRRailroadBuilder_refuseBuildNotification = [CNNotificationHandle notificationHandleWithName:@"refuseBuildNotification"];
    }
}

- (id)notFixedRailBuilding {
    return __notFixedRailBuilding;
}

- (BOOL)isLocked {
    return __isLocked;
}

- (id<CNSeq>)buildingRails {
    return __buildingRails;
}

- (id)railForUndo {
    return [[__buildingRails headOpt] mapF:^TRRail*(TRRailBuilding* _) {
        return ((TRRailBuilding*)(_)).rail;
    }];
}

- (BOOL)isDestruction {
    return [__notFixedRailBuilding isDefined] && [((TRRailBuilding*)([__notFixedRailBuilding get])) isDestruction];
}

- (BOOL)isConstruction {
    return [__notFixedRailBuilding isDefined] && [((TRRailBuilding*)([__notFixedRailBuilding get])) isConstruction];
}

- (BOOL)tryBuildRail:(TRRail*)rail {
    if([[__notFixedRailBuilding mapF:^TRRail*(TRRailBuilding* _) {
    return ((TRRailBuilding*)(_)).rail;
}] containsItem:rail]) {
        return YES;
    } else {
        if(!([self clearMode]) && [self canAddRail:rail]) {
            __notFixedRailBuilding = [CNOption applyValue:[TRRailBuilding railBuildingWithTp:TRRailBuildingType.construction rail:rail]];
            __isLocked = NO;
            [self changed];
            return YES;
        } else {
            if([self clearMode] && [[_railroad rails] containsItem:rail]) {
                __notFixedRailBuilding = [CNOption applyValue:[TRRailBuilding railBuildingWithTp:TRRailBuildingType.destruction rail:rail]];
                [self changed];
                [[_level isLockedRail:rail] onSuccessF:^void(id locked) {
                    if(!(unumb(locked) == __isLocked)) {
                        __isLocked = unumb(locked);
                        [self changed];
                    }
                }];
                return YES;
            } else {
                if([__notFixedRailBuilding isDefined]) {
                    __notFixedRailBuilding = [CNOption none];
                    [self changed];
                }
                return NO;
            }
        }
    }
}

- (void)changed {
    [_TRRailroadBuilder_changedNotification postSender:self];
}

- (BOOL)checkCityTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    GEVec2i nextTile = [connector nextTile:tile];
    return [_railroad.map isFullTile:nextTile] || !([[[_railroad state] contentInTile:nextTile connector:[connector otherSideConnector]] isEmpty]);
}

- (void)clear {
    if([__notFixedRailBuilding isDefined]) {
        __notFixedRailBuilding = [CNOption none];
        __isLocked = NO;
        [self changed];
    }
}

- (void)fix {
    if(__isLocked) {
        [self clear];
    } else {
        if([__notFixedRailBuilding isDefined]) {
            TRRailBuilding* rb = [__notFixedRailBuilding get];
            if([rb isConstruction]) {
                [_railroad.forest cutDownForRail:rb.rail];
            } else {
                [_railroad removeRail:rb.rail];
                [self setClearMode:NO];
            }
            [__buildingRails prependItem:rb];
            __notFixedRailBuilding = [CNOption none];
            __isLocked = NO;
            [self changed];
        }
    }
}

- (BOOL)canAddRail:(TRRail*)rail {
    return [self checkCityTile:rail.tile connector:rail.form.start] && [self checkCityTile:rail.tile connector:rail.form.end] && [_railroad.map isFullTile:rail.tile] && [self checkBuildingsRail:rail];
}

- (BOOL)checkBuildingsRail:(TRRail*)rail {
    return !([__buildingRails existsWhere:^BOOL(TRRailBuilding* _) {
    return [((TRRailBuilding*)(_)).rail isEqual:rail];
}]) && [[_railroad state] canAddRail:rail] && [self checkBuildingsConnectorTile:rail.tile connector:rail.form.start] && [self checkBuildingsConnectorTile:rail.tile connector:rail.form.end];
}

- (BOOL)checkBuildingsConnectorTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    return [[[[_railroad state] contentInTile:tile connector:connector] rails] count] + [[[__buildingRails chain] filter:^BOOL(TRRailBuilding* _) {
    return GEVec2iEq(((TRRailBuilding*)(_)).rail.tile, tile) && [((TRRailBuilding*)(_)).rail.form containsConnector:connector];
}] count] < 2;
}

- (void)updateWithDelta:(CGFloat)delta {
    __block BOOL hasEnd = NO;
    [__buildingRails forEach:^void(TRRailBuilding* b) {
        CGFloat p = ((TRRailBuilding*)(b)).progress;
        BOOL less = p < 0.5;
        p += delta / 4;
        if(less && p > 0.5) [self changed];
        hasEnd = hasEnd || p >= 1.0;
        ((TRRailBuilding*)(b)).progress = p;
    }];
    if(hasEnd) {
        [__buildingRails mutableFilterBy:^BOOL(TRRailBuilding* b) {
            if(((TRRailBuilding*)(b)).progress >= 1.0) {
                if([((TRRailBuilding*)(b)) isConstruction]) [_railroad tryAddRail:((TRRailBuilding*)(b)).rail];
                else [_railroad.score railRemoved];
                return NO;
            } else {
                return YES;
            }
        }];
        [self changed];
    }
    if([self isDestruction]) [[_level isLockedRail:((TRRailBuilding*)([__notFixedRailBuilding get])).rail] onSuccessF:^void(id lk) {
        if(!(unumb(lk) == __isLocked)) {
            __isLocked = unumb(lk);
            [self changed];
        }
    }];
}

- (void)undo {
    if(!([__buildingRails isEmpty])) {
        TRRailBuilding* rb = [__buildingRails head];
        if([rb isDestruction]) [_railroad tryAddRail:rb.rail];
        [__buildingRails removeHead];
        [self changed];
    }
}

- (BOOL)buildMode {
    return __buildMode;
}

- (void)setBuildMode:(BOOL)buildMode {
    if(__buildMode != buildMode) {
        __buildMode = buildMode;
        [_TRRailroadBuilder_buildModeNotification postSender:self];
    }
}

- (BOOL)clearMode {
    return __clearMode;
}

- (void)setClearMode:(BOOL)clearMode {
    if(__clearMode != clearMode) {
        __clearMode = clearMode;
        [_TRRailroadBuilder_clearModeNotification postSender:self];
    }
}

- (void)beganLocation:(GEVec2)location {
    _startedPoint = [CNOption applyValue:wrap(GEVec2, location)];
    _firstTry = YES;
}

- (void)changedLocation:(GEVec2)location {
    GELine2 line = geLine2ApplyP0P1((uwrap(GEVec2, [_startedPoint get])), location);
    float len = geVec2Length(line.u);
    if(len > 0.5) {
        if(!([self isDestruction])) {
            _building = YES;
            GEVec2 nu = geVec2SetLength(line.u, 1.0);
            GELine2 nl = (([_fixedStart isDefined]) ? GELine2Make(line.p0, nu) : GELine2Make((geVec2SubVec2(line.p0, (geVec2MulF(nu, 0.25)))), nu));
            GEVec2 mid = geLine2Mid(nl);
            GEVec2i tile = geVec2Round(mid);
            id railOpt = [[[[[[[[[self possibleRailsAroundTile:tile] map:^CNTuple*(TRRail* rail) {
                return tuple(rail, numf([self distanceBetweenRail:rail paintLine:nl]));
            }] filter:^BOOL(CNTuple* _) {
                return [_fixedStart isEmpty] || unumf(((CNTuple*)(_)).b) < 0.8;
            }] sortBy] ascBy:^id(CNTuple* _) {
                return ((CNTuple*)(_)).b;
            }] endSort] topNumbers:4] filter:^BOOL(CNTuple* _) {
                return [self canAddRail:((CNTuple*)(_)).a] || [self clearMode];
            }] headOpt];
            if([railOpt isDefined]) {
                _firstTry = YES;
                TRRail* rail = ((CNTuple*)([railOpt get])).a;
                if([self tryBuildRail:rail]) {
                    if(len > (([_fixedStart isDefined]) ? 1.6 : 1) && [self isConstruction]) {
                        [self fix];
                        GELine2 rl = [rail line];
                        float la0 = geVec2LengthSquare((geVec2SubVec2(rl.p0, line.p0)));
                        float la1 = geVec2LengthSquare((geVec2SubVec2(rl.p0, geLine2P1(line))));
                        float lb0 = geVec2LengthSquare((geVec2SubVec2(geLine2P1(rl), line.p0)));
                        float lb1 = geVec2LengthSquare((geVec2SubVec2(geLine2P1(rl), geLine2P1(line))));
                        BOOL end0 = la0 < lb0;
                        BOOL end1 = la1 > lb1;
                        BOOL end = ((end0 == end1) ? end0 : la1 > la0);
                        _startedPoint = ((end) ? [CNOption applyValue:wrap(GEVec2, geLine2P1(rl))] : [CNOption applyValue:wrap(GEVec2, rl.p0)]);
                        TRRailConnector* con = ((end) ? rail.form.end : rail.form.start);
                        _fixedStart = [CNOption applyValue:tuple((wrap(GEVec2i, [con nextTile:rail.tile])), [con otherSideConnector])];
                    }
                }
            } else {
                if(_firstTry) {
                    _firstTry = NO;
                    [_TRRailroadBuilder_refuseBuildNotification postSender:[TRRailroadBuilderProcessor railroadBuilderProcessorWithBuilder:self]];
                }
            }
        }
    } else {
        _firstTry = YES;
        [self clear];
    }
}

- (void)ended {
    [self fix];
    _firstTry = YES;
    _startedPoint = [CNOption none];
    _fixedStart = [CNOption none];
    _building = NO;
}

- (CGFloat)distanceBetweenRail:(TRRail*)rail paintLine:(GELine2)paintLine {
    GELine2 railLine = [rail line];
    if([_fixedStart isDefined]) {
        return ((CGFloat)(geVec2LengthSquare((geVec2SubVec2((((GEVec2Eq(paintLine.p0, railLine.p0)) ? geLine2P1(railLine) : railLine.p0)), geLine2P1(paintLine))))));
    } else {
        float p0d = float4MinB((geVec2Length((geVec2SubVec2(railLine.p0, paintLine.p0)))), (geVec2Length((geVec2SubVec2(railLine.p0, geLine2P1(paintLine))))));
        float p1d = float4MinB((geVec2Length((geVec2SubVec2(geLine2P1(railLine), paintLine.p0)))), (geVec2Length((geVec2SubVec2(geLine2P1(railLine), geLine2P1(paintLine))))));
        float d = float4Abs((geVec2DotVec2(railLine.u, geLine2N(paintLine)))) + p0d + p1d;
        NSUInteger c = [[[[rail.form connectors] chain] filter:^BOOL(TRRailConnector* connector) {
            return !([[[_railroad state] contentInTile:[((TRRailConnector*)(connector)) nextTile:rail.tile] connector:[((TRRailConnector*)(connector)) otherSideConnector]] isEmpty]);
        }] count];
        CGFloat k = ((c == 1) ? 0.7 : ((c == 2) ? 0.6 : 1.0));
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

- (id<CNImSeq>)tilesAroundTile:(GEVec2i)tile {
    return (@[wrap(GEVec2i, tile), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(1, 0))))), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(-1, 0))))), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(0, 1))))), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(0, -1))))), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(1, 1))))), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(-1, 1))))), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(1, -1))))), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(-1, -1)))))]);
}

- (id<CNImSeq>)connectorsByDistanceFromPoint:(GEVec2)point {
    return [[[[[[TRRailConnector values] chain] sortBy] ascBy:^id(TRRailConnector* connector) {
        return numf4((geVec2LengthSquare((geVec2SubVec2((geVec2iMulF([((TRRailConnector*)(connector)) vec], 0.5)), point)))));
    }] endSort] toArray];
}

- (ODClassType*)type {
    return [TRRailroadBuilder type];
}

+ (CNNotificationHandle*)changedNotification {
    return _TRRailroadBuilder_changedNotification;
}

+ (CNNotificationHandle*)buildModeNotification {
    return _TRRailroadBuilder_buildModeNotification;
}

+ (CNNotificationHandle*)clearModeNotification {
    return _TRRailroadBuilder_clearModeNotification;
}

+ (CNNotificationHandle*)refuseBuildNotification {
    return _TRRailroadBuilder_refuseBuildNotification;
}

+ (ODClassType*)type {
    return _TRRailroadBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailroadBuilder* o = ((TRRailroadBuilder*)(other));
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


