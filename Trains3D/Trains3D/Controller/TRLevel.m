#import "TRLevel.h"

#import "TRScore.h"
#import "TRWeather.h"
#import "EGSchedule.h"
#import "TRRailroad.h"
#import "TRRailroadBuilder.h"
#import "CNReact.h"
#import "CNObserver.h"
#import "CNChain.h"
#import "CNFuture.h"
#import "TRTrainCollisions.h"
#import "TRStrings.h"
#import "CNConcurrentQueue.h"
TRLevelEventType* TRLevelEventType_Values[6];
TRLevelEventType* TRLevelEventType_train_Desc;
TRLevelEventType* TRLevelEventType_city_Desc;
TRLevelEventType* TRLevelEventType_twoCities_Desc;
TRLevelEventType* TRLevelEventType_help_Desc;
TRLevelEventType* TRLevelEventType_await_Desc;
@implementation TRLevelEventType

+ (instancetype)levelEventTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[TRLevelEventType alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    TRLevelEventType_train_Desc = [TRLevelEventType levelEventTypeWithOrdinal:0 name:@"train"];
    TRLevelEventType_city_Desc = [TRLevelEventType levelEventTypeWithOrdinal:1 name:@"city"];
    TRLevelEventType_twoCities_Desc = [TRLevelEventType levelEventTypeWithOrdinal:2 name:@"twoCities"];
    TRLevelEventType_help_Desc = [TRLevelEventType levelEventTypeWithOrdinal:3 name:@"help"];
    TRLevelEventType_await_Desc = [TRLevelEventType levelEventTypeWithOrdinal:4 name:@"await"];
    TRLevelEventType_Values[0] = nil;
    TRLevelEventType_Values[1] = TRLevelEventType_train_Desc;
    TRLevelEventType_Values[2] = TRLevelEventType_city_Desc;
    TRLevelEventType_Values[3] = TRLevelEventType_twoCities_Desc;
    TRLevelEventType_Values[4] = TRLevelEventType_help_Desc;
    TRLevelEventType_Values[5] = TRLevelEventType_await_Desc;
}

+ (NSArray*)values {
    return (@[TRLevelEventType_train_Desc, TRLevelEventType_city_Desc, TRLevelEventType_twoCities_Desc, TRLevelEventType_help_Desc, TRLevelEventType_await_Desc]);
}

+ (TRLevelEventType*)value:(TRLevelEventTypeR)r {
    return TRLevelEventType_Values[r];
}

@end

@implementation TRLevelRules
static CNClassType* _TRLevelRules_type;
@synthesize mapSize = _mapSize;
@synthesize theme = _theme;
@synthesize trainComingPeriod = _trainComingPeriod;
@synthesize scoreRules = _scoreRules;
@synthesize rewindRules = _rewindRules;
@synthesize weatherRules = _weatherRules;
@synthesize repairerSpeed = _repairerSpeed;
@synthesize sporadicDamagePeriod = _sporadicDamagePeriod;
@synthesize events = _events;

+ (instancetype)levelRulesWithMapSize:(GEVec2i)mapSize theme:(TRLevelThemeR)theme trainComingPeriod:(NSUInteger)trainComingPeriod scoreRules:(TRScoreRules*)scoreRules rewindRules:(TRRewindRules)rewindRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(NSArray*)events {
    return [[TRLevelRules alloc] initWithMapSize:mapSize theme:theme trainComingPeriod:trainComingPeriod scoreRules:scoreRules rewindRules:rewindRules weatherRules:weatherRules repairerSpeed:repairerSpeed sporadicDamagePeriod:sporadicDamagePeriod events:events];
}

- (instancetype)initWithMapSize:(GEVec2i)mapSize theme:(TRLevelThemeR)theme trainComingPeriod:(NSUInteger)trainComingPeriod scoreRules:(TRScoreRules*)scoreRules rewindRules:(TRRewindRules)rewindRules weatherRules:(TRWeatherRules*)weatherRules repairerSpeed:(NSUInteger)repairerSpeed sporadicDamagePeriod:(NSUInteger)sporadicDamagePeriod events:(NSArray*)events {
    self = [super init];
    if(self) {
        _mapSize = mapSize;
        _theme = theme;
        _trainComingPeriod = trainComingPeriod;
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
    if(self == [TRLevelRules class]) _TRLevelRules_type = [CNClassType classTypeWithCls:[TRLevelRules class]];
}

+ (TRLevelRules*)aDefault {
    return [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 5) theme:TRLevelTheme_forest trainComingPeriod:10 scoreRules:[TRScoreRules aDefault] rewindRules:trRewindRulesDefault() weatherRules:TRWeatherRules.aDefault repairerSpeed:30 sporadicDamagePeriod:0 events:((NSArray*)((@[])))];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"LevelRules(%@, %@, %lu, %@, %@, %@, %lu, %lu, %@)", geVec2iDescription(_mapSize), [TRLevelTheme value:_theme], (unsigned long)_trainComingPeriod, _scoreRules, trRewindRulesDescription(_rewindRules), _weatherRules, (unsigned long)_repairerSpeed, (unsigned long)_sporadicDamagePeriod, _events];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRLevelRules class]])) return NO;
    TRLevelRules* o = ((TRLevelRules*)(to));
    return geVec2iIsEqualTo(_mapSize, o.mapSize) && _theme == o.theme && _trainComingPeriod == o.trainComingPeriod && [_scoreRules isEqual:o.scoreRules] && trRewindRulesIsEqualTo(_rewindRules, o.rewindRules) && [_weatherRules isEqual:o.weatherRules] && _repairerSpeed == o.repairerSpeed && _sporadicDamagePeriod == o.sporadicDamagePeriod && [_events isEqual:o.events];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2iHash(_mapSize);
    hash = hash * 31 + [[TRLevelTheme value:_theme] hash];
    hash = hash * 31 + _trainComingPeriod;
    hash = hash * 31 + [_scoreRules hash];
    hash = hash * 31 + trRewindRulesHash(_rewindRules);
    hash = hash * 31 + [_weatherRules hash];
    hash = hash * 31 + _repairerSpeed;
    hash = hash * 31 + _sporadicDamagePeriod;
    hash = hash * 31 + [_events hash];
    return hash;
}

