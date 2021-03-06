#import "TRCity.h"

#import "TRStrings.h"
#import "TRTrain.h"
#import "PGCollisionBody.h"
#import "TRLevel.h"
#import "PGSchedule.h"
#import "PGDynamicWorld.h"
#import "PGMat4.h"
#import "CNReact.h"
#import "CNObserver.h"
TRCityColor* TRCityColor_Values[11];
TRCityColor* TRCityColor_orange_Desc;
TRCityColor* TRCityColor_green_Desc;
TRCityColor* TRCityColor_pink_Desc;
TRCityColor* TRCityColor_beige_Desc;
TRCityColor* TRCityColor_purple_Desc;
TRCityColor* TRCityColor_blue_Desc;
TRCityColor* TRCityColor_red_Desc;
TRCityColor* TRCityColor_mint_Desc;
TRCityColor* TRCityColor_yellow_Desc;
TRCityColor* TRCityColor_grey_Desc;
@implementation TRCityColor{
    PGVec4 _color;
    NSString*(^_localNameFunc)();
    PGVec4 _trainColor;
}
@synthesize color = _color;
@synthesize localNameFunc = _localNameFunc;
@synthesize trainColor = _trainColor;

+ (instancetype)cityColorWithOrdinal:(NSUInteger)ordinal name:(NSString*)name color:(PGVec4)color localNameFunc:(NSString*(^)())localNameFunc {
    return [[TRCityColor alloc] initWithOrdinal:ordinal name:name color:color localNameFunc:localNameFunc];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name color:(PGVec4)color localNameFunc:(NSString*(^)())localNameFunc {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _color = color;
        _localNameFunc = [localNameFunc copy];
        _trainColor = color;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    TRCityColor_orange_Desc = [TRCityColor cityColorWithOrdinal:0 name:@"orange" color:pgVec4DivI((PGVec4Make(247.0, 156.0, 37.0, 255.0)), 255) localNameFunc:^NSString*() {
        return [[TRStr Loc] colorOrange];
    }];
    TRCityColor_green_Desc = [TRCityColor cityColorWithOrdinal:1 name:@"green" color:PGVec4Make(0.66, 0.9, 0.44, 1.0) localNameFunc:^NSString*() {
        return [[TRStr Loc] colorGreen];
    }];
    TRCityColor_pink_Desc = [TRCityColor cityColorWithOrdinal:2 name:@"pink" color:pgVec4DivI((PGVec4Make(255.0, 153.0, 206.0, 255.0)), 255) localNameFunc:^NSString*() {
        return [[TRStr Loc] colorPink];
    }];
    TRCityColor_beige_Desc = [TRCityColor cityColorWithOrdinal:3 name:@"beige" color:pgVec4DivI((PGVec4Make(230.0, 212.0, 184.0, 255.0)), 255) localNameFunc:^NSString*() {
        return [[TRStr Loc] colorBeige];
    }];
    TRCityColor_purple_Desc = [TRCityColor cityColorWithOrdinal:4 name:@"purple" color:PGVec4Make(0.66, 0.44, 0.9, 1.0) localNameFunc:^NSString*() {
        return [[TRStr Loc] colorPurple];
    }];
    TRCityColor_blue_Desc = [TRCityColor cityColorWithOrdinal:5 name:@"blue" color:pgVec4DivI((PGVec4Make(133.0, 158.0, 242.0, 255.0)), 255) localNameFunc:^NSString*() {
        return [[TRStr Loc] colorBlue];
    }];
    TRCityColor_red_Desc = [TRCityColor cityColorWithOrdinal:6 name:@"red" color:pgVec4DivI((PGVec4Make(230.0, 80.0, 85.0, 255.0)), 255) localNameFunc:^NSString*() {
        return [[TRStr Loc] colorRed];
    }];
    TRCityColor_mint_Desc = [TRCityColor cityColorWithOrdinal:7 name:@"mint" color:pgVec4DivI((PGVec4Make(119.0, 217.0, 155.0, 255.0)), 255) localNameFunc:^NSString*() {
        return [[TRStr Loc] colorMint];
    }];
    TRCityColor_yellow_Desc = [TRCityColor cityColorWithOrdinal:8 name:@"yellow" color:pgVec4DivI((PGVec4Make(248.0, 230.0, 28.0, 255.0)), 255) localNameFunc:^NSString*() {
        return [[TRStr Loc] colorYellow];
    }];
    TRCityColor_grey_Desc = [TRCityColor cityColorWithOrdinal:9 name:@"grey" color:PGVec4Make(0.7, 0.7, 0.7, 1.0) localNameFunc:^NSString*() {
        return [[TRStr Loc] colorGrey];
    }];
    TRCityColor_Values[0] = nil;
    TRCityColor_Values[1] = TRCityColor_orange_Desc;
    TRCityColor_Values[2] = TRCityColor_green_Desc;
    TRCityColor_Values[3] = TRCityColor_pink_Desc;
    TRCityColor_Values[4] = TRCityColor_beige_Desc;
    TRCityColor_Values[5] = TRCityColor_purple_Desc;
    TRCityColor_Values[6] = TRCityColor_blue_Desc;
    TRCityColor_Values[7] = TRCityColor_red_Desc;
    TRCityColor_Values[8] = TRCityColor_mint_Desc;
    TRCityColor_Values[9] = TRCityColor_yellow_Desc;
    TRCityColor_Values[10] = TRCityColor_grey_Desc;
}

- (NSString*)localName {
    return _localNameFunc();
}

+ (NSArray*)values {
    return (@[TRCityColor_orange_Desc, TRCityColor_green_Desc, TRCityColor_pink_Desc, TRCityColor_beige_Desc, TRCityColor_purple_Desc, TRCityColor_blue_Desc, TRCityColor_red_Desc, TRCityColor_mint_Desc, TRCityColor_yellow_Desc, TRCityColor_grey_Desc]);
}

+ (TRCityColor*)value:(TRCityColorR)r {
    return TRCityColor_Values[r];
}

@end

TRCityAngle* TRCityAngle_Values[5];
TRCityAngle* TRCityAngle_angle0_Desc;
TRCityAngle* TRCityAngle_angle90_Desc;
TRCityAngle* TRCityAngle_angle180_Desc;
TRCityAngle* TRCityAngle_angle270_Desc;
@implementation TRCityAngle{
    NSInteger _angle;
    TRRailFormR _form;
    BOOL _back;
}
@synthesize angle = _angle;
@synthesize form = _form;
@synthesize back = _back;

+ (instancetype)cityAngleWithOrdinal:(NSUInteger)ordinal name:(NSString*)name angle:(NSInteger)angle form:(TRRailFormR)form back:(BOOL)back {
    return [[TRCityAngle alloc] initWithOrdinal:ordinal name:name angle:angle form:form back:back];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name angle:(NSInteger)angle form:(TRRailFormR)form back:(BOOL)back {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _angle = angle;
        _form = form;
        _back = back;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    TRCityAngle_angle0_Desc = [TRCityAngle cityAngleWithOrdinal:0 name:@"angle0" angle:0 form:TRRailForm_leftRight back:NO];
    TRCityAngle_angle90_Desc = [TRCityAngle cityAngleWithOrdinal:1 name:@"angle90" angle:90 form:TRRailForm_bottomTop back:YES];
    TRCityAngle_angle180_Desc = [TRCityAngle cityAngleWithOrdinal:2 name:@"angle180" angle:180 form:TRRailForm_leftRight back:YES];
    TRCityAngle_angle270_Desc = [TRCityAngle cityAngleWithOrdinal:3 name:@"angle270" angle:270 form:TRRailForm_bottomTop back:NO];
    TRCityAngle_Values[0] = nil;
    TRCityAngle_Values[1] = TRCityAngle_angle0_Desc;
    TRCityAngle_Values[2] = TRCityAngle_angle90_Desc;
    TRCityAngle_Values[3] = TRCityAngle_angle180_Desc;
    TRCityAngle_Values[4] = TRCityAngle_angle270_Desc;
}

- (TRRailConnectorR)in {
    if(_back) return [TRRailForm value:_form].end;
    else return [TRRailForm value:_form].start;
}

- (TRRailConnectorR)out {
    if(_back) return [TRRailForm value:_form].start;
    else return [TRRailForm value:_form].end;
}

+ (NSArray*)values {
    return (@[TRCityAngle_angle0_Desc, TRCityAngle_angle90_Desc, TRCityAngle_angle180_Desc, TRCityAngle_angle270_Desc]);
}

+ (TRCityAngle*)value:(TRCityAngleR)r {
    return TRCityAngle_Values[r];
}

@end

@implementation TRCityState
static CNClassType* _TRCityState_type;
@synthesize city = _city;
@synthesize expectedTrainCounterTime = _expectedTrainCounterTime;
@synthesize expectedTrain = _expectedTrain;
@synthesize isWaiting = _isWaiting;

+ (instancetype)cityStateWithCity:(TRCity*)city expectedTrainCounterTime:(CGFloat)expectedTrainCounterTime expectedTrain:(TRTrain*)expectedTrain isWaiting:(BOOL)isWaiting {
    return [[TRCityState alloc] initWithCity:city expectedTrainCounterTime:expectedTrainCounterTime expectedTrain:expectedTrain isWaiting:isWaiting];
}

- (instancetype)initWithCity:(TRCity*)city expectedTrainCounterTime:(CGFloat)expectedTrainCounterTime expectedTrain:(TRTrain*)expectedTrain isWaiting:(BOOL)isWaiting {
    self = [super init];
    if(self) {
        _city = city;
        _expectedTrainCounterTime = expectedTrainCounterTime;
        _expectedTrain = expectedTrain;
        _isWaiting = isWaiting;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCityState class]) _TRCityState_type = [CNClassType classTypeWithCls:[TRCityState class]];
}

- (BOOL)canRunNewTrain {
    return _expectedTrain == nil;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CityState(%@, %f, %@, %d)", _city, _expectedTrainCounterTime, _expectedTrain, _isWaiting];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRCityState class]])) return NO;
    TRCityState* o = ((TRCityState*)(to));
    return [_city isEqual:o->_city] && eqf(_expectedTrainCounterTime, o->_expectedTrainCounterTime) && [_expectedTrain isEqual:o->_expectedTrain] && _isWaiting == o->_isWaiting;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_city hash];
    hash = hash * 31 + floatHash(_expectedTrainCounterTime);
    hash = hash * 31 + [((TRTrain*)(_expectedTrain)) hash];
    hash = hash * 31 + _isWaiting;
    return hash;
}

