#import "TRRailroadBuilder.h"

#import "TRRailroad.h"
#import "TRLevel.h"
#import "TRRailPoint.h"
#import "EGMapIso.h"
#import "TRTree.h"
#import "TRScore.h"
@implementation TRRailBuilding{
    TRRailBuildingType* _tp;
    TRRail* _rail;
    float _progress;
}
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailBuilding* o = ((TRRailBuilding*)(other));
    return self.tp == o.tp && [self.rail isEqual:o.rail] && eqf4(self.progress, o.progress);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.tp ordinal];
    hash = hash * 31 + [self.rail hash];
    hash = hash * 31 + float4Hash(self.progress);
    return hash;
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


@implementation TRRailroadBuilderState{
    id _notFixedRailBuilding;
    BOOL _isLocked;
    CNImList* _buildingRails;
    BOOL _isBuilding;
}
static ODClassType* _TRRailroadBuilderState_type;
@synthesize notFixedRailBuilding = _notFixedRailBuilding;
@synthesize isLocked = _isLocked;
@synthesize buildingRails = _buildingRails;
@synthesize isBuilding = _isBuilding;

+ (instancetype)railroadBuilderStateWithNotFixedRailBuilding:(id)notFixedRailBuilding isLocked:(BOOL)isLocked buildingRails:(CNImList*)buildingRails isBuilding:(BOOL)isBuilding {
    return [[TRRailroadBuilderState alloc] initWithNotFixedRailBuilding:notFixedRailBuilding isLocked:isLocked buildingRails:buildingRails isBuilding:isBuilding];
}

- (instancetype)initWithNotFixedRailBuilding:(id)notFixedRailBuilding isLocked:(BOOL)isLocked buildingRails:(CNImList*)buildingRails isBuilding:(BOOL)isBuilding {
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
    return [_notFixedRailBuilding isDefined] && [((TRRailBuilding*)([_notFixedRailBuilding get])) isDestruction];
}

- (BOOL)isConstruction {
    return [_notFixedRailBuilding isDefined] && [((TRRailBuilding*)([_notFixedRailBuilding get])) isConstruction];
}

- (TRRailroadBuilderState*)lock {
    return [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:_notFixedRailBuilding isLocked:YES buildingRails:_buildingRails isBuilding:_isBuilding];
}

- (id)railForUndo {
    return [[_buildingRails headOpt] mapF:^TRRail*(TRRailBuilding* _) {
        return ((TRRailBuilding*)(_)).rail;
    }];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailroadBuilderState* o = ((TRRailroadBuilderState*)(other));
    return [self.notFixedRailBuilding isEqual:o.notFixedRailBuilding] && self.isLocked == o.isLocked && [self.buildingRails isEqual:o.buildingRails] && self.isBuilding == o.isBuilding;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.notFixedRailBuilding hash];
    hash = hash * 31 + self.isLocked;
    hash = hash * 31 + [self.buildingRails hash];
    hash = hash * 31 + self.isBuilding;
    return hash;
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


@implementation TRRailroadBuilder{
    __weak TRLevel* _level;
    id __startedPoint;
    __weak TRRailroad* __railroad;
    TRRailroadBuilderState* __state;
    BOOL __isLocked;
    TRRailroadBuilderMode* __mode;
    BOOL __firstTry;
    id __fixedStart;
}
static CNNotificationHandle* _TRRailroadBuilder_changedNotification;
static CNNotificationHandle* _TRRailroadBuilder_modeNotification;
static CNNotificationHandle* _TRRailroadBuilder_refuseBuildNotification;
static ODClassType* _TRRailroadBuilder_type;
@synthesize level = _level;
@synthesize _startedPoint = __startedPoint;
@synthesize _railroad = __railroad;
@synthesize _state = __state;
@synthesize _mode = __mode;
@synthesize _firstTry = __firstTry;
@synthesize _fixedStart = __fixedStart;

+ (instancetype)railroadBuilderWithLevel:(TRLevel*)level {
    return [[TRRailroadBuilder alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        __startedPoint = [CNOption none];
        __railroad = _level.railroad;
        __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:[CNOption none] isLocked:NO buildingRails:[CNImList apply] isBuilding:NO];
        __isLocked = NO;
        __mode = TRRailroadBuilderMode.simple;
        __firstTry = YES;
        __fixedStart = [CNOption none];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadBuilder class]) {
        _TRRailroadBuilder_type = [ODClassType classTypeWithCls:[TRRailroadBuilder class]];
        _TRRailroadBuilder_changedNotification = [CNNotificationHandle notificationHandleWithName:@"Railroad builder changed"];
        _TRRailroadBuilder_modeNotification = [CNNotificationHandle notificationHandleWithName:@"RailroadBuilder.modeNotification"];
        _TRRailroadBuilder_refuseBuildNotification = [CNNotificationHandle notificationHandleWithName:@"refuseBuildNotification"];
    }
}

