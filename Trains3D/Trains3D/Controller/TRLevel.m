#import "TRLevel.h"

#import "TRScore.h"
#import "TRWeather.h"
#import "TRNotification.h"
#import "TRTree.h"
#import "TRRailroad.h"
#import "TRRailroadBuilder.h"
#import "EGSchedule.h"
#import "TRCollisions.h"
#import "TRCity.h"
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

+ (instancetype)levelRulesWithMapSize:(GEVec2i)mapSize theme:(TRLevelTheme*)theme scoreRules:(TRScoreRules*)scoreRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(id<CNSeq>)events {
    return [[TRLevelRules alloc] initWithMapSize:mapSize theme:theme scoreRules:scoreRules weatherRules:weatherRules repairerSpeed:repairerSpeed sporadicDamagePeriod:sporadicDamagePeriod events:events];
}

- (instancetype)initWithMapSize:(GEVec2i)mapSize theme:(TRLevelTheme*)theme scoreRules:(TRScoreRules*)scoreRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(id<CNSeq>)events {
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
    if(self == [TRLevelRules class]) _TRLevelRules_type = [ODClassType classTypeWithCls:[TRLevelRules class]];
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
    CGFloat _scale;
    EGMapSso* _map;
    TRNotifications* _notifications;
    TRScore* _score;
    TRWeather* _weather;
    TRForest* _forest;
    TRRailroad* _railroad;
    TRRailroadBuilder* _builder;
    NSMutableArray* __cities;
    EGSchedule* _schedule;
    id<CNSeq> __trainActors;
    id __repairer;
    TRTrainsCollisionWorld* _collisionWorld;
    TRTrainsDynamicWorld* _dynamicWorld;
    NSMutableArray* __dyingTrainActors;
    CGFloat __timeToNextDamage;
    CGFloat _looseCounter;
    BOOL __resultSent;
    NSUInteger __crashCounter;
    id __help;
    id __result;
    BOOL _rate;
    NSInteger _slowMotionShop;
    EGCounter* _slowMotionCounter;
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
static CNNotificationHandle* _TRLevel_fixDamageNotification;
static CNNotificationHandle* _TRLevel_winNotification;
static ODClassType* _TRLevel_type;
@synthesize number = _number;
@synthesize rules = _rules;
@synthesize scale = _scale;
@synthesize map = _map;
@synthesize notifications = _notifications;
@synthesize score = _score;
@synthesize weather = _weather;
@synthesize forest = _forest;
@synthesize railroad = _railroad;
@synthesize builder = _builder;
@synthesize schedule = _schedule;
@synthesize collisionWorld = _collisionWorld;
@synthesize dynamicWorld = _dynamicWorld;
@synthesize rate = _rate;
@synthesize slowMotionShop = _slowMotionShop;
@synthesize slowMotionCounter = _slowMotionCounter;

+ (instancetype)levelWithNumber:(NSUInteger)number rules:(TRLevelRules*)rules {
    return [[TRLevel alloc] initWithNumber:number rules:rules];
}

- (instancetype)initWithNumber:(NSUInteger)number rules:(TRLevelRules*)rules {
    self = [super init];
    if(self) {
        _number = number;
        _rules = rules;
        _scale = 1.0;
        _map = [EGMapSso mapSsoWithSize:_rules.mapSize];
        _notifications = [TRNotifications notifications];
        _score = [TRScore scoreWithRules:_rules.scoreRules notifications:_notifications];
        _weather = [TRWeather weatherWithRules:_rules.weatherRules];
        _forest = [TRForest forestWithMap:_map rules:_rules.theme.forestRules weather:_weather];
        _railroad = [TRRailroad railroadWithMap:_map score:_score forest:_forest];
        _builder = [TRRailroadBuilder railroadBuilderWithLevel:self];
        __cities = [NSMutableArray mutableArray];
        _schedule = [EGSchedule schedule];
        __trainActors = (@[]);
        __repairer = [CNOption none];
        _collisionWorld = [TRTrainsCollisionWorld trainsCollisionWorldWithLevel:self].actor;
        _dynamicWorld = [TRTrainsDynamicWorld trainsDynamicWorldWithLevel:self].actor;
        __dyingTrainActors = [NSMutableArray mutableArray];
        __timeToNextDamage = odFloatRndMinMax(_rules.sporadicDamagePeriod * 0.75, _rules.sporadicDamagePeriod * 1.25);
        _looseCounter = 0.0;
        __resultSent = NO;
        __crashCounter = 0;
        __help = [CNOption none];
        __result = [CNOption none];
        _rate = NO;
        _slowMotionShop = 0;
        _slowMotionCounter = [EGEmptyCounter emptyCounter];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevel class]) {
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
        _TRLevel_fixDamageNotification = [CNNotificationHandle notificationHandleWithName:@"fixDamageNotification"];
        _TRLevel_winNotification = [CNNotificationHandle notificationHandleWithName:@"Level was passed"];
    }
}

