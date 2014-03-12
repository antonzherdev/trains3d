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

- (id<CNImSeq>)rails {
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

- (id<CNImSeq>)rails {
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


@implementation TRRail
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
    return [TRSwitchState switchStateWithASwitch:[TRSwitch switchWithTile:rail.tile connector:to rail1:self rail2:rail] firstActive:YES];
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return TREmptyConnector.instance;
}

- (id<CNImSeq>)rails {
    return (@[self]);
}

- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnector*)connector mustBe:(BOOL)mustBe {
    if(mustBe) return [TRRailLightState railLightStateWithLight:[TRRailLight railLightWithTile:_tile connector:connector rail:self] isGreen:YES];
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


@implementation TRSwitch
static ODClassType* _TRSwitch_type;
@synthesize tile = _tile;
@synthesize connector = _connector;
@synthesize rail1 = _rail1;
@synthesize rail2 = _rail2;

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
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSwitch class]) _TRSwitch_type = [ODClassType classTypeWithCls:[TRSwitch class]];
}

- (id<CNImSeq>)rails {
    return (@[_rail1, _rail2]);
}

- (TRRailPoint)railPoint1 {
    return [self railPointRail:_rail1];
}

- (TRRailPoint)railPoint2 {
    return [self railPointRail:_rail2];
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail {
    if([rail isEqual:_rail1]) return _rail2;
    else return _rail1;
}

- (TRRailPoint)railPointRail:(TRRail*)rail {
    return trRailPointApplyTileFormXBack(_tile, rail.form, 0.0, rail.form.end == _connector);
}

- (ODClassType*)type {
    return [TRSwitch type];
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


@implementation TRSwitchState
static ODClassType* _TRSwitchState_type;
@synthesize aSwitch = _switch;
@synthesize firstActive = _firstActive;

+ (instancetype)switchStateWithASwitch:(TRSwitch*)aSwitch firstActive:(BOOL)firstActive {
    return [[TRSwitchState alloc] initWithASwitch:aSwitch firstActive:firstActive];
}

- (instancetype)initWithASwitch:(TRSwitch*)aSwitch firstActive:(BOOL)firstActive {
    self = [super init];
    if(self) {
        _switch = aSwitch;
        _firstActive = firstActive;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSwitchState class]) _TRSwitchState_type = [ODClassType classTypeWithCls:[TRSwitchState class]];
}

- (TRRail*)activeRail {
    if(_firstActive) return _switch.rail1;
    else return _switch.rail2;
}

- (id<CNImSeq>)rails {
    if(_firstActive) return [_switch rails];
    else return (@[_switch.rail2, _switch.rail1]);
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return self;
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return [_switch disconnectRail:rail];
}

- (void)cutDownTreesInForest:(TRForest*)forest {
    [forest cutDownForASwitch:_switch];
}

- (BOOL)canAddRail:(TRRail*)rail {
    return NO;
}

- (TRSwitchState*)turn {
    return [TRSwitchState switchStateWithASwitch:_switch firstActive:!(_firstActive)];
}

- (TRRailConnector*)connector {
    return _switch.connector;
}

- (GEVec2i)tile {
    return _switch.tile;
}

- (ODClassType*)type {
    return [TRSwitchState type];
}

+ (ODClassType*)type {
    return _TRSwitchState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSwitchState* o = ((TRSwitchState*)(other));
    return [self.aSwitch isEqual:o.aSwitch] && self.firstActive == o.firstActive;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.aSwitch hash];
    hash = hash * 31 + self.firstActive;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"switch=%@", self.aSwitch];
    [description appendFormat:@", firstActive=%d", self.firstActive];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRailLight
static ODClassType* _TRRailLight_type;
@synthesize tile = _tile;
@synthesize connector = _connector;
@synthesize rail = _rail;

+ (instancetype)railLightWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail {
    return [[TRRailLight alloc] initWithTile:tile connector:connector rail:rail];
}

- (instancetype)initWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail {
    self = [super init];
    if(self) {
        _tile = tile;
        _connector = connector;
        _rail = rail;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailLight class]) _TRRailLight_type = [ODClassType classTypeWithCls:[TRRailLight class]];
}