- (CNFuture*)state {
    __weak TRRailroadBuilder* _weakSelf = self;
    return [self promptF:^TRRailroadBuilderState*() {
        return _weakSelf._state;
    }];
}

- (BOOL)isLocked {
    return __isLocked;
}

- (BOOL)tryBuildRlState:(TRRailroadState*)rlState rail:(TRRail*)rail {
    if([[__state.notFixedRailBuilding mapF:^TRRail*(TRRailBuilding* _) {
    return ((TRRailBuilding*)(_)).rail;
}] containsItem:rail]) {
        return YES;
    } else {
        if(__mode != TRRailroadBuilderMode.clear && [self canAddRlState:rlState rail:rail]) {
            __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:[CNOption applyValue:[TRRailBuilding railBuildingWithTp:TRRailBuildingType.construction rail:rail progress:0.0]] isLocked:NO buildingRails:__state.buildingRails isBuilding:__state.isBuilding];
            [self changed];
            return YES;
        } else {
            if(__mode == TRRailroadBuilderMode.clear && [[rlState rails] containsItem:rail]) {
                __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:[CNOption applyValue:[TRRailBuilding railBuildingWithTp:TRRailBuildingType.destruction rail:rail progress:0.0]] isLocked:__state.isLocked buildingRails:__state.buildingRails isBuilding:__state.isBuilding];
                [self changed];
                [[_level isLockedRail:rail] onSuccessF:^void(id locked) {
                    if(!(unumb(locked) == __isLocked)) {
                        [__state lock];
                        [self changed];
                    }
                }];
                return YES;
            } else {
                [self clear];
                return NO;
            }
        }
    }
}

- (void)changed {
    [_TRRailroadBuilder_changedNotification postSender:self];
}

- (BOOL)checkCityRlState:(TRRailroadState*)rlState tile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    GEVec2i nextTile = [connector nextTile:tile];
    return [__railroad.map isFullTile:nextTile] || !([[rlState contentInTile:nextTile connector:[connector otherSideConnector]] isEmpty]);
}

- (void)clear {
    if([__state.notFixedRailBuilding isDefined]) {
        __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:[CNOption none] isLocked:NO buildingRails:__state.buildingRails isBuilding:__state.isBuilding];
        [self changed];
    }
}

- (void)fix {
    if(__isLocked) {
        [self clear];
    } else {
        if([__state.notFixedRailBuilding isDefined]) {
            TRRailBuilding* rb = [__state.notFixedRailBuilding get];
            if([rb isConstruction]) {
                [__railroad.forest cutDownForRail:rb.rail];
            } else {
                [__railroad removeRail:rb.rail];
                [self doSetMode:TRRailroadBuilderMode.simple];
            }
            __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:[CNOption none] isLocked:NO buildingRails:[CNImList applyItem:rb tail:__state.buildingRails] isBuilding:__state.isBuilding];
            [self changed];
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
        _weakSelf._state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:_weakSelf._state.notFixedRailBuilding isLocked:_weakSelf._state.isLocked buildingRails:[[[[_weakSelf._state.buildingRails chain] map:^TRRailBuilding*(TRRailBuilding* b) {
            float p = ((TRRailBuilding*)(b)).progress;
            BOOL less = p < 0.5;
            p += ((float)(delta / 4));
            if(less && p > 0.5) [_weakSelf changed];
            return [TRRailBuilding railBuildingWithTp:((TRRailBuilding*)(b)).tp rail:((TRRailBuilding*)(b)).rail progress:p];
        }] filter:^BOOL(TRRailBuilding* b) {
            if(((TRRailBuilding*)(b)).progress >= 1.0) {
                if([((TRRailBuilding*)(b)) isConstruction]) [_weakSelf._railroad tryAddRail:((TRRailBuilding*)(b)).rail];
                else [_weakSelf._railroad.score railRemoved];
                return NO;
            } else {
                return YES;
            }
        }] toList] isBuilding:_weakSelf._state.isBuilding];
        if([_weakSelf._state isDestruction]) [[_weakSelf.level isLockedRail:((TRRailBuilding*)([_weakSelf._state.notFixedRailBuilding get])).rail] onSuccessF:^void(id lk) {
            if(!(unumb(lk) == _weakSelf._state.isLocked)) {
                _weakSelf._state = [_weakSelf._state lock];
                [_weakSelf changed];
            }
        }];
        return nil;
    }];
}

