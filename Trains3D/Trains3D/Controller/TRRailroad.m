#import "TRRailroad.h"

#import "TRTree.h"
#import "EGMapIso.h"
#import "TRScore.h"
@implementation TRRailroadConnectorContent
static ODClassType* _TRRailroadConnectorContent_type;

+ (instancetype)railroadConnectorContent {
    return [[TRRailroadConnectorContent alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadConnectorContent class]) _TRRailroadConnectorContent_type = [ODClassType classTypeWithCls:[TRRailroadConnectorContent class]];
}

- (BOOL)canAddRail:(TRRail*)rail {
    return YES;
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    @throw @"Method connect is abstract";
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to {
    @throw @"Method disconnect is abstract";
}

- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnector*)connector mustBe:(BOOL)mustBe {
    return self;
}

- (id<CNSeq>)rails {
    @throw @"Method rails is abstract";
}

- (BOOL)isGreen {
    return YES;
}

- (BOOL)isEmpty {
    return NO;
}

- (void)cutDownTreesInForest:(TRForest*)forest {
}

- (ODClassType*)type {
    return [TRRailroadConnectorContent type];
}

+ (ODClassType*)type {
    return _TRRailroadConnectorContent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TREmptyConnector
static TRRailroadConnectorContent* _TREmptyConnector_instance;
static ODClassType* _TREmptyConnector_type;

+ (instancetype)emptyConnector {
    return [[TREmptyConnector alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TREmptyConnector class]) {
        _TREmptyConnector_type = [ODClassType classTypeWithCls:[TREmptyConnector class]];
        _TREmptyConnector_instance = [TREmptyConnector emptyConnector];
    }
}

- (id<CNSeq>)rails {
    return (@[]);
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return rail;
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return self;
}

- (BOOL)isEmpty {
    return YES;
}

- (ODClassType*)type {
    return [TREmptyConnector type];
}

+ (TRRailroadConnectorContent*)instance {
    return _TREmptyConnector_instance;
}

+ (ODClassType*)type {
    return _TREmptyConnector_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRail{
    GEVec2i _tile;
    TRRailForm* _form;
}
static ODClassType* _TRRail_type;
@synthesize tile = _tile;
@synthesize form = _form;

+ (instancetype)railWithTile:(GEVec2i)tile form:(TRRailForm*)form {
    return [[TRRail alloc] initWithTile:tile form:form];
}

- (instancetype)initWithTile:(GEVec2i)tile form:(TRRailForm*)form {
    self = [super init];
    if(self) {
        _tile = tile;
        _form = form;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRail class]) _TRRail_type = [ODClassType classTypeWithCls:[TRRail class]];
}

- (BOOL)hasConnector:(TRRailConnector*)connector {
    return _form.start == connector || _form.end == connector;
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return [TRSwitch switchWithTile:rail.tile connector:to rail1:self rail2:rail];
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return TREmptyConnector.instance;
}

- (id<CNSeq>)rails {
    return (@[self]);
}

- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnector*)connector mustBe:(BOOL)mustBe {
    if(mustBe) return [TRRailLight railLightWithTile:_tile connector:connector rail:self];
    else return self;
}

- (BOOL)canAddRail:(TRRail*)rail {
    return rail.form != _form;
}

- (GELine2)line {
    return geLine2AddVec2([_form line], geVec2ApplyVec2i(_tile));
}

- (ODClassType*)type {
    return [TRRail type];
}

+ (ODClassType*)type {
    return _TRRail_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRail* o = ((TRRail*)(other));
    return GEVec2iEq(self.tile, o.tile) && self.form == o.form;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.tile);
    hash = hash * 31 + [self.form ordinal];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tile=%@", GEVec2iDescription(self.tile)];
    [description appendFormat:@", form=%@", self.form];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSwitch{
    GEVec2i _tile;
    TRRailConnector* _connector;
    TRRail* _rail1;
    TRRail* _rail2;
    BOOL _firstActive;
}
static CNNotificationHandle* _TRSwitch_turnNotification;
static ODClassType* _TRSwitch_type;
@synthesize tile = _tile;
@synthesize connector = _connector;
@synthesize rail1 = _rail1;
@synthesize rail2 = _rail2;
@synthesize firstActive = _firstActive;

