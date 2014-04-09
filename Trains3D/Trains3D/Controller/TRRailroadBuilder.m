#import "TRRailroadBuilder.h"

#import "TRRailroad.h"
#import "TRLevel.h"
#import "ATObserver.h"
#import "ATReact.h"
#import "TRRailPoint.h"
#import "EGMapIso.h"
#import "TRTree.h"
#import "TRScore.h"
@implementation TRRailBuilding
static ODClassType* _TRRailBuilding_type;
@synthesize tp = _tp;
@synthesize rail = _rail;
@synthesize progress = _progress;

+ (instancetype)railBuildingWithTp:(TRRailBuildingType*)tp rail:(TRRail*)rail progress:(float)progress {
    return [[TRRailBuilding alloc] initWithTp:tp rail:rail progress:progress];
}

- (instancetype)initWithTp:(TRRailBuildingType*)tp rail:(TRRail*)rail progress:(float)progress {
    self = [super init];
    if(self) {
        _tp = tp;
        _rail = rail;
        _progress = progress;
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tp=%@", self.tp];
    [description appendFormat:@", rail=%@", self.rail];
    [description appendFormat:@", progress=%f", self.progress];
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


@implementation TRRailroadBuilderMode
static TRRailroadBuilderMode* _TRRailroadBuilderMode_simple;
static TRRailroadBuilderMode* _TRRailroadBuilderMode_build;
static TRRailroadBuilderMode* _TRRailroadBuilderMode_clear;
static NSArray* _TRRailroadBuilderMode_values;

+ (instancetype)railroadBuilderModeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[TRRailroadBuilderMode alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRailroadBuilderMode_simple = [TRRailroadBuilderMode railroadBuilderModeWithOrdinal:0 name:@"simple"];
    _TRRailroadBuilderMode_build = [TRRailroadBuilderMode railroadBuilderModeWithOrdinal:1 name:@"build"];
    _TRRailroadBuilderMode_clear = [TRRailroadBuilderMode railroadBuilderModeWithOrdinal:2 name:@"clear"];
    _TRRailroadBuilderMode_values = (@[_TRRailroadBuilderMode_simple, _TRRailroadBuilderMode_build, _TRRailroadBuilderMode_clear]);
}

+ (TRRailroadBuilderMode*)simple {
    return _TRRailroadBuilderMode_simple;
}

+ (TRRailroadBuilderMode*)build {
    return _TRRailroadBuilderMode_build;
}

+ (TRRailroadBuilderMode*)clear {
    return _TRRailroadBuilderMode_clear;
}

+ (NSArray*)values {
    return _TRRailroadBuilderMode_values;
}

@end


@implementation TRRailroadBuilderState
static ODClassType* _TRRailroadBuilderState_type;
@synthesize notFixedRailBuilding = _notFixedRailBuilding;
@synthesize isLocked = _isLocked;
@synthesize buildingRails = _buildingRails;
@synthesize isBuilding = _isBuilding;

+ (instancetype)railroadBuilderStateWithNotFixedRailBuilding:(TRRailBuilding*)notFixedRailBuilding isLocked:(BOOL)isLocked buildingRails:(CNImList*)buildingRails isBuilding:(BOOL)isBuilding {
    return [[TRRailroadBuilderState alloc] initWithNotFixedRailBuilding:notFixedRailBuilding isLocked:isLocked buildingRails:buildingRails isBuilding:isBuilding];
}

- (instancetype)initWithNotFixedRailBuilding:(TRRailBuilding*)notFixedRailBuilding isLocked:(BOOL)isLocked buildingRails:(CNImList*)buildingRails isBuilding:(BOOL)isBuilding {
    self = [super init];
    if(self) {
        _notFixedRailBuilding = notFixedRailBuilding;
        _isLocked = isLocked;
        _buildingRails = buildingRails;
        _isBuilding = isBuilding;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadBuilderState class]) _TRRailroadBuilderState_type = [ODClassType classTypeWithCls:[TRRailroadBuilderState class]];
}

- (BOOL)isDestruction {
    if(_notFixedRailBuilding != nil) return [((TRRailBuilding*)(nonnil(_notFixedRailBuilding))) isDestruction];
    else return NO;
}

- (BOOL)isConstruction {
    if(_notFixedRailBuilding != nil) return [((TRRailBuilding*)(nonnil(_notFixedRailBuilding))) isConstruction];
    else return NO;
}

- (TRRailroadBuilderState*)lock {
    return [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:_notFixedRailBuilding isLocked:YES buildingRails:_buildingRails isBuilding:_isBuilding];
}

- (TRRail*)railForUndo {
    return ((TRRailBuilding*)([_buildingRails headOpt])).rail;
}

- (TRRailroadBuilderState*)setIsBuilding:(BOOL)isBuilding {
    return [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:_notFixedRailBuilding isLocked:_isLocked buildingRails:_buildingRails isBuilding:isBuilding];
}

- (ODClassType*)type {
    return [TRRailroadBuilderState type];
}

+ (ODClassType*)type {
    return _TRRailroadBuilderState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"notFixedRailBuilding=%@", self.notFixedRailBuilding];
    [description appendFormat:@", isLocked=%d", self.isLocked];
    [description appendFormat:@", buildingRails=%@", self.buildingRails];
    [description appendFormat:@", isBuilding=%d", self.isBuilding];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRailroadBuilder
static CNNotificationHandle* _TRRailroadBuilder_modeNotification;
static ODClassType* _TRRailroadBuilder_type;
@synthesize level = _level;
@synthesize _startedPoint = __startedPoint;
@synthesize _railroad = __railroad;
@synthesize _state = __state;
@synthesize changed = _changed;
@synthesize buildingWasRefused = _buildingWasRefused;
@synthesize _firstTry = __firstTry;
@synthesize _fixedStart = __fixedStart;

+ (instancetype)railroadBuilderWithLevel:(TRLevel*)level {
    return [[TRRailroadBuilder alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRRailroadBuilder* _weakSelf = self;
    if(self) {
        _level = level;
        __startedPoint = nil;
        __railroad = _level.railroad;
        __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:nil isLocked:NO buildingRails:[CNImList apply] isBuilding:NO];
        _changed = [ATSignal signal];
        __mode = [ATVar applyInitial:TRRailroadBuilderMode.simple];
        _modeObs = [__mode observeF:^void(TRRailroadBuilderMode* m) {
            TRRailroadBuilder* _self = _weakSelf;
            [_TRRailroadBuilder_modeNotification postSender:_self data:m];
        }];
        _buildingWasRefused = [ATSignal signal];
        __firstTry = YES;
        __fixedStart = nil;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadBuilder class]) {
        _TRRailroadBuilder_type = [ODClassType classTypeWithCls:[TRRailroadBuilder class]];
        _TRRailroadBuilder_modeNotification = [CNNotificationHandle notificationHandleWithName:@"RailroadBuilder.modeNotification"];
    }
}

- (CNFuture*)state {
    return [self promptF:^TRRailroadBuilderState*() {
        return __state;
    }];
}

- (CNFuture*)restoreState:(TRRailroadBuilderState*)state {
    return [self promptF:^id() {
        [self clear];
        __state = state;
        return nil;
    }];
}

- (BOOL)tryBuildRlState:(TRRailroadState*)rlState rail:(TRRail*)rail {
    if(({
    id __tmp_0;
    {
        TRRailBuilding* _ = __state.notFixedRailBuilding;
        if(_ != nil) __tmp_0 = numb([_.rail isEqual:rail]);
        else __tmp_0 = nil;
    }
    ((__tmp_0 != nil) ? unumb(__tmp_0) : NO);
})) {
        return YES;
    } else {
        if(!([__mode value] == TRRailroadBuilderMode.clear) && [self canAddRlState:rlState rail:rail]) {
            __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:[TRRailBuilding railBuildingWithTp:TRRailBuildingType.construction rail:rail progress:0.0] isLocked:NO buildingRails:__state.buildingRails isBuilding:__state.isBuilding];
            [_changed post];
            return YES;
        } else {
            if([__mode value] == TRRailroadBuilderMode.clear && [[rlState rails] containsItem:rail]) {
                __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:[TRRailBuilding railBuildingWithTp:TRRailBuildingType.destruction rail:rail progress:0.0] isLocked:__state.isLocked buildingRails:__state.buildingRails isBuilding:__state.isBuilding];
                if([rlState isLockedRail:rail]) {
                    __state = [__state lock];
                    [_buildingWasRefused post];
                } else {
                    [[_level isLockedRail:rail] onSuccessF:^void(id locked) {
                        if(!(unumb(locked) == __state.isLocked)) {
                            __state = [__state lock];
                            [_buildingWasRefused post];
                            [_changed post];
                        }
                    }];
                }
                [_changed post];
                return YES;
            } else {
                [self clear];
                return NO;
            }
        }
    }
}

