#import "TRRailroadBuilder.h"

#import "TRRailroad.h"
#import "TRLevel.h"
#import "CNObserver.h"
#import "CNReact.h"
#import "PGPlatformPlat.h"
#import "PGPlatform.h"
#import "CNFuture.h"
#import "PGMapIso.h"
#import "TRTree.h"
#import "CNChain.h"
#import "TRScore.h"
#import "CNSortBuilder.h"
@implementation TRRailBuilding
static CNClassType* _TRRailBuilding_type;
@synthesize tp = _tp;
@synthesize rail = _rail;
@synthesize progress = _progress;

+ (instancetype)railBuildingWithTp:(TRRailBuildingTypeR)tp rail:(TRRail*)rail progress:(float)progress {
    return [[TRRailBuilding alloc] initWithTp:tp rail:rail progress:progress];
}

- (instancetype)initWithTp:(TRRailBuildingTypeR)tp rail:(TRRail*)rail progress:(float)progress {
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
    if(self == [TRRailBuilding class]) _TRRailBuilding_type = [CNClassType classTypeWithCls:[TRRailBuilding class]];
}

- (BOOL)isDestruction {
    return _tp == TRRailBuildingType_destruction;
}

- (BOOL)isConstruction {
    return _tp == TRRailBuildingType_construction;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RailBuilding(%@, %@, %f)", [TRRailBuildingType value:_tp], _rail, _progress];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRRailBuilding class]])) return NO;
    TRRailBuilding* o = ((TRRailBuilding*)(to));
    return _tp == o->_tp && [_rail isEqual:o->_rail] && eqf4(_progress, o->_progress);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [[TRRailBuildingType value:_tp] hash];
    hash = hash * 31 + [_rail hash];
    hash = hash * 31 + float4Hash(_progress);
    return hash;
}

- (CNClassType*)type {
    return [TRRailBuilding type];
}

+ (CNClassType*)type {
    return _TRRailBuilding_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

TRRailBuildingType* TRRailBuildingType_Values[3];
TRRailBuildingType* TRRailBuildingType_construction_Desc;
TRRailBuildingType* TRRailBuildingType_destruction_Desc;
@implementation TRRailBuildingType

+ (instancetype)railBuildingTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[TRRailBuildingType alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    TRRailBuildingType_construction_Desc = [TRRailBuildingType railBuildingTypeWithOrdinal:0 name:@"construction"];
    TRRailBuildingType_destruction_Desc = [TRRailBuildingType railBuildingTypeWithOrdinal:1 name:@"destruction"];
    TRRailBuildingType_Values[0] = nil;
    TRRailBuildingType_Values[1] = TRRailBuildingType_construction_Desc;
    TRRailBuildingType_Values[2] = TRRailBuildingType_destruction_Desc;
}

+ (NSArray*)values {
    return (@[TRRailBuildingType_construction_Desc, TRRailBuildingType_destruction_Desc]);
}

+ (TRRailBuildingType*)value:(TRRailBuildingTypeR)r {
    return TRRailBuildingType_Values[r];
}

@end

TRRailroadBuilderMode* TRRailroadBuilderMode_Values[4];
TRRailroadBuilderMode* TRRailroadBuilderMode_simple_Desc;
TRRailroadBuilderMode* TRRailroadBuilderMode_build_Desc;
TRRailroadBuilderMode* TRRailroadBuilderMode_clear_Desc;
@implementation TRRailroadBuilderMode

+ (instancetype)railroadBuilderModeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[TRRailroadBuilderMode alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    TRRailroadBuilderMode_simple_Desc = [TRRailroadBuilderMode railroadBuilderModeWithOrdinal:0 name:@"simple"];
    TRRailroadBuilderMode_build_Desc = [TRRailroadBuilderMode railroadBuilderModeWithOrdinal:1 name:@"build"];
    TRRailroadBuilderMode_clear_Desc = [TRRailroadBuilderMode railroadBuilderModeWithOrdinal:2 name:@"clear"];
    TRRailroadBuilderMode_Values[0] = nil;
    TRRailroadBuilderMode_Values[1] = TRRailroadBuilderMode_simple_Desc;
    TRRailroadBuilderMode_Values[2] = TRRailroadBuilderMode_build_Desc;
    TRRailroadBuilderMode_Values[3] = TRRailroadBuilderMode_clear_Desc;
}

+ (NSArray*)values {
    return (@[TRRailroadBuilderMode_simple_Desc, TRRailroadBuilderMode_build_Desc, TRRailroadBuilderMode_clear_Desc]);
}

+ (TRRailroadBuilderMode*)value:(TRRailroadBuilderModeR)r {
    return TRRailroadBuilderMode_Values[r];
}

@end

@implementation TRRailroadBuilderState
static CNClassType* _TRRailroadBuilderState_type;
@synthesize notFixedRailBuilding = _notFixedRailBuilding;
@synthesize buildingRails = _buildingRails;
@synthesize isBuilding = _isBuilding;

+ (instancetype)railroadBuilderStateWithNotFixedRailBuilding:(TRRailBuilding*)notFixedRailBuilding buildingRails:(CNImList*)buildingRails isBuilding:(BOOL)isBuilding {
    return [[TRRailroadBuilderState alloc] initWithNotFixedRailBuilding:notFixedRailBuilding buildingRails:buildingRails isBuilding:isBuilding];
}

- (instancetype)initWithNotFixedRailBuilding:(TRRailBuilding*)notFixedRailBuilding buildingRails:(CNImList*)buildingRails isBuilding:(BOOL)isBuilding {
    self = [super init];
    if(self) {
        _notFixedRailBuilding = notFixedRailBuilding;
        _buildingRails = buildingRails;
        _isBuilding = isBuilding;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadBuilderState class]) _TRRailroadBuilderState_type = [CNClassType classTypeWithCls:[TRRailroadBuilderState class]];
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
    return [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:_notFixedRailBuilding buildingRails:_buildingRails isBuilding:_isBuilding];
}

