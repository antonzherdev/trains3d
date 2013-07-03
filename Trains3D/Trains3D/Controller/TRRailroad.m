#import "TRRailroad.h"

@implementation TRRail{
    EGMapPoint _tile;
    CGPoint _start;
    CGPoint _end;
}
@synthesize tile = _tile;
@synthesize start = _start;
@synthesize end = _end;

+ (id)railWithTile:(EGMapPoint)tile start:(CGPoint)start end:(CGPoint)end {
    return [[TRRail alloc] initWithTile:tile start:start end:end];
}

- (id)initWithTile:(EGMapPoint)tile start:(CGPoint)start end:(CGPoint)end {
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
    EGMapSize _mapSize;
    NSArray* _rails;
    TRRailroadBuilder* _builder;
}
@synthesize mapSize = _mapSize;
@synthesize rails = _rails;
@synthesize builder = _builder;

+ (id)railroadWithMapSize:(EGMapSize)mapSize {
    return [[TRRailroad alloc] initWithMapSize:mapSize];
}

- (id)initWithMapSize:(EGMapSize)mapSize {
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
        return EGMapPointEq(_.tile, rail.tile);
    }] array];
    NSUInteger countsAtStart = [[railsInTile filter:^BOOL(TRRail* _) {
        return CGPointEq(_.start, rail.start) || CGPointEq(_.end, rail.start);
    }] count];
    NSUInteger countsAtEnd = [[railsInTile filter:^BOOL(TRRail* _) {
        return CGPointEq(_.start, rail.end) || CGPointEq(_.end, rail.end);
    }] count];
    return countsAtStart < 2 && countsAtEnd < 2;
}

- (BOOL)tryAddRail:(TRRail*)rail {
    if([self canAddRail:rail]) {
        _rails = [_rails arrayByAddingObject:rail];
        return YES;
    }
    else {
        return NO;
    }
}

@end


@implementation TRRailroadBuilder{
    __weak TRRailroad* _railroad;
    TRRail* _rail;
}
@synthesize railroad = _railroad;

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
    }
    else {
        return NO;
    }
}

- (void)clear {
    _rail = [CNOption none];
}

- (void)fix {
    [_railroad tryAddRail:_rail];
    _rail = [CNOption none];
}

@end


