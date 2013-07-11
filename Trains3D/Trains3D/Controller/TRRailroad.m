#import "TRRailroad.h"

#import "EGMap.h"
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

@end


@implementation TRRailroad{
    EGISize _mapSize;
    NSArray* _rails;
    TRRailroadBuilder* _builder;
}
@synthesize mapSize = _mapSize;
@synthesize rails = _rails;
@synthesize builder = _builder;

+ (id)railroadWithMapSize:(EGISize)mapSize {
    return [[TRRailroad alloc] initWithMapSize:mapSize];
}

- (id)initWithMapSize:(EGISize)mapSize {
    self = [super init];
    if(self) {
        _mapSize = mapSize;
        _rails = (@[]);
        _builder = [TRRailroadBuilder railroadBuilderWithRailroad:self];
    }
    
    return self;
}

- (BOOL)canAddRail:(TRRail*)rail {
    NSArray* railsInTile = [[self railsInTile:rail.tile] array];
    NSUInteger countsAtStart = [[railsInTile filter:^BOOL(TRRail* _) {
        return _.form.start == rail.form.start || _.form.end == rail.form.start;
    }] count];
    NSUInteger countsAtEnd = [[railsInTile filter:^BOOL(TRRail* _) {
        return _.form.start == rail.form.end || _.form.end == rail.form.end;
    }] count];
    return countsAtStart < 2 && countsAtEnd < 2;
}

- (CNChain*)railsInTile:(EGIPoint)tile {
    return [_rails filter:^BOOL(TRRail* _) {
        return EGIPointEq(_.tile, tile);
    }];
}

- (BOOL)tryAddRail:(TRRail*)rail {
    if([self canAddRail:rail]) {
        _rails = [_rails arrayByAddingObject:rail];
        return YES;
    } else {
        return NO;
    }
}

- (TRRailPointCorrection)moveForLength:(CGFloat)length point:(TRRailPoint)point {
    return [self correctPoint:trRailPointAdd(point, length)];
}

- (TRRailPointCorrection)correctPoint:(TRRailPoint)point {
    TRRailPointCorrection correction = trRailPointCorrect(point);
    if(correction.error == 0) {
        return correction;
    } else {
        TRRailConnector* connector = trRailPointEndConnector(point);
        EGIPoint nextTile = [connector nextTile:point.tile];
        TRRailConnector* otherSideConnector = [connector otherSideConnector];
        NSArray* nextRails = [[[self railsInTile:nextTile] filter:^BOOL(TRRail* _) {
            return _.form.start == otherSideConnector || _.form.end == otherSideConnector;
        }] array];
        if([nextRails count] == 0) {
            return correction;
        } else {
            TRRail* rail = [nextRails head];
            TRRailForm* form = rail.form;
            return [self correctPoint:TRRailPointMake(nextTile, form.ordinal, correction.error, form.end == otherSideConnector)];
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