- (CNClassType*)type {
    return [TRLevelRules type];
}

+ (CNClassType*)type {
    return _TRLevelRules_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRLevelState
static CNClassType* _TRLevelState_type;
@synthesize time = _time;
@synthesize seedPosition = _seedPosition;
@synthesize schedule = _schedule;
@synthesize railroad = _railroad;
@synthesize builderState = _builderState;
@synthesize cities = _cities;
@synthesize trains = _trains;
@synthesize dyingTrains = _dyingTrains;
@synthesize repairer = _repairer;
@synthesize score = _score;
@synthesize trees = _trees;
@synthesize timeToNextDamage = _timeToNextDamage;
@synthesize generators = _generators;
@synthesize scheduleAwait = _scheduleAwait;
@synthesize remainingTrainsCount = _remainingTrainsCount;

+ (instancetype)levelStateWithTime:(CGFloat)time seedPosition:(unsigned int)seedPosition schedule:(EGImSchedule*)schedule railroad:(TRRailroadState*)railroad builderState:(TRRailroadBuilderState*)builderState cities:(NSArray*)cities trains:(NSArray*)trains dyingTrains:(NSArray*)dyingTrains repairer:(TRTrain*)repairer score:(TRScoreState*)score trees:(NSArray*)trees timeToNextDamage:(CGFloat)timeToNextDamage generators:(NSArray*)generators scheduleAwait:(CNFuture*(^)(TRLevel*))scheduleAwait remainingTrainsCount:(NSInteger)remainingTrainsCount {
    return [[TRLevelState alloc] initWithTime:time seedPosition:seedPosition schedule:schedule railroad:railroad builderState:builderState cities:cities trains:trains dyingTrains:dyingTrains repairer:repairer score:score trees:trees timeToNextDamage:timeToNextDamage generators:generators scheduleAwait:scheduleAwait remainingTrainsCount:remainingTrainsCount];
}

- (instancetype)initWithTime:(CGFloat)time seedPosition:(unsigned int)seedPosition schedule:(EGImSchedule*)schedule railroad:(TRRailroadState*)railroad builderState:(TRRailroadBuilderState*)builderState cities:(NSArray*)cities trains:(NSArray*)trains dyingTrains:(NSArray*)dyingTrains repairer:(TRTrain*)repairer score:(TRScoreState*)score trees:(NSArray*)trees timeToNextDamage:(CGFloat)timeToNextDamage generators:(NSArray*)generators scheduleAwait:(CNFuture*(^)(TRLevel*))scheduleAwait remainingTrainsCount:(NSInteger)remainingTrainsCount {
    self = [super init];
    if(self) {
        _time = time;
        _seedPosition = seedPosition;
        _schedule = schedule;
        _railroad = railroad;
        _builderState = builderState;
        _cities = cities;
        _trains = trains;
        _dyingTrains = dyingTrains;
        _repairer = repairer;
        _score = score;
        _trees = trees;
        _timeToNextDamage = timeToNextDamage;
        _generators = generators;
        _scheduleAwait = scheduleAwait;
        _remainingTrainsCount = remainingTrainsCount;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelState class]) _TRLevelState_type = [CNClassType classTypeWithCls:[TRLevelState class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"LevelState(%f, %u, %@, %@, %@, %@, %@, %@, %@, %@, %@, %f, %@, %@, %ld)", _time, _seedPosition, _schedule, _railroad, _builderState, _cities, _trains, _dyingTrains, _repairer, _score, _trees, _timeToNextDamage, _generators, _scheduleAwait, (long)_remainingTrainsCount];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRLevelState class]])) return NO;
    TRLevelState* o = ((TRLevelState*)(to));
    return eqf(_time, o.time) && _seedPosition == o.seedPosition && [_schedule isEqual:o.schedule] && [_railroad isEqual:o.railroad] && [_builderState isEqual:o.builderState] && [_cities isEqual:o.cities] && [_trains isEqual:o.trains] && [_dyingTrains isEqual:o.dyingTrains] && [_repairer isEqual:o.repairer] && [_score isEqual:o.score] && [_trees isEqual:o.trees] && eqf(_timeToNextDamage, o.timeToNextDamage) && [_generators isEqual:o.generators] && [_scheduleAwait isEqual:o.scheduleAwait] && _remainingTrainsCount == o.remainingTrainsCount;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(_time);
    hash = hash * 31 + _seedPosition;
    hash = hash * 31 + [_schedule hash];
    hash = hash * 31 + [_railroad hash];
    hash = hash * 31 + [_builderState hash];
    hash = hash * 31 + [_cities hash];
    hash = hash * 31 + [_trains hash];
    hash = hash * 31 + [_dyingTrains hash];
    hash = hash * 31 + [((TRTrain*)(_repairer)) hash];
    hash = hash * 31 + [_score hash];
    hash = hash * 31 + [_trees hash];
    hash = hash * 31 + floatHash(_timeToNextDamage);
    hash = hash * 31 + [_generators hash];
    hash = hash * 31 + [_scheduleAwait hash];
    hash = hash * 31 + _remainingTrainsCount;
    return hash;
}

