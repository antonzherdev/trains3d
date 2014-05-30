#import "TRRailroad.h"

#import "TRTree.h"
#import "EGMapIso.h"
#import "TRScore.h"
#import "CNObserver.h"
#import "CNFuture.h"
#import "CNChain.h"
@implementation TRRailroadConnectorContent
static CNClassType* _TRRailroadConnectorContent_type;

+ (instancetype)railroadConnectorContent {
    return [[TRRailroadConnectorContent alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadConnectorContent class]) _TRRailroadConnectorContent_type = [CNClassType classTypeWithCls:[TRRailroadConnectorContent class]];
}

- (BOOL)canAddRail:(TRRail*)rail {
    return YES;
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnectorR)to {
    @throw @"Method connect is abstract";
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnectorR)to {
    @throw @"Method disconnect is abstract";
}

- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnectorR)connector mustBe:(BOOL)mustBe {
    return self;
}

- (NSArray*)rails {
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

- (NSString*)description {
    return @"RailroadConnectorContent";
}

- (CNClassType*)type {
    return [TRRailroadConnectorContent type];
}

+ (CNClassType*)type {
    return _TRRailroadConnectorContent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TREmptyConnector
static TRRailroadConnectorContent* _TREmptyConnector_instance;
static CNClassType* _TREmptyConnector_type;

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
        _TREmptyConnector_type = [CNClassType classTypeWithCls:[TREmptyConnector class]];
        _TREmptyConnector_instance = [TREmptyConnector emptyConnector];
    }
}

- (NSArray*)rails {
    return ((NSArray*)((@[])));
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnectorR)to {
    return rail;
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnectorR)to {
    return self;
}

- (BOOL)isEmpty {
    return YES;
}

- (NSString*)description {
    return @"EmptyConnector";
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TREmptyConnector class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (CNClassType*)type {
    return [TREmptyConnector type];
}

+ (TRRailroadConnectorContent*)instance {
    return _TREmptyConnector_instance;
}

+ (CNClassType*)type {
    return _TREmptyConnector_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRRail
static CNClassType* _TRRail_type;
@synthesize tile = _tile;
@synthesize form = _form;

+ (instancetype)railWithTile:(GEVec2i)tile form:(TRRailFormR)form {
    return [[TRRail alloc] initWithTile:tile form:form];
}

- (instancetype)initWithTile:(GEVec2i)tile form:(TRRailFormR)form {
    self = [super init];
    if(self) {
        _tile = tile;
        _form = form;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRail class]) _TRRail_type = [CNClassType classTypeWithCls:[TRRail class]];
}

- (BOOL)hasConnector:(TRRailConnectorR)connector {
    return [TRRailForm value:_form].start == connector || [TRRailForm value:_form].end == connector;
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnectorR)to {
    return [TRSwitchState switchStateWithASwitch:[TRSwitch switchWithTile:rail.tile connector:to rail1:self rail2:rail] firstActive:YES];
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnectorR)to {
    return TREmptyConnector.instance;
}

- (NSArray*)rails {
    return (@[self]);
}

- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnectorR)connector mustBe:(BOOL)mustBe {
    if(mustBe) return ((TRRailroadConnectorContent*)([TRRailLightState railLightStateWithLight:[TRRailLight railLightWithTile:_tile connector:connector rail:self] isGreen:YES]));
    else return ((TRRailroadConnectorContent*)(self));
}

- (BOOL)canAddRail:(TRRail*)rail {
    return rail.form != _form;
}

- (GELine2)line {
    return geLine2AddVec2([[TRRailForm value:_form] line], geVec2ApplyVec2i(_tile));
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Rail(%@, %@)", geVec2iDescription(_tile), [TRRailForm value:_form]];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRRail class]])) return NO;
    TRRail* o = ((TRRail*)(to));
    return geVec2iIsEqualTo(_tile, o.tile) && _form == o.form;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2iHash(_tile);
    hash = hash * 31 + [[TRRailForm value:_form] hash];
    return hash;
}

- (CNClassType*)type {
    return [TRRail type];
}