+ (instancetype)switchWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2 {
    return [[TRSwitch alloc] initWithTile:tile connector:connector rail1:rail1 rail2:rail2];
}

- (instancetype)initWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2 {
    self = [super init];
    if(self) {
        _tile = tile;
        _connector = connector;
        _rail1 = rail1;
        _rail2 = rail2;
        _firstActive = YES;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSwitch class]) {
        _TRSwitch_type = [ODClassType classTypeWithCls:[TRSwitch class]];
        _TRSwitch_turnNotification = [CNNotificationHandle notificationHandleWithName:@"switchTurnNotification"];
    }
}

- (TRRail*)activeRail {
    if(_firstActive) return _rail1;
    else return _rail2;
}

- (void)turn {
    _firstActive = !(_firstActive);
    [_TRSwitch_turnNotification postSender:self];
}

- (BOOL)canAddRail:(TRRail*)rail {
    return NO;
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return self;
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to {
    if([rail isEqual:_rail1]) return _rail2;
    else return _rail1;
}

- (id<CNSeq>)rails {
    if(_firstActive) return (@[_rail1, _rail2]);
    else return (@[_rail2, _rail1]);
}

- (void)cutDownTreesInForest:(TRForest*)forest {
    [forest cutDownForASwitch:self];
}

- (TRRailPoint)railPoint1 {
    return [self railPointRail:_rail1];
}

- (TRRailPoint)railPoint2 {
    return [self railPointRail:_rail2];
}

- (TRRailPoint)railPointRail:(TRRail*)rail {
    return trRailPointApplyTileFormXBack(_tile, rail.form, 0.0, rail.form.end == _connector);
}

- (ODClassType*)type {
    return [TRSwitch type];
}

+ (CNNotificationHandle*)turnNotification {
    return _TRSwitch_turnNotification;
}

+ (ODClassType*)type {
    return _TRSwitch_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSwitch* o = ((TRSwitch*)(other));
    return GEVec2iEq(self.tile, o.tile) && self.connector == o.connector && [self.rail1 isEqual:o.rail1] && [self.rail2 isEqual:o.rail2];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.tile);
    hash = hash * 31 + [self.connector ordinal];
    hash = hash * 31 + [self.rail1 hash];
    hash = hash * 31 + [self.rail2 hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tile=%@", GEVec2iDescription(self.tile)];
    [description appendFormat:@", connector=%@", self.connector];
    [description appendFormat:@", rail1=%@", self.rail1];
    [description appendFormat:@", rail2=%@", self.rail2];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRailLight{
    GEVec2i _tile;
    TRRailConnector* _connector;
    TRRail* _rail;
    BOOL _isGreen;
}
static CNNotificationHandle* _TRRailLight_turnNotification;
static ODClassType* _TRRailLight_type;
@synthesize tile = _tile;
@synthesize connector = _connector;
@synthesize rail = _rail;
@synthesize isGreen = _isGreen;

+ (instancetype)railLightWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail {
    return [[TRRailLight alloc] initWithTile:tile connector:connector rail:rail];
}

- (instancetype)initWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail {
    self = [super init];
    if(self) {
        _tile = tile;
        _connector = connector;
        _rail = rail;
        _isGreen = YES;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailLight class]) {
        _TRRailLight_type = [ODClassType classTypeWithCls:[TRRailLight class]];
        _TRRailLight_turnNotification = [CNNotificationHandle notificationHandleWithName:@"Light turned"];
    }
}

- (void)turn {
    _isGreen = !(_isGreen);
    [_TRRailLight_turnNotification postSender:self];
}

- (void)cutDownTreesInForest:(TRForest*)forest {
    [forest cutDownForLight:self];
}

- (BOOL)canAddRail:(TRRail*)rail {
    return [_rail canAddRail:rail];
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return [TRSwitch switchWithTile:_tile connector:to rail1:_rail rail2:rail];
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return TREmptyConnector.instance;
}

- (id<CNSeq>)rails {
    return (@[_rail]);
}

- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnector*)connector mustBe:(BOOL)mustBe {
    if(mustBe) return self;
    else return _rail;
}

