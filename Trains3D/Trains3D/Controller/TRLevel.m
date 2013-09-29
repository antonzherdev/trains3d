#import "TRLevel.h"

#import "TRScore.h"
#import "TRTree.h"
#import "TRWeather.h"
#import "TRNotification.h"
#import "TRRailroad.h"
#import "EGSchedule.h"
#import "TRCollisions.h"
#import "TRCity.h"
#import "TRTrain.h"
#import "TRRailPoint.h"
#import "TRCar.h"
@implementation TRLevelRules{
    GEVec2i _mapSize;
    TRScoreRules* _scoreRules;
    TRForestRules* _forestRules;
    TRWeatherRules* _weatherRules;
    NSUInteger _repairerSpeed;
    id<CNSeq> _events;
}
static ODClassType* _TRLevelRules_type;
@synthesize mapSize = _mapSize;
@synthesize scoreRules = _scoreRules;
@synthesize forestRules = _forestRules;
@synthesize weatherRules = _weatherRules;
@synthesize repairerSpeed = _repairerSpeed;
@synthesize events = _events;

+ (id)levelRulesWithMapSize:(GEVec2i)mapSize scoreRules:(TRScoreRules*)scoreRules forestRules:(TRForestRules*)forestRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed events:(id<CNSeq>)events {
    return [[TRLevelRules alloc] initWithMapSize:mapSize scoreRules:scoreRules forestRules:forestRules weatherRules:weatherRules repairerSpeed:repairerSpeed events:events];
}

