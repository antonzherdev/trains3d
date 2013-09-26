#import "TRRailroad.h"

#import "TRRailPoint.h"
#import "EGMapIso.h"
#import "TRScore.h"
@implementation TRRailroadConnectorContent
static ODClassType* _TRRailroadConnectorContent_type;

+ (id)railroadConnectorContent {
    return [[TRRailroadConnectorContent alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRailroadConnectorContent_type = [ODClassType classTypeWithCls:[TRRailroadConnectorContent class]];
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

- (id<CNSeq>)rails {
    @throw @"Method rails is abstract";
}

- (BOOL)isGreen {
    return YES;
}

- (BOOL)isEmpty {
    return NO;
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

+ (id)emptyConnector {
    return [[TREmptyConnector alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TREmptyConnector_type = [ODClassType classTypeWithCls:[TREmptyConnector class]];
    _TREmptyConnector_instance = [TREmptyConnector emptyConnector];
}

- (id<CNSeq>)rails {
    return (@[]);
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return rail;
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

+ (id)railWithTile:(GEVec2i)tile form:(TRRailForm*)form {
    return [[TRRail alloc] initWithTile:tile form:form];
}

- (id)initWithTile:(GEVec2i)tile form:(TRRailForm*)form {
    self = [super init];
    if(self) {
        _tile = tile;
        _form = form;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRail_type = [ODClassType classTypeWithCls:[TRRail class]];
}

- (BOOL)hasConnector:(TRRailConnector*)connector {
    return _form.start == connector || _form.end == connector;
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return [TRSwitch switchWithTile:rail.tile connector:to rail1:self rail2:rail];
}

- (id<CNSeq>)rails {
    return (@[self]);
}

- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector {
    return [TRRailLight railLightWithTile:_tile connector:connector rail:self];
}

- (BOOL)canAddRail:(TRRail*)rail {
    return rail.form != _form;
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
static ODClassType* _TRSwitch_type;
@synthesize tile = _tile;
@synthesize connector = _connector;
@synthesize rail1 = _rail1;
@synthesize rail2 = _rail2;
@synthesize firstActive = _firstActive;

+ (id)switchWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2 {
    return [[TRSwitch alloc] initWithTile:tile connector:connector rail1:rail1 rail2:rail2];
}

- (id)initWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2 {
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
    _TRSwitch_type = [ODClassType classTypeWithCls:[TRSwitch class]];
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

- (id<CNSeq>)rails {
    if(_firstActive) return (@[_rail1, _rail2]);
    else return (@[_rail2, _rail1]);
}

- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector {
    return self;
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


@implementation TRRailLight{
    GEVec2i _tile;
    TRRailConnector* _connector;
    TRRail* _rail;
    BOOL _isGreen;
}
static ODClassType* _TRRailLight_type;
@synthesize tile = _tile;
@synthesize connector = _connector;
@synthesize rail = _rail;
@synthesize isGreen = _isGreen;

+ (id)railLightWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail {
    return [[TRRailLight alloc] initWithTile:tile connector:connector rail:rail];
}

- (id)initWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail {
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
    _TRRailLight_type = [ODClassType classTypeWithCls:[TRRailLight class]];
}

- (void)turn {
    _isGreen = !(_isGreen);
}

- (BOOL)canAddRail:(TRRail*)rail {
    return [_rail canAddRail:rail];
}

- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    return [TRSwitch switchWithTile:_tile connector:to rail1:_rail rail2:rail];
}

- (id<CNSeq>)rails {
    return (@[_rail]);
}

- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector {
    return self;
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


@implementation TRObstacleType
static TRObstacleType* _TRObstacleType_damage;
static TRObstacleType* _TRObstacleType_switch;
static TRObstacleType* _TRObstacleType_light;
static TRObstacleType* _TRObstacleType_end;
static NSArray* _TRObstacleType_values;

+ (id)obstacleTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[TRObstacleType alloc] initWithOrdinal:ordinal name:name];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
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
    TRRailPoint* _point;
}
static ODClassType* _TRObstacle_type;
@synthesize obstacleType = _obstacleType;
@synthesize point = _point;

+ (id)obstacleWithObstacleType:(TRObstacleType*)obstacleType point:(TRRailPoint*)point {
    return [[TRObstacle alloc] initWithObstacleType:obstacleType point:point];
}

- (id)initWithObstacleType:(TRObstacleType*)obstacleType point:(TRRailPoint*)point {
    self = [super init];
    if(self) {
        _obstacleType = obstacleType;
        _point = point;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRObstacle_type = [ODClassType classTypeWithCls:[TRObstacle class]];
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
    return self.obstacleType == o.obstacleType && [self.point isEqual:o.point];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.obstacleType ordinal];
    hash = hash * 31 + [self.point hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"obstacleType=%@", self.obstacleType];
    [description appendFormat:@", point=%@", self.point];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRailroad{
    EGMapSso* _map;
    TRScore* _score;
    id<CNSeq> __rails;
    id<CNSeq> __switches;
    id<CNSeq> __lights;
    TRRailroadBuilder* _builder;
    CNMapDefault* _connectorIndex;
    NSMutableDictionary* _damagesIndex;
    NSMutableArray* __damagesPoints;
    id<CNSeq> __changeListeners;
}
static ODClassType* _TRRailroad_type;
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
        _connectorIndex = [CNMapDefault mapDefaultWithDefaultFunc:^TRRailroadConnectorContent*(CNTuple* _) {
            return TREmptyConnector.instance;
        } map:[NSMutableDictionary mutableDictionary]];
        _damagesIndex = [NSMutableDictionary mutableDictionary];
        __damagesPoints = [NSMutableArray mutableArray];
        __changeListeners = (@[]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRailroad_type = [ODClassType classTypeWithCls:[TRRailroad class]];
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

- (void)addChangeListener:(void(^)())changeListener {
    __changeListeners = [__changeListeners addItem:changeListener];
}

- (BOOL)canAddRail:(TRRail*)rail {
    return [((TRRailroadConnectorContent*)([_connectorIndex applyKey:tuple(wrap(GEVec2i, rail.tile), rail.form.start)])) canAddRail:rail] && [((TRRailroadConnectorContent*)([_connectorIndex applyKey:tuple(wrap(GEVec2i, rail.tile), rail.form.end)])) canAddRail:rail];
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
    [self connectRail:rail to:rail.form.start];
    [self connectRail:rail to:rail.form.end];
    [self buildLightsForTile:rail.tile connector:rail.form.start];
    [self buildLightsForTile:rail.tile connector:rail.form.end];
    [self rebuildArrays];
}

- (TRRailroadConnectorContent*)contentInTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    return ((TRRailroadConnectorContent*)([_connectorIndex applyKey:tuple(wrap(GEVec2i, tile), connector)]));
}

- (void)connectRail:(TRRail*)rail to:(TRRailConnector*)to {
    ((TRRailroadConnectorContent*)([_connectorIndex modifyBy:^TRRailroadConnectorContent*(TRRailroadConnectorContent* _) {
        return [_ connectRail:rail to:to];
    } forKey:tuple(wrap(GEVec2i, rail.tile), to)]));
}

- (void)buildLightsForTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    GEVec2i nextTile = [connector nextTile:tile];
    TRRailConnector* otherSideConnector = [connector otherSideConnector];
    if([_map isFullTile:tile] && [_map isPartialTile:nextTile]) {
        [self buildLightInTile:nextTile connector:otherSideConnector];
    } else {
        if([self isTurnRailInTile:nextTile connector:otherSideConnector]) [self buildLightInTile:nextTile connector:otherSideConnector];
    }
    if([self isTurnRailInTile:tile connector:connector] && [[((TRRailroadConnectorContent*)([_connectorIndex applyKey:tuple(wrap(GEVec2i, nextTile), otherSideConnector)])) rails] count] == 1) [self buildLightInTile:tile connector:connector];
}

- (BOOL)isTurnRailInTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    id<CNSeq> rails = [((TRRailroadConnectorContent*)([_connectorIndex applyKey:tuple(wrap(GEVec2i, tile), connector)])) rails];
    return [rails count] == 1 && ((TRRail*)([rails applyIndex:0])).form.isTurn;
}

- (void)buildLightInTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    ((TRRailroadConnectorContent*)([_connectorIndex modifyBy:^TRRailroadConnectorContent*(TRRailroadConnectorContent* _) {
        return [_ buildLightInConnector:connector];
    } forKey:tuple(wrap(GEVec2i, tile), connector)]));
}

- (void)rebuildArrays {
    __rails = [[[[[_connectorIndex values] chain] flatMap:^id<CNSeq>(TRRailroadConnectorContent* _) {
        return [_ rails];
    }] distinct] toArray];
    __switches = [[[[_connectorIndex values] chain] filter:^BOOL(TRRailroadConnectorContent* _) {
        return [_ isKindOfClass:[TRSwitch class]];
    }] toArray];
    __lights = [[[[_connectorIndex values] chain] filter:^BOOL(TRRailroadConnectorContent* _) {
        return [_ isKindOfClass:[TRRailLight class]];
    }] toArray];
    [__changeListeners forEach:^void(void(^_)()) {
        ((void(^)())(_))();
    }];
}

- (id)activeRailForTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    return [[((TRRailroadConnectorContent*)([_connectorIndex applyKey:tuple(wrap(GEVec2i, tile), connector)])) rails] head];
}

- (TRRailPointCorrection*)moveWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor forLength:(CGFloat)forLength point:(TRRailPoint*)point {
    TRRailPoint* p = [point addX:forLength];
    TRRailPointCorrection* correction = [p correct];
    id damage = [self checkDamagesWithObstacleProcessor:obstacleProcessor from:point to:correction.point.x];
    if([damage isDefined]) {
        CGFloat x = unumf([damage get]);
        return [TRRailPointCorrection railPointCorrectionWithPoint:[p setX:x] error:correction.error + correction.point.x - x];
    }
    if(eqf(correction.error, 0)) return correction;
    TRRailConnector* connector = [p endConnector];
    TRRailroadConnectorContent* connectorDesc = ((TRRailroadConnectorContent*)([_connectorIndex applyKey:tuple(wrap(GEVec2i, p.tile), connector)]));
    id activeRailOpt = [[connectorDesc rails] head];
    if([activeRailOpt isEmpty]) return correction;
    if(!([connectorDesc isGreen])) if(!(obstacleProcessor([TRObstacle obstacleWithObstacleType:TRObstacleType.light point:correction.point]))) return correction;
    if(((TRRail*)([activeRailOpt get])).form != p.form) {
        obstacleProcessor([TRObstacle obstacleWithObstacleType:TRObstacleType.aSwitch point:correction.point]);
        return correction;
    }
    GEVec2i nextTile = [connector nextTile:p.tile];
    TRRailConnector* otherSideConnector = [connector otherSideConnector];
    id nextRail = [self activeRailForTile:nextTile connector:otherSideConnector];
    if([nextRail isEmpty]) {
        obstacleProcessor([TRObstacle obstacleWithObstacleType:TRObstacleType.end point:correction.point]);
        return correction;
    }
    TRRail* nextActiveRail = ((TRRail*)([nextRail get]));
    TRRailForm* form = nextActiveRail.form;
    return [self moveWithObstacleProcessor:obstacleProcessor forLength:correction.error point:[TRRailPoint railPointWithTile:nextTile form:form x:0.0 back:form.end == otherSideConnector]];
}

- (id)checkDamagesWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor from:(TRRailPoint*)from to:(CGFloat)to {
    if(eqf(from.x, to)) return [CNOption none];
    id opt = [_damagesIndex optKey:tuple(wrap(GEVec2i, from.tile), from.form)];
    if([opt isEmpty]) return [CNOption none];
    BOOL(^on)(id) = ^BOOL(id x) {
        return !(obstacleProcessor([TRObstacle obstacleWithObstacleType:TRObstacleType.damage point:[from setX:unumf(x)]]));
    };
    CGFloat len = from.form.length;
    if(from.back) return [[[[[((id<CNSeq>)([opt get])) chain] filter:^BOOL(id _) {
        return floatBetween(unumf(_), len - to, len - from.x);
    }] sortDesc] map:^id(id _) {
        return numf(len - unumf(_));
    }] find:on];
    else return [[[[((id<CNSeq>)([opt get])) chain] filter:^BOOL(id _) {
        return floatBetween(unumf(_), from.x, to);
    }] sort] find:on];
}

- (void)addDamageAtPoint:(TRRailPoint*)point {
    if(point.back) {
        [self addDamageAtPoint:[point invert]];
    } else {
        [_damagesIndex modifyBy:^id(id arr) {
            return [CNOption applyValue:[[arr mapF:^id<CNSeq>(id<CNSeq> _) {
                return [_ addItem:numf(point.x)];
            }] getOrElseF:^id<CNSeq>() {
                return (@[numf(point.x)]);
            }]];
        } forKey:tuple(wrap(GEVec2i, point.tile), point.form)];
        [__damagesPoints appendItem:point];
    }
}

- (void)fixDamageAtPoint:(TRRailPoint*)point {
    if(point.back) {
        [self fixDamageAtPoint:[point invert]];
    } else {
        [_damagesIndex modifyBy:^id(id arrOpt) {
            return [arrOpt mapF:^id<CNSeq>(id<CNSeq> arr) {
                return [[[arr chain] filter:^BOOL(id _) {
                    return !(eqf(unumf(_), point.x));
                }] toArray];
            }];
        } forKey:tuple(wrap(GEVec2i, point.tile), point.form)];
        [__damagesPoints removeItem:point];
    }
}

- (ODClassType*)type {
    return [TRRailroad type];
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
static ODClassType* _TRRailroadBuilder_type;
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

+ (void)initialize {
    [super initialize];
    _TRRailroadBuilder_type = [ODClassType classTypeWithCls:[TRRailroadBuilder class]];
}

- (id)rail {
    return __rail;
}

- (BOOL)tryBuildRail:(TRRail*)rail {
    if([self checkCityTile:rail.tile connector:rail.form.start] && [self checkCityTile:rail.tile connector:rail.form.end] && [_railroad.map isFullTile:rail.tile] && [_railroad canAddRail:rail]) {
        __rail = [CNOption applyValue:rail];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)checkCityTile:(GEVec2i)tile connector:(TRRailConnector*)connector {
    GEVec2i nextTile = [connector nextTile:tile];
    return [_railroad.map isFullTile:nextTile] || !([[_railroad contentInTile:nextTile connector:[connector otherSideConnector]] isEmpty]);
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

- (ODClassType*)type {
    return [TRRailroadBuilder type];
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