- (ODClassType*)type {
    return [TRRailLight type];
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


@implementation TRRailLightState
static ODClassType* _TRRailLightState_type;
@synthesize light = _light;
@synthesize isGreen = _isGreen;

+ (instancetype)railLightStateWithLight:(TRRailLight*)light isGreen:(BOOL)isGreen {
    return [[TRRailLightState alloc] initWithLight:light isGreen:isGreen];
}

- (instancetype)initWithLight:(TRRailLight*)light isGreen:(BOOL)isGreen {
    self = [super init];
    if(self) {
        _light = light;
        _isGreen = isGreen;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailLightState class]) _TRRailLightState_type = [ODClassType classTypeWithCls:[TRRailLightState class]];
}

- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnector*)connector mustBe:(BOOL)mustBe {
    if(mustBe) return self;
    else return _light.rail;
}

- (id<CNImSeq>)rails {
    return (@[_light.rail]);
}

- (void)cutDownTreesInForest:(TRForest*)forest {
    [forest cutDownForLight:_light];
}

- (BOOL)canAddRail:(TRRail*)rail {
    return [_light.rail canAddRail:rail];
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return [TRSwitchState switchStateWithASwitch:[TRSwitch switchWithTile:_light.tile connector:to rail1:_light.rail rail2:rail] firstActive:YES];
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return TREmptyConnector.instance;
}

- (TRRailLightState*)turn {
    return [TRRailLightState railLightStateWithLight:_light isGreen:!(_isGreen)];
}

- (TRRailConnector*)connector {
    return _light.connector;
}

- (GEVec2i)tile {
    return _light.tile;
}

- (GEVec3)shift {
    return GEVec3Make(((_light.connector == TRRailConnector.top) ? -0.2 : 0.2), 0.0, -0.45);
}

- (ODClassType*)type {
    return [TRRailLightState type];
}

+ (ODClassType*)type {
    return _TRRailLightState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailLightState* o = ((TRRailLightState*)(other));
    return [self.light isEqual:o.light] && self.isGreen == o.isGreen;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.light hash];
    hash = hash * 31 + self.isGreen;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"light=%@", self.light];
    [description appendFormat:@", isGreen=%d", self.isGreen];
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


@implementation TRObstacle
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


@implementation TRRailroad
static CNNotificationHandle* _TRRailroad_switchTurnNotification;
static CNNotificationHandle* _TRRailroad_lightTurnNotification;
static CNNotificationHandle* _TRRailroad_changedNotification;
static ODClassType* _TRRailroad_type;
@synthesize map = _map;
@synthesize score = _score;
@synthesize forest = _forest;
@synthesize _connectorIndex = __connectorIndex;
@synthesize _state = __state;

+ (instancetype)railroadWithMap:(EGMapSso*)map score:(TRScore*)score forest:(TRForest*)forest {
    return [[TRRailroad alloc] initWithMap:map score:score forest:forest];
}

- (instancetype)initWithMap:(EGMapSso*)map score:(TRScore*)score forest:(TRForest*)forest {
    self = [super init];
    if(self) {
        _map = map;
        _score = score;
        _forest = forest;
        __connectorIndex = [CNMMapDefault mapDefaultWithMap:[NSMutableDictionary mutableDictionary] defaultFunc:^TRRailroadConnectorContent*(CNTuple* _) {
            return TREmptyConnector.instance;
        }];
        __state = [TRRailroadState railroadStateWithConnectorIndex:[CNImMapDefault imMapDefaultWithMap:[NSDictionary dictionary] defaultFunc:^TRRailroadConnectorContent*(CNTuple* _) {
            return TREmptyConnector.instance;
        }] damages:[TRRailroadDamages railroadDamagesWithPoints:(@[])]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroad class]) {
        _TRRailroad_type = [ODClassType classTypeWithCls:[TRRailroad class]];
        _TRRailroad_switchTurnNotification = [CNNotificationHandle notificationHandleWithName:@"switchTurnNotification"];
        _TRRailroad_lightTurnNotification = [CNNotificationHandle notificationHandleWithName:@"Light turned"];
        _TRRailroad_changedNotification = [CNNotificationHandle notificationHandleWithName:@"Railroad changed"];
    }
}

