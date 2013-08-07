#import "EGRectIndex.h"

@implementation EGRectIndex{
    NSArray* _rects;
}
@synthesize rects = _rects;

+ (id)rectIndexWithRects:(NSArray*)rects {
    return [[EGRectIndex alloc] initWithRects:rects];
}

- (id)initWithRects:(NSArray*)rects {
    self = [super init];
    if(self) _rects = rects;
    
    return self;
}

- (id)objectForPoint:(EGPoint)point {
    return [[_rects find:^BOOL(CNTuple* _) {
        return egRectContains(uval(EGRect, _.a), point);
    }] map:^id(CNTuple* _) {
        return _.b;
    }];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