- (TRRail*)railForUndo {
    return ((TRRailBuilding*)([_buildingRails head])).rail;
}

- (TRRailroadBuilderState*)setIsBuilding:(BOOL)isBuilding {
    return [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:_notFixedRailBuilding buildingRails:_buildingRails isBuilding:isBuilding];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RailroadBuilderState(%@, %@, %d)", _notFixedRailBuilding, _buildingRails, _isBuilding];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRRailroadBuilderState class]])) return NO;
    TRRailroadBuilderState* o = ((TRRailroadBuilderState*)(to));
    return [_notFixedRailBuilding isEqual:o->_notFixedRailBuilding] && [_buildingRails isEqual:o->_buildingRails] && _isBuilding == o->_isBuilding;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [((TRRailBuilding*)(_notFixedRailBuilding)) hash];
    hash = hash * 31 + [_buildingRails hash];
    hash = hash * 31 + _isBuilding;
    return hash;
}

- (CNClassType*)type {
    return [TRRailroadBuilderState type];
}

+ (CNClassType*)type {
    return _TRRailroadBuilderState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRRailroadBuilder
static CNClassType* _TRRailroadBuilder_type;
@synthesize level = _level;
@synthesize _startedPoint = __startedPoint;
@synthesize _railroad = __railroad;
@synthesize _state = __state;
@synthesize changed = _changed;
@synthesize mode = _mode;
@synthesize buildingWasRefused = _buildingWasRefused;
@synthesize _firstTry = __firstTry;
@synthesize _fixedStart = __fixedStart;

+ (instancetype)railroadBuilderWithLevel:(TRLevel*)level {
    return [[TRRailroadBuilder alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        __startedPoint = nil;
        __railroad = level->_railroad;
        __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:nil buildingRails:[CNImList apply] isBuilding:NO];
        _changed = [CNSignal signal];
        _mode = [CNVar applyInitial:[TRRailroadBuilderMode value:TRRailroadBuilderMode_simple]];
        _buildingWasRefused = [CNSignal signal];
        __firstTry = YES;
        __fixedStart = nil;
        _limitedLen = ((egPlatform()->_isComputer) ? 0.1 : 0.3);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadBuilder class]) _TRRailroadBuilder_type = [CNClassType classTypeWithCls:[TRRailroadBuilder class]];
}

- (CNFuture*)state {
    return [self promptF:^TRRailroadBuilderState*() {
        return __state;
    }];
}