- (id)initWithMapSize:(GEVec2i)mapSize scoreRules:(TRScoreRules*)scoreRules forestRules:(TRForestRules*)forestRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed events:(id<CNSeq>)events {
    self = [super init];
    if(self) {
        _mapSize = mapSize;
        _scoreRules = scoreRules;
        _forestRules = forestRules;
        _weatherRules = weatherRules;
        _repairerSpeed = repairerSpeed;
        _events = events;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelRules_type = [ODClassType classTypeWithCls:[TRLevelRules class]];
}

- (ODClassType*)type {
    return [TRLevelRules type];
}

+ (ODClassType*)type {
    return _TRLevelRules_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelRules* o = ((TRLevelRules*)(other));
    return GEVec2iEq(self.mapSize, o.mapSize) && [self.scoreRules isEqual:o.scoreRules] && [self.forestRules isEqual:o.forestRules] && [self.weatherRules isEqual:o.weatherRules] && self.repairerSpeed == o.repairerSpeed && [self.events isEqual:o.events];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.mapSize);
    hash = hash * 31 + [self.scoreRules hash];
    hash = hash * 31 + [self.forestRules hash];
    hash = hash * 31 + [self.weatherRules hash];
    hash = hash * 31 + self.repairerSpeed;
    hash = hash * 31 + [self.events hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"mapSize=%@", GEVec2iDescription(self.mapSize)];
    [description appendFormat:@", scoreRules=%@", self.scoreRules];
    [description appendFormat:@", forestRules=%@", self.forestRules];
    [description appendFormat:@", weatherRules=%@", self.weatherRules];
    [description appendFormat:@", repairerSpeed=%li", self.repairerSpeed];
    [description appendFormat:@", events=%@", self.events];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRLevel{
    TRLevelRules* _rules;
    EGMapSso* _map;
    TRNotifications* _notifications;
    TRScore* _score;
    TRWeather* _weather;
    TRForest* _forest;
    TRRailroad* _railroad;
    NSMutableArray* __cities;
    EGSchedule* _schedule;
    id<CNSeq> __trains;
    id __repairer;
    TRTrainsCollisionWorld* _collisionWorld;
    TRTrainsDynamicWorld* _dynamicWorld;
    NSMutableArray* __dyingTrains;
}
static ODClassType* _TRLevel_type;
@synthesize rules = _rules;
@synthesize map = _map;
@synthesize notifications = _notifications;
@synthesize score = _score;
@synthesize weather = _weather;
@synthesize forest = _forest;
@synthesize railroad = _railroad;
@synthesize schedule = _schedule;
@synthesize collisionWorld = _collisionWorld;
@synthesize dynamicWorld = _dynamicWorld;

+ (id)levelWithRules:(TRLevelRules*)rules {
    return [[TRLevel alloc] initWithRules:rules];
}

- (id)initWithRules:(TRLevelRules*)rules {
    self = [super init];
    if(self) {
        _rules = rules;
        _map = [EGMapSso mapSsoWithSize:_rules.mapSize];
        _notifications = [TRNotifications notifications];
        _score = [TRScore scoreWithRules:_rules.scoreRules notifications:_notifications];
        _weather = [TRWeather weatherWithRules:_rules.weatherRules];
        _forest = [TRForest forestWithMap:_map rules:_rules.forestRules weather:_weather];
        _railroad = [TRRailroad railroadWithMap:_map score:_score forest:_forest];
        __cities = [NSMutableArray mutableArray];
        _schedule = [self createSchedule];
        __trains = (@[]);
        __repairer = [CNOption none];
        _collisionWorld = [TRTrainsCollisionWorld trainsCollisionWorld];
        _dynamicWorld = [TRTrainsDynamicWorld trainsDynamicWorld];
        __dyingTrains = [NSMutableArray mutableArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevel_type = [ODClassType classTypeWithCls:[TRLevel class]];
}

- (id<CNSeq>)cities {
    return __cities;
}

- (id<CNSeq>)trains {
    return __trains;
}

- (id)repairer {
    return __repairer;
}

- (id<CNSeq>)dyingTrains {
    return __dyingTrains;
}

- (EGSchedule*)createSchedule {
    EGSchedule* schedule = [EGSchedule schedule];
    [self createNewCity];
    [self createNewCity];
    [_rules.events forEach:^void(CNTuple* t) {
        void(^f)(TRLevel*) = t.b;
        [schedule scheduleAfter:unumf(t.a) event:^void() {
            f(self);
        }];
    }];
    return schedule;
}

- (void)createNewCity {
    GEVec2i tile = uwrap(GEVec2i, [[[[_map.partialTiles chain] exclude:[[[self cities] chain] map:^id(TRCity* _) {
        return wrap(GEVec2i, _.tile);
    }]] randomItem] get]);
    TRCity* city = [TRCity cityWithColor:[TRCityColor values][[[self cities] count]] tile:tile angle:[self randomCityDirectionForTile:tile]];
    [_forest cutDownTile:tile];
    [_railroad addRail:[TRRail railWithTile:tile form:city.angle.form]];
    [__cities appendItem:city];
}

- (TRCityAngle*)randomCityDirectionForTile:(GEVec2i)tile {
    EGMapTileCutState cut = [_map cutStateForTile:tile];
    return ((TRCityAngle*)([[[[[TRCityAngle values] chain] filter:^BOOL(TRCityAngle* a) {
        NSInteger angle = a.angle;
        return (angle == 0 && cut.x2 == 0 && cut.y2 == 0) || (angle == 90 && cut.x == 0 && cut.y2 == 0) || (angle == 180 && cut.x == 0 && cut.y == 0) || (angle == 270 && cut.x2 == 0 && cut.y == 0);
    }] randomItem] get]));
}

- (void)runTrain:(TRTrain*)train fromCity:(TRCity*)fromCity {
    fromCity.expectedTrainCounter = [EGCounter applyLength:3.0 finish:^void() {
        [train startFromCity:fromCity];
        [self addTrain:train];
    }];
}

- (void)addTrain:(TRTrain*)train {
    __trains = [__trains addItem:train];
    [_score runTrain:train];
    [_collisionWorld addTrain:train];
    [_dynamicWorld addTrain:train];
}

- (void)runTrainWithGenerator:(TRTrainGenerator*)generator {
    TRCity* city = ((TRCity*)([[__cities randomItem] get]));
    TRTrain* train = [TRTrain trainWithLevel:self trainType:generator.trainType color:city.color _cars:^id<CNSeq>(TRTrain* _) {
        return [generator generateCarsForTrain:_];
    } speed:[generator generateSpeed]];
    [self runTrain:train fromCity:((TRCity*)([[[[__cities chain] filter:^BOOL(TRCity* _) {
        return !([_ isEqual:city]);
    }] randomItem] get]))];
}

- (void)testRunTrain:(TRTrain*)train fromPoint:(TRRailPoint*)fromPoint {
    [train setHead:fromPoint];
    [self addTrain:train];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_score updateWithDelta:delta];
    [__trains forEach:^void(TRTrain* _) {
        [_ updateWithDelta:delta];
    }];
    [__cities forEach:^void(TRCity* _) {
        [_ updateWithDelta:delta];
    }];
    if(!([[self trains] isEmpty])) [self processCollisions];
    [_dynamicWorld updateWithDelta:delta];
    [_schedule updateWithDelta:delta];
    [_weather updateWithDelta:delta];
    [_forest updateWithDelta:delta];
}

- (void)tryTurnTheSwitch:(TRSwitch*)theSwitch {
    if(!([self isLockedTheSwitch:theSwitch])) [theSwitch turn];
}

- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch {
    return [[__trains findWhere:^BOOL(TRTrain* _) {
        return [_ isLockedTheSwitch:theSwitch];
    }] isDefined];
}

- (id)cityForTile:(GEVec2i)tile {
    return [__cities findWhere:^BOOL(TRCity* _) {
        return GEVec2iEq(_.tile, tile);
    }];
}

- (void)arrivedTrain:(TRTrain*)train {
    [self removeTrain:train];
    [_score arrivedTrain:train];
}

- (void)processCollisions {
    [[self detectCollisions] forEach:^void(TRCarsCollision* collision) {
        [collision.cars forEach:^void(TRCar* _) {
            [self destroyTrain:_.train];
        }];
        [_railroad addDamageAtPoint:collision.railPoint];
    }];
}

- (id<CNSeq>)detectCollisions {
    return [_collisionWorld detect];
}

- (void)destroyTrain:(TRTrain*)train {
    if([__trains containsItem:train]) {
        [_score destroyedTrain:train];
        train.isDying = YES;
        __trains = [__trains subItem:train];
        [_collisionWorld removeTrain:train];
        [__dyingTrains appendItem:train];
        [_dynamicWorld dieTrain:train];
        [_schedule scheduleAfter:5.0 event:^void() {
            [self removeTrain:train];
        }];
    }
}

- (void)removeTrain:(TRTrain*)train {
    __trains = [__trains subItem:train];
    [_collisionWorld removeTrain:train];
    [_dynamicWorld removeTrain:train];
    [__dyingTrains removeItem:train];
    __repairer = [__repairer filterF:^BOOL(TRTrain* _) {
        return !([_ isEqual:train]);
    }];
}

- (void)runRepairerFromCity:(TRCity*)city {
    if([__repairer isEmpty]) {
        TRTrain* train = [TRTrain trainWithLevel:self trainType:TRTrainType.repairer color:TRCityColor.grey _cars:^id<CNSeq>(TRTrain* _) {
            return (@[[TRCar carWithTrain:_ carType:TRCarType.engine]]);
        } speed:_rules.repairerSpeed];
        [self runTrain:train fromCity:city];
        __repairer = [CNOption applyValue:train];
    }
}

- (ODClassType*)type {
    return [TRLevel type];
}

+ (ODClassType*)type {
    return _TRLevel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevel* o = ((TRLevel*)(other));
    return [self.rules isEqual:o.rules];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.rules hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"rules=%@", self.rules];
    [description appendString:@">"];
    return description;
}

@end