- (BOOL)checkCityRlState:(TRRailroadState*)rlState tile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    GEVec2i nextTile = [connector nextTile:tile];
    return [__railroad.map isFullTile:nextTile] || !([[rlState contentInTile:nextTile connector:[connector otherSideConnector]] isEmpty]);
}

- (void)clear {
    if(__state.notFixedRailBuilding != nil) {
        __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:nil isLocked:NO buildingRails:__state.buildingRails isBuilding:__state.isBuilding];
        [_changed post];
    }
}

- (void)fix {
    if(__state.isLocked) {
        [self clear];
    } else {
        TRRailBuilding* rb = __state.notFixedRailBuilding;
        if(rb != nil) {
            if([rb isConstruction]) {
                [__railroad.forest cutDownForRail:rb.rail];
            } else {
                [__railroad removeRail:rb.rail];
                [__mode setValue:TRRailroadBuilderMode.simple];
            }
            __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:nil isLocked:NO buildingRails:[CNImList applyItem:rb tail:__state.buildingRails] isBuilding:__state.isBuilding];
            [_changed post];
        }
    }
}

- (BOOL)canAddRlState:(TRRailroadState*)rlState rail:(TRRail*)rail {
    return [self checkCityRlState:rlState tile:rail.tile connector:rail.form.start] && [self checkCityRlState:rlState tile:rail.tile connector:rail.form.end] && [__railroad.map isFullTile:rail.tile] && [self checkBuildingsRlState:rlState rail:rail];
}