- (CNFuture*)restoreState:(TRRailroadBuilderState*)state {
    return [self promptF:^id() {
        [self clear];
        if(!([__state isEqual:state])) {
            __state = state;
            [_changed post];
        }
        return nil;
    }];
}

- (BOOL)tryBuildRlState:(TRRailroadState*)rlState rail:(TRRail*)rail {
    if(({
        id __tmp_0;
        {
            TRRailBuilding* _ = __state->_notFixedRailBuilding;
            if(_ != nil) __tmp_0 = numb([((TRRailBuilding*)(_))->_rail isEqual:rail]);
            else __tmp_0 = nil;
        }
        ((__tmp_0 != nil) ? unumb(__tmp_0) : NO);
    })) {
        return YES;
    } else {
        if(!(((TRRailroadBuilderModeR)([[_mode value] ordinal] + 1)) == TRRailroadBuilderMode_clear) && [self canAddRlState:rlState rail:rail]) {
            __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:[TRRailBuilding railBuildingWithTp:TRRailBuildingType_construction rail:rail progress:0.0] buildingRails:__state->_buildingRails isBuilding:__state->_isBuilding];
            [_changed post];
            return YES;
        } else {
            if(((TRRailroadBuilderModeR)([[_mode value] ordinal] + 1)) == TRRailroadBuilderMode_clear && [[rlState rails] containsItem:rail]) {
                __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:[TRRailBuilding railBuildingWithTp:TRRailBuildingType_destruction rail:rail progress:0.0] buildingRails:__state->_buildingRails isBuilding:__state->_isBuilding];
                [_changed post];
                return YES;
            } else {
                [self clear];
                return NO;
            }
        }
    }
}

- (BOOL)checkCityRlState:(TRRailroadState*)rlState tile:(PGVec2i)tile connector:(TRRailConnectorR)connector {
    PGVec2i nextTile = [[TRRailConnector value:connector] nextTile:tile];
    return [__railroad->_map isFullTile:nextTile] || !([[rlState contentInTile:nextTile connector:[[TRRailConnector value:connector] otherSideConnector]] isEmpty]);
}

- (void)clear {
    if(__state->_notFixedRailBuilding != nil) {
        __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:nil buildingRails:__state->_buildingRails isBuilding:__state->_isBuilding];
        [_changed post];
    }
}

- (void)fix {
    TRRailBuilding* rb = __state->_notFixedRailBuilding;
    if(rb != nil) {
        if([((TRRailBuilding*)(rb)) isConstruction]) [__railroad->_forest cutDownForRail:((TRRailBuilding*)(rb))->_rail];
        else [__railroad removeRail:((TRRailBuilding*)(rb))->_rail];
        __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:nil buildingRails:[CNImList applyItem:rb tail:__state->_buildingRails] isBuilding:__state->_isBuilding];
        [_changed post];
    }
}

- (BOOL)canAddRlState:(TRRailroadState*)rlState rail:(TRRail*)rail {
    return [self checkCityRlState:rlState tile:rail->_tile connector:[TRRailForm value:rail->_form].start] && [self checkCityRlState:rlState tile:rail->_tile connector:[TRRailForm value:rail->_form].end] && [__railroad->_map isFullTile:rail->_tile] && [self checkBuildingsRlState:rlState rail:rail];
}

- (BOOL)checkBuildingsRlState:(TRRailroadState*)rlState rail:(TRRail*)rail {
    return !([__state->_buildingRails existsWhere:^BOOL(TRRailBuilding* _) {
        return [((TRRailBuilding*)(_))->_rail isEqual:rail];
    }]) && [rlState canAddRail:rail] && [self checkBuildingsConnectorRlState:rlState tile:rail->_tile connector:[TRRailForm value:rail->_form].start] && [self checkBuildingsConnectorRlState:rlState tile:rail->_tile connector:[TRRailForm value:rail->_form].end];
}

