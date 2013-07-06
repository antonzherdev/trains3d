#import "TRCity.h"

#import "EGMap.h"
@implementation TRCity{
    TRColor* _color;
    EGIPoint _tile;
    NSInteger _angle;
}
@synthesize color = _color;
@synthesize tile = _tile;
@synthesize angle = _angle;

+ (id)cityWithColor:(TRColor*)color tile:(EGIPoint)tile angle:(NSInteger)angle {
    return [[TRCity alloc] initWithColor:color tile:tile angle:angle];
}

- (id)initWithColor:(TRColor*)color tile:(EGIPoint)tile angle:(NSInteger)angle {
    self = [super init];
    if(self) {
        _color = color;
        _tile = tile;
        _angle = angle;
    }
    
    return self;
}

@end


