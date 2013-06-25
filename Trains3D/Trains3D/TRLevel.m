#import "TRLevel.h"

@implementation TRLevel{
    NSArray* _cities;
}
@synthesize cities = _cities;

+ (id)level {
    return [[TRLevel alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

@end


