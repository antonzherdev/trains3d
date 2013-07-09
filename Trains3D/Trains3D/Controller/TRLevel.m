#import "TRLevel.h"

#import "EGMapIso.h"
#import "TRCity.h"
#import "TRTypes.h"
#import "TRRailroad.h"
#import "TRTrain.h"
@implementation TRLevel{
    EGISize _mapSize;
    TRRailroad* _railroad;
    NSArray* _cities;
    NSArray* _trains;
}
@synthesize mapSize = _mapSize;
@synthesize railroad = _railroad;
@synthesize cities = _cities;
@synthesize trains = _trains;

+ (id)levelWithMapSize:(EGISize)mapSize {
    return [[TRLevel alloc] initWithMapSize:mapSize];
}

- (id)initWithMapSize:(EGISize)mapSize {
    self = [super init];
    if(self) {
        _mapSize = mapSize;
        _railroad = [TRRailroad railroadWithMapSize:_mapSize];
        _cities = [self appendNextCityToCities:[self appendNextCityToCities:(@[])]];
        _trains = (@[]);
    }
    
    return self;
}

- (NSArray*)appendNextCityToCities:(NSArray*)cities {
    EGIPoint tile = uval(EGIPoint, [[egMapSsoPartialTiles(_mapSize) exclude:[cities map:^id(TRCity* _) {
        return val(_.tile);
    }]] randomItem]);
    TRCity* city = [TRCity cityWithColor:[TRColor values][[cities count]] tile:tile angle:[self randomCityDirectionForTile:tile]];
    [_railroad tryAddRail:[TRRail railWithTile:tile form:city.angle.form]];
    return [cities arrayByAddingObject:city];
}

- (TRCityAngle*)randomCityDirectionForTile:(EGIPoint)tile {
    EGIRect cut = egMapSsoTileCut(_mapSize, tile);
    return [[[TRCityAngle values] filter:^BOOL(TRCityAngle* a) {
        NSInteger angle = a.angle;
        return angle == 0 && cut.right == 0 && cut.bottom == 0 || angle == 90 && cut.left == 0 && cut.bottom == 0 || angle == 180 && cut.left == 0 && cut.top == 0 || angle == 270 && cut.right == 0 && cut.top == 0;
    }] randomItem];
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

- (void)updateWithDelta:(CGFloat)delta {
    [_trains forEach:^void(TRTrain* _) {
        [_ updateWithDelta:delta];
    }];
}

@end