- (BOOL)checkBuildingsRlState:(TRRailroadState*)rlState rail:(TRRail*)rail {
    return !([__state.buildingRails existsWhere:^BOOL(TRRailBuilding* _) {
    return [((TRRailBuilding*)(_)).rail isEqual:rail];
}]) && [rlState canAddRail:rail] && [self checkBuildingsConnectorRlState:rlState tile:rail.tile connector:rail.form.start] && [self checkBuildingsConnectorRlState:rlState tile:rail.tile connector:rail.form.end];
}

- (BOOL)checkBuildingsConnectorRlState:(TRRailroadState*)rlState tile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    return [[[rlState contentInTile:tile connector:connector] rails] count] + [[[__state.buildingRails chain] filter:^BOOL(TRRailBuilding* _) {
    return GEVec2iEq(((TRRailBuilding*)(_)).rail.tile, tile) && [((TRRailBuilding*)(_)).rail.form containsConnector:connector];
}] count] < 2;
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    __weak TRRailroadBuilder* _weakSelf = self;
    return [self futureF:^id() {
        __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:__state.notFixedRailBuilding isLocked:__state.isLocked buildingRails:[[[[__state.buildingRails chain] map:^TRRailBuilding*(TRRailBuilding* b) {
            TRRailroadBuilder* _self = _weakSelf;
            float p = ((TRRailBuilding*)(b)).progress;
            BOOL less = p < 0.5;
            p += ((float)(delta / 4));
            if(less && p > 0.5) [_self->_changed post];
            return [TRRailBuilding railBuildingWithTp:((TRRailBuilding*)(b)).tp rail:((TRRailBuilding*)(b)).rail progress:p];
        }] filter:^BOOL(TRRailBuilding* b) {
            TRRailroadBuilder* _self = _weakSelf;
            if(((TRRailBuilding*)(b)).progress >= 1.0) {
                if([((TRRailBuilding*)(b)) isConstruction]) [_self->__railroad tryAddRail:((TRRailBuilding*)(b)).rail];
                else [_self->__railroad.score railRemoved];
                [_self->_changed post];
                return NO;
            } else {
                return YES;
            }
        }] toList] isBuilding:__state.isBuilding];
        if([__state isDestruction]) [[_level isLockedRail:((TRRailBuilding*)(nonnil(__state.notFixedRailBuilding))).rail] onSuccessF:^void(id lk) {
            if(!(unumb(lk) == __state.isLocked)) {
                __state = [__state lock];
                [_changed post];
                [_buildingWasRefused post];
            }
        }];
        return nil;
    }];
}