- (id<CNSeq>)cities {
    return __cities;
}

- (id<CNSeq>)trainActors {
    return __trainActors;
}

- (id)repairer {
    return __repairer;
}

- (void)_init {
    __block CGFloat time = 0.0;
    __weak TRLevel* ws = self;
    [_rules.events forEach:^void(CNTuple* t) {
        void(^f)(TRLevel*) = ((CNTuple*)(t)).b;
        time += unumf(((CNTuple*)(t)).a);
        if(eqf(time, 0)) f(ws);
        else [_schedule scheduleAfter:time event:^void() {
            f(ws);
        }];
    }];
}

- (id<CNSeq>)dyingTrainActors {
    return __dyingTrainActors;
}

- (void)create2Cities {
    GEVec2i cityTile1 = [self createNewCity].tile;
    CNTuple* c = [self rndCityTimeAtt:0 checkF:^BOOL(GEVec2i tile, TRCityAngle* _) {
        return geVec2iLength(geVec2iSubVec2i(tile, cityTile1)) > 2;
    }];
    [self createCityWithTile:uwrap(GEVec2i, c.a) direction:c.b];
}

- (TRCity*)createNewCity {
    CNTuple* c = [self rndCityTimeAtt:0 checkF:^BOOL(GEVec2i _0, TRCityAngle* _1) {
        return YES;
    }];
    return [self createCityWithTile:uwrap(GEVec2i, c.a) direction:c.b];
}

- (BOOL)hasCityInTile:(GEVec2i)tile {
    return [[self cities] existsWhere:^BOOL(TRCity* _) {
        return GEVec2iEq(((TRCity*)(_)).tile, tile);
    }];
}

- (CNTuple*)rndCityTimeAtt:(NSInteger)att checkF:(BOOL(^)(GEVec2i, TRCityAngle*))checkF {
    GEVec2i tile = uwrap(GEVec2i, [[[[_map.partialTiles chain] exclude:[[[self cities] chain] map:^id(TRCity* _) {
        return wrap(GEVec2i, ((TRCity*)(_)).tile);
    }]] randomItem] get]);
    TRCityAngle* dir = [self randomCityDirectionForTile:tile];
    GEVec2i nextTile = [[dir out] nextTile:tile];
    if(att > 30) {
        return tuple(wrap(GEVec2i, tile), dir);
    } else {
        if([[[[TRRailConnector values] chain] filter:^BOOL(TRRailConnector* _) {
    return !(_ == [[dir out] otherSideConnector]);
}] allConfirm:^BOOL(TRRailConnector* connector) {
    return [[_railroad contentInTile:nextTile connector:connector] isKindOfClass:[TRSwitch class]];
}]) {
            return [self rndCityTimeAtt:att + 1 checkF:checkF];
        } else {
            if([[[[dir in] otherSideConnector] neighbours] existsWhere:^BOOL(TRRailConnector* n) {
    return [self hasCityInTile:[((TRRailConnector*)(n)) nextTile:[[dir in] nextTile:tile]]];
}]) {
                return [self rndCityTimeAtt:att + 1 checkF:checkF];
            } else {
                if([_map isRightTile:tile] && ([_map isTopTile:tile] || [_map isBottomTile:tile])) {
                    return [self rndCityTimeAtt:att + 1 checkF:checkF];
                } else {
                    if([_map isLeftTile:tile] && [_map isBottomTile:tile]) {
                        return [self rndCityTimeAtt:att + 1 checkF:checkF];
                    } else {
                        if(!(checkF(tile, dir))) return [self rndCityTimeAtt:att + 1 checkF:checkF];
                        else return tuple(wrap(GEVec2i, tile), dir);
                    }
                }
            }
        }
    }
}

- (TRCity*)createCityWithTile:(GEVec2i)tile direction:(TRCityAngle*)direction {
    TRCity* city = [TRCity cityWithColor:[TRCityColor values][[[self cities] count]] tile:tile angle:direction];
    [_forest cutDownTile:tile];
    [_railroad addRail:[TRRail railWithTile:tile form:city.angle.form]];
    [__cities appendItem:city];
    [_dynamicWorld addCity:city];
    [_TRLevel_buildCityNotification postSender:self data:city];
    if([__cities count] > 2) [_notifications notifyNotification:[TRStr.Loc cityBuilt]];
    return city;
}

