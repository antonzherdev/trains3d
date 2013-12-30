#import "TRCity.h"

#import "TRStrings.h"
#import "EGCollisionBody.h"
#import "EGSchedule.h"
#import "TRTrain.h"
#import "EGDynamicWorld.h"
#import "GEMat4.h"
@implementation TRCityColor{
    GEVec4 _color;
    NSString* _localName;
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
@synthesize localName = _localName;
@synthesize trainColor = _trainColor;

+ (id)cityColorWithOrdinal:(NSUInteger)ordinal name:(NSString*)name color:(GEVec4)color localName:(NSString*)localName {
    return [[TRCityColor alloc] initWithOrdinal:ordinal name:name color:color localName:localName];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name color:(GEVec4)color localName:(NSString*)localName {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _color = color;
        _localName = localName;
        _trainColor = _color;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCityColor_orange = [TRCityColor cityColorWithOrdinal:0 name:@"orange" color:geVec4DivI(GEVec4Make(247.0, 156.0, 37.0, 255.0), 255) localName:[TRStr.Loc colorOrange]];
    _TRCityColor_green = [TRCityColor cityColorWithOrdinal:1 name:@"green" color:GEVec4Make(0.66, 0.9, 0.44, 1.0) localName:[TRStr.Loc colorGreen]];
    _TRCityColor_pink = [TRCityColor cityColorWithOrdinal:2 name:@"pink" color:geVec4DivI(GEVec4Make(255.0, 153.0, 206.0, 255.0), 255) localName:[TRStr.Loc colorPink]];
    _TRCityColor_beige = [TRCityColor cityColorWithOrdinal:3 name:@"beige" color:geVec4DivI(GEVec4Make(230.0, 212.0, 184.0, 255.0), 255) localName:[TRStr.Loc colorPink]];
    _TRCityColor_purple = [TRCityColor cityColorWithOrdinal:4 name:@"purple" color:GEVec4Make(0.66, 0.44, 0.9, 1.0) localName:[TRStr.Loc colorPurple]];
    _TRCityColor_blue = [TRCityColor cityColorWithOrdinal:5 name:@"blue" color:geVec4DivI(GEVec4Make(133.0, 158.0, 242.0, 255.0), 255) localName:[TRStr.Loc colorBlue]];
    _TRCityColor_red = [TRCityColor cityColorWithOrdinal:6 name:@"red" color:geVec4DivI(GEVec4Make(230.0, 80.0, 85.0, 255.0), 255) localName:[TRStr.Loc colorRed]];
    _TRCityColor_mint = [TRCityColor cityColorWithOrdinal:7 name:@"mint" color:geVec4DivI(GEVec4Make(119.0, 217.0, 155.0, 255.0), 255) localName:[TRStr.Loc colorMint]];
    _TRCityColor_yellow = [TRCityColor cityColorWithOrdinal:8 name:@"yellow" color:geVec4DivI(GEVec4Make(248.0, 230.0, 28.0, 255.0), 255) localName:[TRStr.Loc colorYellow]];
    _TRCityColor_grey = [TRCityColor cityColorWithOrdinal:9 name:@"grey" color:GEVec4Make(0.7, 0.7, 0.7, 1.0) localName:[TRStr.Loc colorGrey]];
    _TRCityColor_values = (@[_TRCityColor_orange, _TRCityColor_green, _TRCityColor_pink, _TRCityColor_beige, _TRCityColor_purple, _TRCityColor_blue, _TRCityColor_red, _TRCityColor_mint, _TRCityColor_yellow, _TRCityColor_grey]);
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

+ (id)cityAngleWithOrdinal:(NSUInteger)ordinal name:(NSString*)name angle:(NSInteger)angle form:(TRRailForm*)form back:(BOOL)back {
    return [[TRCityAngle alloc] initWithOrdinal:ordinal name:name angle:angle form:form back:back];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name angle:(NSInteger)angle form:(TRRailForm*)form back:(BOOL)back {
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


@implementation TRCity{
    TRCityColor* _color;
    GEVec2i _tile;
    TRCityAngle* _angle;
    EGCounter* _expectedTrainCounter;
    TRTrain* _expectedTrain;
    EGCounter* _waitingCounter;
    id<CNSeq> _bodies;
}
static EGCollisionBox* _TRCity_box;
static ODClassType* _TRCity_type;
@synthesize color = _color;
@synthesize tile = _tile;
@synthesize angle = _angle;
@synthesize expectedTrainCounter = _expectedTrainCounter;
@synthesize expectedTrain = _expectedTrain;
@synthesize bodies = _bodies;

+ (id)cityWithColor:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle {
    return [[TRCity alloc] initWithColor:color tile:tile angle:angle];
}

- (id)initWithColor:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle {
    self = [super init];
    if(self) {
        _color = color;
        _tile = tile;
        _angle = angle;
        _expectedTrainCounter = [EGCounter apply];
        _waitingCounter = [EGCounter apply];
        _bodies = ^id<CNSeq>() {
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
    _TRCity_type = [ODClassType classTypeWithCls:[TRCity class]];
    _TRCity_box = [EGCollisionBox applyX:0.9 y:0.2 z:0.15];
}

- (TRRailPoint)startPoint {
    return trRailPointApplyTileFormXBack(_tile, _angle.form, -0.6, _angle.back);
}

- (void)updateWithDelta:(CGFloat)delta {
    [_expectedTrainCounter updateWithDelta:delta];
}

- (void)waitToRunTrain {
    _waitingCounter = _expectedTrainCounter;
    _expectedTrainCounter = [EGCounter apply];
}

- (BOOL)isWaitingToRunTrain {
    return [_waitingCounter isRunning];
}

- (void)resumeTrainRunning {
    _expectedTrainCounter = _waitingCounter;
    _waitingCounter = [EGCounter apply];
}

- (BOOL)canRunNewTrain {
    return [_expectedTrainCounter isStopped] && [_waitingCounter isStopped];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRCity* o = ((TRCity*)(other));
    return self.color == o.color && GEVec2iEq(self.tile, o.tile) && self.angle == o.angle;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.color ordinal];
    hash = hash * 31 + GEVec2iHash(self.tile);
    hash = hash * 31 + [self.angle ordinal];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", self.color];
    [description appendFormat:@", tile=%@", GEVec2iDescription(self.tile)];
    [description appendFormat:@", angle=%@", self.angle];
    [description appendString:@">"];
    return description;
}

@end