- (CNFuture*)state {
    __weak TRRailroad* _weakSelf = self;
    return [self promptF:^TRRailroadState*() {
        TRRailroad* _self = _weakSelf;
        return _self->__state;
    }];
}

- (CNFuture*)tryAddRail:(TRRail*)rail {
    __weak TRRailroad* _weakSelf = self;
    return [self futureF:^id() {
        TRRailroad* _self = _weakSelf;
        if([_self->__state canAddRail:rail]) {
            [_self addRail:rail];
            [_self->_score railBuilt];
            return @YES;
        } else {
            return @NO;
        }
    }];
}

- (CNFuture*)turnASwitch:(TRSwitch*)aSwitch {
    __weak TRRailroad* _weakSelf = self;
    return [self futureF:^id() {
        TRRailroad* _self = _weakSelf;
        [[[_self->__state switches] findWhere:^BOOL(TRSwitchState* _) {
            return [((TRSwitchState*)(_)).aSwitch isEqual:aSwitch];
        }] forEach:^void(TRSwitchState* state) {
            TRRailroad* _self = _weakSelf;
            TRSwitchState* ns = [((TRSwitchState*)(state)) turn];
            [_self->__connectorIndex setKey:tuple((wrap(GEVec2i, aSwitch.tile)), aSwitch.connector) value:ns];
            [_self commitState];
            [[TRRailroad switchTurnNotification] postSender:[_self actor] data:ns];
        }];
        return nil;
    }];
}

- (void)commitState {
    __state = [TRRailroadState railroadStateWithConnectorIndex:[__connectorIndex imCopy] damages:__state.damages];
    [_TRRailroad_changedNotification postSender:[self actor]];
}

- (CNFuture*)turnLight:(TRRailLight*)light {
    __weak TRRailroad* _weakSelf = self;
    return [self futureF:^id() {
        TRRailroad* _self = _weakSelf;
        [[[_self->__state lights] findWhere:^BOOL(TRRailLightState* _) {
            return [((TRRailLightState*)(_)).light isEqual:light];
        }] forEach:^void(TRRailLightState* state) {
            TRRailroad* _self = _weakSelf;
            TRRailLightState* ns = [((TRRailLightState*)(state)) turn];
            [_self->__connectorIndex setKey:tuple((wrap(GEVec2i, light.tile)), light.connector) value:ns];
            [_self commitState];
            [[TRRailroad lightTurnNotification] postSender:[_self actor] data:ns];
        }];
        return nil;
    }];
}

- (void)addRail:(TRRail*)rail {
    [[self connectRail:rail to:rail.form.start] cutDownTreesInForest:_forest];
    [[self connectRail:rail to:rail.form.end] cutDownTreesInForest:_forest];
    [self checkLightsNearRail:rail];
    [_forest cutDownForRail:rail];
    [self commitState];
}

- (CNFuture*)removeRail:(TRRail*)rail {
    __weak TRRailroad* _weakSelf = self;
    return [self futureF:^id() {
        TRRailroad* _self = _weakSelf;
        if([[_self->__state rails] containsItem:rail]) {
            [_self disconnectRail:rail to:rail.form.start];
            [_self disconnectRail:rail to:rail.form.end];
            [_self checkLightsNearRail:rail];
            [_self commitState];
        }
        return nil;
    }];
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return [__connectorIndex modifyKey:tuple((wrap(GEVec2i, rail.tile)), to) by:^TRRailroadConnectorContent*(TRRailroadConnectorContent* _) {
        return [((TRRailroadConnectorContent*)(_)) connectRail:rail to:to];
    }];
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return [__connectorIndex modifyKey:tuple((wrap(GEVec2i, rail.tile)), to) by:^TRRailroadConnectorContent*(TRRailroadConnectorContent* _) {
        return [((TRRailroadConnectorContent*)(_)) disconnectRail:rail to:to];
    }];
}

- (void)checkLightsNearRail:(TRRail*)rail {
    GEVec2i tile = rail.tile;
    [[self actor] checkLightsNearTile:tile connector:rail.form.start];
    [[self actor] checkLightsNearTile:tile connector:rail.form.end];
}

