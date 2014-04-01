#import "TRLevel.h"

#import "TRScore.h"
#import "TRWeather.h"
#import "EGSchedule.h"
#import "TRRailroad.h"
#import "ATReact.h"
#import "TRTree.h"
#import "TRRailroadBuilder.h"
#import "TRTrainCollisions.h"
#import "ATObserver.h"
#import "TRTrain.h"
#import "TRCity.h"
#import "TRStrings.h"
#import "TRCar.h"
#import "ATConcurrentQueue.h"
@implementation TRLevelRules
static ODClassType* _TRLevelRules_type;
@synthesize mapSize = _mapSize;
@synthesize theme = _theme;
@synthesize scoreRules = _scoreRules;
@synthesize rewindRules = _rewindRules;
@synthesize weatherRules = _weatherRules;
@synthesize repairerSpeed = _repairerSpeed;
@synthesize sporadicDamagePeriod = _sporadicDamagePeriod;
@synthesize events = _events;

+ (instancetype)levelRulesWithMapSize:(GEVec2i)mapSize theme:(TRLevelTheme*)theme scoreRules:(TRScoreRules*)scoreRules rewindRules:(TRRewindRules)rewindRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(NSArray*)events {
    return [[TRLevelRules alloc] initWithMapSize:mapSize theme:theme scoreRules:scoreRules rewindRules:rewindRules weatherRules:weatherRules repairerSpeed:repairerSpeed sporadicDamagePeriod:sporadicDamagePeriod events:events];
}

- (instancetype)initWithMapSize:(GEVec2i)mapSize theme:(TRLevelTheme*)theme scoreRules:(TRScoreRules*)scoreRules rewindRules:(TRRewindRules)rewindRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(NSArray*)events {
    self = [super init];
    if(self) {
        _mapSize = mapSize;
        _theme = theme;
        _scoreRules = scoreRules;
        _rewindRules = rewindRules;
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
    return GEVec2iEq(self.mapSize, o.mapSize) && self.theme == o.theme && [self.scoreRules isEqual:o.scoreRules] && TRRewindRulesEq(self.rewindRules, o.rewindRules) && [self.weatherRules isEqual:o.weatherRules] && self.repairerSpeed == o.repairerSpeed && self.sporadicDamagePeriod == o.sporadicDamagePeriod && [self.events isEqual:o.events];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.mapSize);
    hash = hash * 31 + [self.theme ordinal];
    hash = hash * 31 + [self.scoreRules hash];
    hash = hash * 31 + TRRewindRulesHash(self.rewindRules);
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
    [description appendFormat:@", rewindRules=%@", TRRewindRulesDescription(self.rewindRules)];
    [description appendFormat:@", weatherRules=%@", self.weatherRules];
    [description appendFormat:@", repairerSpeed=%lu", (unsigned long)self.repairerSpeed];
    [description appendFormat:@", sporadicDamagePeriod=%lu", (unsigned long)self.sporadicDamagePeriod];
    [description appendFormat:@", events=%@", self.events];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRLevelState
static ODClassType* _TRLevelState_type;
@synthesize time = _time;
@synthesize seedPosition = _seedPosition;
@synthesize schedule = _schedule;
@synthesize railroad = _railroad;
@synthesize cities = _cities;
@synthesize trains = _trains;
@synthesize dyingTrains = _dyingTrains;
@synthesize score = _score;
@synthesize trees = _trees;
@synthesize timeToNextDamage = _timeToNextDamage;
@synthesize generators = _generators;

+ (instancetype)levelStateWithTime:(CGFloat)time seedPosition:(unsigned int)seedPosition schedule:(EGImSchedule*)schedule railroad:(TRRailroadState*)railroad cities:(NSArray*)cities trains:(NSArray*)trains dyingTrains:(NSArray*)dyingTrains score:(TRScoreState*)score trees:(id<CNImIterable>)trees timeToNextDamage:(CGFloat)timeToNextDamage generators:(NSArray*)generators {
    return [[TRLevelState alloc] initWithTime:time seedPosition:seedPosition schedule:schedule railroad:railroad cities:cities trains:trains dyingTrains:dyingTrains score:score trees:trees timeToNextDamage:timeToNextDamage generators:generators];
}

- (instancetype)initWithTime:(CGFloat)time seedPosition:(unsigned int)seedPosition schedule:(EGImSchedule*)schedule railroad:(TRRailroadState*)railroad cities:(NSArray*)cities trains:(NSArray*)trains dyingTrains:(NSArray*)dyingTrains score:(TRScoreState*)score trees:(id<CNImIterable>)trees timeToNextDamage:(CGFloat)timeToNextDamage generators:(NSArray*)generators {
    self = [super init];
    if(self) {
        _time = time;
        _seedPosition = seedPosition;
        _schedule = schedule;
        _railroad = railroad;
        _cities = cities;
        _trains = trains;
        _dyingTrains = dyingTrains;
        _score = score;
        _trees = trees;
        _timeToNextDamage = timeToNextDamage;
        _generators = generators;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelState class]) _TRLevelState_type = [ODClassType classTypeWithCls:[TRLevelState class]];
}

