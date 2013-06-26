#import "TRLevel.h"

@implementation TRLevel{
    EGMapSize _mapSize;
    NSArray* _cities;
}
@synthesize mapSize = _mapSize;
@synthesize cities = _cities;

+ (id)levelWithMapSize:(EGMapSize)mapSize {
    return [[TRLevel alloc] initWithMapSize:mapSize];
}

- (id)initWithMapSize:(EGMapSize)mapSize {
    self = [super init];
    if(self) {
        _mapSize = mapSize;
    }
    
    return self;
}

@end