- (GEVec3)shift {
    return GEVec3Make(((_connector == TRRailConnector.top) ? -0.2 : 0.2), 0.0, -0.45);
}

- (ODClassType*)type {
    return [TRRailLight type];
}

+ (CNNotificationHandle*)turnNotification {
    return _TRRailLight_turnNotification;
}

+ (ODClassType*)type {
    return _TRRailLight_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailLight* o = ((TRRailLight*)(other));
    return GEVec2iEq(self.tile, o.tile) && self.connector == o.connector && [self.rail isEqual:o.rail];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.tile);
    hash = hash * 31 + [self.connector ordinal];
    hash = hash * 31 + [self.rail hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tile=%@", GEVec2iDescription(self.tile)];
    [description appendFormat:@", connector=%@", self.connector];
    [description appendFormat:@", rail=%@", self.rail];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRObstacleType
static TRObstacleType* _TRObstacleType_damage;
static TRObstacleType* _TRObstacleType_switch;
static TRObstacleType* _TRObstacleType_light;
static TRObstacleType* _TRObstacleType_end;
static NSArray* _TRObstacleType_values;

+ (instancetype)obstacleTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[TRObstacleType alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRObstacleType_damage = [TRObstacleType obstacleTypeWithOrdinal:0 name:@"damage"];
    _TRObstacleType_switch = [TRObstacleType obstacleTypeWithOrdinal:1 name:@"switch"];
    _TRObstacleType_light = [TRObstacleType obstacleTypeWithOrdinal:2 name:@"light"];
    _TRObstacleType_end = [TRObstacleType obstacleTypeWithOrdinal:3 name:@"end"];
    _TRObstacleType_values = (@[_TRObstacleType_damage, _TRObstacleType_switch, _TRObstacleType_light, _TRObstacleType_end]);
}

+ (TRObstacleType*)damage {
    return _TRObstacleType_damage;
}

+ (TRObstacleType*)aSwitch {
    return _TRObstacleType_switch;
}

+ (TRObstacleType*)light {
    return _TRObstacleType_light;
}

+ (TRObstacleType*)end {
    return _TRObstacleType_end;
}

+ (NSArray*)values {
    return _TRObstacleType_values;
}

@end


@implementation TRObstacle{
    TRObstacleType* _obstacleType;
    TRRailPoint _point;
}
static ODClassType* _TRObstacle_type;
@synthesize obstacleType = _obstacleType;
@synthesize point = _point;

+ (instancetype)obstacleWithObstacleType:(TRObstacleType*)obstacleType point:(TRRailPoint)point {
    return [[TRObstacle alloc] initWithObstacleType:obstacleType point:point];
}

- (instancetype)initWithObstacleType:(TRObstacleType*)obstacleType point:(TRRailPoint)point {
    self = [super init];
    if(self) {
        _obstacleType = obstacleType;
        _point = point;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRObstacle class]) _TRObstacle_type = [ODClassType classTypeWithCls:[TRObstacle class]];
}

- (ODClassType*)type {
    return [TRObstacle type];
}

+ (ODClassType*)type {
    return _TRObstacle_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRObstacle* o = ((TRObstacle*)(other));
    return self.obstacleType == o.obstacleType && TRRailPointEq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.obstacleType ordinal];
    hash = hash * 31 + TRRailPointHash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"obstacleType=%@", self.obstacleType];
    [description appendFormat:@", point=%@", TRRailPointDescription(self.point)];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRailroad{
    EGMapSso* _map;
    TRScore* _score;
    TRForest* _forest;
    id<CNSeq> __rails;
    id<CNSeq> __switches;
    id<CNSeq> __lights;
    CNMapDefault* _connectorIndex;
    NSMutableDictionary* _damagesIndex;
    NSMutableArray* __damagesPoints;
}
static CNNotificationHandle* _TRRailroad_changedNotification;
static ODClassType* _TRRailroad_type;
@synthesize map = _map;
@synthesize score = _score;
@synthesize forest = _forest;