- (ODClassType*)type {
    return [TRLevelState type];
}

+ (ODClassType*)type {
    return _TRLevelState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelState* o = ((TRLevelState*)(other));
    return eqf(self.time, o.time) && self.seedPosition == o.seedPosition && [self.schedule isEqual:o.schedule] && [self.railroad isEqual:o.railroad] && [self.cities isEqual:o.cities] && [self.trains isEqual:o.trains] && [self.dyingTrains isEqual:o.dyingTrains] && [self.score isEqual:o.score] && [self.trees isEqual:o.trees] && eqf(self.timeToNextDamage, o.timeToNextDamage) && [self.generators isEqual:o.generators];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.time);
    hash = hash * 31 + self.seedPosition;
    hash = hash * 31 + [self.schedule hash];
    hash = hash * 31 + [self.railroad hash];
    hash = hash * 31 + [self.cities hash];
    hash = hash * 31 + [self.trains hash];
    hash = hash * 31 + [self.dyingTrains hash];
    hash = hash * 31 + [self.score hash];
    hash = hash * 31 + [self.trees hash];
    hash = hash * 31 + floatHash(self.timeToNextDamage);
    hash = hash * 31 + [self.generators hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"time=%f", self.time];
    [description appendFormat:@", seedPosition=%u", self.seedPosition];
    [description appendFormat:@", schedule=%@", self.schedule];
    [description appendFormat:@", railroad=%@", self.railroad];
    [description appendFormat:@", cities=%@", self.cities];
    [description appendFormat:@", trains=%@", self.trains];
    [description appendFormat:@", dyingTrains=%@", self.dyingTrains];
    [description appendFormat:@", score=%@", self.score];
    [description appendFormat:@", trees=%@", self.trees];
    [description appendFormat:@", timeToNextDamage=%f", self.timeToNextDamage];
    [description appendFormat:@", generators=%@", self.generators];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRewindButton
static ODClassType* _TRRewindButton_type;
@synthesize animation = _animation;
@synthesize position = _position;

+ (instancetype)rewindButton {
    return [[TRRewindButton alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _animation = [[EGCounter applyLength:5.0] finished];
        _position = [ATVar applyInitial:wrap(GEVec2, (GEVec2Make(0.0, 0.0)))];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRewindButton class]) _TRRewindButton_type = [ODClassType classTypeWithCls:[TRRewindButton class]];
}

- (void)showAt:(GEVec2)at {
    [_position setValue:wrap(GEVec2, at)];
    [_animation restart];
}

- (ODClassType*)type {
    return [TRRewindButton type];
}