- (CNClassType*)type {
    return [TRLevelState type];
}

+ (CNClassType*)type {
    return _TRLevelState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRRewindButton
static CNClassType* _TRRewindButton_type;
@synthesize animation = _animation;
@synthesize position = _position;

+ (instancetype)rewindButton {
    return [[TRRewindButton alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _animation = [[EGCounter applyLength:5.0] finished];
        _position = [CNVar applyInitial:wrap(GEVec2, (GEVec2Make(0.0, 0.0)))];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRewindButton class]) _TRRewindButton_type = [CNClassType classTypeWithCls:[TRRewindButton class]];
}

- (void)showAt:(GEVec2)at {
    [_position setValue:wrap(GEVec2, at)];
    [_animation restart];
}

- (NSString*)description {
    return @"RewindButton";
}

- (CNClassType*)type {
    return [TRRewindButton type];
}

+ (CNClassType*)type {
    return _TRRewindButton_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRLevel
static CNSignal* _TRLevel_crashed;
static CNSignal* _TRLevel_knockedDown;
static CNSignal* _TRLevel_damaged;
static CNSignal* _TRLevel_sporadicDamaged;
static CNSignal* _TRLevel_runRepairer;
static CNSignal* _TRLevel_fixedDamage;
static CNSignal* _TRLevel_wan;
static CNClassType* _TRLevel_type;
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
@synthesize cityWasBuilt = _cityWasBuilt;
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
        _scale = [CNSlot slotWithInitial:@1.0];
        _cameraReserves = [CNSlot slotWithInitial:wrap(EGCameraReserve, (EGCameraReserveMake(0.0, 0.0, 0.1, 0.0)))];
        _viewRatio = [CNSlot slotWithInitial:@1.6];
        __seed = [CNSeed apply];
        __time = 0.0;
        _rewindButton = [TRRewindButton rewindButton];
        __remainingTrainsCount = [CNVar applyInitial:numui([[[rules.events chain] filterWhen:^BOOL(CNTuple* _) {
            return ((TRLevelEventTypeR)([((CNTuple*)(((CNTuple*)(_)).b)).a ordinal] + 1)) == TRLevelEventType_train;
        }] count])];
        _history = [TRHistory historyWithLevel:self rules:rules.rewindRules];
        _map = [EGMapSso mapSsoWithSize:rules.mapSize];
        _notifications = [TRNotifications notifications];
        _score = [TRScore scoreWithRules:rules.scoreRules notifications:_notifications];
        _weather = [TRWeather weatherWithRules:rules.weatherRules];
        _forest = [TRForest forestWithMap:_map rules:[TRLevelTheme value:rules.theme].forestRules weather:_weather];
        _railroad = [TRRailroad railroadWithMap:_map score:_score forest:_forest];
        _builder = [TRRailroadBuilder railroadBuilderWithLevel:self];
        __cities = ((NSArray*)((@[])));
        __schedule = [EGMSchedule schedule];
        __trains = ((NSArray*)((@[])));
        __repairer = nil;
        _collisions = [TRTrainCollisions trainCollisionsWithLevel:self];
        __dyingTrains = ((NSArray*)((@[])));
        __timeToNextDamage = cnFloatRndMinMax(rules.sporadicDamagePeriod * 0.75, rules.sporadicDamagePeriod * 1.25);
        _cityWasBuilt = [CNSignal signal];
        _trainIsAboutToRun = [CNSignal signal];
        _trainIsExpected = [CNSignal signal];
        _trainWasAdded = [CNSignal signal];
        __generators = ((NSArray*)((@[])));
        _looseCounter = 0.0;
        __resultSent = NO;
        __crashCounter = 0;
        _trainWasRemoved = [CNSignal signal];
        _help = [CNVar applyInitial:nil];
        _result = [CNVar applyInitial:nil];
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
        _TRLevel_type = [CNClassType classTypeWithCls:[TRLevel class]];
        _TRLevel_crashed = [CNSignal signal];
        _TRLevel_knockedDown = [CNSignal signal];
        _TRLevel_damaged = [CNSignal signal];
        _TRLevel_sporadicDamaged = [CNSignal signal];
        _TRLevel_runRepairer = [CNSignal signal];
        _TRLevel_fixedDamage = [CNSignal signal];
        _TRLevel_wan = [CNSignal signal];
    }
}

- (CNFuture*)time {
    return [self promptF:^id() {
        return numf(__time);
    }];
}

