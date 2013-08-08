#import "TRCity.h"

#import "EGMap.h"
#import "TRTypes.h"
#import "TRRailPoint.h"
@implementation TRCityAngle{
    NSInteger _angle;
    TRRailForm* _form;
    BOOL _back;
}
static TRCityAngle* _angle0;
static TRCityAngle* _angle90;
static TRCityAngle* _angle180;
static TRCityAngle* _angle270;
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
    _angle0 = [TRCityAngle cityAngleWithOrdinal:0 name:@"angle0" angle:0 form:[TRRailForm leftRight] back:NO];
    _angle90 = [TRCityAngle cityAngleWithOrdinal:1 name:@"angle90" angle:90 form:[TRRailForm bottomTop] back:YES];
    _angle180 = [TRCityAngle cityAngleWithOrdinal:2 name:@"angle180" angle:180 form:[TRRailForm leftRight] back:YES];
    _angle270 = [TRCityAngle cityAngleWithOrdinal:3 name:@"angle270" angle:270 form:[TRRailForm bottomTop] back:NO];
    _TRCityAngle_values = (@[_angle0, _angle90, _angle180, _angle270]);
}

+ (TRCityAngle*)angle0 {
    return _angle0;
}

+ (TRCityAngle*)angle90 {
    return _angle90;
}

+ (TRCityAngle*)angle180 {
    return _angle180;
}

+ (TRCityAngle*)angle270 {
    return _angle270;
}

+ (NSArray*)values {
    return _TRCityAngle_values;
}

@end


@implementation TRCity{
    TRColor* _color;
    EGPointI _tile;
    TRCityAngle* _angle;
}
@synthesize color = _color;
@synthesize tile = _tile;
@synthesize angle = _angle;

+ (id)cityWithColor:(TRColor*)color tile:(EGPointI)tile angle:(TRCityAngle*)angle {
    return [[TRCity alloc] initWithColor:color tile:tile angle:angle];
}

- (id)initWithColor:(TRColor*)color tile:(EGPointI)tile angle:(TRCityAngle*)angle {
    self = [super init];
    if(self) {
        _color = color;
        _tile = tile;
        _angle = angle;
    }
    
    return self;
}

- (TRRailPoint*)startPoint {
    return [TRRailPoint railPointWithTile:_tile form:_angle.form x:0 back:_angle.back];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRCity* o = ((TRCity*)other);
    return self.color == o.color && EGPointIEq(self.tile, o.tile) && self.angle == o.angle;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.color ordinal];
    hash = hash * 31 + EGPointIHash(self.tile);
    hash = hash * 31 + [self.angle ordinal];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", self.color];
    [description appendFormat:@", tile=%@", EGPointIDescription(self.tile)];
    [description appendFormat:@", angle=%@", self.angle];
    [description appendString:@">"];
    return description;
}

@end


