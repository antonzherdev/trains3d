#import "TRRailroad.h"

#import "EGMap.h"
#import "EGMapIso.h"
#import "EGMapIsoTileIndex.h"
#import "TRRailPoint.h"
#import "TRScore.h"
@implementation TRRailroadConnectorContent

+ (id)railroadConnectorContent {
    return [[TRRailroadConnectorContent alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (BOOL)canAddRail:(TRRail*)rail {
    return YES;
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    @throw @"Method connect is abstract";
}

- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector {
    return self;
}

- (NSArray*)rails {
    @throw @"Method rails is abstract";
}

- (BOOL)isGreen {
    return YES;
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
static TRRailroadConnectorContent* _instance;

+ (id)emptyConnector {
    return [[TREmptyConnector alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _instance = [TREmptyConnector emptyConnector];
}

- (NSArray*)rails {
    return (@[]);
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return rail;
}

+ (TRRailroadConnectorContent*)instance {
    return _instance;
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
    EGPointI _tile;
    TRRailForm* _form;
}
@synthesize tile = _tile;
@synthesize form = _form;

+ (id)railWithTile:(EGPointI)tile form:(TRRailForm*)form {
    return [[TRRail alloc] initWithTile:tile form:form];
}

- (id)initWithTile:(EGPointI)tile form:(TRRailForm*)form {
    self = [super init];
    if(self) {
        _tile = tile;
        _form = form;
    }
    
    return self;
}

- (BOOL)hasConnector:(TRRailConnector*)connector {
    return _form.start == connector || _form.end == connector;
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return [TRSwitch switchWithTile:rail.tile connector:to rail1:self rail2:rail];
}

- (NSArray*)rails {
    return (@[self]);
}

- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector {
    return [TRLight lightWithTile:_tile connector:connector rail:self];
}

- (BOOL)canAddRail:(TRRail*)rail {
    return rail.form != _form;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRail* o = ((TRRail*)other);
    return EGPointIEq(self.tile, o.tile) && self.form == o.form;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGPointIHash(self.tile);
    hash = hash * 31 + [self.form ordinal];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tile=%@", EGPointIDescription(self.tile)];
    [description appendFormat:@", form=%@", self.form];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSwitch{
    EGPointI _tile;
    TRRailConnector* _connector;
    TRRail* _rail1;
    TRRail* _rail2;
    BOOL _firstActive;
}
@synthesize tile = _tile;
@synthesize connector = _connector;
@synthesize rail1 = _rail1;
@synthesize rail2 = _rail2;
@synthesize firstActive = _firstActive;

+ (id)switchWithTile:(EGPointI)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2 {
    return [[TRSwitch alloc] initWithTile:tile connector:connector rail1:rail1 rail2:rail2];
}

- (id)initWithTile:(EGPointI)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2 {
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

- (TRRail*)activeRail {
    if(_firstActive) return _rail1;
    else return _rail2;
}

- (void)turn {
    _firstActive = !(_firstActive);
}

- (BOOL)canAddRail:(TRRail*)rail {
    return NO;
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    @throw @"Couldn't add rail to switch";
}

- (NSArray*)rails {
    if(_firstActive) return (@[_rail1, _rail2]);
    else return (@[_rail2, _rail1]);
}

- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector {
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSwitch* o = ((TRSwitch*)other);
    return EGPointIEq(self.tile, o.tile) && self.connector == o.connector && [self.rail1 isEqual:o.rail1] && [self.rail2 isEqual:o.rail2];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGPointIHash(self.tile);
    hash = hash * 31 + [self.connector ordinal];
    hash = hash * 31 + [self.rail1 hash];
    hash = hash * 31 + [self.rail2 hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tile=%@", EGPointIDescription(self.tile)];
    [description appendFormat:@", connector=%@", self.connector];
    [description appendFormat:@", rail1=%@", self.rail1];
    [description appendFormat:@", rail2=%@", self.rail2];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRLight{
    EGPointI _tile;
    TRRailConnector* _connector;
    TRRail* _rail;
    BOOL _isGreen;
}
@synthesize tile = _tile;
@synthesize connector = _connector;
@synthesize rail = _rail;
@synthesize isGreen = _isGreen;

+ (id)lightWithTile:(EGPointI)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail {
    return [[TRLight alloc] initWithTile:tile connector:connector rail:rail];
}

- (id)initWithTile:(EGPointI)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail {
    self = [super init];
    if(self) {
        _tile = tile;
        _connector = connector;
        _rail = rail;
        _isGreen = YES;
    }
    
    return self;
}

- (void)turn {
    _isGreen = !(_isGreen);
}

- (BOOL)canAddRail:(TRRail*)rail {
    return [rail canAddRail:rail];
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return [TRSwitch switchWithTile:_tile connector:to rail1:_rail rail2:rail];
}

- (NSArray*)rails {
    return (@[_rail]);
}

- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector {
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLight* o = ((TRLight*)other);
    return EGPointIEq(self.tile, o.tile) && self.connector == o.connector && [self.rail isEqual:o.rail];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGPointIHash(self.tile);
    hash = hash * 31 + [self.connector ordinal];
    hash = hash * 31 + [self.rail hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tile=%@", EGPointIDescription(self.tile)];
    [description appendFormat:@", connector=%@", self.connector];
    [description appendFormat:@", rail=%@", self.rail];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRailroad{
    EGMapSso* _map;
    TRScore* _score;
    NSArray* __rails;
    NSArray* __switches;
    NSArray* __lights;
    TRRailroadBuilder* _builder;
    EGMapSsoTileIndex* _connectorIndex;
}
@synthesize map = _map;
@synthesize score = _score;
@synthesize builder = _builder;

+ (id)railroadWithMap:(EGMapSso*)map score:(TRScore*)score {
    return [[TRRailroad alloc] initWithMap:map score:score];
}

- (id)initWithMap:(EGMapSso*)map score:(TRScore*)score {
    self = [super init];
    if(self) {
        _map = map;
        _score = score;
        __rails = (@[]);
        __switches = (@[]);
        __lights = (@[]);
        _builder = [TRRailroadBuilder railroadBuilderWithRailroad:self];
        _connectorIndex = [EGMapSsoTileIndex mapSsoTileIndexWithMap:_map initial:^NSMutableDictionary*() {
            return [[[[TRRailConnector values] chain] map:^CNTuple*(TRRailConnector* _) {
                return tuple(_, TREmptyConnector.instance);
            }] toMutableMap];
        }];
    }
    
    return self;
}

- (NSArray*)rails {
    return __rails;
}

- (NSArray*)switches {
    return __switches;
}

- (NSArray*)lights {
    return __lights;
}

- (BOOL)canAddRail:(TRRail*)rail {
    NSMutableDictionary* tileIndex = [_connectorIndex objectForTile:rail.tile];
    return [((TRRailroadConnectorContent*)[[tileIndex optionObjectForKey:rail.form.start] get]) canAddRail:rail] && [((TRRailroadConnectorContent*)[[tileIndex optionObjectForKey:rail.form.end] get]) canAddRail:rail];
}

- (BOOL)tryAddRail:(TRRail*)rail {
    if([self canAddRail:rail]) {
        [self connectRail:rail to:rail.form.start];
        [self connectRail:rail to:rail.form.end];
        [self buildLightsForTile:rail.tile connector:rail.form.start];
        [self buildLightsForTile:rail.tile connector:rail.form.end];
        [self rebuildArrays];
        [_score railBuilt];
        return YES;
    } else {
        return NO;
    }
}

- (id)contentInTile:(EGPointI)tile connector:(TRRailConnector*)connector {
    return [CNOption opt:((TRRailroadConnectorContent*)[[_connectorIndex objectForTile:tile][connector] get])];
}

- (void)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    [[_connectorIndex objectForTile:rail.tile] modifyWith:^id(id _) {
        return [CNOption opt:[((TRRailroadConnectorContent*)[_ get]) connectRail:rail to:to]];
    } forKey:to];
}

- (void)buildLightsForTile:(EGPointI)tile connector:(TRRailConnector*)connector {
    EGPointI nextTile = [connector nextTile:tile];
    TRRailConnector* otherSideConnector = [connector otherSideConnector];
    if([_map isFullTile:tile] && [_map isPartialTile:nextTile]) {
        [self buildLightInTile:nextTile connector:otherSideConnector];
    } else {
        if([self isTurnRailInTile:nextTile connector:otherSideConnector]) [self buildLightInTile:nextTile connector:otherSideConnector];
    }
    if([self isTurnRailInTile:tile connector:connector] && [[((TRRailroadConnectorContent*)[[_connectorIndex objectForTile:nextTile][otherSideConnector] get]) rails] count] == 1) [self buildLightInTile:tile connector:connector];
}

- (BOOL)isTurnRailInTile:(EGPointI)tile connector:(TRRailConnector*)connector {
    NSArray* rails = [((TRRailroadConnectorContent*)[[_connectorIndex objectForTile:tile][connector] get]) rails];
    return [rails count] == 1 && ((TRRail*)rails[0]).form.isTurn;
}

- (void)buildLightInTile:(EGPointI)tile connector:(TRRailConnector*)connector {
    [[_connectorIndex objectForTile:tile] modifyWith:^id(id _) {
        return [CNOption opt:[((TRRailroadConnectorContent*)[_ get]) buildLightInConnector:connector]];
    } forKey:connector];
}

- (void)rebuildArrays {
    NSArray* allObjects = [[[[_connectorIndex values] chain] flatMap:^id<CNIterable>(NSMutableDictionary* _) {
        return [_ values];
    }] toArray];
    __rails = [[[[allObjects chain] flatMap:^NSArray*(TRRailroadConnectorContent* _) {
        return [_ rails];
    }] distinct] toArray];
    __switches = [[[allObjects chain] filter:^BOOL(TRRailroadConnectorContent* _) {
        return [_ isKindOfClass:[TRSwitch class]];
    }] toArray];
    __lights = [[[allObjects chain] filter:^BOOL(TRRailroadConnectorContent* _) {
        return [_ isKindOfClass:[TRLight class]];
    }] toArray];
}

- (TRRailPointCorrection*)moveConsideringLights:(BOOL)consideringLights forLength:(double)forLength point:(TRRailPoint*)point {
    return [self correctConsideringLights:consideringLights point:[point addX:forLength]];
}

- (id)activeRailForTile:(EGPointI)tile connector:(TRRailConnector*)connector {
    return [[((TRRailroadConnectorContent*)[[_connectorIndex objectForTile:tile][connector] get]) rails] head];
}

- (TRRailPointCorrection*)correctConsideringLights:(BOOL)consideringLights point:(TRRailPoint*)point {
    TRRailPointCorrection* correction = [point correct];
    if(eqf(correction.error, 0)) {
        return correction;
    } else {
        TRRailConnector* connector = [point endConnector];
        TRRailroadConnectorContent* connectorDesc = ((TRRailroadConnectorContent*)[[_connectorIndex objectForTile:point.tile][connector] get]);
        id activeRailOpt = [[connectorDesc rails] head];
        if([activeRailOpt isEmpty] || (consideringLights && !([connectorDesc isGreen]))) {
            return correction;
        } else {
            if(((TRRail*)[activeRailOpt get]).form != point.form) {
                return correction;
            } else {
                EGPointI nextTile = [connector nextTile:point.tile];
                TRRailConnector* otherSideConnector = [connector otherSideConnector];
                id nextRail = [self activeRailForTile:nextTile connector:otherSideConnector];
                if([nextRail isEmpty]) {
                    return correction;
                } else {
                    TRRail* nextActiveRail = ((TRRail*)[nextRail get]);
                    TRRailForm* form = nextActiveRail.form;
                    return [self correctConsideringLights:consideringLights point:[TRRailPoint railPointWithTile:nextTile form:form x:correction.error back:form.end == otherSideConnector]];
                }
            }
        }
    }
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailroad* o = ((TRRailroad*)other);
    return [self.map isEqual:o.map] && [self.score isEqual:o.score];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.map hash];
    hash = hash * 31 + [self.score hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"map=%@", self.map];
    [description appendFormat:@", score=%@", self.score];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRailroadBuilder{
    __weak TRRailroad* _railroad;
    id __rail;
}
@synthesize railroad = _railroad;

+ (id)railroadBuilderWithRailroad:(TRRailroad*)railroad {
    return [[TRRailroadBuilder alloc] initWithRailroad:railroad];
}

- (id)initWithRailroad:(TRRailroad*)railroad {
    self = [super init];
    if(self) {
        _railroad = railroad;
        __rail = [CNOption none];
    }
    
    return self;
}

- (id)rail {
    return __rail;
}

- (BOOL)tryBuildRail:(TRRail*)rail {
    if([_railroad canAddRail:rail]) {
        __rail = [CNOption opt:rail];
        return YES;
    } else {
        return NO;
    }
}

- (void)clear {
    __rail = [CNOption none];
}

- (void)fix {
    [__rail forEach:^void(TRRail* r) {
        [_railroad tryAddRail:r];
    }];
    __rail = [CNOption none];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailroadBuilder* o = ((TRRailroadBuilder*)other);
    return [self.railroad isEqual:o.railroad];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.railroad hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"railroad=%@", self.railroad];
    [description appendString:@">"];
    return description;
}

@end


