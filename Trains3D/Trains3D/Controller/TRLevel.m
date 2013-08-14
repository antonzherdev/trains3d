#import "TRLevel.h"

#import "EGMapIso.h"
#import "TRCity.h"
#import "TRTypes.h"
#import "TRRailroad.h"
#import "TRRailPoint.h"
#import "TRTrain.h"
#import "TRScore.h"
@implementation TRLevelRules{
    EGSizeI _mapSize;
    TRScoreRules* _scoreRules;
}
@synthesize mapSize = _mapSize;
@synthesize scoreRules = _scoreRules;

+ (id)levelRulesWithMapSize:(EGSizeI)mapSize scoreRules:(TRScoreRules*)scoreRules {
    return [[TRLevelRules alloc] initWithMapSize:mapSize scoreRules:scoreRules];
}

- (id)initWithMapSize:(EGSizeI)mapSize scoreRules:(TRScoreRules*)scoreRules {
    self = [super init];
    if(self) {
        _mapSize = mapSize;
        _scoreRules = scoreRules;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelRules* o = ((TRLevelRules*)other);
    return EGSizeIEq(self.mapSize, o.mapSize) && [self.scoreRules isEqual:o.scoreRules];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGSizeIHash(self.mapSize);
    hash = hash * 31 + [self.scoreRules hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"mapSize=%@", EGSizeIDescription(self.mapSize)];
    [description appendFormat:@", scoreRules=%@", self.scoreRules];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRLevel{
    TRLevelRules* _rules;
    EGMapSso* _map;
    TRScore* _score;
    TRRailroad* _railroad;
    NSArray* __cities;
    NSArray* __trains;
}
@synthesize rules = _rules;
@synthesize map = _map;
@synthesize score = _score;
@synthesize railroad = _railroad;

+ (id)levelWithRules:(TRLevelRules*)rules {
    return [[TRLevel alloc] initWithRules:rules];
}

- (id)initWithRules:(TRLevelRules*)rules {
    self = [super init];
    if(self) {
        _rules = rules;
        _map = [EGMapSso mapSsoWithSize:_rules.mapSize];
        _score = [TRScore scoreWithRules:_rules.scoreRules];
        _railroad = [TRRailroad railroadWithMap:_map score:_score];
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
    EGPointI tile = uwrap(EGPointI, [[[_map.partialTiles exclude:[cities map:^id(TRCity* _) {
        return wrap(EGPointI, _.tile);
    }]] randomItem] get]);
    TRCity* city = [TRCity cityWithColor:[TRColor values][[cities count]] tile:tile angle:[self randomCityDirectionForTile:tile]];
    [_railroad tryAddRail:[TRRail railWithTile:tile form:city.angle.form]];
    return [cities arrayByAddingObject:city];
}

- (TRCityAngle*)randomCityDirectionForTile:(EGPointI)tile {
    EGRectI cut = [_map cutRectForTile:tile];
    return [[[[TRCityAngle values] filter:^BOOL(TRCityAngle* a) {
        NSInteger angle = a.angle;
        return (angle == 0 && egRectIX2(cut) == 0 && egRectIY2(cut) == 0) || (angle == 90 && cut.x == 0 && egRectIY2(cut) == 0) || (angle == 180 && cut.x == 0 && cut.y == 0) || (angle == 270 && egRectIX2(cut) == 0 && cut.y == 0);
    }] randomItem] get];
}

- (void)createNewCity {
    __cities = [self appendNextCityToCities:__cities];
}

- (void)runTrain:(TRTrain*)train fromCity:(TRCity*)fromCity {
    [train startFromCity:fromCity];
    __trains = [__trains arrayByAddingObject:train];
    [_score runTrain:train];
}

- (void)runSample {
    TRCity* city0 = ((TRCity*)__cities[0]);
    TRCity* city1 = ((TRCity*)__cities[1]);
    [self runTrain:[TRTrain trainWithLevel:self color:city1.color cars:(@[[TRCar car], [TRCar car]]) speed:0.3] fromCity:city0];
    [self runTrain:[TRTrain trainWithLevel:self color:city0.color cars:(@[[TRCar car]]) speed:0.6] fromCity:city1];
}

- (void)updateWithDelta:(double)delta {
    [_score updateWithDelta:delta];
    [__trains forEach:^void(TRTrain* _) {
        [_ updateWithDelta:delta];
    }];
    [self detectCollisions];
}

- (void)tryTurnTheSwitch:(TRSwitch*)theSwitch {
    if(!([self isLockedTheSwitch:theSwitch])) [theSwitch turn];
}

- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch {
    return [[__trains find:^BOOL(TRTrain* _) {
        return [_ isLockedTheSwitch:theSwitch];
    }] isDefined];
}

- (id)cityForTile:(EGPointI)tile {
    return [__cities find:^BOOL(TRCity* _) {
        return EGPointIEq(_.tile, tile);
    }];
}

- (void)arrivedTrain:(TRTrain*)train {
    __trains = [__trains arrayByRemovingObject:train];
    [_score arrivedTrain:train];
}

- (void)detectCollisions {
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"rules=%@", self.rules];
    [description appendString:@">"];
    return description;
}

@end