- (TRCityAngle*)randomCityDirectionForTile:(GEVec2i)tile {
    EGMapTileCutState cut = [_map cutStateForTile:tile];
    return [[[[[TRCityAngle values] chain] filter:^BOOL(TRCityAngle* a) {
        NSInteger angle = ((TRCityAngle*)(a)).angle;
        return (angle == 0 && cut.x2 == 0 && cut.y2 == 0) || (angle == 90 && cut.x == 0 && cut.y2 == 0) || (angle == 180 && cut.x == 0 && cut.y == 0) || (angle == 270 && cut.x2 == 0 && cut.y == 0);
    }] randomItem] get];
}

- (void)runTrain:(TRTrainActor*)train fromCity:(TRCity*)fromCity {
    fromCity.expectedTrain = train;
    __weak TRLevel* ws = self;
    __weak TRCity* fs = fromCity;
    __weak TRTrainActor* wt = train;
    fromCity.expectedTrainCounter = [[EGCounter applyLength:((CGFloat)(_TRLevel_trainComingPeriod)) finish:^void() {
        [train startFromCity:fs];
        [ws addTrain:wt];
        fs.expectedTrain = nil;
    }] onTime:0.9 event:^void() {
        [_TRLevel_prepareToRunTrainNotification postSender:ws data:tuple(wt, fs)];
    }];
    [_TRLevel_expectedTrainNotification postSender:ws data:tuple(wt, fs)];
}

- (CNFuture*)lockedTiles {
    return [[[__trainActors chain] map:^CNFuture*(TRTrainActor* _) {
        return [((TRTrainActor*)(_)) lockedTiles];
    }] futureF:^id<CNSet>(CNChain* _) {
        return [[_ flat] toSet];
    }];
}

- (void)addTrain:(TRTrainActor*)train {
    __trainActors = [__trainActors addItem:train];
    [_score runTrain:train];
    [_collisionWorld addTrain:train];
    [_dynamicWorld addTrain:train];
    [_TRLevel_runTrainNotification postSender:self data:train];
}