+ (instancetype)railroadWithMap:(EGMapSso*)map score:(TRScore*)score forest:(TRForest*)forest {
    return [[TRRailroad alloc] initWithMap:map score:score forest:forest];
}

- (instancetype)initWithMap:(EGMapSso*)map score:(TRScore*)score forest:(TRForest*)forest {
    self = [super init];
    if(self) {
        _map = map;
        _score = score;
        _forest = forest;
        __rails = (@[]);
        __switches = (@[]);
        __lights = (@[]);
        _connectorIndex = [CNMapDefault mapDefaultWithDefaultFunc:^TRRailroadConnectorContent*(CNTuple* _) {
            return TREmptyConnector.instance;
        } map:[NSMutableDictionary mutableDictionary]];
        _damagesIndex = [NSMutableDictionary mutableDictionary];
        __damagesPoints = [NSMutableArray mutableArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroad class]) {
        _TRRailroad_type = [ODClassType classTypeWithCls:[TRRailroad class]];
        _TRRailroad_changedNotification = [CNNotificationHandle notificationHandleWithName:@"Railroad changed"];
    }
}

- (id<CNSeq>)rails {
    return __rails;
}

- (id<CNSeq>)switches {
    return __switches;
}

- (id<CNSeq>)lights {
    return __lights;
}

- (id<CNSeq>)damagesPoints {
    return __damagesPoints;
}

- (BOOL)canAddRail:(TRRail*)rail {
    return [((TRRailroadConnectorContent*)([_connectorIndex applyKey:tuple((wrap(GEVec2i, rail.tile)), rail.form.start)])) canAddRail:rail] && [((TRRailroadConnectorContent*)([_connectorIndex applyKey:tuple((wrap(GEVec2i, rail.tile)), rail.form.end)])) canAddRail:rail];
}

- (BOOL)tryAddRail:(TRRail*)rail {
    if([self canAddRail:rail]) {
        [self addRail:rail];
        [_score railBuilt];
        return YES;
    } else {
        return NO;
    }
}

- (void)addRail:(TRRail*)rail {
    [[self connectRail:rail to:rail.form.start] cutDownTreesInForest:_forest];
    [[self connectRail:rail to:rail.form.end] cutDownTreesInForest:_forest];
    [self checkLightsNearRail:rail];
    [_forest cutDownForRail:rail];
    [self rebuildArrays];
}

- (void)removeRail:(TRRail*)rail {
    if([[self rails] containsItem:rail]) {
        [self disconnectRail:rail to:rail.form.start];
        [self disconnectRail:rail to:rail.form.end];
        [self checkLightsNearRail:rail];
        [self rebuildArrays];
    }
}

- (TRRailroadConnectorContent*)contentInTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    return [_connectorIndex applyKey:tuple((wrap(GEVec2i, tile)), connector)];
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return [_connectorIndex modifyKey:tuple((wrap(GEVec2i, rail.tile)), to) by:^TRRailroadConnectorContent*(TRRailroadConnectorContent* _) {
        return [((TRRailroadConnectorContent*)(_)) connectRail:rail to:to];
    }];
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return [_connectorIndex modifyKey:tuple((wrap(GEVec2i, rail.tile)), to) by:^TRRailroadConnectorContent*(TRRailroadConnectorContent* _) {
        return [((TRRailroadConnectorContent*)(_)) disconnectRail:rail to:to];
    }];
}

- (void)checkLightsNearRail:(TRRail*)rail {
    GEVec2i tile = rail.tile;
    [self checkLightsNearTile:tile connector:rail.form.start distance:4 this:YES];
    [self checkLightsNearTile:tile connector:rail.form.end distance:4 this:YES];
}

