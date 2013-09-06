#import "TRTypes.h"

@implementation TRColor{
    EGColor _color;
}
static TRColor* _TRColor_orange;
static TRColor* _TRColor_green;
static TRColor* _TRColor_purple;
static TRColor* _TRColor_grey;
static NSArray* _TRColor_values;
@synthesize color = _color;

+ (id)colorWithOrdinal:(NSUInteger)ordinal name:(NSString*)name color:(EGColor)color {
    return [[TRColor alloc] initWithOrdinal:ordinal name:name color:color];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name color:(EGColor)color {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _color = color;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRColor_orange = [TRColor colorWithOrdinal:0 name:@"orange" color:EGColorMake(((float)(1.0)), ((float)(0.5)), ((float)(0.0)), ((float)(1.0)))];
    _TRColor_green = [TRColor colorWithOrdinal:1 name:@"green" color:EGColorMake(((float)(0.66)), ((float)(0.9)), ((float)(0.44)), ((float)(1.0)))];
    _TRColor_purple = [TRColor colorWithOrdinal:2 name:@"purple" color:EGColorMake(((float)(0.9)), ((float)(0.44)), ((float)(0.66)), ((float)(1.0)))];
    _TRColor_grey = [TRColor colorWithOrdinal:3 name:@"grey" color:EGColorMake(((float)(0.5)), ((float)(0.5)), ((float)(0.5)), ((float)(1.0)))];
    _TRColor_values = (@[_TRColor_orange, _TRColor_green, _TRColor_purple, _TRColor_grey]);
}

- (void)set {
    egColor(_color);
}

+ (TRColor*)orange {
    return _TRColor_orange;
}

+ (TRColor*)green {
    return _TRColor_green;
}

+ (TRColor*)purple {
    return _TRColor_purple;
}

+ (TRColor*)grey {
    return _TRColor_grey;
}

+ (NSArray*)values {
    return _TRColor_values;
}

@end


