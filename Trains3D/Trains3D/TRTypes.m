#import "TRTypes.h"

@implementation TRColor{
    NSInteger _ordinal;
    NSString* _name;
}
static TRColor* orange;
static TRColor* green;
@synthesize ordinal = _ordinal;
@synthesize name = _name;

+ (id)colorWithOrdinal:(NSInteger)ordinal name:(NSString*)name {
    return [[TRColor alloc] initWithOrdinal:ordinal name:name];
}

- (id)initWithOrdinal:(NSInteger)ordinal name:(NSString*)name {
    self = [super init];
    if(self) {
        _ordinal = ordinal;
        _name = name;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    orange = [TRColor colorWithOrdinal:0 name:@"orange"];
    green = [TRColor colorWithOrdinal:1 name:@"green"];
}

+ (TRColor*)orange {
    return orange;
}

+ (TRColor*)green {
    return green;
}

@end