- (void)runTrainWithGenerator:(TRTrainGenerator*)generator {
    [[self lockedTiles] onSuccessF:^void(id<CNSet> lts) {
        id fromCityOpt = [[[__cities chain] filter:^BOOL(TRCity* c) {
            return [((TRCity*)(c)) canRunNewTrain] && !([((id<CNSet>)(lts)) containsItem:wrap(GEVec2i, ((TRCity*)(c)).tile)]);
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
        [self runTrain:[TRTrainActor trainActorWith_train:train] fromCity:fromCity];
    }];
}

- (void)testRunTrain:(TRTrain*)train fromPoint:(TRRailPoint)fromPoint {
    TRTrainActor* act = [TRTrainActor trainActorWith_train:train].actor;
    [act setHead:fromPoint];
    [self addTrain:act];
}

- (void)updateWithDelta:(CGFloat)delta {
    [__trainActors forEach:^void(TRTrainActor* _) {
        [((TRTrainActor*)(_)) updateWithDelta:delta];
    }];
    [__dyingTrainActors forEach:^void(TRTrainActor* _) {
        [((TRTrainActor*)(_)) updateWithDelta:delta];
    }];
    [_score updateWithDelta:delta];
    [__cities forEach:^void(TRCity* _) {
        [((TRCity*)(_)) updateWithDelta:delta];
    }];
    [_railroad updateWithDelta:delta];
    [_builder updateWithDelta:delta];
    [_schedule updateWithDelta:delta];
    [_weather updateWithDelta:delta];
    [_forest updateWithDelta:delta];
    [_slowMotionCounter updateWithDelta:delta];
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
        if([_schedule isEmpty] && [__trainActors isEmpty] && [__dyingTrainActors isEmpty] && [__cities allConfirm:^BOOL(TRCity* _) {
    return [((TRCity*)(_)) canRunNewTrain];
}] && !(__resultSent)) {
            __resultSent = YES;
            [self win];
        }
    }
    if(!([__trainActors isEmpty])) [self processCollisions];
    [_dynamicWorld updateWithDelta:delta];
    [[self lockedTiles] onSuccessF:^void(id<CNSet> lts) {
        [__cities forEach:^void(TRCity* city) {
            if([((TRCity*)(city)).expectedTrainCounter isRunning]) {
                if([((id<CNSet>)(lts)) containsItem:wrap(GEVec2i, ((TRCity*)(city)).tile)]) [((TRCity*)(city)) waitToRunTrain];
            } else {
                if([((TRCity*)(city)) isWaitingToRunTrain]) {
                    if(!([((id<CNSet>)(lts)) containsItem:wrap(GEVec2i, ((TRCity*)(city)).tile)])) [((TRCity*)(city)) resumeTrainRunning];
                }
            }
        }];
    }];
}

- (void)waitForDyingTrains {
}

- (void)tryTurnTheSwitch:(TRSwitch*)theSwitch {
    [[self isLockedTheSwitch:theSwitch] onSuccessF:^void(id locked) {
        if(!(locked)) [theSwitch turn];
    }];
}

- (CNFuture*)isLockedTheSwitch:(TRSwitch*)theSwitch {
    return [[[__trainActors chain] map:^CNFuture*(TRTrainActor* _) {
        return [((TRTrainActor*)(_)) isLockedASwitch:theSwitch];
    }] futureF:^id(CNChain* _) {
        return numb([_ or]);
    }];
}

- (CNFuture*)isLockedRail:(TRRail*)rail {
    return [[[__trainActors chain] map:^CNFuture*(TRTrainActor* _) {
        return [((TRTrainActor*)(_)) isLockedRail:rail];
    }] futureF:^id(CNChain* _) {
        return numb([_ or]);
    }];
}

- (id)cityForTile:(GEVec2i)tile {
    return [__cities findWhere:^BOOL(TRCity* _) {
        return GEVec2iEq(((TRCity*)(_)).tile, tile);
    }];
}

- (void)arrivedTrain:(TRTrainActor*)train {
    if([[self repairer] containsItem:train]) [_score removeTrain:train];
    else [_score arrivedTrain:train];
    [self removeTrain:train];
}

- (void)processCollisions {
    [[self detectCollisions] onSuccessF:^void(id<CNSeq> collisions) {
        [((id<CNSeq>)(collisions)) forEach:^void(TRCarsCollision* collision) {
            [((TRCarsCollision*)(collision)).cars forEach:^void(TRCar* _) {
                [self doDestroyTrain:[TRTrainActor trainActorWith_train:((TRCar*)(_)).train]];
            }];
            __crashCounter = 2;
            [_TRLevel_crashNotification postSender:self data:[[[((TRCarsCollision*)(collision)).cars chain] map:^TRTrain*(TRCar* _) {
                return ((TRCar*)(_)).train;
            }] toArray]];
            __weak TRLevel* ws = self;
            [_schedule scheduleAfter:5.0 event:^void() {
                [ws.railroad addDamageAtPoint:((TRCarsCollision*)(collision)).railPoint];
                [_TRLevel_damageNotification postSender:ws data:wrap(TRRailPoint, ((TRCarsCollision*)(collision)).railPoint)];
            }];
        }];
    }];
}

- (void)knockDownTrain:(TRTrainActor*)train {
    if([__trainActors containsItem:train]) {
        [self doDestroyTrain:train];
        __crashCounter += 1;
        [_TRLevel_knockDownNotification postSender:self data:tuple(train, numui(__crashCounter))];
    }
}

- (void)addSporadicDamage {
    [[[_railroad rails] randomItem] forEach:^void(TRRail* rail) {
        TRRailPoint p = trRailPointApplyTileFormXBack(((TRRail*)(rail)).tile, ((TRRail*)(rail)).form, odFloatRndMinMax(0.0, ((TRRail*)(rail)).form.length), NO);
        TRRailPoint pp = [_railroad addDamageAtPoint:p];
        [_TRLevel_sporadicDamageNotification postSender:self data:wrap(TRRailPoint, pp)];
        [_TRLevel_damageNotification postSender:self data:wrap(TRRailPoint, pp)];
    }];
}

- (CNFuture*)detectCollisions {
    return [_collisionWorld detect];
}

- (void)destroyTrain:(TRTrainActor*)train {
    if([__trainActors containsItem:train]) {
        __crashCounter = 1;
        [_TRLevel_crashNotification postSender:self data:(@[train])];
        [self doDestroyTrain:train];
    }
}

- (void)doDestroyTrain:(TRTrainActor*)train {
    if([__trainActors containsItem:train]) {
        [_score destroyedTrain:train];
        [train die];
        __trainActors = [__trainActors subItem:train];
        [_collisionWorld removeTrain:train];
        [__dyingTrainActors appendItem:train];
        [_dynamicWorld dieTrain:train];
        __weak TRLevel* ws = self;
        [_schedule scheduleAfter:5.0 event:^void() {
            [ws removeTrain:train];
        }];
    }
}

- (void)removeTrain:(TRTrainActor*)train {
    __trainActors = [__trainActors subItem:train];
    [_collisionWorld removeTrain:train];
    [_dynamicWorld removeTrain:train];
    [__dyingTrainActors removeItem:train];
    __repairer = [__repairer filterF:^BOOL(TRTrainActor* _) {
        return !([_ isEqual:train]);
    }];
}

- (void)runRepairerFromCity:(TRCity*)city {
    if([__repairer isEmpty]) {
        [_score repairerCalled];
        TRTrain* train = [TRTrain trainWithLevel:self trainType:TRTrainType.repairer color:TRCityColor.grey __cars:^id<CNSeq>(TRTrain* _) {
            return (@[[TRCar carWithTrain:_ carType:TRCarType.engine]]);
        } speed:_rules.repairerSpeed];
        [self runTrain:[TRTrainActor trainActorWith_train:train] fromCity:city];
        __repairer = [CNOption applyValue:train];
        [_TRLevel_runRepairerNotification postSender:self];
    }
}

- (void)fixDamageAtPoint:(TRRailPoint)point {
    [_railroad fixDamageAtPoint:point];
    [_score damageFixed];
    [_TRLevel_fixDamageNotification postSender:self data:wrap(TRRailPoint, point)];
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
    [_TRLevel_winNotification postSender:self];
}

- (void)lose {
    __result = [CNOption applyValue:[TRLevelResult levelResultWithWin:NO]];
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

+ (CNNotificationHandle*)fixDamageNotification {
    return _TRLevel_fixDamageNotification;
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

+ (instancetype)helpWithText:(NSString*)text {
    return [[TRHelp alloc] initWithText:text];
}

- (instancetype)initWithText:(NSString*)text {
    self = [super init];
    if(self) _text = text;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRHelp class]) _TRHelp_type = [ODClassType classTypeWithCls:[TRHelp class]];
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

+ (instancetype)levelResultWithWin:(BOOL)win {
    return [[TRLevelResult alloc] initWithWin:win];
}

- (instancetype)initWithWin:(BOOL)win {
    self = [super init];
    if(self) _win = win;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelResult class]) _TRLevelResult_type = [ODClassType classTypeWithCls:[TRLevelResult class]];
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
    BOOL _dark;
}
static TRLevelTheme* _TRLevelTheme_forest;
static TRLevelTheme* _TRLevelTheme_winter;
static TRLevelTheme* _TRLevelTheme_leafForest;
static TRLevelTheme* _TRLevelTheme_palm;
static NSArray* _TRLevelTheme_values;
@synthesize background = _background;
@synthesize forestRules = _forestRules;
@synthesize dark = _dark;

+ (instancetype)levelThemeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name background:(NSString*)background forestRules:(TRForestRules*)forestRules dark:(BOOL)dark {
    return [[TRLevelTheme alloc] initWithOrdinal:ordinal name:name background:background forestRules:forestRules dark:dark];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name background:(NSString*)background forestRules:(TRForestRules*)forestRules dark:(BOOL)dark {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _background = background;
        _forestRules = forestRules;
        _dark = dark;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelTheme_forest = [TRLevelTheme levelThemeWithOrdinal:0 name:@"forest" background:@"Grass" forestRules:[TRForestRules forestRulesWithForestType:TRForestType.Pine thickness:2.0] dark:YES];
    _TRLevelTheme_winter = [TRLevelTheme levelThemeWithOrdinal:1 name:@"winter" background:@"Snow" forestRules:[TRForestRules forestRulesWithForestType:TRForestType.SnowPine thickness:2.0] dark:NO];
    _TRLevelTheme_leafForest = [TRLevelTheme levelThemeWithOrdinal:2 name:@"leafForest" background:@"Grass2" forestRules:[TRForestRules forestRulesWithForestType:TRForestType.Leaf thickness:2.0] dark:YES];
    _TRLevelTheme_palm = [TRLevelTheme levelThemeWithOrdinal:3 name:@"palm" background:@"PalmGrass" forestRules:[TRForestRules forestRulesWithForestType:TRForestType.Palm thickness:1.5] dark:YES];
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


