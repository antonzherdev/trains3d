#import "TRCity.h"

#import "TRStrings.h"
#import "EGCollisionBody.h"
#import "TRLevel.h"
#import "EGSchedule.h"
#import "EGDynamicWorld.h"
#import "GEMat4.h"
#import "ATReact.h"
#import "TRTrain.h"
#import "ATObserver.h"
@implementation TRCityColor{
    GEVec4 _color;
    NSString*(^_localNameFunc)();
    GEVec4 _trainColor;
}
static TRCityColor* _TRCityColor_orange;
static TRCityColor* _TRCityColor_green;
static TRCityColor* _TRCityColor_pink;
static TRCityColor* _TRCityColor_beige;
static TRCityColor* _TRCityColor_purple;
static TRCityColor* _TRCityColor_blue;
static TRCityColor* _TRCityColor_red;
static TRCityColor* _TRCityColor_mint;
static TRCityColor* _TRCityColor_yellow;
static TRCityColor* _TRCityColor_grey;
static NSArray* _TRCityColor_values;
@synthesize color = _color;
@synthesize localNameFunc = _localNameFunc;
@synthesize trainColor = _trainColor;

+ (instancetype)cityColorWithOrdinal:(NSUInteger)ordinal name:(NSString*)name color:(GEVec4)color localNameFunc:(NSString*(^)())localNameFunc {
    return [[TRCityColor alloc] initWithOrdinal:ordinal name:name color:color localNameFunc:localNameFunc];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name color:(GEVec4)color localNameFunc:(NSString*(^)())localNameFunc {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _color = color;
        _localNameFunc = [localNameFunc copy];
        _trainColor = _color;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCityColor_orange = [TRCityColor cityColorWithOrdinal:0 name:@"orange" color:geVec4DivF4((GEVec4Make(247.0, 156.0, 37.0, 255.0)), 255.0) localNameFunc:^NSString*() {
        return [TRStr.Loc colorOrange];
    }];
    _TRCityColor_green = [TRCityColor cityColorWithOrdinal:1 name:@"green" color:GEVec4Make(0.66, 0.9, 0.44, 1.0) localNameFunc:^NSString*() {
        return [TRStr.Loc colorGreen];
    }];
    _TRCityColor_pink = [TRCityColor cityColorWithOrdinal:2 name:@"pink" color:geVec4DivF4((GEVec4Make(255.0, 153.0, 206.0, 255.0)), 255.0) localNameFunc:^NSString*() {
        return [TRStr.Loc colorPink];
    }];
    _TRCityColor_beige = [TRCityColor cityColorWithOrdinal:3 name:@"beige" color:geVec4DivF4((GEVec4Make(230.0, 212.0, 184.0, 255.0)), 255.0) localNameFunc:^NSString*() {
        return [TRStr.Loc colorBeige];
    }];
    _TRCityColor_purple = [TRCityColor cityColorWithOrdinal:4 name:@"purple" color:GEVec4Make(0.66, 0.44, 0.9, 1.0) localNameFunc:^NSString*() {
        return [TRStr.Loc colorPurple];
    }];
    _TRCityColor_blue = [TRCityColor cityColorWithOrdinal:5 name:@"blue" color:geVec4DivF4((GEVec4Make(133.0, 158.0, 242.0, 255.0)), 255.0) localNameFunc:^NSString*() {
        return [TRStr.Loc colorBlue];
    }];
    _TRCityColor_red = [TRCityColor cityColorWithOrdinal:6 name:@"red" color:geVec4DivF4((GEVec4Make(230.0, 80.0, 85.0, 255.0)), 255.0) localNameFunc:^NSString*() {
        return [TRStr.Loc colorRed];
    }];
    _TRCityColor_mint = [TRCityColor cityColorWithOrdinal:7 name:@"mint" color:geVec4DivF4((GEVec4Make(119.0, 217.0, 155.0, 255.0)), 255.0) localNameFunc:^NSString*() {
        return [TRStr.Loc colorMint];
    }];
    _TRCityColor_yellow = [TRCityColor cityColorWithOrdinal:8 name:@"yellow" color:geVec4DivF4((GEVec4Make(248.0, 230.0, 28.0, 255.0)), 255.0) localNameFunc:^NSString*() {
        return [TRStr.Loc colorYellow];
    }];
    _TRCityColor_grey = [TRCityColor cityColorWithOrdinal:9 name:@"grey" color:GEVec4Make(0.7, 0.7, 0.7, 1.0) localNameFunc:^NSString*() {
        return [TRStr.Loc colorGrey];
    }];
    _TRCityColor_values = (@[_TRCityColor_orange, _TRCityColor_green, _TRCityColor_pink, _TRCityColor_beige, _TRCityColor_purple, _TRCityColor_blue, _TRCityColor_red, _TRCityColor_mint, _TRCityColor_yellow, _TRCityColor_grey]);
}

- (NSString*)localName {
    return _localNameFunc();
}

+ (TRCityColor*)orange {
    return _TRCityColor_orange;
}

+ (TRCityColor*)green {
    return _TRCityColor_green;
}

+ (TRCityColor*)pink {
    return _TRCityColor_pink;
}

+ (TRCityColor*)beige {
    return _TRCityColor_beige;
}

+ (TRCityColor*)purple {
    return _TRCityColor_purple;
}

+ (TRCityColor*)blue {
    return _TRCityColor_blue;
}

+ (TRCityColor*)red {
    return _TRCityColor_red;
}

+ (TRCityColor*)mint {
    return _TRCityColor_mint;
}

+ (TRCityColor*)yellow {
    return _TRCityColor_yellow;
}

+ (TRCityColor*)grey {
    return _TRCityColor_grey;
}

+ (NSArray*)values {
    return _TRCityColor_values;
}

@end


@implementation TRCityAngle{
    NSInteger _angle;
    TRRailForm* _form;
    BOOL _back;
}
static TRCityAngle* _TRCityAngle_angle0;
static TRCityAngle* _TRCityAngle_angle90;
static TRCityAngle* _TRCityAngle_angle180;
static TRCityAngle* _TRCityAngle_angle270;
static NSArray* _TRCityAngle_values;
@synthesize angle = _angle;
@synthesize form = _form;
@synthesize back = _back;

+ (instancetype)cityAngleWithOrdinal:(NSUInteger)ordinal name:(NSString*)name angle:(NSInteger)angle form:(TRRailForm*)form back:(BOOL)back {
    return [[TRCityAngle alloc] initWithOrdinal:ordinal name:name angle:angle form:form back:back];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name angle:(NSInteger)angle form:(TRRailForm*)form back:(BOOL)back {
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
    _TRCityAngle_angle0 = [TRCityAngle cityAngleWithOrdinal:0 name:@"angle0" angle:0 form:TRRailForm.leftRight back:NO];
    _TRCityAngle_angle90 = [TRCityAngle cityAngleWithOrdinal:1 name:@"angle90" angle:90 form:TRRailForm.bottomTop back:YES];
    _TRCityAngle_angle180 = [TRCityAngle cityAngleWithOrdinal:2 name:@"angle180" angle:180 form:TRRailForm.leftRight back:YES];
    _TRCityAngle_angle270 = [TRCityAngle cityAngleWithOrdinal:3 name:@"angle270" angle:270 form:TRRailForm.bottomTop back:NO];
    _TRCityAngle_values = (@[_TRCityAngle_angle0, _TRCityAngle_angle90, _TRCityAngle_angle180, _TRCityAngle_angle270]);
}

- (TRRailConnector*)in {
    if(_back) return _form.end;
    else return _form.start;
}

- (TRRailConnector*)out {
    if(_back) return _form.start;
    else return _form.end;
}

+ (TRCityAngle*)angle0 {
    return _TRCityAngle_angle0;
}

+ (TRCityAngle*)angle90 {
    return _TRCityAngle_angle90;
}

+ (TRCityAngle*)angle180 {
    return _TRCityAngle_angle180;
}

+ (TRCityAngle*)angle270 {
    return _TRCityAngle_angle270;
}

+ (NSArray*)values {
    return _TRCityAngle_values;
}

@end


@implementation TRCityState
static ODClassType* _TRCityState_type;
@synthesize city = _city;
@synthesize expectedTrainCounterTime = _expectedTrainCounterTime;
@synthesize expectedTrain = _expectedTrain;
@synthesize isWaiting = _isWaiting;

+ (instancetype)cityStateWithCity:(TRCity*)city expectedTrainCounterTime:(CGFloat)expectedTrainCounterTime expectedTrain:(id)expectedTrain isWaiting:(BOOL)isWaiting {
    return [[TRCityState alloc] initWithCity:city expectedTrainCounterTime:expectedTrainCounterTime expectedTrain:expectedTrain isWaiting:isWaiting];
}

- (instancetype)initWithCity:(TRCity*)city expectedTrainCounterTime:(CGFloat)expectedTrainCounterTime expectedTrain:(id)expectedTrain isWaiting:(BOOL)isWaiting {
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
    if(self == [TRCityState class]) _TRCityState_type = [ODClassType classTypeWithCls:[TRCityState class]];
}

- (ODClassType*)type {
    return [TRCityState type];
}

+ (ODClassType*)type {
    return _TRCityState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRCityState* o = ((TRCityState*)(other));
    return [self.city isEqual:o.city] && eqf(self.expectedTrainCounterTime, o.expectedTrainCounterTime) && [self.expectedTrain isEqual:o.expectedTrain] && self.isWaiting == o.isWaiting;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.city hash];
    hash = hash * 31 + floatHash(self.expectedTrainCounterTime);
    hash = hash * 31 + [self.expectedTrain hash];
    hash = hash * 31 + self.isWaiting;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"city=%@", self.city];
    [description appendFormat:@", expectedTrainCounterTime=%f", self.expectedTrainCounterTime];
    [description appendFormat:@", expectedTrain=%@", self.expectedTrain];
    [description appendFormat:@", isWaiting=%d", self.isWaiting];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRCity
static EGCollisionBox* _TRCity_box;
static ODClassType* _TRCity_type;
@synthesize level = _level;
@synthesize color = _color;
@synthesize tile = _tile;
@synthesize angle = _angle;
@synthesize left = _left;
@synthesize right = _right;
@synthesize bottom = _bottom;
@synthesize top = _top;
@synthesize bodies = _bodies;

+ (instancetype)cityWithLevel:(TRLevel*)level color:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle {
    return [[TRCity alloc] initWithLevel:level color:color tile:tile angle:angle];
}

- (instancetype)initWithLevel:(TRLevel*)level color:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle {
    self = [super init];
    if(self) {
        _level = level;
        _color = color;
        _tile = tile;
        _angle = angle;
        _left = [_level.map isLeftTile:_tile];
        _right = [_level.map isRightTile:_tile];
        _bottom = [_level.map isBottomTile:_tile];
        _top = [_level.map isTopTile:_tile];
        __expectedTrainCounter = [EGCounter apply];
        __wasSentIsAboutToRun = NO;
        __isWaiting = NO;
        _bodies = ^NSArray*() {
            EGRigidBody* a = [EGRigidBody staticalData:nil shape:_TRCity_box];
            EGRigidBody* b = [EGRigidBody staticalData:nil shape:_TRCity_box];
            GEMat4* moveYa = [[GEMat4 identity] translateX:0.0 y:0.3 z:0.0];
            GEMat4* moveYb = [[GEMat4 identity] translateX:0.0 y:-0.3 z:0.0];
            GEMat4* rotate = [[GEMat4 identity] rotateAngle:((float)(_angle.angle)) x:0.0 y:0.0 z:-1.0];
            GEMat4* moveTile = [[GEMat4 identity] translateX:((float)(_tile.x)) y:((float)(_tile.y)) z:0.0];
            a.matrix = [[moveTile mulMatrix:rotate] mulMatrix:moveYa];
            b.matrix = [[moveTile mulMatrix:rotate] mulMatrix:moveYb];
            return (@[a, b]);
        }();
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCity class]) {
        _TRCity_type = [ODClassType classTypeWithCls:[TRCity class]];
        _TRCity_box = [EGCollisionBox applyX:0.9 y:0.2 z:0.15];
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<City: %@, %@/%ld>", _color.name, GEVec2iDescription(_tile), (long)_angle.angle];
}

- (TRRailPoint)startPoint {
    return trRailPointApplyTileFormXBack(_tile, _angle.form, [self startPointX], _angle.back);
}

- (CGFloat)startPointX {
    if(_left || _right) {
        return 0.45;
    } else {
        if(_top) {
            if(uwrap(EGCameraReserve, [_level.cameraReserves value]).top > 0.4) {
                return -0.35;
            } else {
                if(uwrap(EGCameraReserve, [_level.cameraReserves value]).top > 0.2) return 0.1;
                else return 0.4;
            }
        } else {
            if(_bottom) {
                if(uwrap(EGCameraReserve, [_level.cameraReserves value]).bottom > 0.01) {
                    if(unumf4([_level.viewRatio value]) < 1.34) return -0.2;
                    else return -0.45;
                } else {
                    return -0.1;
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
    __isWaiting = state.isWaiting;
    if([state.expectedTrain isDefined]) {
        [self expectTrain:[state.expectedTrain get]];
        [[__expectedTrainCounter time] setValue:numf(state.expectedTrainCounterTime)];
    } else {
        __expectedTrain = [CNOption none];
        __expectedTrainCounter = EGEmptyCounter.instance;
    }
    return self;
}

- (id)expectedTrain {
    return __expectedTrain;
}

- (void)expectTrain:(TRTrain*)train {
    __expectedTrain = [CNOption applyValue:train];
    __expectedTrainCounter = [EGCounter applyLength:((CGFloat)(TRLevel.trainComingPeriod))];
    __wasSentIsAboutToRun = NO;
}

- (EGCounter*)expectedTrainCounter {
    if(__isWaiting) return ((EGCounter*)(EGEmptyCounter.instance));
    else return __expectedTrainCounter;
}

- (void)updateWithDelta:(CGFloat)delta {
    if(!(__isWaiting) && [__expectedTrain isDefined]) {
        [__expectedTrainCounter updateWithDelta:delta];
        if(!(unumb([[__expectedTrainCounter isRunning] value]))) {
            [_level addTrain:[__expectedTrain get]];
            [((TRTrain*)([__expectedTrain get])) startFromCity:self];
            __expectedTrain = [CNOption none];
            __wasSentIsAboutToRun = NO;
        } else {
            if(unumf([[__expectedTrainCounter time] value]) > 0.9 && !(__wasSentIsAboutToRun)) {
                __wasSentIsAboutToRun = YES;
                [_level.trainIsAboutToRun postData:tuple([__expectedTrain get], self)];
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

- (ODClassType*)type {
    return [TRCity type];
}

+ (EGCollisionBox*)box {
    return _TRCity_box;
}

+ (ODClassType*)type {
    return _TRCity_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


