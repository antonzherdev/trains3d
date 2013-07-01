#import "TRLevel.h"

@implementation TRLevel{
    EGMapSize _mapSize;
    NSArray* _cities;
}
@synthesize mapSize = _mapSize;
@synthesize cities = _cities;

+ (id)levelWithMapSize:(EGMapSize)mapSize {
    return [[TRLevel alloc] initWithMapSize:mapSize];
}

- (id)initWithMapSize:(EGMapSize)mapSize {
    self = [super init];
    if(self) {
        _mapSize = mapSize;
        _cities = [self appendNextCityToCities:[self appendNextCityToCities:(@[])]];
    }
    
    return self;
}

- (NSArray*)appendNextCityToCities:(NSArray*)cities {
    EGMapPoint tile = uval(EGMapPoint, [[egMapSsoPartialTiles(_mapSize) exclude:[cities map:^id(TRCity* _) {
        return val(_.tile);
    }]] randomItem]);
    return [cities arrayByAddingObject:[TRCity cityWithColor:[TRColor values][[cities count]] tile:tile angle:[self randomCityDirectionForTile:tile]]];
}

- (NSInteger)randomCityDirectionForTile:(EGMapPoint)tile {
    EGMapRect cut = egMapSsoTileCut(_mapSize, tile);
    return unumi([[(@[@0, @90, @180, @270]) filter:^BOOL(id angle_) {
        NSInteger angle = unumi(angle_);
        return angle == 0 && cut.right == 0 && cut.bottom == 0 || angle == 90 && cut.left == 0 && cut.bottom == 0 || angle == 180 && cut.left == 0 && cut.top == 0 || angle == 270 && cut.right == 0 && cut.top == 0;
    }] randomItem]);
}

- (void)createNewCity {
    _cities = [self appendNextCityToCities:_cities];
}

@end