- (CNClassType*)type {
    return [TRCityState type];
}

+ (CNClassType*)type {
    return _TRCityState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRCity
static PGCollisionBox* _TRCity_box;
static CNClassType* _TRCity_type;
@synthesize level = _level;
@synthesize color = _color;
@synthesize tile = _tile;
@synthesize angle = _angle;
@synthesize left = _left;
@synthesize right = _right;
@synthesize bottom = _bottom;
@synthesize top = _top;
@synthesize bodies = _bodies;

+ (instancetype)cityWithLevel:(TRLevel*)level color:(TRCityColorR)color tile:(PGVec2i)tile angle:(TRCityAngleR)angle {
    return [[TRCity alloc] initWithLevel:level color:color tile:tile angle:angle];
}

- (instancetype)initWithLevel:(TRLevel*)level color:(TRCityColorR)color tile:(PGVec2i)tile angle:(TRCityAngleR)angle {
    self = [super init];
    if(self) {
        _level = level;
        _color = color;
        _tile = tile;
        _angle = angle;
        _left = [level->_map isLeftTile:tile];
        _right = [level->_map isRightTile:tile];
        _bottom = [level->_map isBottomTile:tile];
        _top = [level->_map isTopTile:tile];
        __expectedTrainCounter = [PGCounter apply];
        __wasSentIsAboutToRun = NO;
        __isWaiting = NO;
        _bodies = ({
            PGRigidBody* a = [PGRigidBody staticalData:nil shape:_TRCity_box];
            PGRigidBody* b = [PGRigidBody staticalData:nil shape:_TRCity_box];
            PGMat4* moveYa = [[PGMat4 identity] translateX:0.0 y:0.3 z:0.0];
            PGMat4* moveYb = [[PGMat4 identity] translateX:0.0 y:-0.3 z:0.0];
            PGMat4* rotate = [[PGMat4 identity] rotateAngle:((float)([TRCityAngle value:angle].angle)) x:0.0 y:0.0 z:-1.0];
            PGMat4* moveTile = [[PGMat4 identity] translateX:((float)(tile.x)) y:((float)(tile.y)) z:0.0];
            a.matrix = [[moveTile mulMatrix:rotate] mulMatrix:moveYa];
            b.matrix = [[moveTile mulMatrix:rotate] mulMatrix:moveYb];
            (@[a, b]);
        });
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCity class]) {
        _TRCity_type = [CNClassType classTypeWithCls:[TRCity class]];
        _TRCity_box = [PGCollisionBox applyX:0.9 y:0.2 z:0.15];
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<City: %@, %@/%ld>", [TRCityColor value:_color].name, pgVec2iDescription(_tile), (long)[TRCityAngle value:_angle].angle];
}

- (TRRailPoint)startPoint {
    return trRailPointApplyTileFormXBack(_tile, [TRCityAngle value:_angle].form, [self startPointX], [TRCityAngle value:_angle].back);
}

- (CGFloat)startPointX {
    if(_left || _right) {
        return 0.45;
    } else {
        if(_top) {
            if(uwrap(PGCameraReserve, [_level->_cameraReserves value]).top > 0.4) {
                return -0.45;
            } else {
                if(uwrap(PGCameraReserve, [_level->_cameraReserves value]).top > 0.2) return 0.0;
                else return 0.4;
            }
        } else {
            if(_bottom) {
                if(uwrap(PGCameraReserve, [_level->_cameraReserves value]).bottom > 0.01) {
                    if(unumf4([_level->_viewRatio value]) < 1.34) return -0.35;
                    else return -0.45;
                } else {
                    return -0.35;
                }
            } else {
                return 0.5;
            }
        }
    }
}

- (TRCityState*)state {
    return [TRCityState cityStateWithCity:self expectedTrainCounterTime:unumf([[[self expectedTrainCounter] time] value]) expectedTrain:__expectedTrain isWaiting:__isWaiting];
}

- (TRCity*)restoreState:(TRCityState*)state {
    __isWaiting = state->_isWaiting;
    if(state->_expectedTrain != nil) {
        [self expectTrain:((TRTrain*)(nonnil(state->_expectedTrain)))];
        [[__expectedTrainCounter time] setValue:numf(state->_expectedTrainCounterTime)];
    } else {
        __expectedTrain = nil;
        __expectedTrainCounter = [PGEmptyCounter instance];
    }
    return self;
}

- (TRTrain*)expectedTrain {
    return __expectedTrain;
}

- (void)expectTrain:(TRTrain*)train {
    __expectedTrain = train;
    __expectedTrainCounter = [PGCounter applyLength:((CGFloat)(_level->_rules->_trainComingPeriod))];
    __wasSentIsAboutToRun = NO;
}

- (PGCounter*)expectedTrainCounter {
    if(__isWaiting) return ((PGCounter*)([PGEmptyCounter instance]));
    else return __expectedTrainCounter;
}

- (void)updateWithDelta:(CGFloat)delta {
    if(!(__isWaiting) && __expectedTrain != nil) {
        [__expectedTrainCounter updateWithDelta:delta];
        if(!(unumb([[__expectedTrainCounter isRunning] value]))) {
            [_level addTrain:__expectedTrain];
            [((TRTrain*)(__expectedTrain)) startFromCity:self];
            __expectedTrain = nil;
            __wasSentIsAboutToRun = NO;
        } else {
            if(unumf([[__expectedTrainCounter time] value]) > 0.9 && !(__wasSentIsAboutToRun)) {
                __wasSentIsAboutToRun = YES;
                [_level->_trainIsAboutToRun postData:tuple(__expectedTrain, self)];
            }
        }
    }
}

- (void)waitToRunTrain {
    __isWaiting = YES;
}

- (BOOL)isWaitingToRunTrain {
    return __isWaiting && unumb([[__expectedTrainCounter isRunning] value]);
}

- (void)resumeTrainRunning {
    __isWaiting = NO;
}

- (BOOL)canRunNewTrain {
    return !(unumb([[__expectedTrainCounter isRunning] value]));
}

- (CNClassType*)type {
    return [TRCity type];
}

+ (PGCollisionBox*)box {
    return _TRCity_box;
}

+ (CNClassType*)type {
    return _TRCity_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

