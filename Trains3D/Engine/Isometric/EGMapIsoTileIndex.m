#import "EGMapIsoTileIndex.h"

@implementation EGMapSsoTileIndex{
    EGISize _mapSize;
    NSMutableDictionary* _map;
}
@synthesize mapSize = _mapSize;

+ (id)mapSsoTileIndexWithMapSize:(EGISize)mapSize {
    return [[EGMapSsoTileIndex alloc] initWithMapSize:mapSize];
}

- (id)initWithMapSize:(EGISize)mapSize {
    self = [super init];
    if(self) {
        _mapSize = mapSize;
        _map = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (id)lookupWithDef:(id(^)())def forTile:(EGIPoint)forTile {
    NSNumber * forKey = [self getNumberForTile:forTile];
    id v = [_map objectForKey:forKey];
    if(v == nil) {
        v = def();
        [_map setObject:v forKey:forKey];
    }
    return v;
}

- (NSNumber *)getNumberForTile:(EGIPoint)tile {
    return numi((tile.x + tile.y)*(_mapSize.width + _mapSize.height + 1) + tile.y - tile.x);
}

- (id)lookupForTile:(EGIPoint)forTile {
    NSNumber * forKey = [self getNumberForTile:forTile];
    id v = [_map objectForKey:forKey];
    return v == nil ? [CNOption none] : v;
}

- (id)setObject:(id)object forTile:(EGIPoint)forTile {
    [_map setObject:object forKey:[self getNumberForTile:forTile]];
    return object;
}

- (NSArray*)values {
    return [[_map objectEnumerator] allObjects];
}

- (void)clear {
    [_map removeAllObjects];
}

@end