- (CNFuture*)checkLightsNearTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    __weak TRRailroad* _weakSelf = self;
    return [self futureF:^id() {
        TRRailroad* _self = _weakSelf;
        if([_self checkLightsNearTile:tile connector:connector distance:4 this:YES]) [_self commitState];
        return nil;
    }];
}

- (BOOL)checkLightsNearTile:(GEVec2i)tile connector:(TRRailConnector*)connector distance:(NSInteger)distance this:(BOOL)this {
    __block BOOL changed = NO;
    if(distance <= 0) {
        changed = [self checkLightInTile:tile connector:connector];
    } else {
        TRRailroadConnectorContent* c = [__connectorIndex applyKey:tuple((wrap(GEVec2i, tile)), connector)];
        [[c rails] forEach:^void(TRRail* rail) {
            TRRailConnector* oc = [((TRRail*)(rail)).form otherConnectorThan:connector];
            changed = [self checkLightsNearTile:[oc nextTile:tile] connector:[oc otherSideConnector] distance:distance - 1 this:NO] || changed;
            changed = [self checkLightInTile:tile connector:oc] || changed;
        }];
        if(!(this)) changed = [self checkLightInTile:tile connector:connector] || changed;
    }
    return changed;
}

- (BOOL)needLightsInTile:(GEVec2i)tile connector:(TRRailConnector*)connector distance:(NSInteger)distance this:(BOOL)this {
    TRRailroadConnectorContent* content = [__connectorIndex applyKey:tuple((wrap(GEVec2i, tile)), connector)];
    if([content isKindOfClass:[TRRailLightState class]] && !(this)) {
        return NO;
    } else {
        if(distance == 0) {
            return YES;
        } else {
            GEVec2i nextTile = [connector nextTile:tile];
            TRRailConnector* otherSideConnector = [connector otherSideConnector];
            TRRailroadConnectorContent* nc = [__connectorIndex applyKey:tuple((wrap(GEVec2i, nextTile)), otherSideConnector)];
            return [[nc rails] existsWhere:^BOOL(TRRail* rail) {
                return [self needLightsInTile:nextTile connector:[((TRRail*)(rail)).form otherConnectorThan:otherSideConnector] distance:distance - 1 this:NO];
            }];
        }
    }
}

- (BOOL)needLightsInOtherDirectionTile:(GEVec2i)tile connector:(TRRailConnector*)connector distance:(NSInteger)distance this:(BOOL)this {
    TRRailroadConnectorContent* content = [__connectorIndex applyKey:tuple((wrap(GEVec2i, tile)), connector)];
    if([content isKindOfClass:[TRRailLightState class]] && !(this)) {
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
    id<CNImSeq> rails = [((TRRailroadConnectorContent*)([__connectorIndex applyKey:tuple((wrap(GEVec2i, tile)), connector)])) rails];
    return [rails count] == 1 && ((TRRail*)([rails applyIndex:0])).form.isTurn;
}

- (BOOL)checkLightInTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    if([self needLightsInTile:tile connector:connector distance:2 this:YES] && [self needLightsInOtherDirectionTile:tile connector:connector distance:2 this:YES]) {
        return [self buildLightInTile:tile connector:connector mustBe:YES];
    } else {
        if([_map isPartialTile:tile] && [_map isFullTile:[connector nextTile:tile]]) {
            return [self buildLightInTile:tile connector:connector mustBe:YES];
        } else {
            GEVec2i nextTile = [connector nextTile:tile];
            TRRailConnector* otherSideConnector = [connector otherSideConnector];
            TRRailroadConnectorContent* c = [__connectorIndex applyKey:tuple((wrap(GEVec2i, nextTile)), otherSideConnector)];
            if([c isKindOfClass:[TRRail class]] && [[c rails] existsWhere:^BOOL(TRRail* rail) {
    TRRailConnector* oc = [((TRRail*)(rail)).form otherConnectorThan:otherSideConnector];
    return ((TRRail*)(rail)).form.isTurn && [((TRRailroadConnectorContent*)([__connectorIndex applyKey:tuple((wrap(GEVec2i, nextTile)), oc)])) isKindOfClass:[TRSwitchState class]];
}]) return [self buildLightInTile:tile connector:connector mustBe:YES];
            else return [self buildLightInTile:tile connector:connector mustBe:NO];
        }
    }
}