- (BOOL)checkBuildingsConnectorRlState:(TRRailroadState*)rlState tile:(PGVec2i)tile connector:(TRRailConnectorR)connector {
    return [[[rlState contentInTile:tile connector:connector] rails] count] + [[[__state->_buildingRails chain] filterWhen:^BOOL(TRRailBuilding* _) {
        return pgVec2iIsEqualTo(((TRRailBuilding*)(_))->_rail->_tile, tile) && [[TRRailForm value:((TRRailBuilding*)(_))->_rail->_form] containsConnector:connector];
    }] count] < 2;
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    __weak TRRailroadBuilder* _weakSelf = self;
    return [self futureF:^id() {
        __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:__state->_notFixedRailBuilding buildingRails:[[[[__state->_buildingRails chain] mapF:^TRRailBuilding*(TRRailBuilding* b) {
            TRRailroadBuilder* _self = _weakSelf;
            if(_self != nil) {
                float p = ((TRRailBuilding*)(b))->_progress;
                BOOL less = p < 0.5;
                p += ((float)(delta / 4));
                if(less && p > 0.5) [_self->_changed post];
                return [TRRailBuilding railBuildingWithTp:((TRRailBuilding*)(b))->_tp rail:((TRRailBuilding*)(b))->_rail progress:p];
            } else {
                return nil;
            }
        }] filterWhen:^BOOL(TRRailBuilding* b) {
            TRRailroadBuilder* _self = _weakSelf;
            if(_self != nil) {
                if(((TRRailBuilding*)(b))->_progress >= 1.0) {
                    if([((TRRailBuilding*)(b)) isConstruction]) [_self->__railroad tryAddRail:((TRRailBuilding*)(b))->_rail];
                    else [_self->__railroad->_score railRemoved];
                    [_self->_changed post];
                    return NO;
                } else {
                    return YES;
                }
            } else {
                return NO;
            }
        }] toList] isBuilding:__state->_isBuilding];
        return nil;
    }];
}

- (CNFuture*)undo {
    return [self futureF:^id() {
        TRRailBuilding* rb = [__state->_buildingRails head];
        if(rb != nil) {
            if([((TRRailBuilding*)(rb)) isDestruction]) [__railroad tryAddRail:((TRRailBuilding*)(rb))->_rail free:YES];
            __state = [TRRailroadBuilderState railroadBuilderStateWithNotFixedRailBuilding:__state->_notFixedRailBuilding buildingRails:[__state->_buildingRails tail] isBuilding:__state->_isBuilding];
            [_changed post];
        }
        return nil;
    }];
}

- (CNFuture*)modeBuildFlip {
    return [self promptF:^id() {
        if(((TRRailroadBuilderModeR)([[_mode value] ordinal] + 1)) == TRRailroadBuilderMode_build) [_mode setValue:[TRRailroadBuilderMode value:TRRailroadBuilderMode_simple]];
        else [_mode setValue:[TRRailroadBuilderMode value:TRRailroadBuilderMode_build]];
        return nil;
    }];
}

- (CNFuture*)modeClearFlip {
    return [self promptF:^id() {
        if(((TRRailroadBuilderModeR)([[_mode value] ordinal] + 1)) == TRRailroadBuilderMode_clear) [_mode setValue:[TRRailroadBuilderMode value:TRRailroadBuilderMode_simple]];
        else [_mode setValue:[TRRailroadBuilderMode value:TRRailroadBuilderMode_clear]];
        return nil;
    }];
}

- (CNFuture*)eBeganLocation:(PGVec2)location {
    return [self promptF:^id() {
        __startedPoint = wrap(PGVec2, location);
        __firstTry = YES;
        return nil;
    }];
}

