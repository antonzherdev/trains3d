#import "TRLevel.h"

#import "TRScore.h"
#import "TRWeather.h"
#import "TRNotification.h"
#import "TRTree.h"
#import "TRRailroad.h"
#import "EGSchedule.h"
#import "TRCollisions.h"
#import "TRCity.h"
#import "TRRailPoint.h"
#import "TRStrings.h"
#import "TRTrain.h"
#import "TRCar.h"
@implementation TRLevelRules{
    GEVec2i _mapSize;
    TRLevelTheme* _theme;
    TRScoreRules* _scoreRules;
    TRWeatherRules* _weatherRules;
    NSUInteger _repairerSpeed;
    NSUInteger _sporadicDamagePeriod;
    id<CNSeq> _events;
}
static ODClassType* _TRLevelRules_type;
@synthesize mapSize = _mapSize;
@synthesize theme = _theme;
@synthesize scoreRules = _scoreRules;
@synthesize weatherRules = _weatherRules;
@synthesize repairerSpeed = _repairerSpeed;
@synthesize sporadicDamagePeriod = _sporadicDamagePeriod;
@synthesize events = _events;

+ (id)levelRulesWithMapSize:(GEVec2i)mapSize theme:(TRLevelTheme*)theme scoreRules:(TRScoreRules*)scoreRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(id<CNSeq>)events {
    return [[TRLevelRules alloc] initWithMapSize:mapSize theme:theme scoreRules:scoreRules weatherRules:weatherRules repairerSpeed:repairerSpeed sporadicDamagePeriod:sporadicDamagePeriod events:events];
}