- (void)checkLightsNearTile:(GEVec2i)tile connector:(TRRailConnector*)connector distance:(NSInteger)distance this:(BOOL)this {
    if(distance <= 0) {
        [self checkLightInTile:tile connector:connector];
    } else {
        TRRailroadConnectorContent* c = [_connectorIndex applyKey:tuple((wrap(GEVec2i, tile)), connector)];
        [[c rails] forEach:^void(TRRail* rail) {
            TRRailConnector* oc = [((TRRail*)(rail)).form otherConnectorThan:connector];
            [self checkLightsNearTile:[oc nextTile:tile] connector:[oc otherSideConnector] distance:distance - 1 this:NO];
            [self checkLightInTile:tile connector:oc];
        }];
        if(!(this)) [self checkLightInTile:tile connector:connector];
    }
}

- (BOOL)needLightsInTile:(GEVec2i)tile connector:(TRRailConnector*)connector distance:(NSInteger)distance this:(BOOL)this {
    TRRailroadConnectorContent* content = [_connectorIndex applyKey:tuple((wrap(GEVec2i, tile)), connector)];
    if([content isKindOfClass:[TRRailLight class]] && !(this)) {
        return NO;
    } else {
        if(distance == 0) {
            return YES;
        } else {
            GEVec2i nextTile = [connector nextTile:tile];
            TRRailConnector* otherSideConnector = [connector otherSideConnector];
            TRRailroadConnectorContent* nc = [_connectorIndex applyKey:tuple((wrap(GEVec2i, nextTile)), otherSideConnector)];
            return [[nc rails] existsWhere:^BOOL(TRRail* rail) {
                return [self needLightsInTile:nextTile connector:[((TRRail*)(rail)).form otherConnectorThan:otherSideConnector] distance:distance - 1 this:NO];
            }];
        }
    }
}

- (BOOL)needLightsInOtherDirectionTile:(GEVec2i)tile connector:(TRRailConnector*)connector distance:(NSInteger)distance this:(BOOL)this {
    TRRailroadConnectorContent* content = [_connectorIndex applyKey:tuple((wrap(GEVec2i, tile)), connector)];
    if([content isKindOfClass:[TRRailLight class]] && !(this)) {
        return NO;
    } else {
        if(distance == 0) return YES;
        else return [[content rails] existsWhere:^BOOL(TRRail* rail) {
            TRRailConnector* c = [((TRRail*)(rail)).form otherConnectorThan:connector];
            return [self needLightsInOtherDirectionTile:[c nextTile:tile] connector:[c otherSideConnector] distance:distance - 1 this:NO];
        }];
    }
}

- (BOOL)isTurnRailInTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    id<CNSeq> rails = [((TRRailroadConnectorContent*)([_connectorIndex applyKey:tuple((wrap(GEVec2i, tile)), connector)])) rails];
    return [rails count] == 1 && ((TRRail*)([rails applyIndex:0])).form.isTurn;
}

- (void)checkLightInTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    if([self needLightsInTile:tile connector:connector distance:2 this:YES] && [self needLightsInOtherDirectionTile:tile connector:connector distance:2 this:YES]) {
        [self buildLightInTile:tile connector:connector mustBe:YES];
        return ;
    } else {
        if([_map isPartialTile:tile] && [_map isFullTile:[connector nextTile:tile]]) {
            [self buildLightInTile:tile connector:connector mustBe:YES];
            return ;
        } else {
            GEVec2i nextTile = [connector nextTile:tile];
            TRRailConnector* otherSideConnector = [connector otherSideConnector];
            TRRailroadConnectorContent* c = [self contentInTile:nextTile connector:otherSideConnector];
            if([c isKindOfClass:[TRRail class]] && [[c rails] existsWhere:^BOOL(TRRail* rail) {
    TRRailConnector* oc = [((TRRail*)(rail)).form otherConnectorThan:otherSideConnector];
    return ((TRRail*)(rail)).form.isTurn && [[self contentInTile:nextTile connector:oc] isKindOfClass:[TRSwitch class]];
}]) {
                [self buildLightInTile:tile connector:connector mustBe:YES];
                return ;
            }
        }
    }
    [self buildLightInTile:tile connector:connector mustBe:NO];
}

