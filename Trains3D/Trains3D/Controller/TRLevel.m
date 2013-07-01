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
        _cities = [self appendNextCityToCities:[self appendNextCityToCities:@[]]];
    }
    
    return self;
}

- (NSArray*)appendNextCityToCities:(NSArray*)cities {
    EGMapPoint tile = uval(EGMapPoint, [[egMapSsoPartialTiles(_mapSize) exclude:[cities map:^id(TRCity* _) {
        return val(_.tile);
    }]] randomItem]);
    return [cities arrayByAddingObject:[TRCity cityWithColor:[TRColor values][[cities count]] tile:tile]];
}

- (void)createNewCity {
    _cities = [self appendNextCityToCities:_cities];
}

@end