- (id)initWithMapSize:(GEVec2i)mapSize theme:(TRLevelTheme*)theme scoreRules:(TRScoreRules*)scoreRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(id<CNSeq>)events {
    self = [super init];
    if(self) {
        _mapSize = mapSize;
        _theme = theme;
        _scoreRules = scoreRules;
        _weatherRules = weatherRules;
        _repairerSpeed = repairerSpeed;
        _sporadicDamagePeriod = sporadicDamagePeriod;
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
    return GEVec2iEq(self.mapSize, o.mapSize) && self.theme == o.theme && [self.scoreRules isEqual:o.scoreRules] && [self.weatherRules isEqual:o.weatherRules] && self.repairerSpeed == o.repairerSpeed && self.sporadicDamagePeriod == o.sporadicDamagePeriod && [self.events isEqual:o.events];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.mapSize);
    hash = hash * 31 + [self.theme ordinal];
    hash = hash * 31 + [self.scoreRules hash];
    hash = hash * 31 + [self.weatherRules hash];
    hash = hash * 31 + self.repairerSpeed;
    hash = hash * 31 + self.sporadicDamagePeriod;
    hash = hash * 31 + [self.events hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"mapSize=%@", GEVec2iDescription(self.mapSize)];
    [description appendFormat:@", theme=%@", self.theme];
    [description appendFormat:@", scoreRules=%@", self.scoreRules];
    [description appendFormat:@", weatherRules=%@", self.weatherRules];
    [description appendFormat:@", repairerSpeed=%lu", (unsigned long)self.repairerSpeed];
    [description appendFormat:@", sporadicDamagePeriod=%lu", (unsigned long)self.sporadicDamagePeriod];
    [description appendFormat:@", events=%@", self.events];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRLevel{
    NSUInteger _number;
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
    CNLazy* __lazy_dynamicWorld;
    NSMutableArray* __dyingTrains;
    CGFloat __timeToNextDamage;
    CGFloat _looseCounter;
    BOOL __resultSent;
    NSUInteger __crashCounter;
    id __help;
    id __result;
    BOOL _rate;
}
static NSInteger _TRLevel_trainComingPeriod = 10;
static CNNotificationHandle* _TRLevel_buildCityNotification;
static CNNotificationHandle* _TRLevel_prepareToRunTrainNotification;
static CNNotificationHandle* _TRLevel_expectedTrainNotification;
static CNNotificationHandle* _TRLevel_runTrainNotification;
static CNNotificationHandle* _TRLevel_crashNotification;
static CNNotificationHandle* _TRLevel_knockDownNotification;
static CNNotificationHandle* _TRLevel_damageNotification;
static CNNotificationHandle* _TRLevel_sporadicDamageNotification;
static CNNotificationHandle* _TRLevel_runRepairerNotification;
static CNNotificationHandle* _TRLevel_winNotification;
static ODClassType* _TRLevel_type;
@synthesize number = _number;
@synthesize rules = _rules;
@synthesize map = _map;
@synthesize notifications = _notifications;
@synthesize score = _score;
@synthesize weather = _weather;
@synthesize forest = _forest;
@synthesize railroad = _railroad;
@synthesize schedule = _schedule;
@synthesize collisionWorld = _collisionWorld;
@synthesize rate = _rate;

+ (id)levelWithNumber:(NSUInteger)number rules:(TRLevelRules*)rules {
    return [[TRLevel alloc] initWithNumber:number rules:rules];
}

- (id)initWithNumber:(NSUInteger)number rules:(TRLevelRules*)rules {
    self = [super init];
    __weak TRLevel* _weakSelf = self;
    if(self) {
        _number = number;
        _rules = rules;
        _map = [EGMapSso mapSsoWithSize:_rules.mapSize];
        _notifications = [TRNotifications notifications];
        _score = [TRScore scoreWithRules:_rules.scoreRules notifications:_notifications];
        _weather = [TRWeather weatherWithRules:_rules.weatherRules];
        _forest = [TRForest forestWithMap:_map rules:_rules.theme.forestRules weather:_weather];
        _railroad = [TRRailroad railroadWithMap:_map score:_score forest:_forest];
        __cities = [NSMutableArray mutableArray];
        _schedule = ^EGSchedule*() {
            EGSchedule* schedule = [EGSchedule schedule];
            __block CGFloat time = 0.0;
            __weak TRLevel* ws = self;
            [_rules.events forEach:^void(CNTuple* t) {
                void(^f)(TRLevel*) = ((CNTuple*)(t)).b;
                time += unumf(((CNTuple*)(t)).a);
                [schedule scheduleAfter:time event:^void() {
                    f(ws);
                }];
            }];
            [CNLog applyText:[NSString stringWithFormat:@"Schedule for level %lu is %f seconds", (unsigned long)_number, time]];
            return schedule;
        }();
        __trains = (@[]);
        __repairer = [CNOption none];
        _collisionWorld = [TRTrainsCollisionWorld trainsCollisionWorldWithMap:_map];
        __lazy_dynamicWorld = [CNLazy lazyWithF:^TRTrainsDynamicWorld*() {
            return [TRTrainsDynamicWorld trainsDynamicWorldWithLevel:_weakSelf];
        }];
        __dyingTrains = [NSMutableArray mutableArray];
        __timeToNextDamage = odFloatRndMinMax(_rules.sporadicDamagePeriod * 0.75, _rules.sporadicDamagePeriod * 1.25);
        _looseCounter = 0.0;
        __resultSent = NO;
        __crashCounter = 0;
        __help = [CNOption none];
        __result = [CNOption none];
        _rate = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevel_type = [ODClassType classTypeWithCls:[TRLevel class]];
    _TRLevel_buildCityNotification = [CNNotificationHandle notificationHandleWithName:@"buildCityNotification"];
    _TRLevel_prepareToRunTrainNotification = [CNNotificationHandle notificationHandleWithName:@"prepateToRunTrainNotification"];
    _TRLevel_expectedTrainNotification = [CNNotificationHandle notificationHandleWithName:@"expectedTrainNotification"];
    _TRLevel_runTrainNotification = [CNNotificationHandle notificationHandleWithName:@"runTrainNotification"];
    _TRLevel_crashNotification = [CNNotificationHandle notificationHandleWithName:@"Trains crashed"];
    _TRLevel_knockDownNotification = [CNNotificationHandle notificationHandleWithName:@"Knock down crashed"];
    _TRLevel_damageNotification = [CNNotificationHandle notificationHandleWithName:@"damageNotification"];
    _TRLevel_sporadicDamageNotification = [CNNotificationHandle notificationHandleWithName:@"sporadicDamageNotification"];
    _TRLevel_runRepairerNotification = [CNNotificationHandle notificationHandleWithName:@"runRepairerNotification"];
    _TRLevel_winNotification = [CNNotificationHandle notificationHandleWithName:@"Level was passed"];
}

- (TRTrainsDynamicWorld*)dynamicWorld {
    return [__lazy_dynamicWorld get];
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

- (void)createNewCity {
    CNTuple* c = [self rndCityTimeAtt:0];
    [self createCityWithTile:uwrap(GEVec2i, c.a) direction:c.b];
}

- (BOOL)hasCityInTile:(GEVec2i)tile {
    return [[self cities] existsWhere:^BOOL(TRCity* _) {
        return GEVec2iEq(((TRCity*)(_)).tile, tile);
    }];
}

- (CNTuple*)rndCityTimeAtt:(NSInteger)att {
    GEVec2i tile = uwrap(GEVec2i, [[[[_map.partialTiles chain] exclude:[[[self cities] chain] map:^id(TRCity* _) {
        return wrap(GEVec2i, ((TRCity*)(_)).tile);
    }]] randomItem] get]);
    TRCityAngle* dir = [self randomCityDirectionForTile:tile];
    GEVec2i nextTile = [[dir out] nextTile:tile];
    if(att > 30) {
        return tuple(wrap(GEVec2i, tile), dir);
    } else {
        if([_map isRightTile:tile]) {
            return [self rndCityTimeAtt:att + 1];
        } else {
            if([[[[TRRailConnector values] chain] filter:^BOOL(TRRailConnector* _) {
    return !(_ == [[dir out] otherSideConnector]);
}] allConfirm:^BOOL(TRRailConnector* connector) {
    return [[_railroad contentInTile:nextTile connector:connector] isKindOfClass:[TRSwitch class]];
}]) {
                return [self rndCityTimeAtt:att + 1];
            } else {
                if([_map isTopTile:tile] && [self hasCityInTile:geVec2iApplyVec2(geVec2iAddVec2(tile, ((dir.form == TRRailForm.leftRight) ? GEVec2Make(-1.0, -1.0) : GEVec2Make(1.0, 1.0))))]) return [self rndCityTimeAtt:att + 1];
                else return tuple(wrap(GEVec2i, tile), dir);
            }
        }
    }
}

- (void)createCityWithTile:(GEVec2i)tile direction:(TRCityAngle*)direction {
    TRCity* city = [TRCity cityWithColor:[TRCityColor values][[[self cities] count]] tile:tile angle:direction];
    [_forest cutDownTile:tile];
    [_railroad addRail:[TRRail railWithTile:tile form:city.angle.form]];
    [__cities appendItem:city];
    [[self dynamicWorld] addCity:city];
    [_TRLevel_buildCityNotification postData:city];
    if([__cities count] > 2) [_notifications notifyNotification:[TRStr.Loc cityBuilt]];
}

- (TRCityAngle*)randomCityDirectionForTile:(GEVec2i)tile {
    EGMapTileCutState cut = [_map cutStateForTile:tile];
    return [[[[[TRCityAngle values] chain] filter:^BOOL(TRCityAngle* a) {
        NSInteger angle = ((TRCityAngle*)(a)).angle;
        return (angle == 0 && cut.x2 == 0 && cut.y2 == 0) || (angle == 90 && cut.x == 0 && cut.y2 == 0) || (angle == 180 && cut.x == 0 && cut.y == 0) || (angle == 270 && cut.x2 == 0 && cut.y == 0);
    }] randomItem] get];
}

- (void)runTrain:(TRTrain*)train fromCity:(TRCity*)fromCity {
    fromCity.expectedTrain = train;
    __weak TRLevel* ws = self;
    __weak TRCity* fs = fromCity;
    fromCity.expectedTrainCounter = [[EGCounter applyLength:((CGFloat)(_TRLevel_trainComingPeriod)) finish:^void() {
        [train startFromCity:fs];
        [ws addTrain:train];
    }] onTime:0.9 event:^void() {
        [_TRLevel_prepareToRunTrainNotification postData:tuple(train, fs)];
    }];
    [_TRLevel_expectedTrainNotification postData:tuple(train, fromCity)];
}

- (void)addTrain:(TRTrain*)train {
    __trains = [__trains addItem:train];
    [_score runTrain:train];
    [_collisionWorld addTrain:train];
    [[self dynamicWorld] addTrain:train];
    [_TRLevel_runTrainNotification postData:tuple(self, train)];
}

- (void)runTrainWithGenerator:(TRTrainGenerator*)generator {
    id fromCityOpt = [[[__cities chain] filter:^BOOL(TRCity* c) {
        return [((TRCity*)(c)) canRunNewTrain] && !([[self trains] existsWhere:^BOOL(TRTrain* _) {
    return [((TRTrain*)(_)) isInTile:((TRCity*)(c)).tile];
}]);
    }] randomItem];
    if([fromCityOpt isEmpty]) {
        __weak TRLevel* ws = self;
        [_schedule scheduleAfter:1.0 event:^void() {
            [ws runTrainWithGenerator:generator];
        }];
        return ;
    }
    TRCity* fromCity = [fromCityOpt get];
    TRCityColor* color = ((generator.trainType == TRTrainType.crazy) ? TRCityColor.grey : ((TRCity*)([[[[__cities chain] filter:^BOOL(TRCity* _) {
        return !([_ isEqual:fromCity]);
    }] randomItem] get])).color);
    TRTrain* train = [TRTrain trainWithLevel:self trainType:generator.trainType color:color __cars:^id<CNSeq>(TRTrain* _) {
        return [generator generateCarsForTrain:_];
    } speed:[generator generateSpeed]];
    [self runTrain:train fromCity:fromCity];
}

- (void)testRunTrain:(TRTrain*)train fromPoint:(TRRailPoint*)fromPoint {
    [train setHead:fromPoint];
    [self addTrain:train];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_score updateWithDelta:delta];
    [__trains forEach:^void(TRTrain* _) {
        [((TRTrain*)(_)) updateWithDelta:delta];
    }];
    [__dyingTrains forEach:^void(TRTrain* _) {
        [((TRTrain*)(_)) updateWithDelta:delta];
    }];
    [__cities forEach:^void(TRCity* _) {
        [((TRCity*)(_)) updateWithDelta:delta];
    }];
    if(!([[self trains] isEmpty])) [self processCollisions];
    [_railroad updateWithDelta:delta];
    [[self dynamicWorld] updateWithDelta:delta];
    [_schedule updateWithDelta:delta];
    [_weather updateWithDelta:delta];
    [_forest updateWithDelta:delta];
    [__cities forEach:^void(TRCity* city) {
        if([((TRCity*)(city)).expectedTrainCounter isRunning]) {
            if([__trains existsWhere:^BOOL(TRTrain* _) {
    return [((TRTrain*)(_)) isInTile:((TRCity*)(city)).tile];
}]) [((TRCity*)(city)) waitToRunTrain];
        } else {
            if([((TRCity*)(city)) isWaitingToRunTrain]) {
                if(!([__trains existsWhere:^BOOL(TRTrain* _) {
    return [((TRTrain*)(_)) isInTile:((TRCity*)(city)).tile];
}])) [((TRCity*)(city)) resumeTrainRunning];
            }
        }
    }];
    if(_rules.sporadicDamagePeriod > 0) {
        __timeToNextDamage -= delta;
        if(__timeToNextDamage <= 0) {
            [self addSporadicDamage];
            __timeToNextDamage = odFloatRndMinMax(_rules.sporadicDamagePeriod * 0.75, _rules.sporadicDamagePeriod * 1.25);
        }
    }
    if([_score score] < 0) {
        _looseCounter += delta;
        if(_looseCounter > 5 && !(__resultSent)) {
            __resultSent = YES;
            [self lose];
        }
    } else {
        _looseCounter = 0.0;
        if([_schedule isEmpty] && [__trains isEmpty] && [__dyingTrains isEmpty] && [__cities allConfirm:^BOOL(TRCity* _) {
    return [((TRCity*)(_)) canRunNewTrain];
}] && !(__resultSent)) {
            __resultSent = YES;
            [self win];
        }
    }
}

- (void)tryTurnTheSwitch:(TRSwitch*)theSwitch {
    if(!([self isLockedTheSwitch:theSwitch])) [theSwitch turn];
}

- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch {
    return [[__trains findWhere:^BOOL(TRTrain* _) {
        return [((TRTrain*)(_)) isLockedTheSwitch:theSwitch];
    }] isDefined];
}

- (id)cityForTile:(GEVec2i)tile {
    return [__cities findWhere:^BOOL(TRCity* _) {
        return GEVec2iEq(((TRCity*)(_)).tile, tile);
    }];
}

- (void)arrivedTrain:(TRTrain*)train {
    if([[self repairer] containsItem:train]) [_score removeTrain:train];
    else [_score arrivedTrain:train];
    [self removeTrain:train];
}

- (void)processCollisions {
    [[self detectCollisions] forEach:^void(TRCarsCollision* collision) {
        [((TRCarsCollision*)(collision)).cars forEach:^void(TRCar* _) {
            [self doDestroyTrain:((TRCar*)(_)).train];
        }];
        __crashCounter = 2;
        [_TRLevel_crashNotification postData:[[[((TRCarsCollision*)(collision)).cars chain] map:^TRTrain*(TRCar* _) {
            return ((TRCar*)(_)).train;
        }] toArray]];
        __weak TRLevel* ws = self;
        [_schedule scheduleAfter:5.0 event:^void() {
            [ws.railroad addDamageAtPoint:((TRCarsCollision*)(collision)).railPoint];
            [_TRLevel_damageNotification postData:tuple(ws, ((TRCarsCollision*)(collision)).railPoint)];
        }];
    }];
}

- (void)knockDownTrain:(TRTrain*)train {
    if([__trains containsItem:train]) {
        [self doDestroyTrain:train];
        __crashCounter += 1;
        [_TRLevel_knockDownNotification postData:tuple(train, numui(__crashCounter))];
    }
}

- (void)addSporadicDamage {
    [[[_railroad rails] randomItem] forEach:^void(TRRail* rail) {
        TRRailPoint* p = [TRRailPoint railPointWithTile:((TRRail*)(rail)).tile form:((TRRail*)(rail)).form x:odFloatRndMinMax(0.0, ((TRRail*)(rail)).form.length) back:NO];
        TRRailPoint* pp = [_railroad addDamageAtPoint:p];
        [_TRLevel_sporadicDamageNotification postData:tuple(self, pp)];
        [_TRLevel_damageNotification postData:tuple(self, pp)];
    }];
}

- (id<CNSeq>)detectCollisions {
    return [_collisionWorld detect];
}

- (void)destroyTrain:(TRTrain*)train {
    if([__trains containsItem:train]) {
        __crashCounter = 1;
        [_TRLevel_crashNotification postData:(@[train])];
        [self doDestroyTrain:train];
    }
}

- (void)doDestroyTrain:(TRTrain*)train {
    if([__trains containsItem:train]) {
        [_score destroyedTrain:train];
        train.isDying = YES;
        __trains = [__trains subItem:train];
        [_collisionWorld removeTrain:train];
        [__dyingTrains appendItem:train];
        [[self dynamicWorld] dieTrain:train];
        __weak TRLevel* ws = self;
        [_schedule scheduleAfter:5.0 event:^void() {
            [ws removeTrain:train];
        }];
    }
}

- (void)removeTrain:(TRTrain*)train {
    __trains = [__trains subItem:train];
    [_collisionWorld removeTrain:train];
    [[self dynamicWorld] removeTrain:train];
    [__dyingTrains removeItem:train];
    __repairer = [__repairer filterF:^BOOL(TRTrain* _) {
        return !([_ isEqual:train]);
    }];
}

- (void)runRepairerFromCity:(TRCity*)city {
    if([__repairer isEmpty]) {
        [_score repairerCalled];
        TRTrain* train = [TRTrain trainWithLevel:self trainType:TRTrainType.repairer color:TRCityColor.grey __cars:^id<CNSeq>(TRTrain* _) {
            return (@[[TRCar carWithTrain:_ carType:TRCarType.engine]]);
        } speed:_rules.repairerSpeed];
        [self runTrain:train fromCity:city];
        __repairer = [CNOption applyValue:train];
        [_TRLevel_runRepairerNotification postData:self];
    }
}

- (void)fixDamageAtPoint:(TRRailPoint*)point {
    [_railroad fixDamageAtPoint:point];
    [_score damageFixed];
}

- (id)help {
    return __help;
}

- (void)showHelpText:(NSString*)text {
    __help = [CNOption applyValue:[TRHelp helpWithText:text]];
}

- (void)clearHelp {
    __help = [CNOption none];
}

- (id)result {
    return __result;
}

- (void)win {
    __result = [CNOption applyValue:[TRLevelResult levelResultWithWin:YES]];
    [_TRLevel_winNotification postData:self];
}

- (void)lose {
    __result = [CNOption applyValue:[TRLevelResult levelResultWithWin:NO]];
}

- (void)dealloc {
    [CNLog applyText:[NSString stringWithFormat:@"Dealloc level %lu", (unsigned long)_number]];
}

- (void)start {
}

- (void)stop {
}

- (ODClassType*)type {
    return [TRLevel type];
}

+ (NSInteger)trainComingPeriod {
    return _TRLevel_trainComingPeriod;
}

+ (CNNotificationHandle*)buildCityNotification {
    return _TRLevel_buildCityNotification;
}

+ (CNNotificationHandle*)prepareToRunTrainNotification {
    return _TRLevel_prepareToRunTrainNotification;
}

+ (CNNotificationHandle*)expectedTrainNotification {
    return _TRLevel_expectedTrainNotification;
}

+ (CNNotificationHandle*)runTrainNotification {
    return _TRLevel_runTrainNotification;
}

+ (CNNotificationHandle*)crashNotification {
    return _TRLevel_crashNotification;
}

+ (CNNotificationHandle*)knockDownNotification {
    return _TRLevel_knockDownNotification;
}

+ (CNNotificationHandle*)damageNotification {
    return _TRLevel_damageNotification;
}

+ (CNNotificationHandle*)sporadicDamageNotification {
    return _TRLevel_sporadicDamageNotification;
}

+ (CNNotificationHandle*)runRepairerNotification {
    return _TRLevel_runRepairerNotification;
}

+ (CNNotificationHandle*)winNotification {
    return _TRLevel_winNotification;
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
    return self.number == o.number && [self.rules isEqual:o.rules];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.number;
    hash = hash * 31 + [self.rules hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"number=%lu", (unsigned long)self.number];
    [description appendFormat:@", rules=%@", self.rules];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRHelp{
    NSString* _text;
}
static ODClassType* _TRHelp_type;
@synthesize text = _text;

+ (id)helpWithText:(NSString*)text {
    return [[TRHelp alloc] initWithText:text];
}

- (id)initWithText:(NSString*)text {
    self = [super init];
    if(self) _text = text;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRHelp_type = [ODClassType classTypeWithCls:[TRHelp class]];
}

- (ODClassType*)type {
    return [TRHelp type];
}

+ (ODClassType*)type {
    return _TRHelp_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRHelp* o = ((TRHelp*)(other));
    return [self.text isEqual:o.text];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.text hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"text=%@", self.text];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRLevelResult{
    BOOL _win;
}
static ODClassType* _TRLevelResult_type;
@synthesize win = _win;

+ (id)levelResultWithWin:(BOOL)win {
    return [[TRLevelResult alloc] initWithWin:win];
}

- (id)initWithWin:(BOOL)win {
    self = [super init];
    if(self) _win = win;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelResult_type = [ODClassType classTypeWithCls:[TRLevelResult class]];
}

- (ODClassType*)type {
    return [TRLevelResult type];
}

+ (ODClassType*)type {
    return _TRLevelResult_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelResult* o = ((TRLevelResult*)(other));
    return self.win == o.win;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.win;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"win=%d", self.win];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRLevelTheme{
    NSString* _background;
    TRForestRules* _forestRules;
}
static TRLevelTheme* _TRLevelTheme_forest;
static TRLevelTheme* _TRLevelTheme_winter;
static TRLevelTheme* _TRLevelTheme_leafForest;
static TRLevelTheme* _TRLevelTheme_palm;
static NSArray* _TRLevelTheme_values;
@synthesize background = _background;
@synthesize forestRules = _forestRules;

+ (id)levelThemeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name background:(NSString*)background forestRules:(TRForestRules*)forestRules {
    return [[TRLevelTheme alloc] initWithOrdinal:ordinal name:name background:background forestRules:forestRules];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name background:(NSString*)background forestRules:(TRForestRules*)forestRules {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _background = background;
        _forestRules = forestRules;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelTheme_forest = [TRLevelTheme levelThemeWithOrdinal:0 name:@"forest" background:@"Grass.png" forestRules:[TRForestRules forestRulesWithForestType:TRForestType.Pine thickness:2.0]];
    _TRLevelTheme_winter = [TRLevelTheme levelThemeWithOrdinal:1 name:@"winter" background:@"Snow.png" forestRules:[TRForestRules forestRulesWithForestType:TRForestType.SnowPine thickness:2.0]];
    _TRLevelTheme_leafForest = [TRLevelTheme levelThemeWithOrdinal:2 name:@"leafForest" background:@"Grass2.png" forestRules:[TRForestRules forestRulesWithForestType:TRForestType.Leaf thickness:2.0]];
    _TRLevelTheme_palm = [TRLevelTheme levelThemeWithOrdinal:3 name:@"palm" background:@"PalmGrass.png" forestRules:[TRForestRules forestRulesWithForestType:TRForestType.Palm thickness:2.0]];
    _TRLevelTheme_values = (@[_TRLevelTheme_forest, _TRLevelTheme_winter, _TRLevelTheme_leafForest, _TRLevelTheme_palm]);
}

+ (TRLevelTheme*)forest {
    return _TRLevelTheme_forest;
}

+ (TRLevelTheme*)winter {
    return _TRLevelTheme_winter;
}

+ (TRLevelTheme*)leafForest {
    return _TRLevelTheme_leafForest;
}

+ (TRLevelTheme*)palm {
    return _TRLevelTheme_palm;
}

+ (NSArray*)values {
    return _TRLevelTheme_values;
}

@end


