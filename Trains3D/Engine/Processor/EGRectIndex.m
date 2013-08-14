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
        return egRectContains(uwrap(EGRect, _.a), point);
    }] map:^id(CNTuple* _) {
        return _.b;
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


