#import "EGMapIsoTileIndex.h"

@implementation EGMapSsoTileIndex{
    EGSizeI _mapSize;
    NSMutableDictionary* _map;
}
@synthesize mapSize = _mapSize;

+ (id)mapSsoTileIndexWithMapSize:(EGSizeI)mapSize {
    return [[EGMapSsoTileIndex alloc] initWithMapSize:mapSize];
}

- (id)initWithMapSize:(EGSizeI)mapSize {
    self = [super init];
    if(self) {
        _mapSize = mapSize;
        _map = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (id)lookupWithDef:(id(^)())def forTile:(EGPointI)forTile {
    NSNumber * forKey = [self getNumberForTile:forTile];
    id v = [_map objectForKey:forKey];
    if(v == nil) {
        v = def();
        [_map setObject:v forKey:forKey];
    }
    return v;
}

- (NSNumber *)getNumberForTile:(EGPointI)tile {
    return numi((tile.x + tile.y)*(_mapSize.width + _mapSize.height + 1) + tile.y - tile.x);
}

- (id)lookupForTile:(EGPointI)forTile {
    NSNumber * forKey = [self getNumberForTile:forTile];
    id v = [_map objectForKey:forKey];
    return v == nil ? [CNOption none] : v;
}

- (id)setObject:(id)object forTile:(EGPointI)forTile {
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


