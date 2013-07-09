#import "TRCity.h"

#import "EGMap.h"
#import "TRTypes.h"
@implementation TRCityAngle{
    NSInteger _angle;
    TRRailForm* _form;
    BOOL _back;
}
static TRCityAngle* _angle0;
static TRCityAngle* _angle90;
static TRCityAngle* _angle180;
static TRCityAngle* _angle270;
static NSArray* values;
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
    values = (@[_angle0, _angle90, _angle180, _angle270]);
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
    return values;
}

@end


@implementation TRCity{
    TRColor* _color;
    EGIPoint _tile;
    TRCityAngle* _angle;
}
@synthesize color = _color;
@synthesize tile = _tile;
@synthesize angle = _angle;

+ (id)cityWithColor:(TRColor*)color tile:(EGIPoint)tile angle:(TRCityAngle*)angle {
    return [[TRCity alloc] initWithColor:color tile:tile angle:angle];
}

- (id)initWithColor:(TRColor*)color tile:(EGIPoint)tile angle:(TRCityAngle*)angle {
    self = [super init];
    if(self) {
        _color = color;
        _tile = tile;
        _angle = angle;
    }
    
    return self;
}

- (TRRailPoint)startPoint {
    return TRRailPointMake(_tile, _angle.form.ordinal, 0, _angle.back);
}

@end