- (CNFuture*)state {
    return [self promptJoinF:^CNFuture*() {
        return [self lockAndOnSuccessFuture:[CNFuture joinA:[_railroad state] b:[[[[__trains chain] appendCollection:__dyingTrains] mapF:^CNFuture*(TRTrain* _) {
            return [((TRTrain*)(_)) state];
        }] future] c:[_forest trees] d:[_score state] e:[_builder state]] f:^TRLevelState*(CNTuple5* t) {
            TRRailroadState* rrState = ((CNTuple5*)(t)).a;
            NSArray* trains = ((CNTuple5*)(t)).b;
            NSArray* trees = ((CNTuple5*)(t)).c;
            TRScoreState* scoreState = ((CNTuple5*)(t)).d;
            TRRailroadBuilderState* builderState = ((CNTuple5*)(t)).e;
            return [TRLevelState levelStateWithTime:__time seedPosition:[__seed position] schedule:[__schedule imCopy] railroad:rrState builderState:builderState cities:[[[__cities chain] mapF:^TRCityState*(TRCity* _) {
                return [((TRCity*)(_)) state];
            }] toArray] trains:[[[trains chain] filterCastTo:TRLiveTrainState.type] toArray] dyingTrains:[[[trains chain] filterCastTo:TRDieTrainState.type] toArray] repairer:__repairer score:scoreState trees:trees timeToNextDamage:__timeToNextDamage generators:__generators scheduleAwait:__scheduleAwait remainingTrainsCount:unumi([__remainingTrainsCount value])];
        }];
    }];
}

- (CNFuture*)restoreState:(TRLevelState*)state {
    return [self futureF:^id() {
        __time = state.time;
        [__seed setPosition:state.seedPosition];
        [_railroad restoreState:state.railroad];
        [__schedule assignImSchedule:state.schedule];
        NSArray* newCities = [[[state.cities chain] mapF:^TRCity*(TRCityState* _) {
            return [((TRCityState*)(_)).city restoreState:_];
        }] toArray];
        [[[__cities chain] excludeCollection:newCities] forEach:^void(TRCity* _) {
            [_collisions removeCity:_];
        }];
        __cities = newCities;
        NSArray* newTrains = [[[state.trains chain] mapF:^TRTrain*(TRLiveTrainState* ts) {
            [((TRLiveTrainState*)(ts)).train restoreState:ts];
            return ((TRLiveTrainState*)(ts)).train;
        }] toArray];
        NSArray* newDyingTrains = [[[state.dyingTrains chain] mapF:^TRTrain*(TRDieTrainState* ts) {
            [((TRDieTrainState*)(ts)).train restoreState:ts];
            return ((TRDieTrainState*)(ts)).train;
        }] toArray];
        [[[[newTrains chain] appendCollection:newDyingTrains] excludeCollection:[__trains addSeq:__dyingTrains]] forEach:^void(TRTrain* tr) {
            [_trainWasAdded postData:tr];
        }];
        [[[[__trains chain] appendCollection:__dyingTrains] excludeCollection:[newTrains addSeq:newDyingTrains]] forEach:^void(TRTrain* tr) {
            [_collisions removeTrain:tr];
            [_trainWasRemoved postData:tr];
        }];
        [[[__dyingTrains chain] intersectCollection:newTrains] forEach:^void(TRTrain* tr) {
            [_collisions removeTrain:tr];
            [_collisions addTrain:tr state:((TRLiveTrainState*)(nonnil([state.trains findWhere:^BOOL(TRLiveTrainState* _) {
                return ((TRLiveTrainState*)(_)).train == tr;
            }])))];
        }];
        [[[__trains chain] intersectCollection:newDyingTrains] forEach:^void(TRTrain* tr) {
            [_collisions dieTrain:tr dieState:((TRDieTrainState*)(nonnil([state.dyingTrains findWhere:^BOOL(TRDieTrainState* _) {
                return ((TRDieTrainState*)(_)).train == tr;
            }])))];
        }];
        __trains = newTrains;
        __dyingTrains = newDyingTrains;
        __repairer = state.repairer;
        __timeToNextDamage = state.timeToNextDamage;
        [_score restoreState:state.score];
        [_forest restoreTrees:state.trees];
        [__schedule assignImSchedule:state.schedule];
        __generators = state.generators;
        for(TRTrainGenerator* _ in state.generators) {
            [self _runTrainWithGenerator:_];
        }
        [_rewindButton.animation finish];
        [_builder restoreState:state.builderState];
        __scheduleAwait = state.scheduleAwait;
        __scheduleAwaitLastFuture = nil;
        [__remainingTrainsCount setValue:numi(state.remainingTrainsCount)];
        return nil;
    }];
}

- (CNReact*)remainingTrainsCount {
    return __remainingTrainsCount;
}

- (void)scheduleAwaitBy:(CNFuture*(^)(TRLevel*))by {
    __scheduleAwait = by;
}

- (CNFuture*)cities {
    return [self promptF:^NSArray*() {
        return [[[__cities chain] mapF:^TRCityState*(TRCity* _) {
            return [((TRCity*)(_)) state];
        }] toArray];
    }];
}

- (CNFuture*)trains {
    return [self promptF:^NSArray*() {
        return __trains;
    }];
}

- (TRTrain*)repairer {
    return __repairer;
}

