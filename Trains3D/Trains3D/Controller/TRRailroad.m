#import "TRRailroad.h"

#import "EGMap.h"
#import "EGMapIso.h"
@implementation TRRail{
    EGIPoint _tile;
    TRRailForm* _form;
}
@synthesize tile = _tile;
@synthesize form = _form;

+ (id)railWithTile:(EGIPoint)tile form:(TRRailForm*)form {
    return [[TRRail alloc] initWithTile:tile form:form];
}

- (id)initWithTile:(EGIPoint)tile form:(TRRailForm*)form {
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
    EGIPoint _tile;
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

+ (id)switchWithTile:(EGIPoint)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2 {
    return [[TRSwitch alloc] initWithTile:tile connector:connector rail1:rail1 rail2:rail2];
}

- (id)initWithTile:(EGIPoint)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2 {
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
    EGIPoint _tile;
    TRRailConnector* _connector;
    BOOL _isGreen;
}
@synthesize tile = _tile;
@synthesize connector = _connector;
@synthesize isGreen = _isGreen;

+ (id)lightWithTile:(EGIPoint)tile connector:(TRRailConnector*)connector {
    return [[TRLight alloc] initWithTile:tile connector:connector];
}

- (id)initWithTile:(EGIPoint)tile connector:(TRRailConnector*)connector {
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
    NSArray* _rails;
    NSArray* _switches;
    NSArray* _lights;
    TRRailroadBuilder* _builder;
}
@synthesize map = _map;
@synthesize rails = _rails;
@synthesize switches = _switches;
@synthesize lights = _lights;
@synthesize builder = _builder;

+ (id)railroadWithMap:(EGMapSso*)map {
    return [[TRRailroad alloc] initWithMap:map];
}

- (id)initWithMap:(EGMapSso*)map {
    self = [super init];
    if(self) {
        _map = map;
        _rails = (@[]);
        _switches = (@[]);
        _lights = (@[]);
        _builder = [TRRailroadBuilder railroadBuilderWithRailroad:self];
    }
    
    return self;
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

- (CNChain*)railsInTile:(EGIPoint)tile {
    return [_rails filter:^BOOL(TRRail* _) {
        return EGIPointEq(_.tile, tile);
    }];
}

- (TRSwitch*)switchInTile:(EGIPoint)tile connector:(TRRailConnector*)connector {
    return [[_switches filter:^BOOL(TRSwitch* _) {
        return EGIPointEq(_.tile, tile);
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
        _rails = [_rails arrayByAddingObject:rail];
        return YES;
    } else {
        return NO;
    }
}

- (void)maybeBuildSwitchForRail:(TRRail*)rail connector:(TRRailConnector*)connector {
    [[[self railsInTile:rail.tile] filter:^BOOL(TRRail* _) {
        return [_ hasConnector:connector];
    }] forEach:^void(TRRail* otherRail) {
        _switches = [_switches arrayByAddingObject:[TRSwitch switchWithTile:rail.tile connector:connector rail1:otherRail rail2:rail]];
    }];
}

- (void)maybeBuildLightForRail:(TRRail*)rail connector:(TRRailConnector*)connector {
}

- (TRRailPointCorrection)moveForLength:(CGFloat)length point:(TRRailPoint)point {
    return [self correctPoint:trRailPointAdd(point, length)];
}

- (TRRail*)activeRailForTile:(EGIPoint)tile connector:(TRRailConnector*)connector {
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
            EGIPoint nextTile = [connector nextTile:point.tile];
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
    TRRail* _rail;
}
@synthesize railroad = _railroad;
@synthesize rail = _rail;

+ (id)railroadBuilderWithRailroad:(TRRailroad*)railroad {
    return [[TRRailroadBuilder alloc] initWithRailroad:railroad];
}

- (id)initWithRailroad:(TRRailroad*)railroad {
    self = [super init];
    if(self) {
        _railroad = railroad;
        _rail = [CNOption none];
    }
    
    return self;
}

- (BOOL)tryBuildRail:(TRRail*)rail {
    if([_railroad canAddRail:rail]) {
        _rail = [CNOption opt:rail];
        return YES;
    } else {
        return NO;
    }
}

- (void)clear {
    _rail = [CNOption none];
}

- (void)fix {
    [_rail forEach:^void(TRRail* r) {
        [_railroad tryAddRail:r];
    }];
    _rail = [CNOption none];
}

@end