- (CNFuture*)undo {
    return [self futureF:^id() {
        TRRailBuilding* rb = [__state.buildingRails headOpt];
        if(rb != nil) {
            if([rb isDestruction]) [__railroad tryAddRail:rb.rail free:YES];
            __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:__state.notFixedRailBuilding isLocked:__state.isLocked buildingRails:[__state.buildingRails tail] isBuilding:__state.isBuilding];
            [_changed post];
        }
        return nil;
    }];
}

- (ATReact*)mode {
    return __mode;
}

- (CNFuture*)modeBuildFlip {
    return [self promptF:^id() {
        if([__mode value] == TRRailroadBuilderMode.build) [__mode setValue:TRRailroadBuilderMode.simple];
        else [__mode setValue:TRRailroadBuilderMode.build];
        return nil;
    }];
}

- (CNFuture*)modeClearFlip {
    return [self promptF:^id() {
        if([__mode value] == TRRailroadBuilderMode.clear) [__mode setValue:TRRailroadBuilderMode.simple];
        else [__mode setValue:TRRailroadBuilderMode.clear];
        return nil;
    }];
}

- (CNFuture*)setMode:(TRRailroadBuilderMode*)mode {
    return [self promptF:^id() {
        [__mode setValue:mode];
        return nil;
    }];
}

- (CNFuture*)eBeganLocation:(GEVec2)location {
    return [self promptF:^id() {
        __startedPoint = wrap(GEVec2, location);
        __firstTry = YES;
        return nil;
    }];
}

- (CNFuture*)eChangedLocation:(GEVec2)location {
    return [self lockAndOnSuccessFuture:[__railroad state] f:^id(TRRailroadState* rlState) {
        GELine2 line = geLine2ApplyP0P1((uwrap(GEVec2, nonnil(__startedPoint))), location);
        float len = geVec2Length(line.u);
        if(len > 0.5) {
            if(!([__state isDestruction])) {
                __state = [__state setIsBuilding:YES];
                GEVec2 nu = geVec2SetLength(line.u, 1.0);
                GELine2 nl = ((__fixedStart != nil) ? GELine2Make(line.p0, nu) : GELine2Make((geVec2SubVec2(line.p0, (geVec2MulF4(nu, 0.25)))), nu));
                GEVec2 mid = geLine2Mid(nl);
                GEVec2i tile = geVec2Round(mid);
                CNTuple* railOpt = [[[[[[[[[self possibleRailsAroundTile:tile] map:^CNTuple*(TRRail* rail) {
                    return tuple(rail, numf([self distanceBetweenRlState:rlState rail:rail paintLine:nl]));
                }] filter:^BOOL(CNTuple* _) {
                    return __fixedStart == nil || unumf(((CNTuple*)(_)).b) < 0.8;
                }] sortBy] ascBy:^id(CNTuple* _) {
                    return ((CNTuple*)(_)).b;
                }] endSort] topNumbers:4] filter:^BOOL(CNTuple* _) {
                    return [self canAddRlState:rlState rail:((CNTuple*)(_)).a] || [__mode value] == TRRailroadBuilderMode.clear;
                }] headOpt];
                if(railOpt != nil) {
                    __firstTry = YES;
                    TRRail* rail = ((CNTuple*)(railOpt)).a;
                    if([self tryBuildRlState:rlState rail:rail]) {
                        if(len > ((__fixedStart != nil) ? 1.6 : 1.0) && [__state isConstruction]) {
                            [self fix];
                            GELine2 rl = [rail line];
                            float la0 = geVec2LengthSquare((geVec2SubVec2(rl.p0, line.p0)));
                            float la1 = geVec2LengthSquare((geVec2SubVec2(rl.p0, geLine2P1(line))));
                            float lb0 = geVec2LengthSquare((geVec2SubVec2(geLine2P1(rl), line.p0)));
                            float lb1 = geVec2LengthSquare((geVec2SubVec2(geLine2P1(rl), geLine2P1(line))));
                            BOOL end0 = la0 < lb0;
                            BOOL end1 = la1 > lb1;
                            BOOL end = ((end0 == end1) ? end0 : la1 > la0);
                            __startedPoint = ((end) ? wrap(GEVec2, geLine2P1(rl)) : wrap(GEVec2, rl.p0));
                            TRRailConnector* con = ((end) ? rail.form.end : rail.form.start);
                            __fixedStart = tuple((wrap(GEVec2i, [con nextTile:rail.tile])), [con otherSideConnector]);
                        }
                    }
                } else {
                    if(__firstTry) {
                        __firstTry = NO;
                        [_buildingWasRefused post];
                    }
                }
            }
        } else {
            __firstTry = YES;
            [self clear];
        }
        return nil;
    }];
}

