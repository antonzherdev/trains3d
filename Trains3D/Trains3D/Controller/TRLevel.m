#import "TRLevel.h"

@implementation TRLevel{
    EGISize _mapSize;
    NSArray* _cities;
    TRRailroad* _railroad;
}
@synthesize mapSize = _mapSize;
@synthesize cities = _cities;
@synthesize railroad = _railroad;

+ (id)levelWithMapSize:(EGISize)mapSize {
    return [[TRLevel alloc] initWithMapSize:mapSize];
}

- (id)initWithMapSize:(EGISize)mapSize {
    self = [super init];
    if(self) {
        _mapSize = mapSize;
        _cities = [self appendNextCityToCities:[self appendNextCityToCities:(@[])]];
        _railroad = [TRRailroad railroadWithMapSize:_mapSize];
    }
    
    return self;
}

- (NSArray*)appendNextCityToCities:(NSArray*)cities {
    EGIPoint tile = uval(EGIPoint, [[egMapSsoPartialTiles(_mapSize) exclude:[cities map:^id(TRCity* _) {
        return val(_.tile);
    }]] randomItem]);
    return [cities arrayByAddingObject:[TRCity cityWithColor:[TRColor values][[cities count]] tile:tile angle:[self randomCityDirectionForTile:tile]]];
}

- (NSInteger)randomCityDirectionForTile:(EGIPoint)tile {
    EGIRect cut = egMapSsoTileCut(_mapSize, tile);
    return unumi([[(@[@0, @90, @180, @270]) filter:^BOOL(id angle_) {
        NSInteger angle = unumi(angle_);
        return angle == 0 && cut.right == 0 && cut.bottom == 0 || angle == 90 && cut.left == 0 && cut.bottom == 0 || angle == 180 && cut.left == 0 && cut.top == 0 || angle == 270 && cut.right == 0 && cut.top == 0;
    }] randomItem]);
}

- (void)createNewCity {
    _cities = [self appendNextCityToCities:_cities];
}

@end