- (void)_init {
    __block CGFloat time = 0.0;
    __weak TRLevel* ws = self;
    for(CNTuple* t in _rules.events) {
        void(^f)(TRLevel*) = ((CNTuple*)(((CNTuple*)(t)).b)).b;
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
        TRCity* city1 = [self doCreateNewCityRlState:rlState aCheck:^BOOL(GEVec2i _0, TRCityAngleR _1) {
            return YES;
        }];
        GEVec2i cityTile1 = city1.tile;
        return [self doCreateNewCityRlState:rlState aCheck:^BOOL(GEVec2i tile, TRCityAngleR _) {
            return geVec2iLength((geVec2iSubVec2i(tile, cityTile1))) > 2;
        }];
    }]));
}

- (CNFuture*)createNewCity {
    return [self onSuccessFuture:[_railroad state] f:^TRCity*(TRRailroadState* rlState) {
        return [self doCreateNewCityRlState:rlState aCheck:^BOOL(GEVec2i _0, TRCityAngleR _1) {
            return YES;
        }];
    }];
}

- (TRCity*)doCreateNewCityRlState:(TRRailroadState*)rlState aCheck:(BOOL(^)(GEVec2i, TRCityAngleR))aCheck {
    CNTuple* c = [self rndCityTimeRlState:rlState aCheck:aCheck];
    return [self createCityWithTile:uwrap(GEVec2i, c.a) direction:((TRCityAngleR)([c.b ordinal] + 1))];
}

- (BOOL)hasCityInTile:(GEVec2i)tile {
    return [__cities existsWhere:^BOOL(TRCity* _) {
        return geVec2iIsEqualTo(((TRCity*)(_)).tile, tile);
    }];
}

- (CNTuple*)rndCityTimeRlState:(TRRailroadState*)rlState aCheck:(BOOL(^)(GEVec2i, TRCityAngleR))aCheck {
    CNChain* chain = [[[[[[_map.partialTiles chain] filterWhen:^BOOL(id tile) {
        return !([_map isRightTile:uwrap(GEVec2i, tile)] && ([_map isTopTile:uwrap(GEVec2i, tile)] || [_map isBottomTile:uwrap(GEVec2i, tile)])) && !([_map isLeftTile:uwrap(GEVec2i, tile)] && ([_map isTopTile:uwrap(GEVec2i, tile)] || [_map isBottomTile:uwrap(GEVec2i, tile)]));
    }] excludeCollection:[[__cities chain] mapF:^id(TRCity* _) {
        return wrap(GEVec2i, ((TRCity*)(_)).tile);
    }]] mulBy:[TRCityAngle values]] filterWhen:^BOOL(CNTuple* t) {
        EGMapTileCutState cut = [_map cutStateForTile:uwrap(GEVec2i, ((CNTuple*)(t)).a)];
        NSInteger angle = [TRCityAngle value:((TRCityAngleR)([((CNTuple*)(t)).b ordinal] + 1))].angle;
        return (angle == 0 && cut.x2 == 0 && cut.y2 == 0) || (angle == 90 && cut.x == 0 && cut.y2 == 0) || (angle == 180 && cut.x == 0 && cut.y == 0) || (angle == 270 && cut.x2 == 0 && cut.y == 0);
    }] shuffle];
    {
        CNTuple* __tmp_1 = [chain findWhere:^BOOL(CNTuple* t) {
            GEVec2i tile = uwrap(GEVec2i, ((CNTuple*)(t)).a);
            TRCityAngleR dir = ((TRCityAngleR)([((CNTuple*)(t)).b ordinal] + 1));
            GEVec2i nextTile = [[TRRailConnector value:[[TRCityAngle value:dir] out]] nextTile:tile];
            return !([[[[TRRailConnector values] chain] filterWhen:^BOOL(TRRailConnector* _) {
                return !(((TRRailConnectorR)([_ ordinal] + 1)) == [[TRRailConnector value:[[TRCityAngle value:dir] out]] otherSideConnector]);
            }] allConfirm:^BOOL(TRRailConnector* connector) {
                return [[rlState contentInTile:nextTile connector:((TRRailConnectorR)([connector ordinal] + 1))] isKindOfClass:[TRSwitch class]];
            }]) && !([[[TRRailConnector value:[[TRRailConnector value:[[TRCityAngle value:dir] in]] otherSideConnector]] neighbours] existsWhere:^BOOL(TRRailConnector* n) {
                return [self hasCityInTile:[[TRRailConnector value:((TRRailConnectorR)([n ordinal] + 1))] nextTile:[[TRRailConnector value:[[TRCityAngle value:dir] in]] nextTile:tile]]];
            }]) && aCheck(tile, dir);
        }];
        if(__tmp_1 != nil) return ((CNTuple*)(__tmp_1));
        else return ((CNTuple*)(nonnil([chain head])));
    }
}

- (TRCity*)createCityWithTile:(GEVec2i)tile direction:(TRCityAngleR)direction {
    TRCity* city = [TRCity cityWithLevel:self color:((TRCityColorR)([__cities count] + 1)) tile:tile angle:direction];
    [_forest cutDownTile:tile];
    [_railroad tryAddRail:[TRRail railWithTile:tile form:[TRCityAngle value:city.angle].form] free:YES];
    __cities = [__cities addItem:city];
    [_collisions addCity:city];
    [_cityWasBuilt postData:city];
    if([__cities count] > 2) [_notifications notifyNotification:[TRStr.Loc cityBuilt]];
    return city;
}