- (CNFuture*)eEnded {
    return [self futureF:^id() {
        [self fix];
        __firstTry = YES;
        __startedPoint = nil;
        __fixedStart = nil;
        __state = [__state setIsBuilding:NO];
        return nil;
    }];
}

- (CGFloat)distanceBetweenRlState:(TRRailroadState*)rlState rail:(TRRail*)rail paintLine:(GELine2)paintLine {
    GELine2 railLine = [rail line];
    if(__fixedStart != nil) {
        return ((CGFloat)(geVec2LengthSquare((geVec2SubVec2((((GEVec2Eq(paintLine.p0, railLine.p0)) ? geLine2P1(railLine) : railLine.p0)), geLine2P1(paintLine))))));
    } else {
        float p0d = float4MinB((geVec2Length((geVec2SubVec2(railLine.p0, paintLine.p0)))), (geVec2Length((geVec2SubVec2(railLine.p0, geLine2P1(paintLine))))));
        float p1d = float4MinB((geVec2Length((geVec2SubVec2(geLine2P1(railLine), paintLine.p0)))), (geVec2Length((geVec2SubVec2(geLine2P1(railLine), geLine2P1(paintLine))))));
        float d = float4Abs((geVec2DotVec2(railLine.u, geLine2N(paintLine)))) + p0d + p1d;
        NSUInteger c = [[[[rail.form connectors] chain] filter:^BOOL(TRRailConnector* connector) {
            return !([[rlState contentInTile:[((TRRailConnector*)(connector)) nextTile:rail.tile] connector:[((TRRailConnector*)(connector)) otherSideConnector]] isEmpty]);
        }] count];
        CGFloat k = ((c == 1) ? 0.7 : ((c == 2) ? 0.6 : 1.0));
        return ((CGFloat)(((float)(k * d))));
    }
}

- (CNChain*)possibleRailsAroundTile:(GEVec2i)tile {
    if(__fixedStart != nil) return [[[[TRRailForm values] chain] filter:^BOOL(TRRailForm* _) {
        return [((TRRailForm*)(_)) containsConnector:((CNTuple*)(__fixedStart)).b];
    }] map:^TRRail*(TRRailForm* _) {
        return [TRRail railWithTile:uwrap(GEVec2i, ((CNTuple*)(__fixedStart)).a) form:_];
    }];
    else return [[[[self tilesAroundTile:tile] chain] mul:[TRRailForm values]] map:^TRRail*(CNTuple* p) {
        return [TRRail railWithTile:uwrap(GEVec2i, ((CNTuple*)(p)).a) form:((CNTuple*)(p)).b];
    }];
}

- (NSArray*)tilesAroundTile:(GEVec2i)tile {
    return (@[wrap(GEVec2i, tile), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(1, 0))))), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(-1, 0))))), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(0, 1))))), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(0, -1))))), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(1, 1))))), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(-1, 1))))), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(1, -1))))), wrap(GEVec2i, (geVec2iAddVec2i(tile, (GEVec2iMake(-1, -1)))))]);
}

- (NSArray*)connectorsByDistanceFromPoint:(GEVec2)point {
    return [[[[[[TRRailConnector values] chain] sortBy] ascBy:^id(TRRailConnector* connector) {
        return numf4((geVec2LengthSquare((geVec2iSubVec2((geVec2iMulI([((TRRailConnector*)(connector)) vec], ((NSInteger)(0.5)))), point)))));
    }] endSort] toArray];
}

- (ODClassType*)type {
    return [TRRailroadBuilder type];
}

+ (CNNotificationHandle*)modeNotification {
    return _TRRailroadBuilder_modeNotification;
}

+ (ODClassType*)type {
    return _TRRailroadBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


