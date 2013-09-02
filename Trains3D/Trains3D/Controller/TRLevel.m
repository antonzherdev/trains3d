#import "TRLevel.h"

#import "CNChain.h"
#import "EGMapIso.h"
#import "EGCollisions.h"
#import "EGSchedule.h"
#import "TRCity.h"
#import "TRTypes.h"
#import "TRRailroad.h"
#import "TRRailPoint.h"
#import "TRTrain.h"
#import "TRScore.h"
@implementation TRLevelRules{
    EGSizeI _mapSize;
    TRScoreRules* _scoreRules;
    NSUInteger _repairerSpeed;
    id<CNSeq> _events;
}
static ODClassType* _TRLevelRules_type;
@synthesize mapSize = _mapSize;
@synthesize scoreRules = _scoreRules;
@synthesize repairerSpeed = _repairerSpeed;
@synthesize events = _events;

+ (id)levelRulesWithMapSize:(EGSizeI)mapSize scoreRules:(TRScoreRules*)scoreRules repairerSpeed:(NSUInteger)repairerSpeed events:(id<CNSeq>)events {
    return [[TRLevelRules alloc] initWithMapSize:mapSize scoreRules:scoreRules repairerSpeed:repairerSpeed events:events];
}

- (id)initWithMapSize:(EGSizeI)mapSize scoreRules:(TRScoreRules*)scoreRules repairerSpeed:(NSUInteger)repairerSpeed events:(id<CNSeq>)events {
    self = [super init];
    if(self) {
        _mapSize = mapSize;
        _scoreRules = scoreRules;
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
    return EGSizeIEq(self.mapSize, o.mapSize) && [self.scoreRules isEqual:o.scoreRules] && self.repairerSpeed == o.repairerSpeed && [self.events isEqual:o.events];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGSizeIHash(self.mapSize);
    hash = hash * 31 + [self.scoreRules hash];
    hash = hash * 31 + self.repairerSpeed;
    hash = hash * 31 + [self.events hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"mapSize=%@", EGSizeIDescription(self.mapSize)];
    [description appendFormat:@", scoreRules=%@", self.scoreRules];
    [description appendFormat:@", repairerSpeed=%li", self.repairerSpeed];
    [description appendFormat:@", events=%@", self.events];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRLevel{
    TRLevelRules* _rules;
    EGMapSso* _map;
    TRScore* _score;
    TRRailroad* _railroad;
    NSMutableArray* __cities;
    EGSchedule* _schedule;
    id<CNSeq> __trains;
    id __repairer;
}
static ODClassType* _TRLevel_type;
@synthesize rules = _rules;
@synthesize map = _map;
@synthesize score = _score;
@synthesize railroad = _railroad;
@synthesize schedule = _schedule;

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
        __cities = [NSMutableArray mutableArray];
        _schedule = [self createSchedule];
        __trains = (@[]);
        __repairer = [CNOption none];
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

- (EGSchedule*)createSchedule {
    EGSchedule* schedule = [EGSchedule schedule];
    [self createNewCity];
    [self createNewCity];
    [_rules.events forEach:^void(CNTuple* t) {
        void(^f)(TRLevel*) = t.b;
        [schedule scheduleEvent:^void() {
            f(self);
        } after:unumf(t.a)];
    }];
    return schedule;
}

- (void)createNewCity {
    EGPointI tile = uwrap(EGPointI, [[[[_map.partialTiles chain] exclude:[[[self cities] chain] map:^id(TRCity* _) {
        return wrap(EGPointI, _.tile);
    }]] randomItem] get]);
    TRCity* city = [TRCity cityWithColor:[TRColor values][[[self cities] count]] tile:tile angle:[self randomCityDirectionForTile:tile]];
    [_railroad tryAddRail:[TRRail railWithTile:tile form:city.angle.form]];
    [__cities addObject:city];
}

- (TRCityAngle*)randomCityDirectionForTile:(EGPointI)tile {
    EGRectI cut = [_map cutRectForTile:tile];
    return ((TRCityAngle*)([[[[[TRCityAngle values] chain] filter:^BOOL(TRCityAngle* a) {
        NSInteger angle = a.angle;
        return (angle == 0 && egRectIX2(cut) == 0 && egRectIY2(cut) == 0) || (angle == 90 && cut.x == 0 && egRectIY2(cut) == 0) || (angle == 180 && cut.x == 0 && cut.y == 0) || (angle == 270 && egRectIX2(cut) == 0 && cut.y == 0);
    }] randomItem] get]));
}

- (void)runTrain:(TRTrain*)train fromCity:(TRCity*)fromCity {
    fromCity.expectedTrainAnimation = [CNOption opt:[EGAnimation animationWithLength:3.0 finish:^void() {
        fromCity.expectedTrainAnimation = [CNOption none];
        [train startFromCity:fromCity];
        __trains = [__trains arrayByAddingObject:train];
        [_score runTrain:train];
    }]];
}

- (void)runTrainWithGenerator:(TRTrainGenerator*)generator {
    TRCity* city = ((TRCity*)([[__cities randomItem] get]));
    [self runTrain:[TRTrain trainWithLevel:self trainType:generator.trainType color:city.color cars:[generator generateCars] speed:[generator generateSpeed]] fromCity:((TRCity*)([[[[__cities chain] filter:^BOOL(TRCity* _) {
        return !([_ isEqual:city]);
    }] randomItem] get]))];
}

- (void)testRunTrain:(TRTrain*)train fromPoint:(TRRailPoint*)fromPoint {
    [train setHead:fromPoint];
    __trains = [__trains arrayByAddingObject:train];
    [_score runTrain:train];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_score updateWithDelta:delta];
    [__trains forEach:^void(TRTrain* _) {
        [_ updateWithDelta:delta];
    }];
    [__cities forEach:^void(TRCity* _) {
        [_ updateWithDelta:delta];
    }];
    [self processCollisions];
    [_schedule updateWithDelta:delta];
}

- (void)tryTurnTheSwitch:(TRSwitch*)theSwitch {
    if(!([self isLockedTheSwitch:theSwitch])) [theSwitch turn];
}

- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch {
    return [[__trains findWhere:^BOOL(TRTrain* _) {
        return [_ isLockedTheSwitch:theSwitch];
    }] isDefined];
}

- (id)cityForTile:(EGPointI)tile {
    return [__cities findWhere:^BOOL(TRCity* _) {
        return EGPointIEq(_.tile, tile);
    }];
}

- (void)arrivedTrain:(TRTrain*)train {
    [self removeTrain:train];
    [_score arrivedTrain:train];
}

- (void)processCollisions {
    [[self detectCollisions] forEach:^void(EGCollision* collision) {
        [collision.items forEach:^void(CNTuple* _) {
            [self destroyTrain:((TRTrain*)(_.a))];
        }];
        TRCar* car1 = ((TRCar*)(((CNTuple*)(collision.items.a)).b));
        TRCar* car2 = ((TRCar*)(((CNTuple*)(collision.items.b)).b));
        [[[[[[[[(@[car1.head, car1.tail]) chain] mul:(@[car2.head, car2.tail])] sortBy] ascBy:^id(CNTuple* pair) {
            TRRailPoint* x = ((TRRailPoint*)(pair.a));
            TRRailPoint* y = ((TRRailPoint*)(pair.b));
            if(x.form == y.form && EGPointIEq(x.tile, y.tile)) return numf(fabs(x.x - y.x));
            else return @1000;
        }] endSort] map:^TRRailPoint*(CNTuple* _) {
            return ((TRRailPoint*)(_.a));
        }] head] forEach:^void(TRRailPoint* _) {
            [_railroad addDamageAtPoint:_];
        }];
    }];
}

- (id<CNSet>)detectCollisions {
    id<CNSeq> carFigures = [[[__trains chain] flatMap:^CNChain*(TRTrain* train) {
        return [[train.cars chain] map:^CNTuple*(TRCar* car) {
            return tuple(tuple(train, car), [car figure]);
        }];
    }] toArray];
    return [EGCollisions collisionsForFigures:carFigures];
}

- (void)destroyTrain:(TRTrain*)train {
    if([__trains containsObject:train]) {
        [self removeTrain:train];
        [_score destroyedTrain:train];
    }
}

- (void)removeTrain:(TRTrain*)train {
    __trains = [__trains arrayByRemovingObject:train];
    __repairer = [__repairer filter:^BOOL(TRTrain* _) {
        return !([_ isEqual:train]);
    }];
}

- (void)runRepairerFromCity:(TRCity*)city {
    if([__repairer isEmpty]) {
        TRTrain* train = [TRTrain trainWithLevel:self trainType:TRTrainType.repairer color:TRColor.grey cars:(@[[TRCar carWithCarType:TRCarType.engine]]) speed:_rules.repairerSpeed];
        [self runTrain:train fromCity:city];
        __repairer = [CNOption opt:train];
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