- (void)runTrain:(TRTrain*)train fromCity:(TRCity*)fromCity {
    [fromCity expectTrain:train];
    [_trainIsExpected postData:tuple(train, fromCity)];
}

- (CNFuture*)lockedTiles {
    return [[[__trains chain] mapF:^CNFuture*(TRTrain* _) {
        return [((TRTrain*)(_)) lockedTiles];
    }] futureF:^id<CNSet>(CNChain* _) {
        return [[_ flat] toSet];
    }];
}

- (CNFuture*)addTrain:(TRTrain*)train {
    return [self futureF:^id() {
        __trains = [__trains addItem:train];
        [_score runTrain:train];
        if(train.trainType != TRTrainType_repairer) [__remainingTrainsCount updateF:^id(id _) {
            return numi(unumi(_) - 1);
        }];
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
        TRCity* fromCityOpt = [[[__cities chain] filterWhen:^BOOL(TRCity* c) {
            return [((TRCity*)(c)) canRunNewTrain] && !([((id<CNSet>)(lts)) containsItem:wrap(GEVec2i, ((TRCity*)(c)).tile)]);
        }] randomItemSeed:__seed];
        __generators = [__generators subItem:generator];
        if(fromCityOpt == nil) {
            [__schedule scheduleAfter:1.0 event:^void() {
                TRLevel* _self = _weakSelf;
                if(_self != nil) [_self runTrainWithGenerator:generator];
            }];
        } else {
            TRCityColorR color = ((generator.trainType == TRTrainType_crazy) ? TRCityColor_grey : ((TRCity*)(nonnil([[[__cities chain] filterWhen:^BOOL(TRCity* _) {
                return !([_ isEqual:fromCityOpt]);
            }] randomItemSeed:__seed]))).color);
            TRTrain* train = [TRTrain trainWithLevel:self trainType:generator.trainType color:color carTypes:[generator generateCarTypesSeed:__seed] speed:[generator generateSpeedSeed:__seed]];
            [self runTrain:train fromCity:fromCityOpt];
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
            [[_railroad state] onCompleteF:^void(CNTry* t) {
                if([t isSuccess]) {
                    TRRailroadState* rrState = [t get];
                    {
                        for(TRTrain* _ in __trains) {
                            [((TRTrain*)(_)) updateWithRrState:rrState delta:delta];
                        }
                        for(TRTrain* _ in __dyingTrains) {
                            [((TRTrain*)(_)) updateWithRrState:rrState delta:delta];
                        }
                    }
                }
            }];
            [_score updateWithDelta:delta];
            [_builder updateWithDelta:delta];
            if(__scheduleAwait != nil) {
                if(__scheduleAwaitLastFuture != nil) {
                    CNTry* r = [((CNFuture*)(__scheduleAwaitLastFuture)) result];
                    if(r != nil) {
                        if(({
                            id __tmpp0_0t_4t_0t_1t_0c = [((CNTry*)(r)) value];
                            ((__tmpp0_0t_4t_0t_1t_0c != nil) ? unumb(__tmpp0_0t_4t_0t_1t_0c) : YES);
                        })) {
                            __scheduleAwait = nil;
                            __scheduleAwaitLastFuture = nil;
                            [__schedule updateWithDelta:delta];
                        } else {
                            __scheduleAwaitLastFuture = __scheduleAwait(self);
                        }
                    }
                } else {
                    __scheduleAwaitLastFuture = __scheduleAwait(self);
                }
            } else {
                [__schedule updateWithDelta:delta];
            }
            [_weather updateWithDelta:delta];
            [_forest updateWithDelta:delta];
            [_slowMotionCounter updateWithDelta:delta];
            if(_rules.sporadicDamagePeriod > 0) {
                __timeToNextDamage -= delta;
                if(__timeToNextDamage <= 0) {
                    [self addSporadicDamage];
                    __timeToNextDamage = cnFloatRndMinMax(_rules.sporadicDamagePeriod * 0.75, _rules.sporadicDamagePeriod * 1.25);
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
                if([__schedule isEmpty] && [__generators isEmpty] && [__trains isEmpty] && [__dyingTrains isEmpty] && [__cities allConfirm:^BOOL(TRCity* _) {
                    return [((TRCity*)(_)) canRunNewTrain];
                }] && !(__resultSent)) {
                    __resultSent = YES;
                    [self win];
                }
            }
            for(TRCity* _ in __cities) {
                [((TRCity*)(_)) updateWithDelta:delta];
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
        return [[[((NSArray*)(trs)) chain] mapF:^CNFuture*(TRTrain* _) {
            return [((TRTrain*)(_)) isLockedTheSwitch:theSwitch];
        }] futureF:^id(CNChain* _) {
            return numb([_ or]);
        }];
    }];
}

- (CNFuture*)isLockedRail:(TRRail*)rail {
    return [CNFuture mapA:[[self trains] flatMapF:^CNFuture*(NSArray* trs) {
        return [[[((NSArray*)(trs)) chain] mapF:^CNFuture*(TRTrain* _) {
            return [((TRTrain*)(_)) isLockedRail:rail];
        }] futureF:^id(CNChain* _) {
            return numb([_ or]);
        }];
    }] b:[_railroad isLockedRail:rail] f:^id(id a, id b) {
        return numb(unumb(a) || unumb(b));
    }];
}

- (TRCity*)cityForTile:(GEVec2i)tile {
    return [__cities findWhere:^BOOL(TRCity* _) {
        return geVec2iIsEqualTo(((TRCity*)(_)).tile, tile);
    }];
}

- (CNFuture*)possiblyArrivedTrain:(TRTrain*)train tile:(GEVec2i)tile tailX:(CGFloat)tailX {
    return [self futureF:^id() {
        TRCity* city = [self cityForTile:tile];
        if(city != nil) {
            if([((TRCity*)(city)) startPointX] - 0.1 > tailX) [self arrivedTrain:train];
        }
        return nil;
    }];
}

- (void)arrivedTrain:(TRTrain*)train {
    if(({
        TRTrain* __tmp_0c = [self repairer];
        __tmp_0c != nil && [__tmp_0c isEqual:train];
    })) [_score removeTrain:train];
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
    [_TRLevel_crashed postData:collision.trains];
    [self addDamageAfterCollisionRailPoint:collision.railPoint];
}

- (void)addDamageAfterCollisionRailPoint:(TRRailPoint)railPoint {
    __weak TRLevel* ws = self;
    [_rewindButton showAt:railPoint.point];
    [__schedule scheduleAfter:5.0 event:^void() {
        [[ws.railroad addDamageAtPoint:railPoint] onCompleteF:^void(CNTry* t) {
            if([t isSuccess]) {
                id pp = [t get];
                [_TRLevel_damaged postData:pp];
            }
        }];
    }];
}

- (CNFuture*)knockDownTrain:(TRTrain*)train {
    return [self futureF:^id() {
        if([__trains containsItem:train]) {
            [self doDestroyTrain:train wasCollision:NO];
            __crashCounter += 1;
            [_TRLevel_knockedDown postData:tuple(train, numui(__crashCounter))];
        }
        return nil;
    }];
}

- (CNFuture*)addSporadicDamage {
    return [self onSuccessFuture:[_railroad state] f:^id(TRRailroadState* rlState) {
        TRRail* rail = [[[((TRRailroadState*)(rlState)) rails] chain] randomItemSeed:__seed];
        if(rail != nil) {
            TRRailPoint p = trRailPointApplyTileFormXBack(((TRRail*)(rail)).tile, ((TRRail*)(rail)).form, (cnFloatRndMinMax(0.0, [TRRailForm value:((TRRail*)(rail)).form].length)), NO);
            [[_railroad addDamageAtPoint:p] onCompleteF:^void(CNTry* t) {
                if([t isSuccess]) {
                    id pp = [t get];
                    {
                        [_TRLevel_sporadicDamaged postData:pp];
                        [_TRLevel_damaged postData:pp];
                    }
                }
            }];
        }
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
            [_TRLevel_crashed postData:(@[train])];
            [self doDestroyTrain:train wasCollision:NO];
            {
                id _ = railPoint;
                if(_ != nil) [self addDamageAfterCollisionRailPoint:uwrap(TRRailPoint, _)];
            }
        }
        return nil;
    }];
}

- (CNFuture*)destroyTrain:(TRTrain*)train {
    return [self destroyTrain:train railPoint:nil];
}

- (void)doDestroyTrain:(TRTrain*)train wasCollision:(BOOL)wasCollision {
    if([__trains containsItem:train]) {
        [_score destroyedTrain:train];
        __trains = [__trains subItem:train];
        __dyingTrains = [__dyingTrains addItem:train];
        [[train die] onCompleteF:^void(CNTry* t) {
            if([t isSuccess]) {
                TRLiveTrainState* state = [t get];
                {
                    TRLiveTrainState* _ = state;
                    if(_ != nil) [_collisions dieTrain:train liveState:_ wasCollision:wasCollision];
                }
            }
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
    if(__repairer != nil && [__repairer isEqual:train]) __repairer = nil;
    [_trainWasRemoved postData:train];
}

- (CNFuture*)runRepairerFromCity:(TRCity*)city {
    return [self futureF:^id() {
        if(__repairer == nil) {
            [_score repairerCalled];
            TRTrain* train = [TRTrain trainWithLevel:self trainType:TRTrainType_repairer color:TRCityColor_grey carTypes:(@[[TRCarType value:TRCarType_engine]]) speed:_rules.repairerSpeed];
            [self runTrain:train fromCity:city];
            __repairer = train;
            [_TRLevel_runRepairer post];
        }
        return nil;
    }];
}

- (CNFuture*)fixDamageAtPoint:(TRRailPoint)point {
    return [self futureF:^id() {
        [_railroad fixDamageAtPoint:point];
        [_score damageFixed];
        [_TRLevel_fixedDamage postData:wrap(TRRailPoint, point)];
        return nil;
    }];
}

- (void)showHelpText:(NSString*)text {
    [_help setValue:[TRHelp helpWithText:text]];
}

- (void)clearHelp {
    [_help setValue:nil];
}

- (void)win {
    [_result setValue:[TRLevelResult levelResultWithWin:YES]];
    [_TRLevel_wan postData:self];
}

- (void)lose {
    [_result setValue:[TRLevelResult levelResultWithWin:NO]];
}

- (void)rewind {
    [_result setValue:nil];
    _looseCounter = 0.0;
    __resultSent = NO;
    [_history rewind];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Level(%lu, %@)", (unsigned long)_number, _rules];
}

- (void)start {
}

- (void)stop {
}

- (CNClassType*)type {
    return [TRLevel type];
}

+ (CNSignal*)crashed {
    return _TRLevel_crashed;
}

+ (CNSignal*)knockedDown {
    return _TRLevel_knockedDown;
}

+ (CNSignal*)damaged {
    return _TRLevel_damaged;
}

+ (CNSignal*)sporadicDamaged {
    return _TRLevel_sporadicDamaged;
}

+ (CNSignal*)runRepairer {
    return _TRLevel_runRepairer;
}

+ (CNSignal*)fixedDamage {
    return _TRLevel_fixedDamage;
}

+ (CNSignal*)wan {
    return _TRLevel_wan;
}

+ (CNClassType*)type {
    return _TRLevel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRHelp
static CNClassType* _TRHelp_type;
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
    if(self == [TRHelp class]) _TRHelp_type = [CNClassType classTypeWithCls:[TRHelp class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Help(%@)", _text];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRHelp class]])) return NO;
    TRHelp* o = ((TRHelp*)(to));
    return [_text isEqual:o.text];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_text hash];
    return hash;
}

- (CNClassType*)type {
    return [TRHelp type];
}

+ (CNClassType*)type {
    return _TRHelp_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRLevelResult
static CNClassType* _TRLevelResult_type;
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
    if(self == [TRLevelResult class]) _TRLevelResult_type = [CNClassType classTypeWithCls:[TRLevelResult class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"LevelResult(%d)", _win];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRLevelResult class]])) return NO;
    TRLevelResult* o = ((TRLevelResult*)(to));
    return _win == o.win;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + _win;
    return hash;
}

- (CNClassType*)type {
    return [TRLevelResult type];
}

+ (CNClassType*)type {
    return _TRLevelResult_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

TRLevelTheme* TRLevelTheme_Values[5];
TRLevelTheme* TRLevelTheme_forest_Desc;
TRLevelTheme* TRLevelTheme_winter_Desc;
TRLevelTheme* TRLevelTheme_leafForest_Desc;
TRLevelTheme* TRLevelTheme_palm_Desc;
@implementation TRLevelTheme{
    NSString* _background;
    TRForestRules* _forestRules;
}
@synthesize background = _background;
@synthesize forestRules = _forestRules;

+ (instancetype)levelThemeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name background:(NSString*)background forestRules:(TRForestRules*)forestRules dark:(BOOL)dark {
    return [[TRLevelTheme alloc] initWithOrdinal:ordinal name:name background:background forestRules:forestRules dark:dark];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name background:(NSString*)background forestRules:(TRForestRules*)forestRules dark:(BOOL)dark {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _background = background;
        _forestRules = forestRules;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    TRLevelTheme_forest_Desc = [TRLevelTheme levelThemeWithOrdinal:0 name:@"forest" background:@"Grass" forestRules:[TRForestRules forestRulesWithForestType:TRForestType_Pine thickness:2.0] dark:YES];
    TRLevelTheme_winter_Desc = [TRLevelTheme levelThemeWithOrdinal:1 name:@"winter" background:@"Snow" forestRules:[TRForestRules forestRulesWithForestType:TRForestType_SnowPine thickness:2.0] dark:NO];
    TRLevelTheme_leafForest_Desc = [TRLevelTheme levelThemeWithOrdinal:2 name:@"leafForest" background:@"Grass2" forestRules:[TRForestRules forestRulesWithForestType:TRForestType_Leaf thickness:2.0] dark:YES];
    TRLevelTheme_palm_Desc = [TRLevelTheme levelThemeWithOrdinal:3 name:@"palm" background:@"PalmGrass" forestRules:[TRForestRules forestRulesWithForestType:TRForestType_Palm thickness:1.5] dark:YES];
    TRLevelTheme_Values[0] = nil;
    TRLevelTheme_Values[1] = TRLevelTheme_forest_Desc;
    TRLevelTheme_Values[2] = TRLevelTheme_winter_Desc;
    TRLevelTheme_Values[3] = TRLevelTheme_leafForest_Desc;
    TRLevelTheme_Values[4] = TRLevelTheme_palm_Desc;
}

+ (NSArray*)values {
    return (@[TRLevelTheme_forest_Desc, TRLevelTheme_winter_Desc, TRLevelTheme_leafForest_Desc, TRLevelTheme_palm_Desc]);
}

+ (TRLevelTheme*)value:(TRLevelThemeR)r {
    return TRLevelTheme_Values[r];
}

@end

@implementation TRNotifications
static CNClassType* _TRNotifications_type;

+ (instancetype)notifications {
    return [[TRNotifications alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _queue = [CNConcurrentQueue concurrentQueue];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRNotifications class]) _TRNotifications_type = [CNClassType classTypeWithCls:[TRNotifications class]];
}

- (void)notifyNotification:(NSString*)notification {
    [_queue enqueueItem:notification];
}

- (BOOL)isEmpty {
    return [_queue isEmpty];
}

- (NSString*)take {
    return [_queue dequeue];
}

- (NSString*)description {
    return @"Notifications";
}

- (CNClassType*)type {
    return [TRNotifications type];
}

+ (CNClassType*)type {
    return _TRNotifications_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