- (void)buildLightInTile:(GEVec2i)tile connector:(TRRailConnector*)connector mustBe:(BOOL)mustBe {
    [_connectorIndex modifyKey:tuple((wrap(GEVec2i, tile)), connector) by:^TRRailroadConnectorContent*(TRRailroadConnectorContent* content) {
        TRRailroadConnectorContent* r = [((TRRailroadConnectorContent*)(content)) checkLightInConnector:connector mustBe:mustBe];
        if([r isKindOfClass:[TRRailLight class]]) [r cutDownTreesInForest:_forest];
        return r;
    }];
}

- (void)rebuildArrays {
    __rails = [[[[[_connectorIndex values] chain] flatMap:^id<CNSeq>(TRRailroadConnectorContent* _) {
        return [((TRRailroadConnectorContent*)(_)) rails];
    }] distinct] toArray];
    __switches = [[[[_connectorIndex values] chain] filter:^BOOL(TRRailroadConnectorContent* _) {
        return [((TRRailroadConnectorContent*)(_)) isKindOfClass:[TRSwitch class]];
    }] toArray];
    __lights = [[[[_connectorIndex values] chain] filter:^BOOL(TRRailroadConnectorContent* _) {
        return [((TRRailroadConnectorContent*)(_)) isKindOfClass:[TRRailLight class]];
    }] toArray];
    [_TRRailroad_changedNotification postSender:self];
}

- (id)activeRailForTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    return [[((TRRailroadConnectorContent*)([_connectorIndex applyKey:tuple((wrap(GEVec2i, tile)), connector)])) rails] headOpt];
}

- (TRRailPointCorrection)moveWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor forLength:(CGFloat)forLength point:(TRRailPoint)point {
    TRRailPoint p = trRailPointAddX(point, forLength);
    TRRailPointCorrection correction = trRailPointCorrect(p);
    id damage = [self checkDamagesWithObstacleProcessor:obstacleProcessor from:point to:correction.point.x];
    if([damage isDefined]) {
        CGFloat x = unumf([damage get]);
        return TRRailPointCorrectionMake((trRailPointSetX(p, x)), correction.error + correction.point.x - x);
    }
    if(eqf(correction.error, 0)) {
        TRRailPointCorrection switchCheckCorrection = trRailPointCorrect((trRailPointAddX(correction.point, 0.5)));
        if(eqf(switchCheckCorrection.error, 0)) return correction;
        id scActiveRailOpt = [[((TRRailroadConnectorContent*)([_connectorIndex applyKey:tuple((wrap(GEVec2i, p.tile)), trRailPointEndConnector(p))])) rails] headOpt];
        if([scActiveRailOpt isEmpty]) return correction;
        if(((TRRail*)([scActiveRailOpt get])).form != p.form) {
            if(!(obstacleProcessor([TRObstacle obstacleWithObstacleType:TRObstacleType.aSwitch point:correction.point]))) return TRRailPointCorrectionMake((trRailPointAddX(switchCheckCorrection.point, -0.5)), switchCheckCorrection.error);
        }
        return correction;
    }
    TRRailConnector* connector = trRailPointEndConnector(p);
    TRRailroadConnectorContent* connectorDesc = [_connectorIndex applyKey:tuple((wrap(GEVec2i, p.tile)), connector)];
    id activeRailOpt = [[connectorDesc rails] headOpt];
    if([activeRailOpt isEmpty]) return correction;
    if(((TRRail*)([activeRailOpt get])).form != p.form) {
        obstacleProcessor([TRObstacle obstacleWithObstacleType:TRObstacleType.aSwitch point:correction.point]);
        return correction;
    }
    if(!([connectorDesc isGreen])) {
        if(!(obstacleProcessor([TRObstacle obstacleWithObstacleType:TRObstacleType.light point:correction.point]))) return correction;
    }
    GEVec2i nextTile = [connector nextTile:p.tile];
    TRRailConnector* otherSideConnector = [connector otherSideConnector];
    id nextRail = [self activeRailForTile:nextTile connector:otherSideConnector];
    if([nextRail isEmpty]) {
        obstacleProcessor([TRObstacle obstacleWithObstacleType:TRObstacleType.end point:correction.point]);
        return correction;
    }
    TRRail* nextActiveRail = [nextRail get];
    TRRailForm* form = nextActiveRail.form;
    return [self moveWithObstacleProcessor:obstacleProcessor forLength:correction.error point:trRailPointApplyTileFormXBack(nextTile, form, 0.0, form.end == otherSideConnector)];
}

