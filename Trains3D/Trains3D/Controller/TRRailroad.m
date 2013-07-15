#import "TRRailroad.h"

#import "EGMap.h"
#import "EGMapIso.h"
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

@end


@implementation TRLight{
    EGPointI _tile;
    TRRailConnector* _connector;
    BOOL _isGreen;
}
@synthesize tile = _tile;
@synthesize connector = _connector;
@synthesize isGreen = _isGreen;

+ (id)lightWithTile:(EGPointI)tile connector:(TRRailConnector*)connector {
    return [[TRLight alloc] initWithTile:tile connector:connector];
}

- (id)initWithTile:(EGPointI)tile connector:(TRRailConnector*)connector {
    self = [super init];
    if(self) {
        _tile = tile;
        _connector = connector;
        _isGreen = YES;
    }
    
    return self;
}

- (void)turn {
    _isGreen = !(_isGreen);
}

@end


@implementation TRRailroad{
    EGMapSso* _map;
    NSArray* __rails;
    NSArray* __switches;
    NSArray* __lights;
    TRRailroadBuilder* _builder;
}
@synthesize map = _map;
@synthesize builder = _builder;

+ (id)railroadWithMap:(EGMapSso*)map {
    return [[TRRailroad alloc] initWithMap:map];
}

- (id)initWithMap:(EGMapSso*)map {
    self = [super init];
    if(self) {
        _map = map;
        __rails = (@[]);
        __switches = (@[]);
        __lights = (@[]);
        _builder = [TRRailroadBuilder railroadBuilderWithRailroad:self];
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
    NSArray* railsInTile = [[self railsInTile:rail.tile] array];
    NSUInteger countsAtStart = [[railsInTile filter:^BOOL(TRRail* _) {
        return [_ hasConnector:rail.form.start];
    }] count];
    NSUInteger countsAtEnd = [[railsInTile filter:^BOOL(TRRail* _) {
        return [_ hasConnector:rail.form.end];
    }] count];
    return countsAtStart < 2 && countsAtEnd < 2;
}

- (CNChain*)railsInTile:(EGPointI)tile {
    return [__rails filter:^BOOL(TRRail* _) {
        return EGPointIEq(_.tile, tile);
    }];
}

- (TRSwitch*)switchInTile:(EGPointI)tile connector:(TRRailConnector*)connector {
    return [[__switches filter:^BOOL(TRSwitch* _) {
        return EGPointIEq(_.tile, tile);
    }] find:^BOOL(TRSwitch* _) {
        return _.connector == connector;
    }];
}

- (BOOL)tryAddRail:(TRRail*)rail {
    if([self canAddRail:rail]) {
        [self maybeBuildSwitchForRail:rail connector:rail.form.start];
        [self maybeBuildSwitchForRail:rail connector:rail.form.end];
        [self maybeBuildLightForRail:rail connector:rail.form.start];
        [self maybeBuildLightForRail:rail connector:rail.form.end];
        __rails = [__rails arrayByAddingObject:rail];
        return YES;
    } else {
        return NO;
    }
}

- (void)maybeBuildSwitchForRail:(TRRail*)rail connector:(TRRailConnector*)connector {
    [[[self railsInTile:rail.tile] filter:^BOOL(TRRail* _) {
        return [_ hasConnector:connector];
    }] forEach:^void(TRRail* otherRail) {
        __switches = [__switches arrayByAddingObject:[TRSwitch switchWithTile:rail.tile connector:connector rail1:otherRail rail2:rail]];
    }];
}

- (void)maybeBuildLightForRail:(TRRail*)rail connector:(TRRailConnector*)connector {
    if([_map isPartialTile:rail.tile] && [_map isFullTile:[connector nextTile:rail.tile]]) __lights = [__lights arrayByAddingObject:[TRLight lightWithTile:rail.tile connector:connector]];
}

- (TRRailPointCorrection)moveForLength:(double)length point:(TRRailPoint)point {
    return [self correctPoint:trRailPointAdd(point, length)];
}

- (TRRail*)activeRailForTile:(EGPointI)tile connector:(TRRailConnector*)connector {
    return [[[self switchInTile:tile connector:connector] map:^TRRail*(TRSwitch* _) {
        return [_ activeRail];
    }] getOrElse:^TRRail*() {
        return [[[self railsInTile:tile] filter:^BOOL(TRRail* _) {
            return [_ hasConnector:connector];
        }] head];
    }];
}

- (TRRailPointCorrection)correctPoint:(TRRailPoint)point {
    TRRailPointCorrection correction = trRailPointCorrect(point);
    if(correction.error == 0) {
        return correction;
    } else {
        TRRailConnector* connector = trRailPointEndConnector(point);
        TRRail* activeRail = [[self activeRailForTile:point.tile connector:connector] get];
        if(activeRail.form.ordinal != point.form) {
            return correction;
        } else {
            EGPointI nextTile = [connector nextTile:point.tile];
            TRRailConnector* otherSideConnector = [connector otherSideConnector];
            TRRail* nextRail = [self activeRailForTile:nextTile connector:otherSideConnector];
            if([nextRail isEmpty]) {
                return correction;
            } else {
                TRRail* nextActiveRail = [nextRail get];
                TRRailForm* form = nextActiveRail.form;
                return [self correctPoint:TRRailPointMake(nextTile, form.ordinal, correction.error, form.end == otherSideConnector)];
            }
        }
    }
}

@end


@implementation TRRailroadBuilder{
    __weak TRRailroad* _railroad;
    TRRail* __rail;
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

- (TRRail*)rail {
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

@end


