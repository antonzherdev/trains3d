#import "TRCity.h"

@implementation TRCity{
    TRColor* _color;
    EGTilePoint _tile;
}
@synthesize color = _color;
@synthesize tile = _tile;

+ (id)cityWithColor:(TRColor*)color tile:(EGTilePoint)tile {
    return [[TRCity alloc] initWithColor:color tile:tile];
}

- (id)initWithColor:(TRColor*)color tile:(EGTilePoint)tile {
    self = [super init];
    if(self) {
        _color = color;
        _tile = tile;
    }
    
    return self;
}

@end


