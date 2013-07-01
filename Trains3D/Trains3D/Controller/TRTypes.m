#import "TRTypes.h"

@implementation TRColor{
    NSInteger _ordinal;
    NSString* _name;
    EGColor _color;
}
static TRColor* orange;
static TRColor* green;
static TRColor* purple;
static NSArray* values;
@synthesize ordinal = _ordinal;
@synthesize name = _name;
@synthesize color = _color;

+ (id)colorWithOrdinal:(NSInteger)ordinal name:(NSString*)name color:(EGColor)color {
    return [[TRColor alloc] initWithOrdinal:ordinal name:name color:color];
}

- (id)initWithOrdinal:(NSInteger)ordinal name:(NSString*)name color:(EGColor)color {
    self = [super init];
    if(self) {
        _ordinal = ordinal;
        _name = name;
        _color = color;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    orange = [TRColor colorWithOrdinal:0 name:@"orange" color:EGColorMake(1.0, 0.5, 0.0, 1.0)];
    green = [TRColor colorWithOrdinal:1 name:@"green" color:EGColorMake(0.66, 0.9, 0.44, 1.0)];
    purple = [TRColor colorWithOrdinal:2 name:@"purple" color:EGColorMake(0.9, 0.44, 0.66, 1.0)];
    values = @[orange, green, purple];
}

+ (TRColor*)orange {
    return orange;
}

+ (TRColor*)green {
    return green;
}

+ (TRColor*)purple {
    return purple;
}

+ (NSArray*)values {
    return values;
}

@end