- (id)checkDamagesWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor from:(TRRailPoint)from to:(CGFloat)to {
    if([__damagesPoints isEmpty]) return [CNOption none];
    if(eqf(from.x, to)) return [CNOption none];
    id opt = [_damagesIndex optKey:tuple((wrap(GEVec2i, from.tile)), from.form)];
    if([opt isEmpty]) return [CNOption none];
    BOOL(^on)(id) = ^BOOL(id x) {
        return !(obstacleProcessor(([TRObstacle obstacleWithObstacleType:TRObstacleType.damage point:trRailPointSetX(from, unumf(x))])));
    };
    CGFloat len = from.form.length;
    if(from.back) return [[[[[((id<CNSeq>)([opt get])) chain] filter:^BOOL(id _) {
        return floatBetween(unumf(_), len - to, len - from.x);
    }] sortDesc] map:^id(id _) {
        return numf(len - unumf(_));
    }] findWhere:on];
    else return [[[[((id<CNSeq>)([opt get])) chain] filter:^BOOL(id _) {
        return floatBetween(unumf(_), from.x, to);
    }] sort] findWhere:on];
}

- (TRRailPoint)addDamageAtPoint:(TRRailPoint)point {
    TRRailPoint p = point;
    if(p.back) p = trRailPointInvert(p);
    CGFloat fl = p.form.length;
    if([p.form isStraight] && floatBetween(p.x, 0.35, 0.65)) {
        p = trRailPointSetX(p, 0.35);
    } else {
        if(floatBetween(p.x, 0.0, 0.3)) {
            p = trRailPointSetX(p, 0.3);
        } else {
            if(floatBetween(p.x, fl - 0.3, fl)) p = trRailPointSetX(p, fl - 0.3);
        }
    }
    if(!([_map isVisibleVec2:p.point])) {
        p = trRailPointSetX(p, 0.0);
        if(!([_map isVisibleVec2:p.point])) p = trRailPointSetX(p, fl);
    }
    [_damagesIndex modifyKey:tuple((wrap(GEVec2i, p.tile)), p.form) by:^id(id arr) {
        return [CNOption applyValue:[[arr mapF:^id<CNSeq>(id<CNSeq> _) {
            return [((id<CNSeq>)(_)) addItem:numf(p.x)];
        }] getOrElseF:^id<CNSeq>() {
            return (@[numf(p.x)]);
        }]];
    }];
    [__damagesPoints appendItem:wrap(TRRailPoint, p)];
    return p;
}

- (void)fixDamageAtPoint:(TRRailPoint)point {
    TRRailPoint p = point;
    if(p.back) p = trRailPointInvert(point);
    [_damagesIndex modifyKey:tuple((wrap(GEVec2i, p.tile)), p.form) by:^id(id arrOpt) {
        return [arrOpt mapF:^id<CNSeq>(id<CNSeq> arr) {
            return [[[((id<CNSeq>)(arr)) chain] filter:^BOOL(id _) {
                return !(eqf(unumf(_), p.x));
            }] toArray];
        }];
    }];
    [__damagesPoints removeItem:wrap(TRRailPoint, p)];
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (ODClassType*)type {
    return [TRRailroad type];
}

+ (CNNotificationHandle*)changedNotification {
    return _TRRailroad_changedNotification;
}

+ (ODClassType*)type {
    return _TRRailroad_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailroad* o = ((TRRailroad*)(other));
    return [self.map isEqual:o.map] && [self.score isEqual:o.score] && [self.forest isEqual:o.forest];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.map hash];
    hash = hash * 31 + [self.score hash];
    hash = hash * 31 + [self.forest hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"map=%@", self.map];
    [description appendFormat:@", score=%@", self.score];
    [description appendFormat:@", forest=%@", self.forest];
    [description appendString:@">"];
    return description;
}

@end


