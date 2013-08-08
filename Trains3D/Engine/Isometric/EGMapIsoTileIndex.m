#import "EGMapIsoTileIndex.h"

#import "EGMapIso.h"
@implementation EGMapSsoTileIndex{
    EGMapSso* _map;
    id(^_initial)();
    NSMutableDictionary* _index;
    NSInteger _wh;
}
@synthesize map = _map;
@synthesize initial = _initial;

+ (id)mapSsoTileIndexWithMap:(EGMapSso*)map initial:(id(^)())initial {
    return [[EGMapSsoTileIndex alloc] initWithMap:map initial:initial];
}

- (id)initWithMap:(EGMapSso*)map initial:(id(^)())initial {
    self = [super init];
    if(self) {
        _map = map;
        _initial = initial;
        _index = [(@{}) mutableCopy];
        _wh = _map.size.width + _map.size.height + 1;
    }
    
    return self;
}

- (NSInteger)numberForTile:(EGPointI)tile {
    return (tile.x + tile.y) * _wh + tile.y - tile.x;
}

- (id)objectForTile:(EGPointI)tile {
    return [_index objectForKey:numi([self numberForTile:tile]) orUpdateWith:_initial];
}

- (NSArray*)values {
    return [_index values];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMapSsoTileIndex* o = ((EGMapSsoTileIndex*)other);
    return [self.map isEqual:o.map] && [self.initial isEqual:o.initial];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.map hash];
    hash = hash * 31 + [self.initial hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"map=%@", self.map];
    [description appendFormat:@", initial=%@", self.initial];
    [description appendString:@">"];
    return description;
}

@end