- (CNFuture*)eChangedLocation:(PGVec2)location {
    return [self lockAndOnSuccessFuture:[__railroad state] f:^id(TRRailroadState* rlState) {
        PGLine2 line = pgLine2ApplyP0P1((uwrap(PGVec2, nonnil(__startedPoint))), location);
        float len = pgVec2Length(line.u);
        if(len > 0.3) {
            if(!([__state isDestruction])) {
                __state = [__state setIsBuilding:YES];
                PGVec2 nu = pgVec2SetLength(line.u, 1.0);
                PGLine2 nl = ((__fixedStart != nil) ? PGLine2Make(line.p0, nu) : PGLine2Make((pgVec2SubVec2(line.p0, (pgVec2MulF(nu, 0.25)))), nu));
                PGVec2 mid = pgLine2Mid(nl);
                PGVec2i tile = pgVec2Round(mid);
                CNTuple* railOpt = [[[[[[[[[self possibleRailsAroundTile:tile] mapF:^CNTuple*(TRRail* rail) {
                    return tuple(rail, numf([self distanceBetweenRlState:rlState rail:rail paintLine:nl]));
                }] filterWhen:^BOOL(CNTuple* _) {
                    return __fixedStart == nil || unumf(((CNTuple*)(_))->_b) < 0.8;
                }] sortBy] ascBy:^id(CNTuple* _) {
                    return ((CNTuple*)(_))->_b;
                }] endSort] topNumbers:4] filterWhen:^BOOL(CNTuple* _) {
                    return [self canAddRlState:rlState rail:((CNTuple*)(_))->_a];
                }] head];
                if(railOpt != nil) {
                    __firstTry = YES;
                    TRRail* rail = ((CNTuple*)(railOpt))->_a;
                    if([self tryBuildRlState:rlState rail:rail]) {
                        if(len > ((__fixedStart != nil) ? 1.6 : 1.0) && [__state isConstruction]) {
                            [self fix];
                            PGLine2 rl = [rail line];
                            float la0 = pgVec2LengthSquare((pgVec2SubVec2(rl.p0, line.p0)));
                            float la1 = pgVec2LengthSquare((pgVec2SubVec2(rl.p0, pgLine2P1(line))));
                            float lb0 = pgVec2LengthSquare((pgVec2SubVec2(pgLine2P1(rl), line.p0)));
                            float lb1 = pgVec2LengthSquare((pgVec2SubVec2(pgLine2P1(rl), pgLine2P1(line))));
                            BOOL end0 = la0 < lb0;
                            BOOL end1 = la1 > lb1;
                            BOOL end = ((end0 == end1) ? end0 : la1 > la0);
                            __startedPoint = ((end) ? wrap(PGVec2, pgLine2P1(rl)) : wrap(PGVec2, rl.p0));
                            TRRailConnectorR con = ((end) ? [TRRailForm value:rail->_form].end : [TRRailForm value:rail->_form].start);
                            __fixedStart = tuple((wrap(PGVec2i, [[TRRailConnector value:con] nextTile:rail->_tile])), [TRRailConnector value:[[TRRailConnector value:con] otherSideConnector]]);
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

- (CNFuture*)eTapLocation:(PGVec2)location {
    return [self lockAndOnSuccessFuture:[__railroad state] f:^id(TRRailroadState* rlState) {
        NSArray* rails = [[[[((TRRailroadState*)(rlState)) railsInTile:pgVec2iApplyVec2(location)] chain] filterWhen:^BOOL(TRRail* _) {
            return !([((TRRailroadState*)(rlState)) isLockedRail:_]);
        }] toArray];
        if(!([rails isEmpty])) {
            CNFuture* lk = [[[rails chain] mapF:^CNFuture*(TRRail* rail) {
                return [_level isLockedRail:rail];
            }] future];
            [self lockAndOnSuccessFuture:lk f:^id(NSArray* locked) {
                NSArray* unlockedRails = [[[[[((NSArray*)(locked)) chain] zipB:rails] filterWhen:^BOOL(CNTuple* _) {
                    return !(unumb(((CNTuple*)(_))->_a));
                }] mapF:^TRRail*(CNTuple* _) {
                    return ((CNTuple*)(_))->_b;
                }] toArray];
                if([unlockedRails isEmpty]) {
                    [_buildingWasRefused post];
                } else {
                    for(TRRail* rail in unlockedRails) {
                        [self tryBuildRlState:rlState rail:rail];
                        [self fix];
                    }
                    [_mode setValue:[TRRailroadBuilderMode value:TRRailroadBuilderMode_simple]];
                }
                return nil;
            }];
        } else {
            [_buildingWasRefused post];
        }
        return nil;
    }];
}

- (CGFloat)distanceBetweenRlState:(TRRailroadState*)rlState rail:(TRRail*)rail paintLine:(PGLine2)paintLine {
    PGLine2 railLine = [rail line];
    if(__fixedStart != nil) {
        return ((CGFloat)(pgVec2LengthSquare((pgVec2SubVec2((((pgVec2IsEqualTo(paintLine.p0, railLine.p0)) ? pgLine2P1(railLine) : railLine.p0)), pgLine2P1(paintLine))))));
    } else {
        float p0d = float4MinB((pgVec2Length((pgVec2SubVec2(railLine.p0, paintLine.p0)))), (pgVec2Length((pgVec2SubVec2(railLine.p0, pgLine2P1(paintLine))))));
        float p1d = float4MinB((pgVec2Length((pgVec2SubVec2(pgLine2P1(railLine), paintLine.p0)))), (pgVec2Length((pgVec2SubVec2(pgLine2P1(railLine), pgLine2P1(paintLine))))));
        float d = float4Abs((pgVec2DotVec2(railLine.u, pgLine2N(paintLine)))) + p0d + p1d;
        NSUInteger c = [[[[[TRRailForm value:rail->_form] connectors] chain] filterWhen:^BOOL(TRRailConnector* connector) {
            return !([[rlState contentInTile:[[TRRailConnector value:((TRRailConnectorR)([connector ordinal] + 1))] nextTile:rail->_tile] connector:[[TRRailConnector value:((TRRailConnectorR)([connector ordinal] + 1))] otherSideConnector]] isEmpty]);
        }] count];
        CGFloat k = ((c == 1) ? 0.7 : ((c == 2) ? 0.6 : 1.0));
        return ((CGFloat)(((float)(k * d))));
    }
}

- (CNChain*)possibleRailsAroundTile:(PGVec2i)tile {
    if(__fixedStart != nil) return [[[[TRRailForm values] chain] filterWhen:^BOOL(TRRailForm* _) {
        return [[TRRailForm value:((TRRailFormR)([_ ordinal] + 1))] containsConnector:((TRRailConnectorR)([((CNTuple*)(__fixedStart))->_b ordinal] + 1))];
    }] mapF:^TRRail*(TRRailForm* _) {
        return [TRRail railWithTile:uwrap(PGVec2i, ((CNTuple*)(__fixedStart))->_a) form:((TRRailFormR)([_ ordinal] + 1))];
    }];
    else return [[[[self tilesAroundTile:tile] chain] mulBy:[TRRailForm values]] mapF:^TRRail*(CNTuple* p) {
        return [TRRail railWithTile:uwrap(PGVec2i, ((CNTuple*)(p))->_a) form:((TRRailFormR)([((CNTuple*)(p))->_b ordinal] + 1))];
    }];
}

- (NSArray*)tilesAroundTile:(PGVec2i)tile {
    return (@[wrap(PGVec2i, tile), wrap(PGVec2i, (pgVec2iAddVec2i(tile, (PGVec2iMake(1, 0))))), wrap(PGVec2i, (pgVec2iAddVec2i(tile, (PGVec2iMake(-1, 0))))), wrap(PGVec2i, (pgVec2iAddVec2i(tile, (PGVec2iMake(0, 1))))), wrap(PGVec2i, (pgVec2iAddVec2i(tile, (PGVec2iMake(0, -1))))), wrap(PGVec2i, (pgVec2iAddVec2i(tile, (PGVec2iMake(1, 1))))), wrap(PGVec2i, (pgVec2iAddVec2i(tile, (PGVec2iMake(-1, 1))))), wrap(PGVec2i, (pgVec2iAddVec2i(tile, (PGVec2iMake(1, -1))))), wrap(PGVec2i, (pgVec2iAddVec2i(tile, (PGVec2iMake(-1, -1)))))]);
}

- (NSArray*)connectorsByDistanceFromPoint:(PGVec2)point {
    return [[[[[[TRRailConnector values] chain] sortBy] ascBy:^id(TRRailConnector* connector) {
        return numf4((pgVec2LengthSquare((pgVec2SubVec2((pgVec2iMulF([[TRRailConnector value:((TRRailConnectorR)([connector ordinal] + 1))] vec], 0.5)), point)))));
    }] endSort] toArray];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RailroadBuilder(%@)", _level];
}

- (CNClassType*)type {
    return [TRRailroadBuilder type];
}

+ (CNClassType*)type {
    return _TRRailroadBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