+ (CNClassType*)type {
    return _TRRail_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRSwitch
static CNClassType* _TRSwitch_type;
@synthesize tile = _tile;
@synthesize connector = _connector;
@synthesize rail1 = _rail1;
@synthesize rail2 = _rail2;

+ (instancetype)switchWithTile:(GEVec2i)tile connector:(TRRailConnectorR)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2 {
    return [[TRSwitch alloc] initWithTile:tile connector:connector rail1:rail1 rail2:rail2];
}

- (instancetype)initWithTile:(GEVec2i)tile connector:(TRRailConnectorR)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2 {
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
    if(self == [TRSwitch class]) _TRSwitch_type = [CNClassType classTypeWithCls:[TRSwitch class]];
}

- (NSArray*)rails {
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
    return trRailPointApplyTileFormXBack(_tile, rail.form, 0.0, [TRRailForm value:rail.form].end == _connector);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Switch(%@, %@, %@, %@)", geVec2iDescription(_tile), [TRRailConnector value:_connector], _rail1, _rail2];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRSwitch class]])) return NO;
    TRSwitch* o = ((TRSwitch*)(to));
    return geVec2iIsEqualTo(_tile, o.tile) && _connector == o.connector && [_rail1 isEqual:o.rail1] && [_rail2 isEqual:o.rail2];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2iHash(_tile);
    hash = hash * 31 + [[TRRailConnector value:_connector] hash];
    hash = hash * 31 + [_rail1 hash];
    hash = hash * 31 + [_rail2 hash];
    return hash;
}

- (CNClassType*)type {
    return [TRSwitch type];
}

+ (CNClassType*)type {
    return _TRSwitch_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRSwitchState
static CNClassType* _TRSwitchState_type;
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
    if(self == [TRSwitchState class]) _TRSwitchState_type = [CNClassType classTypeWithCls:[TRSwitchState class]];
}

- (TRRail*)activeRail {
    if(_firstActive) return _switch.rail1;
    else return _switch.rail2;
}

- (NSArray*)rails {
    if(_firstActive) return ((NSArray*)([_switch rails]));
    else return (@[_switch.rail2, _switch.rail1]);
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnectorR)to {
    return self;
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnectorR)to {
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

- (TRRailConnectorR)connector {
    return _switch.connector;
}

- (GEVec2i)tile {
    return _switch.tile;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SwitchState(%@, %d)", _switch, _firstActive];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRSwitchState class]])) return NO;
    TRSwitchState* o = ((TRSwitchState*)(to));
    return [_switch isEqual:o.aSwitch] && _firstActive == o.firstActive;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_switch hash];
    hash = hash * 31 + _firstActive;
    return hash;
}

- (CNClassType*)type {
    return [TRSwitchState type];
}

+ (CNClassType*)type {
    return _TRSwitchState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRRailLight
static CNClassType* _TRRailLight_type;
@synthesize tile = _tile;
@synthesize connector = _connector;
@synthesize rail = _rail;

+ (instancetype)railLightWithTile:(GEVec2i)tile connector:(TRRailConnectorR)connector rail:(TRRail*)rail {
    return [[TRRailLight alloc] initWithTile:tile connector:connector rail:rail];
}

- (instancetype)initWithTile:(GEVec2i)tile connector:(TRRailConnectorR)connector rail:(TRRail*)rail {
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
    if(self == [TRRailLight class]) _TRRailLight_type = [CNClassType classTypeWithCls:[TRRailLight class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RailLight(%@, %@, %@)", geVec2iDescription(_tile), [TRRailConnector value:_connector], _rail];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRRailLight class]])) return NO;
    TRRailLight* o = ((TRRailLight*)(to));
    return geVec2iIsEqualTo(_tile, o.tile) && _connector == o.connector && [_rail isEqual:o.rail];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2iHash(_tile);
    hash = hash * 31 + [[TRRailConnector value:_connector] hash];
    hash = hash * 31 + [_rail hash];
    return hash;
}

- (CNClassType*)type {
    return [TRRailLight type];
}

+ (CNClassType*)type {
    return _TRRailLight_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRRailLightState
static CNClassType* _TRRailLightState_type;
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
    if(self == [TRRailLightState class]) _TRRailLightState_type = [CNClassType classTypeWithCls:[TRRailLightState class]];
}

- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnectorR)connector mustBe:(BOOL)mustBe {
    if(mustBe) return ((TRRailroadConnectorContent*)(self));
    else return ((TRRailroadConnectorContent*)(_light.rail));
}

- (NSArray*)rails {
    return (@[_light.rail]);
}

- (void)cutDownTreesInForest:(TRForest*)forest {
    [forest cutDownForLight:_light];
}

- (BOOL)canAddRail:(TRRail*)rail {
    return [_light.rail canAddRail:rail];
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnectorR)to {
    return [TRSwitchState switchStateWithASwitch:[TRSwitch switchWithTile:_light.tile connector:to rail1:_light.rail rail2:rail] firstActive:YES];
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnectorR)to {
    return TREmptyConnector.instance;
}

- (TRRailLightState*)turn {
    return [TRRailLightState railLightStateWithLight:_light isGreen:!(_isGreen)];
}

- (TRRailConnectorR)connector {
    return _light.connector;
}

- (GEVec2i)tile {
    return _light.tile;
}

- (GEVec3)shift {
    return GEVec3Make(((_light.connector == TRRailConnector_top) ? -0.2 : 0.2), 0.0, -0.45);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RailLightState(%@, %d)", _light, _isGreen];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRRailLightState class]])) return NO;
    TRRailLightState* o = ((TRRailLightState*)(to));
    return [_light isEqual:o.light] && _isGreen == o.isGreen;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_light hash];
    hash = hash * 31 + _isGreen;
    return hash;
}

- (CNClassType*)type {
    return [TRRailLightState type];
}

+ (CNClassType*)type {
    return _TRRailLightState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

TRObstacleType* TRObstacleType_Values[5];
TRObstacleType* TRObstacleType_damage_Desc;
TRObstacleType* TRObstacleType_switch_Desc;
TRObstacleType* TRObstacleType_light_Desc;
TRObstacleType* TRObstacleType_end_Desc;
@implementation TRObstacleType

+ (instancetype)obstacleTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[TRObstacleType alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    TRObstacleType_damage_Desc = [TRObstacleType obstacleTypeWithOrdinal:0 name:@"damage"];
    TRObstacleType_switch_Desc = [TRObstacleType obstacleTypeWithOrdinal:1 name:@"switch"];
    TRObstacleType_light_Desc = [TRObstacleType obstacleTypeWithOrdinal:2 name:@"light"];
    TRObstacleType_end_Desc = [TRObstacleType obstacleTypeWithOrdinal:3 name:@"end"];
    TRObstacleType_Values[0] = nil;
    TRObstacleType_Values[1] = TRObstacleType_damage_Desc;
    TRObstacleType_Values[2] = TRObstacleType_switch_Desc;
    TRObstacleType_Values[3] = TRObstacleType_light_Desc;
    TRObstacleType_Values[4] = TRObstacleType_end_Desc;
}

+ (NSArray*)values {
    return (@[TRObstacleType_damage_Desc, TRObstacleType_switch_Desc, TRObstacleType_light_Desc, TRObstacleType_end_Desc]);
}

+ (TRObstacleType*)value:(TRObstacleTypeR)r {
    return TRObstacleType_Values[r];
}

@end

@implementation TRObstacle
static CNClassType* _TRObstacle_type;
@synthesize obstacleType = _obstacleType;
@synthesize point = _point;

+ (instancetype)obstacleWithObstacleType:(TRObstacleTypeR)obstacleType point:(TRRailPoint)point {
    return [[TRObstacle alloc] initWithObstacleType:obstacleType point:point];
}

- (instancetype)initWithObstacleType:(TRObstacleTypeR)obstacleType point:(TRRailPoint)point {
    self = [super init];
    if(self) {
        _obstacleType = obstacleType;
        _point = point;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRObstacle class]) _TRObstacle_type = [CNClassType classTypeWithCls:[TRObstacle class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Obstacle(%@, %@)", [TRObstacleType value:_obstacleType], trRailPointDescription(_point)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRObstacle class]])) return NO;
    TRObstacle* o = ((TRObstacle*)(to));
    return _obstacleType == o.obstacleType && trRailPointIsEqualTo(_point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [[TRObstacleType value:_obstacleType] hash];
    hash = hash * 31 + trRailPointHash(_point);
    return hash;
}

- (CNClassType*)type {
    return [TRObstacle type];
}

+ (CNClassType*)type {
    return _TRObstacle_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRRailroad
static CNClassType* _TRRailroad_type;
@synthesize map = _map;
@synthesize score = _score;
@synthesize forest = _forest;
@synthesize stateWasRestored = _stateWasRestored;
@synthesize switchWasTurned = _switchWasTurned;
@synthesize lightWasTurned = _lightWasTurned;
@synthesize railWasBuilt = _railWasBuilt;
@synthesize railWasRemoved = _railWasRemoved;
@synthesize lightWasBuiltOrRemoved = _lightWasBuiltOrRemoved;

+ (instancetype)railroadWithMap:(EGMapSso*)map score:(TRScore*)score forest:(TRForest*)forest {
    return [[TRRailroad alloc] initWithMap:map score:score forest:forest];
}

- (instancetype)initWithMap:(EGMapSso*)map score:(TRScore*)score forest:(TRForest*)forest {
    self = [super init];
    if(self) {
        _map = map;
        _score = score;
        _forest = forest;
        __connectorIndex = [CNMMapDefault mapDefaultWithMap:[CNMHashMap hashMap] defaultFunc:^TRRailroadConnectorContent*(id _) {
            return TREmptyConnector.instance;
        }];
        __state = [TRRailroadState railroadStateWithId:0 connectorIndex:[CNImMapDefault imMapDefaultWithMap:[CNImHashMap imHashMap] defaultFunc:^TRRailroadConnectorContent*(id _) {
            return TREmptyConnector.instance;
        }] damages:[TRRailroadDamages railroadDamagesWithPoints:((NSArray*)((@[])))]];
        _stateWasRestored = [CNSignal signal];
        _switchWasTurned = [CNSignal signal];
        _lightWasTurned = [CNSignal signal];
        _railWasBuilt = [CNSignal signal];
        _railWasRemoved = [CNSignal signal];
        _lightWasBuiltOrRemoved = [CNSignal signal];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroad class]) _TRRailroad_type = [CNClassType classTypeWithCls:[TRRailroad class]];
}

- (CNFuture*)state {
    return [self promptF:^TRRailroadState*() {
        return __state;
    }];
}

- (CNFuture*)restoreState:(TRRailroadState*)state {
    return [self futureF:^id() {
        if(!([__state isEqual:state])) {
            __state = state;
            [__connectorIndex.map assignImMap:__state.connectorIndex.map];
            [_stateWasRestored post];
        }
        return nil;
    }];
}

- (CNFuture*)tryAddRail:(TRRail*)rail {
    return [self tryAddRail:rail free:NO];
}

- (CNFuture*)tryAddRail:(TRRail*)rail free:(BOOL)free {
    return [self futureF:^id() {
        if([__state canAddRail:rail]) {
            [self addRail:rail];
            if(!(free)) [_score railBuilt];
            return @YES;
        } else {
            return @NO;
        }
    }];
}

- (CNFuture*)turnASwitch:(TRSwitch*)aSwitch {
    return [self futureF:^id() {
        TRSwitchState* state = [[__state switches] findWhere:^BOOL(TRSwitchState* _) {
            return [((TRSwitchState*)(_)).aSwitch isEqual:aSwitch];
        }];
        if(state != nil) {
            TRSwitchState* ns = [((TRSwitchState*)(state)) turn];
            [__connectorIndex setKey:numui4(({
                GEVec2i __tmp__il_p0_1rp0tile = aSwitch.tile;
                ((unsigned int)((__tmp__il_p0_1rp0tile.x + 8192) * 65536 + (__tmp__il_p0_1rp0tile.y + 8192) * 4 + aSwitch.connector));
            })) value:ns];
            [self commitState];
            [_switchWasTurned postData:ns];
        }
        return nil;
    }];
}

+ (unsigned int)indexKeyTile:(GEVec2i)tile connector:(TRRailConnectorR)connector {
    return ((unsigned int)((tile.x + 8192) * 65536 + (tile.y + 8192) * 4 + connector));
}

- (void)commitState {
    __state = [TRRailroadState railroadStateWithId:__state.id + 1 connectorIndex:[__connectorIndex imCopy] damages:__state.damages];
}

- (CNFuture*)turnLight:(TRRailLight*)light {
    return [self futureF:^id() {
        TRRailLightState* state = [[__state lights] findWhere:^BOOL(TRRailLightState* _) {
            return [((TRRailLightState*)(_)).light isEqual:light];
        }];
        if(state != nil) {
            TRRailLightState* ns = [((TRRailLightState*)(state)) turn];
            [__connectorIndex setKey:numui4(({
                GEVec2i __tmp__il_p0_1rp0tile = light.tile;
                ((unsigned int)((__tmp__il_p0_1rp0tile.x + 8192) * 65536 + (__tmp__il_p0_1rp0tile.y + 8192) * 4 + light.connector));
            })) value:ns];
            [self commitState];
            [_lightWasTurned postData:ns];
        }
        return nil;
    }];
}

- (void)addRail:(TRRail*)rail {
    [((TRRailroadConnectorContent*)([self connectRail:rail to:[TRRailForm value:rail.form].start])) cutDownTreesInForest:_forest];
    [((TRRailroadConnectorContent*)([self connectRail:rail to:[TRRailForm value:rail.form].end])) cutDownTreesInForest:_forest];
    [self checkLightsNearRail:rail];
    [_forest cutDownForRail:rail];
    [self commitState];
    [_railWasBuilt post];
}

- (CNFuture*)removeRail:(TRRail*)rail {
    return [self futureF:^id() {
        if([[__state rails] containsItem:rail]) {
            [self disconnectRail:rail to:[TRRailForm value:rail.form].start];
            [self disconnectRail:rail to:[TRRailForm value:rail.form].end];
            [self checkLightsNearRail:rail];
            [self commitState];
            [_railWasRemoved post];
        }
        return nil;
    }];
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnectorR)to {
    return [__connectorIndex modifyKey:numui4(({
        GEVec2i __tmp__il_rp0tile = rail.tile;
        ((unsigned int)((__tmp__il_rp0tile.x + 8192) * 65536 + (__tmp__il_rp0tile.y + 8192) * 4 + to));
    })) by:^TRRailroadConnectorContent*(TRRailroadConnectorContent* _) {
        return [((TRRailroadConnectorContent*)(_)) connectRail:rail to:to];
    }];
}

- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnectorR)to {
    return [__connectorIndex modifyKey:numui4(({
        GEVec2i __tmp__il_rp0tile = rail.tile;
        ((unsigned int)((__tmp__il_rp0tile.x + 8192) * 65536 + (__tmp__il_rp0tile.y + 8192) * 4 + to));
    })) by:^TRRailroadConnectorContent*(TRRailroadConnectorContent* _) {
        return [((TRRailroadConnectorContent*)(_)) disconnectRail:rail to:to];
    }];
}

- (void)checkLightsNearRail:(TRRail*)rail {
    GEVec2i tile = rail.tile;
    [self checkLightsNearTile:tile connector:[TRRailForm value:rail.form].start];
    [self checkLightsNearTile:tile connector:[TRRailForm value:rail.form].end];
}

- (CNFuture*)checkLightsNearTile:(GEVec2i)tile connector:(TRRailConnectorR)connector {
    return [self futureF:^id() {
        if([self checkLightsNearTile:tile connector:connector distance:4 this:YES]) [self commitState];
        return nil;
    }];
}

- (BOOL)checkLightsNearTile:(GEVec2i)tile connector:(TRRailConnectorR)connector distance:(NSInteger)distance this:(BOOL)this {
    __block BOOL changed = NO;
    if(distance <= 0) {
        changed = [self checkLightInTile:tile connector:connector];
    } else {
        TRRailroadConnectorContent* c = [__connectorIndex applyKey:numui4(((unsigned int)((tile.x + 8192) * 65536 + (tile.y + 8192) * 4 + connector)))];
        for(TRRail* rail in [c rails]) {
            TRRailConnectorR oc = [[TRRailForm value:((TRRail*)(rail)).form] otherConnectorThan:connector];
            changed = [self checkLightsNearTile:[[TRRailConnector value:oc] nextTile:tile] connector:[[TRRailConnector value:oc] otherSideConnector] distance:distance - 1 this:NO] || changed;
            changed = [self checkLightInTile:tile connector:oc] || changed;
        }
        if(!(this)) changed = [self checkLightInTile:tile connector:connector] || changed;
    }
    return changed;
}

- (BOOL)needLightsInTile:(GEVec2i)tile connector:(TRRailConnectorR)connector distance:(NSInteger)distance this:(BOOL)this {
    TRRailroadConnectorContent* content = [__connectorIndex applyKey:numui4(((unsigned int)((tile.x + 8192) * 65536 + (tile.y + 8192) * 4 + connector)))];
    if([content isKindOfClass:[TRRailLightState class]] && !(this)) {
        return NO;
    } else {
        if(distance == 0) {
            return YES;
        } else {
            GEVec2i nextTile = [[TRRailConnector value:connector] nextTile:tile];
            TRRailConnectorR otherSideConnector = [[TRRailConnector value:connector] otherSideConnector];
            TRRailroadConnectorContent* nc = [__connectorIndex applyKey:numui4(((unsigned int)((nextTile.x + 8192) * 65536 + (nextTile.y + 8192) * 4 + otherSideConnector)))];
            return [[nc rails] existsWhere:^BOOL(TRRail* rail) {
                return [self needLightsInTile:nextTile connector:[[TRRailForm value:((TRRail*)(rail)).form] otherConnectorThan:otherSideConnector] distance:distance - 1 this:NO];
            }];
        }
    }
}

- (BOOL)needLightsInOtherDirectionTile:(GEVec2i)tile connector:(TRRailConnectorR)connector distance:(NSInteger)distance this:(BOOL)this {
    TRRailroadConnectorContent* content = [__connectorIndex applyKey:numui4(((unsigned int)((tile.x + 8192) * 65536 + (tile.y + 8192) * 4 + connector)))];
    if([content isKindOfClass:[TRRailLightState class]] && !(this)) {
        return NO;
    } else {
        if(distance == 0) return YES;
        else return [[content rails] existsWhere:^BOOL(TRRail* rail) {
            TRRailConnectorR c = [[TRRailForm value:((TRRail*)(rail)).form] otherConnectorThan:connector];
            return [self needLightsInOtherDirectionTile:[[TRRailConnector value:c] nextTile:tile] connector:[[TRRailConnector value:c] otherSideConnector] distance:distance - 1 this:NO];
        }];
    }
}

- (BOOL)isTurnRailInTile:(GEVec2i)tile connector:(TRRailConnectorR)connector {
    NSArray* rails = [((TRRailroadConnectorContent*)([__connectorIndex applyKey:numui4(((unsigned int)((tile.x + 8192) * 65536 + (tile.y + 8192) * 4 + connector)))])) rails];
    return [rails count] == 1 && [TRRailForm value:((TRRail*)([rails applyIndex:0])).form].isTurn;
}

- (BOOL)checkLightInTile:(GEVec2i)tile connector:(TRRailConnectorR)connector {
    if([self needLightsInTile:tile connector:connector distance:2 this:YES] && [self needLightsInOtherDirectionTile:tile connector:connector distance:2 this:YES]) {
        return [self buildLightInTile:tile connector:connector mustBe:YES];
    } else {
        if([_map isPartialTile:tile] && [_map isFullTile:[[TRRailConnector value:connector] nextTile:tile]]) {
            return [self buildLightInTile:tile connector:connector mustBe:YES];
        } else {
            GEVec2i nextTile = [[TRRailConnector value:connector] nextTile:tile];
            TRRailConnectorR otherSideConnector = [[TRRailConnector value:connector] otherSideConnector];
            TRRailroadConnectorContent* c = [__connectorIndex applyKey:numui4(((unsigned int)((nextTile.x + 8192) * 65536 + (nextTile.y + 8192) * 4 + otherSideConnector)))];
            if([c isKindOfClass:[TRRail class]] && [[c rails] existsWhere:^BOOL(TRRail* rail) {
                TRRailConnectorR oc = [[TRRailForm value:((TRRail*)(rail)).form] otherConnectorThan:otherSideConnector];
                return [TRRailForm value:((TRRail*)(rail)).form].isTurn && [((TRRailroadConnectorContent*)([__connectorIndex applyKey:numui4(((unsigned int)((nextTile.x + 8192) * 65536 + (nextTile.y + 8192) * 4 + oc)))])) isKindOfClass:[TRSwitchState class]];
            }]) return [self buildLightInTile:tile connector:connector mustBe:YES];
            else return [self buildLightInTile:tile connector:connector mustBe:NO];
        }
    }
}

- (BOOL)buildLightInTile:(GEVec2i)tile connector:(TRRailConnectorR)connector mustBe:(BOOL)mustBe {
    __block BOOL changed = NO;
    [__connectorIndex modifyKey:numui4(((unsigned int)((tile.x + 8192) * 65536 + (tile.y + 8192) * 4 + connector))) by:^TRRailroadConnectorContent*(TRRailroadConnectorContent* content) {
        TRRailroadConnectorContent* r = [((TRRailroadConnectorContent*)(content)) checkLightInConnector:connector mustBe:mustBe];
        if(!([r isEqual:content])) {
            if([r isKindOfClass:[TRRailLightState class]]) [r cutDownTreesInForest:_forest];
            changed = YES;
        }
        return r;
    }];
    if(changed) [_lightWasBuiltOrRemoved post];
    return changed;
}

- (CNFuture*)addDamageAtPoint:(TRRailPoint)point {
    return [self futureF:^id() {
        TRRailPoint p = point;
        if(p.back) p = trRailPointInvert(p);
        CGFloat fl = [TRRailForm value:p.form].length;
        if([[TRRailForm value:p.form] isStraight] && floatBetween(p.x, 0.35, 0.65)) {
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
        __state = [TRRailroadState railroadStateWithId:__state.id + 1 connectorIndex:__state.connectorIndex damages:[TRRailroadDamages railroadDamagesWithPoints:[__state.damages.points addItem:wrap(TRRailPoint, p)]]];
        return wrap(TRRailPoint, p);
    }];
}

- (CNFuture*)fixDamageAtPoint:(TRRailPoint)point {
    return [self futureF:^id() {
        TRRailPoint p = point;
        if(p.back) p = trRailPointInvert(point);
        __state = [TRRailroadState railroadStateWithId:__state.id + 1 connectorIndex:__state.connectorIndex damages:[TRRailroadDamages railroadDamagesWithPoints:[__state.damages.points subItem:wrap(TRRailPoint, p)]]];
        return nil;
    }];
}

- (CNFuture*)isLockedRail:(TRRail*)rail {
    return [self promptF:^id() {
        return numb([__state isLockedRail:rail]);
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Railroad(%@, %@, %@)", _map, _score, _forest];
}

- (CNClassType*)type {
    return [TRRailroad type];
}

+ (CNClassType*)type {
    return _TRRailroad_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRRailroadDamages
static CNClassType* _TRRailroadDamages_type;
@synthesize points = _points;

+ (instancetype)railroadDamagesWithPoints:(NSArray*)points {
    return [[TRRailroadDamages alloc] initWithPoints:points];
}

- (instancetype)initWithPoints:(NSArray*)points {
    self = [super init];
    if(self) {
        _points = points;
        __lazy_index = [CNLazy lazyWithF:^NSDictionary*() {
            return [[[points chain] groupBy:^CNTuple*(id _) {
                return tuple((wrap(GEVec2i, (uwrap(TRRailPoint, _).tile))), ([TRRailForm value:uwrap(TRRailPoint, _).form]));
            } f:^id(id _) {
                return numf((uwrap(TRRailPoint, _).x));
            }] toMap];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadDamages class]) _TRRailroadDamages_type = [CNClassType classTypeWithCls:[TRRailroadDamages class]];
}

- (NSDictionary*)index {
    return [__lazy_index get];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RailroadDamages(%@)", _points];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRRailroadDamages class]])) return NO;
    TRRailroadDamages* o = ((TRRailroadDamages*)(to));
    return [_points isEqual:o.points];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_points hash];
    return hash;
}

- (CNClassType*)type {
    return [TRRailroadDamages type];
}

+ (CNClassType*)type {
    return _TRRailroadDamages_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRRailroadState
static CNClassType* _TRRailroadState_type;
@synthesize id = _id;
@synthesize connectorIndex = _connectorIndex;
@synthesize damages = _damages;

+ (instancetype)railroadStateWithId:(NSUInteger)id connectorIndex:(CNImMapDefault*)connectorIndex damages:(TRRailroadDamages*)damages {
    return [[TRRailroadState alloc] initWithId:id connectorIndex:connectorIndex damages:damages];
}

- (instancetype)initWithId:(NSUInteger)id connectorIndex:(CNImMapDefault*)connectorIndex damages:(TRRailroadDamages*)damages {
    self = [super init];
    if(self) {
        _id = id;
        _connectorIndex = connectorIndex;
        _damages = damages;
        __lazy_rails = [CNLazy lazyWithF:^NSArray*() {
            return [[[[[connectorIndex values] chain] flatMapF:^NSArray*(TRRailroadConnectorContent* _) {
                return [((TRRailroadConnectorContent*)(_)) rails];
            }] distinct] toArray];
        }];
        __lazy_switches = [CNLazy lazyWithF:^NSArray*() {
            return [[[[connectorIndex values] chain] filterCastTo:TRSwitchState.type] toArray];
        }];
        __lazy_lights = [CNLazy lazyWithF:^NSArray*() {
            return [[[[connectorIndex values] chain] filterCastTo:TRRailLightState.type] toArray];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadState class]) _TRRailroadState_type = [CNClassType classTypeWithCls:[TRRailroadState class]];
}

- (NSArray*)rails {
    return [__lazy_rails get];
}

- (NSArray*)switches {
    return [__lazy_switches get];
}

- (NSArray*)lights {
    return [__lazy_lights get];
}

- (NSArray*)railsInTile:(GEVec2i)tile {
    return [[[[self rails] chain] filterWhen:^BOOL(TRRail* _) {
        return geVec2iIsEqualTo(((TRRail*)(_)).tile, tile);
    }] toArray];
}

- (BOOL)canAddRail:(TRRail*)rail {
    return [((TRRailroadConnectorContent*)([_connectorIndex applyKey:numui4(({
        GEVec2i __tmp__il_alrp0tile = rail.tile;
        ((unsigned int)((__tmp__il_alrp0tile.x + 8192) * 65536 + (__tmp__il_alrp0tile.y + 8192) * 4 + [TRRailForm value:rail.form].start));
    }))])) canAddRail:rail] && [((TRRailroadConnectorContent*)([_connectorIndex applyKey:numui4(({
        GEVec2i __tmp__il_blrp0tile = rail.tile;
        ((unsigned int)((__tmp__il_blrp0tile.x + 8192) * 65536 + (__tmp__il_blrp0tile.y + 8192) * 4 + [TRRailForm value:rail.form].end));
    }))])) canAddRail:rail];
}

- (TRRail*)activeRailForTile:(GEVec2i)tile connector:(TRRailConnectorR)connector {
    return [[((TRRailroadConnectorContent*)([_connectorIndex applyKey:numui4(((unsigned int)((tile.x + 8192) * 65536 + (tile.y + 8192) * 4 + connector)))])) rails] head];
}

- (TRRailPointCorrection)moveWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor forLength:(CGFloat)forLength point:(TRRailPoint)point {
    TRRailPoint p = trRailPointAddX(point, forLength);
    TRRailPointCorrection correction = trRailPointCorrect(p);
    id damage = [self checkDamagesWithObstacleProcessor:obstacleProcessor from:point to:correction.point.x];
    if(damage != nil) {
        id x = damage;
        return TRRailPointCorrectionMake((trRailPointSetX(p, unumf(x))), correction.error + correction.point.x - unumf(x));
    }
    if(eqf(correction.error, 0)) {
        TRRailPointCorrection switchCheckCorrection = trRailPointCorrect((trRailPointAddX(correction.point, 0.5)));
        if(eqf(switchCheckCorrection.error, 0)) return correction;
        TRRail* scActiveRailOpt = [[((TRRailroadConnectorContent*)([_connectorIndex applyKey:numui4(({
            GEVec2i __tmp__il__4t_2llrp0tile = p.tile;
            ((unsigned int)((__tmp__il__4t_2llrp0tile.x + 8192) * 65536 + (__tmp__il__4t_2llrp0tile.y + 8192) * 4 + trRailPointEndConnector(p)));
        }))])) rails] head];
        if(scActiveRailOpt == nil) return correction;
        if(((TRRail*)(nonnil(scActiveRailOpt))).form != p.form) {
            if(!(obstacleProcessor([TRObstacle obstacleWithObstacleType:TRObstacleType_switch point:correction.point]))) return TRRailPointCorrectionMake((trRailPointAddX(switchCheckCorrection.point, -0.5)), switchCheckCorrection.error);
        }
        return correction;
    }
    TRRailConnectorR connector = trRailPointEndConnector(p);
    TRRailroadConnectorContent* connectorDesc = [_connectorIndex applyKey:numui4(({
        GEVec2i __tmp__il__6rp0tile = p.tile;
        ((unsigned int)((__tmp__il__6rp0tile.x + 8192) * 65536 + (__tmp__il__6rp0tile.y + 8192) * 4 + connector));
    }))];
    TRRail* activeRailOpt = [[connectorDesc rails] head];
    if(activeRailOpt == nil) {
        return correction;
    } else {
        if(((TRRail*)(activeRailOpt)).form != p.form) {
            obstacleProcessor([TRObstacle obstacleWithObstacleType:TRObstacleType_switch point:correction.point]);
            return correction;
        }
    }
    if(!([connectorDesc isGreen])) {
        if(!(obstacleProcessor([TRObstacle obstacleWithObstacleType:TRObstacleType_light point:correction.point]))) return correction;
    }
    GEVec2i nextTile = [[TRRailConnector value:connector] nextTile:p.tile];
    TRRailConnectorR otherSideConnector = [[TRRailConnector value:connector] otherSideConnector];
    TRRail* nextRail = [self activeRailForTile:nextTile connector:otherSideConnector];
    if(nextRail == nil) {
        obstacleProcessor([TRObstacle obstacleWithObstacleType:TRObstacleType_end point:correction.point]);
        return correction;
    } else {
        TRRailFormR form = ((TRRail*)(nextRail)).form;
        return [self moveWithObstacleProcessor:obstacleProcessor forLength:correction.error point:trRailPointApplyTileFormXBack(nextTile, form, 0.0, [TRRailForm value:form].end == otherSideConnector)];
    }
}

- (id)checkDamagesWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor from:(TRRailPoint)from to:(CGFloat)to {
    if([_damages.points isEmpty] || eqf(from.x, to)) return nil;
    {
        NSArray* opt = [[_damages index] applyKey:tuple((wrap(GEVec2i, from.tile)), [TRRailForm value:from.form])];
        if(opt != nil) {
            BOOL(^on)(id) = ^BOOL(id x) {
                return !(obstacleProcessor(([TRObstacle obstacleWithObstacleType:TRObstacleType_damage point:trRailPointSetX(from, unumf(x))])));
            };
            CGFloat len = [TRRailForm value:from.form].length;
            if(from.back) return [[[[[((NSArray*)(opt)) chain] filterWhen:^BOOL(id _) {
                return floatBetween(unumf(_), len - to, len - from.x);
            }] sortDesc] mapF:^id(id _) {
                return numf(len - unumf(_));
            }] findWhere:on];
            else return [[[[((NSArray*)(opt)) chain] filterWhen:^BOOL(id _) {
                return floatBetween(unumf(_), from.x, to);
            }] sort] findWhere:on];
        } else {
            return nil;
        }
    }
}

- (TRRailroadConnectorContent*)contentInTile:(GEVec2i)tile connector:(TRRailConnectorR)connector {
    return [_connectorIndex applyKey:numui4(((unsigned int)((tile.x + 8192) * 65536 + (tile.y + 8192) * 4 + connector)))];
}

- (BOOL)isLockedRail:(TRRail*)rail {
    return !([({
        NSArray* __tmp_0l = [[_damages index] applyKey:tuple((wrap(GEVec2i, rail.tile)), [TRRailForm value:rail.form])];
        ((__tmp_0l != nil) ? ((NSArray*)(__tmp_0l)) : ((NSArray*)((@[]))));
    }) isEmpty]);
}

- (BOOL)isConnectedA:(TRRailPoint)a b:(TRRailPoint)b {
    return [self _isConnectedA:a b:b checked:[CNMHashSet hashSet]];
}

- (BOOL)_isConnectedA:(TRRailPoint)a b:(TRRailPoint)b checked:(id<CNMSet>)checked {
    if(geVec2iIsEqualTo(a.tile, b.tile) && a.form == b.form) {
        return YES;
    } else {
        TRRailConnectorR endConnector = trRailPointEndConnector(a);
        GEVec2i ot = [[TRRailConnector value:endConnector] nextTile:a.tile];
        TRRailConnectorR oc = [[TRRailConnector value:endConnector] otherSideConnector];
        unsigned int ik = ((unsigned int)((ot.x + 8192) * 65536 + (ot.y + 8192) * 4 + oc));
        if([checked containsItem:numui4(ik)]) {
            return NO;
        } else {
            [checked appendItem:numui4(ik)];
            return [[((TRRailroadConnectorContent*)([_connectorIndex applyKey:numui4(ik)])) rails] existsWhere:^BOOL(TRRail* rail) {
                TRRailPoint na = trRailPointApplyTileFormXBack(ot, ((TRRail*)(rail)).form, 0.0, [TRRailForm value:((TRRail*)(rail)).form].end == oc);
                return [self _isConnectedA:na b:b checked:checked];
            }];
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RailroadState(%lu, %@, %@)", (unsigned long)_id, _connectorIndex, _damages];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRRailroadState class]])) return NO;
    TRRailroadState* o = ((TRRailroadState*)(to));
    return _id == o.id && [_connectorIndex isEqual:o.connectorIndex] && [_damages isEqual:o.damages];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + _id;
    hash = hash * 31 + [_connectorIndex hash];
    hash = hash * 31 + [_damages hash];
    return hash;
}

- (CNClassType*)type {
    return [TRRailroadState type];
}

+ (CNClassType*)type {
    return _TRRailroadState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