+ (ODClassType*)type {
    return _TRRewindButton_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRLevel
static NSInteger _TRLevel_trainComingPeriod = 10;
static CNNotificationHandle* _TRLevel_buildCityNotification;
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
@synthesize cameraReserves = _cameraReserves;
@synthesize viewRatio = _viewRatio;
@synthesize rewindButton = _rewindButton;
@synthesize history = _history;
@synthesize map = _map;
@synthesize notifications = _notifications;
@synthesize score = _score;
@synthesize weather = _weather;
@synthesize forest = _forest;
@synthesize railroad = _railroad;
@synthesize builder = _builder;
@synthesize collisions = _collisions;
@synthesize trainIsAboutToRun = _trainIsAboutToRun;
@synthesize trainIsExpected = _trainIsExpected;
@synthesize trainWasAdded = _trainWasAdded;
@synthesize trainWasRemoved = _trainWasRemoved;
@synthesize help = _help;
@synthesize result = _result;
@synthesize rate = _rate;
@synthesize rewindShop = _rewindShop;
@synthesize slowMotionCounter = _slowMotionCounter;

+ (instancetype)levelWithNumber:(NSUInteger)number rules:(TRLevelRules*)rules {
    return [[TRLevel alloc] initWithNumber:number rules:rules];
}

- (instancetype)initWithNumber:(NSUInteger)number rules:(TRLevelRules*)rules {
    self = [super init];
    if(self) {
        _number = number;
        _rules = rules;
        _scale = [ATSlot applyInitial:@1.0];
        _cameraReserves = [ATSlot applyInitial:wrap(EGCameraReserve, (EGCameraReserveMake(0.0, 0.0, 0.1, 0.0)))];
        _viewRatio = [ATSlot applyInitial:@1.6];
        __seed = [CNSeed apply];
        __time = 0.0;
        _rewindButton = [TRRewindButton rewindButton];
        _history = [TRHistory historyWithLevel:self rules:_rules.rewindRules];
        _map = [EGMapSso mapSsoWithSize:_rules.mapSize];
        _notifications = [TRNotifications notifications];
        _score = [TRScore scoreWithRules:_rules.scoreRules notifications:_notifications];
        _weather = [TRWeather weatherWithRules:_rules.weatherRules];
        _forest = [TRForest forestWithMap:_map rules:_rules.theme.forestRules weather:_weather];
        _railroad = [TRRailroad railroadWithMap:_map score:_score forest:_forest];
        _builder = [TRRailroadBuilder railroadBuilderWithLevel:self];
        __cities = (@[]);
        __schedule = [EGMSchedule schedule];
        __trains = (@[]);
        __repairer = [CNOption none];
        _collisions = [TRTrainCollisions trainCollisionsWithLevel:self];
        __dyingTrains = (@[]);
        __timeToNextDamage = odFloatRndMinMax(_rules.sporadicDamagePeriod * 0.75, _rules.sporadicDamagePeriod * 1.25);
        _trainIsAboutToRun = [ATSignal signal];
        _trainIsExpected = [ATSignal signal];
        _trainWasAdded = [ATSignal signal];
        __generators = (@[]);
        _looseCounter = 0.0;
        __resultSent = NO;
        __crashCounter = 0;
        _trainWasRemoved = [ATSignal signal];
        _help = [ATVar applyInitial:[CNOption none]];
        _result = [ATVar applyInitial:[CNOption none]];
        _rate = NO;
        _rewindShop = 0;
        _slowMotionCounter = [EGEmptyCounter emptyCounter];
        if([self class] == [TRLevel class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevel class]) {
        _TRLevel_type = [ODClassType classTypeWithCls:[TRLevel class]];
        _TRLevel_buildCityNotification = [CNNotificationHandle notificationHandleWithName:@"buildCityNotification"];
        _TRLevel_crashNotification = [CNNotificationHandle notificationHandleWithName:@"Trains crashed"];
        _TRLevel_knockDownNotification = [CNNotificationHandle notificationHandleWithName:@"Knock down crashed"];
        _TRLevel_damageNotification = [CNNotificationHandle notificationHandleWithName:@"damageNotification"];
        _TRLevel_sporadicDamageNotification = [CNNotificationHandle notificationHandleWithName:@"sporadicDamageNotification"];
        _TRLevel_runRepairerNotification = [CNNotificationHandle notificationHandleWithName:@"runRepairerNotification"];
        _TRLevel_fixDamageNotification = [CNNotificationHandle notificationHandleWithName:@"fixDamageNotification"];
        _TRLevel_winNotification = [CNNotificationHandle notificationHandleWithName:@"Level was passed"];
    }
}

- (CNFuture*)time {
    return [self promptF:^id() {
        return numf(__time);
    }];
}

- (CNFuture*)state {
    return [self onSuccessFuture:[CNFuture joinA:[_railroad state] b:[[[[__trains chain] append:__dyingTrains] map:^CNFuture*(TRTrain* _) {
        return [((TRTrain*)(_)) state];
    }] future] c:[_forest trees] d:[_score state]] f:^TRLevelState*(CNTuple4* t) {
        TRRailroadState* rrState = ((CNTuple4*)(t)).a;
        NSArray* trains = ((CNTuple4*)(t)).b;
        id<CNImIterable> trees = ((CNTuple4*)(t)).c;
        TRScoreState* scoreState = ((CNTuple4*)(t)).d;
        return [TRLevelState levelStateWithTime:__time seedPosition:[__seed position] schedule:[__schedule imCopy] railroad:rrState cities:[[[__cities chain] map:^TRCityState*(TRCity* _) {
            return [((TRCity*)(_)) state];
        }] toArray] trains:[[[trains chain] filterCast:TRLiveTrainState.type] toArray] dyingTrains:[[[trains chain] filterCast:TRDieTrainState.type] toArray] score:scoreState trees:trees timeToNextDamage:__timeToNextDamage generators:__generators];
    }];
}

- (CNFuture*)restoreState:(TRLevelState*)state {
    return [self futureF:^id() {
        __time = state.time;
        [__seed setPosition:state.seedPosition];
        [_railroad restoreState:state.railroad];
        [__schedule assignImSchedule:state.schedule];
        NSArray* newCities = [[[state.cities chain] map:^TRCity*(TRCityState* _) {
            return [((TRCityState*)(_)).city restoreState:_];
        }] toArray];
        [[[__cities chain] exclude:newCities] forEach:^void(TRCity* _) {
            [_collisions removeCity:_];
        }];
        __cities = newCities;
        NSArray* newTrains = [[[state.trains chain] map:^TRTrain*(TRLiveTrainState* ts) {
            [((TRLiveTrainState*)(ts)).train restoreState:ts];
            return ((TRLiveTrainState*)(ts)).train;
        }] toArray];
        NSArray* newDyingTrains = [[[state.dyingTrains chain] map:^TRTrain*(TRDieTrainState* ts) {
            [((TRDieTrainState*)(ts)).train restoreState:ts];
            return ((TRDieTrainState*)(ts)).train;
        }] toArray];
        [[[[newTrains chain] append:newDyingTrains] exclude:[__trains addSeq:__dyingTrains]] forEach:^void(TRTrain* tr) {
            [_trainWasAdded postData:tr];
        }];
        [[[[__trains chain] append:__dyingTrains] exclude:[newTrains addSeq:newDyingTrains]] forEach:^void(TRTrain* tr) {
            [_collisions removeTrain:tr];
            [_trainWasRemoved postData:tr];
        }];
        [[[__dyingTrains chain] intersect:newTrains] forEach:^void(TRTrain* tr) {
            [_collisions removeTrain:tr];
            [_collisions addTrain:tr state:[[state.trains findWhere:^BOOL(TRLiveTrainState* _) {
                return ((TRLiveTrainState*)(_)).train == tr;
            }] get]];
        }];
        [[[__trains chain] intersect:newDyingTrains] forEach:^void(TRTrain* tr) {
            [_collisions dieTrain:tr dieState:[[state.dyingTrains findWhere:^BOOL(TRDieTrainState* _) {
                return ((TRDieTrainState*)(_)).train == tr;
            }] get]];
        }];
        __trains = newTrains;
        __dyingTrains = newDyingTrains;
        __repairer = [[[newTrains chain] append:newDyingTrains] findWhere:^BOOL(TRTrain* _) {
            return ((TRTrain*)(_)).trainType == TRTrainType.repairer;
        }];
        __timeToNextDamage = state.timeToNextDamage;
        [_score restoreState:state.score];
        [_forest restoreTrees:state.trees];
        [__schedule assignImSchedule:state.schedule];
        __generators = state.generators;
        for(TRTrainGenerator* _ in state.generators) {
            [self _runTrainWithGenerator:_];
        }
        [_rewindButton.animation finish];
        return nil;
    }];
}

- (id<CNSeq>)cities {
    return __cities;
}

- (CNFuture*)trains {
    return [self promptF:^NSArray*() {
        return __trains;
    }];
}

- (id)repairer {
    return __repairer;
}

- (void)_init {
    __block CGFloat time = 0.0;
    __weak TRLevel* ws = self;
    for(CNTuple* t in _rules.events) {
        void(^f)(TRLevel*) = ((CNTuple*)(t)).b;
        time += unumf(((CNTuple*)(t)).a);
        if(eqf(time, 0)) f(ws);
        else [__schedule scheduleAfter:time event:^void() {
            f(ws);
        }];
    }
}

- (CNFuture*)dyingTrains {
    return [self promptF:^NSArray*() {
        return __dyingTrains;
    }];
}

- (CNFuture*)scheduleAfter:(CGFloat)after event:(void(^)())event {
    return [self promptF:^id() {
        [__schedule scheduleAfter:after event:event];
        return nil;
    }];
}

- (CNFuture*)create2Cities {
    return ((CNFuture*)([self onSuccessFuture:[_railroad state] f:^TRCity*(TRRailroadState* rlState) {
        TRCity* city1 = [self doCreateNewCityRlState:rlState aCheck:^BOOL(GEVec2i _0, TRCityAngle* _1) {
            return YES;
        }];
        GEVec2i cityTile1 = city1.tile;
        return [self doCreateNewCityRlState:rlState aCheck:^BOOL(GEVec2i tile, TRCityAngle* _) {
            return geVec2iLength((geVec2iSubVec2i(tile, cityTile1))) > 2;
        }];
    }]));
}

- (CNFuture*)createNewCity {
    return [self onSuccessFuture:[_railroad state] f:^TRCity*(TRRailroadState* rlState) {
        return [self doCreateNewCityRlState:rlState aCheck:^BOOL(GEVec2i _0, TRCityAngle* _1) {
            return YES;
        }];
    }];
}

- (TRCity*)doCreateNewCityRlState:(TRRailroadState*)rlState aCheck:(BOOL(^)(GEVec2i, TRCityAngle*))aCheck {
    CNTuple* c = [self rndCityTimeRlState:rlState aCheck:aCheck];
    return [self createCityWithTile:uwrap(GEVec2i, c.a) direction:c.b];
}

- (BOOL)hasCityInTile:(GEVec2i)tile {
    return [[self cities] existsWhere:^BOOL(TRCity* _) {
        return GEVec2iEq(((TRCity*)(_)).tile, tile);
    }];
}

- (CNTuple*)rndCityTimeRlState:(TRRailroadState*)rlState aCheck:(BOOL(^)(GEVec2i, TRCityAngle*))aCheck {
    CNChain* chain = [[[[[_map.partialTiles chain] exclude:[[[self cities] chain] map:^id(TRCity* _) {
        return wrap(GEVec2i, ((TRCity*)(_)).tile);
    }]] mul:[TRCityAngle values]] filter:^BOOL(CNTuple* t) {
        EGMapTileCutState cut = [_map cutStateForTile:uwrap(GEVec2i, ((CNTuple*)(t)).a)];
        NSInteger angle = ((TRCityAngle*)(((CNTuple*)(t)).b)).angle;
        return (angle == 0 && cut.x2 == 0 && cut.y2 == 0) || (angle == 90 && cut.x == 0 && cut.y2 == 0) || (angle == 180 && cut.x == 0 && cut.y == 0) || (angle == 270 && cut.x2 == 0 && cut.y == 0);
    }] shuffle];
    return [[[chain filter:^BOOL(CNTuple* t) {
        GEVec2i tile = uwrap(GEVec2i, ((CNTuple*)(t)).a);
        TRCityAngle* dir = ((CNTuple*)(t)).b;
        GEVec2i nextTile = [[dir out] nextTile:tile];
        return !([[[[TRRailConnector values] chain] filter:^BOOL(TRRailConnector* _) {
    return !(_ == [[dir out] otherSideConnector]);
}] allConfirm:^BOOL(TRRailConnector* connector) {
    return [[rlState contentInTile:nextTile connector:connector] isKindOfClass:[TRSwitch class]];
}]) && !([[[[dir in] otherSideConnector] neighbours] existsWhere:^BOOL(TRRailConnector* n) {
    return [self hasCityInTile:[((TRRailConnector*)(n)) nextTile:[[dir in] nextTile:tile]]];
}]) && !([_map isRightTile:tile] && ([_map isTopTile:tile] || [_map isBottomTile:tile])) && !([_map isLeftTile:tile] && [_map isBottomTile:tile]) && aCheck(tile, dir);
    }] headOpt] getOrElseF:^CNTuple*() {
        return [chain head];
    }];
}

- (TRCity*)createCityWithTile:(GEVec2i)tile direction:(TRCityAngle*)direction {
    TRCity* city = [TRCity cityWithLevel:self color:[TRCityColor values][[[self cities] count]] tile:tile angle:direction];
    [_forest cutDownTile:tile];
    [_railroad tryAddRail:[TRRail railWithTile:tile form:city.angle.form] free:YES];
    __cities = [__cities addItem:city];
    [_collisions addCity:city];
    [_TRLevel_buildCityNotification postSender:self data:city];
    if([__cities count] > 2) [_notifications notifyNotification:[TRStr.Loc cityBuilt]];
    return city;
}

- (void)runTrain:(TRTrain*)train fromCity:(TRCity*)fromCity {
    [fromCity expectTrain:train];
    [_trainIsExpected postData:tuple(train, fromCity)];
}

- (CNFuture*)lockedTiles {
    return [[[__trains chain] map:^CNFuture*(TRTrain* _) {
        return [((TRTrain*)(_)) lockedTiles];
    }] futureF:^id<CNSet>(CNChain* _) {
        return [[_ flat] toSet];
    }];
}

- (CNFuture*)addTrain:(TRTrain*)train {
    return [self futureF:^id() {
        __trains = [__trains addItem:train];
        [_score runTrain:train];
        [_collisions addTrain:train];
        [_trainWasAdded postData:train];
        return nil;
    }];
}

- (CNFuture*)runTrainWithGenerator:(TRTrainGenerator*)generator {
    __generators = [__generators addItem:generator];
    return [self _runTrainWithGenerator:generator];
}

- (CNFuture*)_runTrainWithGenerator:(TRTrainGenerator*)generator {
    __weak TRLevel* _weakSelf = self;
    return [self lockAndOnSuccessFuture:[self lockedTiles] f:^id(id<CNSet> lts) {
        id fromCityOpt = [[[__cities chain] filter:^BOOL(TRCity* c) {
            return [((TRCity*)(c)) canRunNewTrain] && !([((id<CNSet>)(lts)) containsItem:wrap(GEVec2i, ((TRCity*)(c)).tile)]);
        }] randomItemSeed:__seed];
        __generators = [__generators subItem:generator];
        if([fromCityOpt isEmpty]) {
            [__schedule scheduleAfter:1.0 event:^void() {
                TRLevel* _self = _weakSelf;
                [_self runTrainWithGenerator:generator];
            }];
        } else {
            TRCity* fromCity = [fromCityOpt get];
            TRCityColor* color = ((generator.trainType == TRTrainType.crazy) ? TRCityColor.grey : ((TRCity*)([[[[__cities chain] filter:^BOOL(TRCity* _) {
                return !([_ isEqual:fromCity]);
            }] randomItemSeed:__seed] get])).color);
            TRTrain* train = [TRTrain trainWithLevel:self trainType:generator.trainType color:color carTypes:[generator generateCarTypesSeed:__seed] speed:[generator generateSpeedSeed:__seed]];
            [self runTrain:train fromCity:fromCity];
        }
        return nil;
    }];
}

- (CNFuture*)testRunTrain:(TRTrain*)train fromPoint:(TRRailPoint)fromPoint {
    return [self futureF:^CNFuture*() {
        [train setHead:fromPoint];
        return [self addTrain:train];
    }];
}

- (void)updateWithDelta:(CGFloat)delta {
    [self _updateWithDelta:delta];
}

- (CNFuture*)_updateWithDelta:(CGFloat)delta {
    return [self futureF:^id() {
        if(!(unumb([[_history.rewindCounter isRunning] value]))) {
            __time += delta;
            [[_railroad state] onSuccessF:^void(TRRailroadState* rrState) {
                for(TRTrain* _ in __trains) {
                    [((TRTrain*)(_)) updateWithRrState:rrState delta:delta];
                }
                for(TRTrain* _ in __dyingTrains) {
                    [((TRTrain*)(_)) updateWithRrState:rrState delta:delta];
                }
            }];
            [_score updateWithDelta:delta];
            for(TRCity* _ in __cities) {
                [((TRCity*)(_)) updateWithDelta:delta];
            }
            [_builder updateWithDelta:delta];
            [__schedule updateWithDelta:delta];
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
            if(unumi([_score.money value]) < 0) {
                _looseCounter += delta;
                if(_looseCounter > 5 && !(__resultSent)) {
                    __resultSent = YES;
                    [self lose];
                }
            } else {
                _looseCounter = 0.0;
                if([__schedule isEmpty] && [__trains isEmpty] && [__dyingTrains isEmpty] && [__cities allConfirm:^BOOL(TRCity* _) {
    return [((TRCity*)(_)) canRunNewTrain];
}] && !(__resultSent)) {
                    __resultSent = YES;
                    [self win];
                }
            }
            [_collisions updateWithDelta:delta];
            if([__cities existsWhere:^BOOL(TRCity* _) {
    return unumb([[[((TRCity*)(_)) expectedTrainCounter] isRunning] value]) || [((TRCity*)(_)) isWaitingToRunTrain];
}]) [self checkCitiesLock];
            [_rewindButton.animation updateWithDelta:delta];
        }
        [_history updateWithDelta:delta];
        return nil;
    }];
}

- (CNFuture*)checkCitiesLock {
    return [self onSuccessFuture:[self lockedTiles] f:^id(id<CNSet> lts) {
        for(TRCity* city in __cities) {
            if(unumb([[[((TRCity*)(city)) expectedTrainCounter] isRunning] value])) {
                if([((id<CNSet>)(lts)) containsItem:wrap(GEVec2i, ((TRCity*)(city)).tile)]) [((TRCity*)(city)) waitToRunTrain];
            } else {
                if([((TRCity*)(city)) isWaitingToRunTrain]) {
                    if(!([((id<CNSet>)(lts)) containsItem:wrap(GEVec2i, ((TRCity*)(city)).tile)])) [((TRCity*)(city)) resumeTrainRunning];
                }
            }
        }
        return nil;
    }];
}

- (CNFuture*)tryTurnASwitch:(TRSwitch*)aSwitch {
    return [[self isLockedTheSwitch:aSwitch] flatMapF:^CNFuture*(id locked) {
        if(!(unumb(locked))) return [_railroad turnASwitch:aSwitch];
        else return ((CNFuture*)([CNFuture successfulResult:nil]));
    }];
}

- (CNFuture*)isLockedTheSwitch:(TRSwitch*)theSwitch {
    return [[self trains] flatMapF:^CNFuture*(NSArray* trs) {
        return [[[((NSArray*)(trs)) chain] map:^CNFuture*(TRTrain* _) {
            return [((TRTrain*)(_)) isLockedTheSwitch:theSwitch];
        }] futureF:^id(CNChain* _) {
            return numb([_ or]);
        }];
    }];
}

- (CNFuture*)isLockedRail:(TRRail*)rail {
    return [CNFuture mapA:[[self trains] flatMapF:^CNFuture*(NSArray* trs) {
        return [[[((NSArray*)(trs)) chain] map:^CNFuture*(TRTrain* _) {
            return [((TRTrain*)(_)) isLockedRail:rail];
        }] futureF:^id(CNChain* _) {
            return numb([_ or]);
        }];
    }] b:[_railroad isLockedRail:rail] f:^id(id a, id b) {
        return numb(unumb(a) || unumb(b));
    }];
}

- (id)cityForTile:(GEVec2i)tile {
    return [__cities findWhere:^BOOL(TRCity* _) {
        return GEVec2iEq(((TRCity*)(_)).tile, tile);
    }];
}

- (CNFuture*)possiblyArrivedTrain:(TRTrain*)train tile:(GEVec2i)tile tailX:(CGFloat)tailX {
    return [self futureF:^id() {
        [[self cityForTile:tile] forEach:^void(TRCity* city) {
            if([((TRCity*)(city)) startPointX] - 0.1 > tailX) [self arrivedTrain:train];
        }];
        return nil;
    }];
}

- (void)arrivedTrain:(TRTrain*)train {
    if([[self repairer] containsItem:train]) [_score removeTrain:train];
    else [_score arrivedTrain:train];
    [self removeTrain:train];
}

- (CNFuture*)processCollisions {
    return [[self detectCollisions] mapF:^id(NSArray* collisions) {
        [((NSArray*)(collisions)) forEach:^void(TRCarsCollision* collision) {
            [self _processCollision:collision];
        }];
        return nil;
    }];
}

- (CNFuture*)processCollision:(TRCarsCollision*)collision {
    return [self futureF:^id() {
        [self _processCollision:collision];
        return nil;
    }];
}

- (void)_processCollision:(TRCarsCollision*)collision {
    for(TRTrain* _ in collision.trains) {
        [self doDestroyTrain:_ wasCollision:YES];
    }
    __crashCounter = 2;
    [_TRLevel_crashNotification postSender:self data:collision.trains];
    [self addDamageAfterCollisionRailPoint:collision.railPoint];
}

- (void)addDamageAfterCollisionRailPoint:(TRRailPoint)railPoint {
    __weak TRLevel* ws = self;
    [_rewindButton showAt:railPoint.point];
    [__schedule scheduleAfter:5.0 event:^void() {
        [[ws.railroad addDamageAtPoint:railPoint] onSuccessF:^void(id pp) {
            [_TRLevel_damageNotification postSender:ws data:pp];
        }];
    }];
}

- (CNFuture*)knockDownTrain:(TRTrain*)train {
    return [self futureF:^id() {
        if([__trains containsItem:train]) {
            [self doDestroyTrain:train wasCollision:NO];
            __crashCounter += 1;
            [_TRLevel_knockDownNotification postSender:self data:tuple(train, numui(__crashCounter))];
        }
        return nil;
    }];
}

- (CNFuture*)addSporadicDamage {
    return [self onSuccessFuture:[_railroad state] f:^id(TRRailroadState* rlState) {
        [[[[((TRRailroadState*)(rlState)) rails] chain] randomItemSeed:__seed] forEach:^void(TRRail* rail) {
            TRRailPoint p = trRailPointApplyTileFormXBack(((TRRail*)(rail)).tile, ((TRRail*)(rail)).form, (odFloatRndMinMax(0.0, ((TRRail*)(rail)).form.length)), NO);
            [[_railroad addDamageAtPoint:p] onSuccessF:^void(id pp) {
                [_TRLevel_sporadicDamageNotification postSender:self data:pp];
                [_TRLevel_damageNotification postSender:self data:pp];
            }];
        }];
        return nil;
    }];
}

- (CNFuture*)detectCollisions {
    return [_collisions detect];
}

- (CNFuture*)destroyTrain:(TRTrain*)train railPoint:(id)railPoint {
    return [self futureF:^id() {
        if([__trains containsItem:train]) {
            __crashCounter = 1;
            [_TRLevel_crashNotification postSender:self data:(@[train])];
            [self doDestroyTrain:train wasCollision:NO];
            [railPoint forEach:^void(id _) {
                [self addDamageAfterCollisionRailPoint:uwrap(TRRailPoint, _)];
            }];
        }
        return nil;
    }];
}

- (CNFuture*)destroyTrain:(TRTrain*)train {
    return [self destroyTrain:train railPoint:[CNOption none]];
}

- (void)doDestroyTrain:(TRTrain*)train wasCollision:(BOOL)wasCollision {
    if([__trains containsItem:train]) {
        [_score destroyedTrain:train];
        __trains = [__trains subItem:train];
        __dyingTrains = [__dyingTrains addItem:train];
        [[train die] onSuccessF:^void(TRLiveTrainState* state) {
            [_collisions dieTrain:train liveState:state wasCollision:wasCollision];
        }];
        __weak TRLevel* ws = self;
        [__schedule scheduleAfter:5.0 event:^void() {
            [ws removeTrain:train];
        }];
    }
}

- (void)removeTrain:(TRTrain*)train {
    __trains = [__trains subItem:train];
    [_collisions removeTrain:train];
    __dyingTrains = [__dyingTrains subItem:train];
    __repairer = [__repairer filterF:^BOOL(TRTrain* _) {
        return !([_ isEqual:train]);
    }];
    [_trainWasRemoved postData:train];
}

- (CNFuture*)runRepairerFromCity:(TRCity*)city {
    return [self futureF:^id() {
        if([__repairer isEmpty]) {
            [_score repairerCalled];
            TRTrain* train = [TRTrain trainWithLevel:self trainType:TRTrainType.repairer color:TRCityColor.grey carTypes:(@[TRCarType.engine]) speed:_rules.repairerSpeed];
            [self runTrain:train fromCity:city];
            __repairer = [CNOption applyValue:train];
            [_TRLevel_runRepairerNotification postSender:self];
        }
        return nil;
    }];
}

- (CNFuture*)fixDamageAtPoint:(TRRailPoint)point {
    return [self futureF:^id() {
        [_railroad fixDamageAtPoint:point];
        [_score damageFixed];
        [_TRLevel_fixDamageNotification postSender:self data:wrap(TRRailPoint, point)];
        return nil;
    }];
}

- (void)showHelpText:(NSString*)text {
    [_help setValue:[CNOption applyValue:[TRHelp helpWithText:text]]];
}

- (void)clearHelp {
    [_help setValue:[CNOption none]];
}

- (void)win {
    [_result setValue:[CNOption applyValue:[TRLevelResult levelResultWithWin:YES]]];
    [_TRLevel_winNotification postSender:self];
}

- (void)lose {
    [_result setValue:[CNOption applyValue:[TRLevelResult levelResultWithWin:NO]]];
}

- (void)rewind {
    [_result setValue:[CNOption none]];
    _looseCounter = 0.0;
    __resultSent = NO;
    [_history rewind];
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"number=%lu", (unsigned long)self.number];
    [description appendFormat:@", rules=%@", self.rules];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRHelp
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"text=%@", self.text];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRLevelResult
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


@implementation TRNotifications
static ODClassType* _TRNotifications_type;

+ (instancetype)notifications {
    return [[TRNotifications alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _queue = [ATConcurrentQueue concurrentQueue];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRNotifications class]) _TRNotifications_type = [ODClassType classTypeWithCls:[TRNotifications class]];
}

- (void)notifyNotification:(NSString*)notification {
    [_queue enqueueItem:notification];
}

- (BOOL)isEmpty {
    return [_queue isEmpty];
}

- (id)take {
    return [_queue dequeue];
}

- (ODClassType*)type {
    return [TRNotifications type];
}

+ (ODClassType*)type {
    return _TRNotifications_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


