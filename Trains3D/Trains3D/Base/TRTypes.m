#import "TRTypes.h"

@implementation TRColor{
    EGColor _color;
}
static TRColor* _orange;
static TRColor* _green;
static TRColor* _purple;
static NSArray* values;
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
    _orange = [TRColor colorWithOrdinal:0 name:@"orange" color:EGColorMake(1.0, 0.5, 0.0, 1.0)];
    _green = [TRColor colorWithOrdinal:1 name:@"green" color:EGColorMake(0.66, 0.9, 0.44, 1.0)];
    _purple = [TRColor colorWithOrdinal:2 name:@"purple" color:EGColorMake(0.9, 0.44, 0.66, 1.0)];
    values = (@[_orange, _green, _purple]);
}

- (void)set {
    egColorSet(_color);
}

+ (TRColor*)orange {
    return _orange;
}

+ (TRColor*)green {
    return _green;
}

+ (TRColor*)purple {
    return _purple;
}

+ (NSArray*)values {
    return values;
}

@end


