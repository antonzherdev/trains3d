#import "TRLevel.h"

#import "EGMapIso.h"
#import "TRCity.h"
#import "TRRailroad.h"
#import "TRTrain.h"
@implementation TRLevel{
    EGISize _mapSize;
    NSArray* _cities;
    TRRailroad* _railroad;
    NSArray* _trains;
}
@synthesize mapSize = _mapSize;
@synthesize cities = _cities;
@synthesize railroad = _railroad;
@synthesize trains = _trains;

+ (id)levelWithMapSize:(EGISize)mapSize {
    return [[TRLevel alloc] initWithMapSize:mapSize];
}

- (id)initWithMapSize:(EGISize)mapSize {
    self = [super init];
    if(self) {
        _mapSize = mapSize;
        _cities = [self appendNextCityToCities:[self appendNextCityToCities:(@[])]];
        _railroad = [TRRailroad railroadWithMapSize:_mapSize];
        _trains = (@[]);
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
    return unumi([[(@[@0, @90, @180, @270]) filter:^BOOL(id angle) {
        return unumi(angle) == 0 && cut.right == 0 && cut.bottom == 0 || unumi(angle) == 90 && cut.left == 0 && cut.bottom == 0 || unumi(angle) == 180 && cut.left == 0 && cut.top == 0 || unumi(angle) == 270 && cut.right == 0 && cut.top == 0;
    }] randomItem]);
}

- (void)createNewCity {
    _cities = [self appendNextCityToCities:_cities];
}

- (void)runTrain:(TRTrain*)train fromCity:(TRCity*)fromCity {
    [train startFromCity:fromCity];
    _trains = [_trains arrayByAddingObject:train];
}

- (void)runSample {
    TRCity* city0 = _cities[0];
    TRCity* city1 = _cities[1];
    [self runTrain:[TRTrain trainWithLevel:self color:city1.color cars:(@[[TRCar car], [TRCar car]]) speed:0.3] fromCity:city0];
    [self runTrain:[TRTrain trainWithLevel:self color:city0.color cars:(@[[TRCar car]]) speed:0.3] fromCity:city1];
}

@end


