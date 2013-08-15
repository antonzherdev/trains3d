#import "EGCollisions.h"

#import "EGFigure.h"
#import "EGBentleyOttmann.h"
#import "CNPair.h"
@implementation EGCollisions

+ (id)collisions {
    return [[EGCollisions alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (NSSet*)collisionsForFigures:(NSArray*)figures {
    NSArray* segments = [[[[[[figures chain] combinations] filter:^BOOL(CNTuple* p) {
        return !([((CNTuple*)p.a).a isEqual:((CNTuple*)p.b).a]) && egRectIntersects([((CNTuple*)p.a).b boundingRect], [((CNTuple*)p.b).b boundingRect]);
    }] uncombinations] flatMap:^CNChain*(CNTuple* f) {
        return [[[f.b segments] chain] map:^CNTuple*(EGLineSegment* segment) {
            return tuple(f.a, segment);
        }];
    }] toArray];
    if([segments isEmpty]) return [NSSet set];
    NSSet* intersections = [EGBentleyOttmann intersectionsForSegments:segments];
    return [[[[intersections chain] groupBy:^CNPair*(EGIntersection* _) {
        return _.items;
    } map:^id(EGIntersection* _) {
        return wrap(EGPoint, _.point);
    } withBuilder:^NSSetBuilder*() {
        return [NSSetBuilder setBuilder];
    }] map:^EGCollision*(CNTuple* p) {
        return [EGCollision collisionWithItems:p.a points:((NSSet*)p.b)];
    }] toSet];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCollision{
    CNPair* _items;
    NSSet* _points;
}
@synthesize items = _items;
@synthesize points = _points;

+ (id)collisionWithItems:(CNPair*)items points:(NSSet*)points {
    return [[EGCollision alloc] initWithItems:items points:points];
}

- (id)initWithItems:(CNPair*)items points:(NSSet*)points {
    self = [super init];
    if(self) {
        _items = items;
        _points = points;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCollision* o = ((EGCollision*)other);
    return [self.items isEqual:o.items] && [self.points isEqual:o.points];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.items hash];
    hash = hash * 31 + [self.points hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"items=%@", self.items];
    [description appendFormat:@", points=%@", self.points];
    [description appendString:@">"];
    return description;
}

@end