- (BOOL)buildLightInTile:(GEVec2i)tile connector:(TRRailConnector*)connector mustBe:(BOOL)mustBe {
    __block BOOL changed = NO;
    [__connectorIndex modifyKey:tuple((wrap(GEVec2i, tile)), connector) by:^TRRailroadConnectorContent*(TRRailroadConnectorContent* content) {
        TRRailroadConnectorContent* r = [((TRRailroadConnectorContent*)(content)) checkLightInConnector:connector mustBe:mustBe];
        if(!([r isEqual:content])) {
            if([r isKindOfClass:[TRRailLightState class]]) [r cutDownTreesInForest:_forest];
            changed = YES;
        }
        return r;
    }];
    return changed;
}

- (CNFuture*)addDamageAtPoint:(TRRailPoint)point {
    __weak TRRailroad* _weakSelf = self;
    return [self futureF:^id() {
        TRRailroad* _self = _weakSelf;
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
        if(!([_self->_map isVisibleVec2:p.point])) {
            p = trRailPointSetX(p, 0.0);
            if(!([_self->_map isVisibleVec2:p.point])) p = trRailPointSetX(p, fl);
        }
        _self->__state = [TRRailroadState railroadStateWithConnectorIndex:_self->__state.connectorIndex damages:[TRRailroadDamages railroadDamagesWithPoints:[_self->__state.damages.points addItem:wrap(TRRailPoint, p)]]];
        return wrap(TRRailPoint, p);
    }];
}

- (CNFuture*)fixDamageAtPoint:(TRRailPoint)point {
    __weak TRRailroad* _weakSelf = self;
    return [self futureF:^id() {
        TRRailroad* _self = _weakSelf;
        TRRailPoint p = point;
        if(p.back) p = trRailPointInvert(point);
        _self->__state = [TRRailroadState railroadStateWithConnectorIndex:_self->__state.connectorIndex damages:[TRRailroadDamages railroadDamagesWithPoints:[_self->__state.damages.points subItem:wrap(TRRailPoint, p)]]];
        return nil;
    }];
}

- (ODClassType*)type {
    return [TRRailroad type];
}

+ (CNNotificationHandle*)switchTurnNotification {
    return _TRRailroad_switchTurnNotification;
}

