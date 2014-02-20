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
    CGFloat _progress;
}
static ODClassType* _TRRailBuilding_type;
@synthesize tp = _tp;
@synthesize rail = _rail;
@synthesize progress = _progress;

+ (id)railBuildingWithTp:(TRRailBuildingType*)tp rail:(TRRail*)rail {
    return [[TRRailBuilding alloc] initWithTp:tp rail:rail];
}

- (id)initWithTp:(TRRailBuildingType*)tp rail:(TRRail*)rail {
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

+ (id)railBuildingTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[TRRailBuildingType alloc] initWithOrdinal:ordinal name:name];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
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
    __weak TRRailroad* _railroad;
    BOOL _building;
    id __notFixedRailBuilding;
    BOOL __isLocked;
    CNMutableList* __buildingRails;
    BOOL __buildMode;
    BOOL __clearMode;
}
static CNNotificationHandle* _TRRailroadBuilder_changedNotification;
static CNNotificationHandle* _TRRailroadBuilder_buildModeNotification;
static CNNotificationHandle* _TRRailroadBuilder_clearModeNotification;
static ODClassType* _TRRailroadBuilder_type;
@synthesize level = _level;
@synthesize railroad = _railroad;
@synthesize building = _building;

+ (id)railroadBuilderWithLevel:(TRLevel*)level {
    return [[TRRailroadBuilder alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _railroad = _level.railroad;
        _building = NO;
        __notFixedRailBuilding = [CNOption none];
        __isLocked = NO;
        __buildingRails = [CNMutableList mutableList];
        __buildMode = NO;
        __clearMode = NO;
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
                __isLocked = !([_level isLockedRail:rail]);
                [self changed];
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
    return [_railroad.map isFullTile:nextTile] || !([[_railroad contentInTile:nextTile connector:[connector otherSideConnector]] isEmpty]);
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
}]) && [_railroad canAddRail:rail] && [self checkBuildingsConnectorTile:rail.tile connector:rail.form.start] && [self checkBuildingsConnectorTile:rail.tile connector:rail.form.end];
}

- (BOOL)checkBuildingsConnectorTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    return [[[_railroad contentInTile:tile connector:connector] rails] count] + [[[__buildingRails chain] filter:^BOOL(TRRailBuilding* _) {
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
    if([self isDestruction]) {
        BOOL lk = [_level isLockedRail:((TRRailBuilding*)([__notFixedRailBuilding get])).rail];
        if(lk != __isLocked) {
            __isLocked = lk;
            [self changed];
        }
    }
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