- (CNFuture*)undo {
    __weak TRRailroadBuilder* _weakSelf = self;
    return [self futureF:^id() {
        id r = [_weakSelf._state.buildingRails headOpt];
        if(!([r isEmpty])) {
            TRRailBuilding* rb = [r get];
            if([rb isDestruction]) [_weakSelf._railroad tryAddRail:rb.rail];
            _weakSelf._state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:_weakSelf._state.notFixedRailBuilding isLocked:_weakSelf._state.isLocked buildingRails:[_weakSelf._state.buildingRails tail] isBuilding:_weakSelf._state.isBuilding];
            [_weakSelf changed];
        }
        return nil;
    }];
}

- (CNFuture*)mode {
    __weak TRRailroadBuilder* _weakSelf = self;
    return [self promptF:^TRRailroadBuilderMode*() {
        return _weakSelf._mode;
    }];
}

- (CNFuture*)modeBuildFlip {
    __weak TRRailroadBuilder* _weakSelf = self;
    return [self promptF:^id() {
        if(_weakSelf._mode == TRRailroadBuilderMode.build) _weakSelf._mode = TRRailroadBuilderMode.simple;
        else _weakSelf._mode = TRRailroadBuilderMode.build;
        [[TRRailroadBuilder modeNotification] postSender:[_weakSelf actor] data:_weakSelf._mode];
        return nil;
    }];
}

- (CNFuture*)modeClearFlip {
    __weak TRRailroadBuilder* _weakSelf = self;
    return [self promptF:^id() {
        if(_weakSelf._mode == TRRailroadBuilderMode.clear) _weakSelf._mode = TRRailroadBuilderMode.simple;
        else _weakSelf._mode = TRRailroadBuilderMode.clear;
        [[TRRailroadBuilder modeNotification] postSender:[_weakSelf actor] data:_weakSelf._mode];
        return nil;
    }];
}

- (CNFuture*)setMode:(TRRailroadBuilderMode*)mode {
    __weak TRRailroadBuilder* _weakSelf = self;
    return [self promptF:^id() {
        [_weakSelf doSetMode:mode];
        return nil;
    }];
}

- (void)doSetMode:(TRRailroadBuilderMode*)mode {
    if(__mode != mode) {
        __mode = mode;
        [_TRRailroadBuilder_modeNotification postSender:[self actor] data:mode];
    }
}

- (CNFuture*)beganLocation:(GEVec2)location {
    __weak TRRailroadBuilder* _weakSelf = self;
    return [self promptF:^id() {
        _weakSelf._startedPoint = [CNOption applyValue:wrap(GEVec2, location)];
        _weakSelf._firstTry = YES;
        return nil;
    }];
}

