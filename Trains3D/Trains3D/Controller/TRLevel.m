#import "TRLevel.h"

#import "EGMapIso.h"
#import "TRCity.h"
#import "TRTypes.h"
#import "TRRailroad.h"
#import "TRTrain.h"
@implementation TRLevel{
    EGMapSso* _map;
    TRRailroad* _railroad;
    NSArray* __cities;
    NSArray* __trains;
}
@synthesize map = _map;
@synthesize railroad = _railroad;

+ (id)levelWithMap:(EGMapSso*)map {
    return [[TRLevel alloc] initWithMap:map];
}

- (id)initWithMap:(EGMapSso*)map {
    self = [super init];
    if(self) {
        _map = map;
        _railroad = [TRRailroad railroadWithMap:_map];
        __cities = [self appendNextCityToCities:[self appendNextCityToCities:(@[])]];
        __trains = (@[]);
    }
    
    return self;
}

- (NSArray*)cities {
    return __cities;
}

- (NSArray*)trains {
    return __trains;
}

- (NSArray*)appendNextCityToCities:(NSArray*)cities {
    EGPointI tile = uval(EGPointI, [[[_map.partialTiles exclude:[cities map:^id(TRCity* _) {
        return val(_.tile);
    }]] randomItem] get]);
    TRCity* city = [TRCity cityWithColor:[TRColor values][[cities count]] tile:tile angle:[self randomCityDirectionForTile:tile]];
    [_railroad tryAddRail:[TRRail railWithTile:tile form:city.angle.form]];
    return [cities arrayByAddingObject:city];
}

- (TRCityAngle*)randomCityDirectionForTile:(EGPointI)tile {
    EGRectI cut = [_map cutRectForTile:tile];
    return [[[[TRCityAngle values] filter:^BOOL(TRCityAngle* a) {
        NSInteger angle = a.angle;
        return (angle == 0 && cut.right == 0 && cut.bottom == 0) || (angle == 90 && cut.left == 0 && cut.bottom == 0) || (angle == 180 && cut.left == 0 && cut.top == 0) || (angle == 270 && cut.right == 0 && cut.top == 0);
    }] randomItem] get];
}

- (void)createNewCity {
    __cities = [self appendNextCityToCities:__cities];
}

- (void)runTrain:(TRTrain*)train fromCity:(TRCity*)fromCity {
    [train startFromCity:fromCity];
    __trains = [__trains arrayByAddingObject:train];
}

- (void)runSample {
    TRCity* city0 = ((TRCity*)__cities[0]);
    TRCity* city1 = ((TRCity*)__cities[1]);
    [self runTrain:[TRTrain trainWithLevel:self color:city1.color cars:(@[[TRCar car], [TRCar car]]) speed:0.3] fromCity:city0];
    [self runTrain:[TRTrain trainWithLevel:self color:city0.color cars:(@[[TRCar car]]) speed:0.6] fromCity:city1];
}

- (void)updateWithDelta:(double)delta {
    [__trains forEach:^void(TRTrain* _) {
        [_ updateWithDelta:delta];
    }];
}

- (void)tryTurnTheSwitch:(TRSwitch*)theSwitch {
    if(!([self isLockedTheSwitch:theSwitch])) [theSwitch turn];
}

- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch {
    return [[__trains find:^BOOL(TRTrain* _) {
        return [_ isLockedTheSwitch:theSwitch];
    }] isDefined];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