+ (CNNotificationHandle*)lightTurnNotification {
    return _TRRailroad_lightTurnNotification;
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


@implementation TRRailroadDamages
static ODClassType* _TRRailroadDamages_type;
@synthesize points = _points;

+ (instancetype)railroadDamagesWithPoints:(id<CNImSeq>)points {
    return [[TRRailroadDamages alloc] initWithPoints:points];
}

- (instancetype)initWithPoints:(id<CNImSeq>)points {
    self = [super init];
    __weak TRRailroadDamages* _weakSelf = self;
    if(self) {
        _points = points;
        __lazy_index = [CNLazy lazyWithF:^id<CNImMap>() {
            TRRailroadDamages* _self = _weakSelf;
            return [[[_self->_points chain] groupBy:^CNTuple*(id _) {
                return tuple((wrap(GEVec2i, (uwrap(TRRailPoint, _).tile))), (uwrap(TRRailPoint, _).form));
            } map:^id(id _) {
                return numf((uwrap(TRRailPoint, _).x));
            }] toMap];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadDamages class]) _TRRailroadDamages_type = [ODClassType classTypeWithCls:[TRRailroadDamages class]];
}

- (id<CNImMap>)index {
    return [__lazy_index get];
}

- (ODClassType*)type {
    return [TRRailroadDamages type];
}

+ (ODClassType*)type {
    return _TRRailroadDamages_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailroadDamages* o = ((TRRailroadDamages*)(other));
    return [self.points isEqual:o.points];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.points hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"points=%@", self.points];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRailroadState
static ODClassType* _TRRailroadState_type;
@synthesize connectorIndex = _connectorIndex;
@synthesize damages = _damages;

+ (instancetype)railroadStateWithConnectorIndex:(CNImMapDefault*)connectorIndex damages:(TRRailroadDamages*)damages {
    return [[TRRailroadState alloc] initWithConnectorIndex:connectorIndex damages:damages];
}

- (instancetype)initWithConnectorIndex:(CNImMapDefault*)connectorIndex damages:(TRRailroadDamages*)damages {
    self = [super init];
    __weak TRRailroadState* _weakSelf = self;
    if(self) {
        _connectorIndex = connectorIndex;
        _damages = damages;
        __lazy_rails = [CNLazy lazyWithF:^id<CNImSeq>() {
            TRRailroadState* _self = _weakSelf;
            return [[[[[_self->_connectorIndex values] chain] flatMap:^id<CNImSeq>(TRRailroadConnectorContent* _) {
                return [((TRRailroadConnectorContent*)(_)) rails];
            }] distinct] toArray];
        }];
        __lazy_switches = [CNLazy lazyWithF:^id<CNImSeq>() {
            TRRailroadState* _self = _weakSelf;
            return [[[[_self->_connectorIndex values] chain] filter:^BOOL(TRRailroadConnectorContent* _) {
                return [((TRRailroadConnectorContent*)(_)) isKindOfClass:[TRSwitchState class]];
            }] toArray];
        }];
        __lazy_lights = [CNLazy lazyWithF:^id<CNImSeq>() {
            TRRailroadState* _self = _weakSelf;
            return [[[[_self->_connectorIndex values] chain] filter:^BOOL(TRRailroadConnectorContent* _) {
                return [((TRRailroadConnectorContent*)(_)) isKindOfClass:[TRRailLightState class]];
            }] toArray];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadState class]) _TRRailroadState_type = [ODClassType classTypeWithCls:[TRRailroadState class]];
}

- (id<CNImSeq>)rails {
    return [__lazy_rails get];
}

- (id<CNImSeq>)switches {
    return [__lazy_switches get];
}

- (id<CNImSeq>)lights {
    return [__lazy_lights get];
}

- (BOOL)canAddRail:(TRRail*)rail {
    return [((TRRailroadConnectorContent*)([_connectorIndex applyKey:tuple((wrap(GEVec2i, rail.tile)), rail.form.start)])) canAddRail:rail] && [((TRRailroadConnectorContent*)([_connectorIndex applyKey:tuple((wrap(GEVec2i, rail.tile)), rail.form.end)])) canAddRail:rail];
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
    if([_damages.points isEmpty]) return [CNOption none];
    if(eqf(from.x, to)) return [CNOption none];
    id opt = [[_damages index] optKey:tuple((wrap(GEVec2i, from.tile)), from.form)];
    if([opt isEmpty]) return [CNOption none];
    BOOL(^on)(id) = ^BOOL(id x) {
        return !(obstacleProcessor(([TRObstacle obstacleWithObstacleType:TRObstacleType.damage point:trRailPointSetX(from, unumf(x))])));
    };
    CGFloat len = from.form.length;
    if(from.back) return [[[[[((id<CNImSeq>)([opt get])) chain] filter:^BOOL(id _) {
        return floatBetween(unumf(_), len - to, len - from.x);
    }] sortDesc] map:^id(id _) {
        return numf(len - unumf(_));
    }] findWhere:on];
    else return [[[[((id<CNImSeq>)([opt get])) chain] filter:^BOOL(id _) {
        return floatBetween(unumf(_), from.x, to);
    }] sort] findWhere:on];
}

- (TRRailroadConnectorContent*)contentInTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    return [_connectorIndex applyKey:tuple((wrap(GEVec2i, tile)), connector)];
}

- (ODClassType*)type {
    return [TRRailroadState type];
}

+ (ODClassType*)type {
    return _TRRailroadState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailroadState* o = ((TRRailroadState*)(other));
    return [self.connectorIndex isEqual:o.connectorIndex] && [self.damages isEqual:o.damages];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.connectorIndex hash];
    hash = hash * 31 + [self.damages hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"connectorIndex=%@", self.connectorIndex];
    [description appendFormat:@", damages=%@", self.damages];
    [description appendString:@">"];
    return description;
}

@end


