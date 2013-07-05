#import "TRRailroad.h"

#import "EGMap.h"
@implementation TRRail{
    EGIPoint _tile;
    EGIPoint _start;
    EGIPoint _end;
}
@synthesize tile = _tile;
@synthesize start = _start;
@synthesize end = _end;

+ (id)railWithTile:(EGIPoint)tile start:(EGIPoint)start end:(EGIPoint)end {
    return [[TRRail alloc] initWithTile:tile start:start end:end];
}

- (id)initWithTile:(EGIPoint)tile start:(EGIPoint)start end:(EGIPoint)end {
    self = [super init];
    if(self) {
        _tile = tile;
        _start = start;
        _end = end;
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
    NSArray* railsInTile = [[_rails filter:^BOOL(TRRail* _) {
        return EGIPointEq(_.tile, rail.tile);
    }] array];
    NSUInteger countsAtStart = [[railsInTile filter:^BOOL(TRRail* _) {
        return EGIPointEq(_.start, rail.start) || EGIPointEq(_.end, rail.start);
    }] count];
    NSUInteger countsAtEnd = [[railsInTile filter:^BOOL(TRRail* _) {
        return EGIPointEq(_.start, rail.end) || EGIPointEq(_.end, rail.end);
    }] count];
    return countsAtStart < 2 && countsAtEnd < 2;
}

- (BOOL)tryAddRail:(TRRail*)rail {
    if([self canAddRail:rail]) {
        _rails = [_rails arrayByAddingObject:rail];
        return YES;
    } else return NO;
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
    } else return NO;
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


