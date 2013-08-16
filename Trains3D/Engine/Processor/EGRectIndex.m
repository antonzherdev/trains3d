#import "EGRectIndex.h"

@implementation EGRectIndex{
    id<CNList> _rects;
}
@synthesize rects = _rects;

+ (id)rectIndexWithRects:(id<CNList>)rects {
    return [[EGRectIndex alloc] initWithRects:rects];
}

- (id)initWithRects:(id<CNList>)rects {
    self = [super init];
    if(self) _rects = rects;
    
    return self;
}

- (id)applyPoint:(EGPoint)point {
    return [[_rects findWhere:^BOOL(CNTuple* _) {
        return egRectContains(uwrap(EGRect, _.a), point);
    }] map:^CNTuple*(CNTuple* _) {
        return ((CNTuple*)_.b);
    }];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGRectIndex* o = ((EGRectIndex*)other);
    return [self.rects isEqual:o.rects];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.rects hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"rects=%@", self.rects];
    [description appendString:@">"];
    return description;
}

@end