- (CNFuture*)changedLocation:(GEVec2)location {
    __weak TRRailroadBuilder* _weakSelf = self;
    return [self lockAndOnSuccessFuture:[__railroad state] f:^id(TRRailroadState* rlState) {
        GELine2 line = geLine2ApplyP0P1((uwrap(GEVec2, [_weakSelf._startedPoint get])), location);
        float len = geVec2Length(line.u);
        if(len > 0.5) {
            if(!([_weakSelf._state isDestruction])) {
                _weakSelf._state = [_weakSelf._state setIsBuilding:YES];
                GEVec2 nu = geVec2SetLength(line.u, 1.0);
                GELine2 nl = (([_weakSelf._fixedStart isDefined]) ? GELine2Make(line.p0, nu) : GELine2Make((geVec2SubVec2(line.p0, (geVec2MulF(nu, 0.25)))), nu));
                GEVec2 mid = geLine2Mid(nl);
                GEVec2i tile = geVec2Round(mid);
                id railOpt = [[[[[[[[[_weakSelf possibleRailsAroundTile:tile] map:^CNTuple*(TRRail* rail) {
                    return tuple(rail, numf([_weakSelf distanceBetweenRlState:rlState rail:rail paintLine:nl]));
                }] filter:^BOOL(CNTuple* _) {
                    return [_weakSelf._fixedStart isEmpty] || unumf(((CNTuple*)(_)).b) < 0.8;
                }] sortBy] ascBy:^id(CNTuple* _) {
                    return ((CNTuple*)(_)).b;
                }] endSort] topNumbers:4] filter:^BOOL(CNTuple* _) {
                    return [_weakSelf canAddRlState:rlState rail:((CNTuple*)(_)).a] || _weakSelf._mode == TRRailroadBuilderMode.clear;
                }] headOpt];
                if([railOpt isDefined]) {
                    _weakSelf._firstTry = YES;
                    TRRail* rail = ((CNTuple*)([railOpt get])).a;
                    if([_weakSelf tryBuildRlState:rlState rail:rail]) {
                        if(len > (([_weakSelf._fixedStart isDefined]) ? 1.6 : 1) && [_weakSelf._state isConstruction]) {
                            [_weakSelf fix];
                            GELine2 rl = [rail line];
                            float la0 = geVec2LengthSquare((geVec2SubVec2(rl.p0, line.p0)));
                            float la1 = geVec2LengthSquare((geVec2SubVec2(rl.p0, geLine2P1(line))));
                            float lb0 = geVec2LengthSquare((geVec2SubVec2(geLine2P1(rl), line.p0)));
                            float lb1 = geVec2LengthSquare((geVec2SubVec2(geLine2P1(rl), geLine2P1(line))));
                            BOOL end0 = la0 < lb0;
                            BOOL end1 = la1 > lb1;
                            BOOL end = ((end0 == end1) ? end0 : la1 > la0);
                            _weakSelf._startedPoint = ((end) ? [CNOption applyValue:wrap(GEVec2, geLine2P1(rl))] : [CNOption applyValue:wrap(GEVec2, rl.p0)]);
                            TRRailConnector* con = ((end) ? rail.form.end : rail.form.start);
                            _weakSelf._fixedStart = [CNOption applyValue:tuple((wrap(GEVec2i, [con nextTile:rail.tile])), [con otherSideConnector])];
                        }
                    }
                } else {
                    if(_weakSelf._firstTry) {
                        _weakSelf._firstTry = NO;
                        [[TRRailroadBuilder refuseBuildNotification] postSender:[_weakSelf actor]];
                    }
                }
            }
        } else {
            _weakSelf._firstTry = YES;
            [_weakSelf clear];
        }
        return nil;
    }];
}

- (CNFuture*)ended {
    __weak TRRailroadBuilder* _weakSelf = self;
    return [self futureF:^id() {
        [_weakSelf fix];
        _weakSelf._firstTry = YES;
        _weakSelf._startedPoint = [CNOption none];
        _weakSelf._fixedStart = [CNOption none];
        _weakSelf._state = [_weakSelf._state setIsBuilding:NO];
        return nil;
    }];
}

- (CGFloat)distanceBetweenRlState:(TRRailroadState*)rlState rail:(TRRail*)rail paintLine:(GELine2)paintLine {
    GELine2 railLine = [rail line];
    if([__fixedStart isDefined]) {
        return ((CGFloat)(geVec2LengthSquare((geVec2SubVec2((((GEVec2Eq(paintLine.p0, railLine.p0)) ? geLine2P1(railLine) : railLine.p0)), geLine2P1(paintLine))))));
    } else {
        float p0d = float4MinB((geVec2Length((geVec2SubVec2(railLine.p0, paintLine.p0)))), (geVec2Length((geVec2SubVec2(railLine.p0, geLine2P1(paintLine))))));
        float p1d = float4MinB((geVec2Length((geVec2SubVec2(geLine2P1(railLine), paintLine.p0)))), (geVec2Length((geVec2SubVec2(geLine2P1(railLine), geLine2P1(paintLine))))));
        float d = float4Abs((geVec2DotVec2(railLine.u, geLine2N(paintLine)))) + p0d + p1d;
        NSUInteger c = [[[[rail.form connectors] chain] filter:^BOOL(TRRailConnector* connector) {
            return !([[rlState contentInTile:[((TRRailConnector*)(connector)) nextTile:rail.tile] connector:[((TRRailConnector*)(connector)) otherSideConnector]] isEmpty]);
        }] count];
        CGFloat k = ((c == 1) ? 0.7 : ((c == 2) ? 0.6 : 1.0));
        return k * d;
    }
}

- (CNChain*)possibleRailsAroundTile:(GEVec2i)tile {
    if([__fixedStart isDefined]) return [[[[TRRailForm values] chain] filter:^BOOL(TRRailForm* _) {
        return [((TRRailForm*)(_)) containsConnector:((CNTuple*)([__fixedStart get])).b];
    }] map:^TRRail*(TRRailForm* _) {
        return [TRRail railWithTile:uwrap(GEVec2i, ((CNTuple*)([__fixedStart get])).a) form:_];
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

+ (CNNotificationHandle*)modeNotification {
    return _TRRailroadBuilder_modeNotification;
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


