#import "EGRectIndex.h"

@implementation EGRectIndex{
    id<CNSeq> _rects;
}
static ODClassType* _EGRectIndex_type;
@synthesize rects = _rects;

+ (id)rectIndexWithRects:(id<CNSeq>)rects {
    return [[EGRectIndex alloc] initWithRects:rects];
}

- (id)initWithRects:(id<CNSeq>)rects {
    self = [super init];
    if(self) _rects = rects;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGRectIndex_type = [ODClassType classTypeWithCls:[EGRectIndex class]];
}

- (id)applyPoint:(EGVec2)point {
    return [[_rects findWhere:^BOOL(CNTuple* _) {
        return egRectContainsPoint(uwrap(EGRect, _.a), point);
    }] map:^CNTuple*(CNTuple* _) {
        return ((CNTuple*)(_.b));
    }];
}

- (ODClassType*)type {
    return [EGRectIndex type];
}

+ (ODClassType*)type {
    return _EGRectIndex_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGRectIndex* o = ((EGRectIndex*)(other));
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


