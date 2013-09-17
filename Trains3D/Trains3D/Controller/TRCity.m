#import "TRCity.h"

#import "GL.h"
#import "TRRailPoint.h"
#import "EGSchedule.h"
@implementation TRCityColor{
    GEVec4 _color;
}
static TRCityColor* _TRCityColor_orange;
static TRCityColor* _TRCityColor_green;
static TRCityColor* _TRCityColor_purple;
static TRCityColor* _TRCityColor_grey;
static NSArray* _TRCityColor_values;
@synthesize color = _color;

+ (id)cityColorWithOrdinal:(NSUInteger)ordinal name:(NSString*)name color:(GEVec4)color {
    return [[TRCityColor alloc] initWithOrdinal:ordinal name:name color:color];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name color:(GEVec4)color {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _color = color;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCityColor_orange = [TRCityColor cityColorWithOrdinal:0 name:@"orange" color:GEVec4Make(1.0, 0.5, 0.0, 1.0)];
    _TRCityColor_green = [TRCityColor cityColorWithOrdinal:1 name:@"green" color:GEVec4Make(0.66, 0.9, 0.44, 1.0)];
    _TRCityColor_purple = [TRCityColor cityColorWithOrdinal:2 name:@"purple" color:GEVec4Make(0.9, 0.44, 0.66, 1.0)];
    _TRCityColor_grey = [TRCityColor cityColorWithOrdinal:3 name:@"grey" color:GEVec4Make(0.5, 0.5, 0.5, 1.0)];
    _TRCityColor_values = (@[_TRCityColor_orange, _TRCityColor_green, _TRCityColor_purple, _TRCityColor_grey]);
}

- (void)set {
    egColor(_color);
}

+ (TRCityColor*)orange {
    return _TRCityColor_orange;
}

+ (TRCityColor*)green {
    return _TRCityColor_green;
}

+ (TRCityColor*)purple {
    return _TRCityColor_purple;
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
    id _expectedTrainAnimation;
}
static ODClassType* _TRCity_type;
@synthesize color = _color;
@synthesize tile = _tile;
@synthesize angle = _angle;
@synthesize expectedTrainAnimation = _expectedTrainAnimation;

+ (id)cityWithColor:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle {
    return [[TRCity alloc] initWithColor:color tile:tile angle:angle];
}

- (id)initWithColor:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle {
    self = [super init];
    if(self) {
        _color = color;
        _tile = tile;
        _angle = angle;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCity_type = [ODClassType classTypeWithCls:[TRCity class]];
}

- (TRRailPoint*)startPoint {
    return [TRRailPoint railPointWithTile:_tile form:_angle.form x:0.0 back:_angle.back];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_expectedTrainAnimation forEach:^void(EGAnimation* _) {
        [_ updateWithDelta:delta];
    }];
}

- (ODClassType*)type {
    return [TRCity type];
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


