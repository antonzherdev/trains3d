#import "EGBentleyOttmann.h"

#import "EGFigure.h"
#import "CNTreeSet.h"
@implementation EGBentleyOttmann

+ (id)bentleyOttmann {
    return [[EGBentleyOttmann alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (NSArray*)intersectionsSegments:(NSArray*)segments {
    return [[EGBentleyOttmann intersectionsMapSegments:segments] values];
}

+ (NSDictionary*)intersectionsMapSegments:(NSArray*)segments {
    if([segments count] < 2) {
        return (@{});
    } else {
        EGSweepLine* sweepLine = [EGSweepLine sweepLine];
        EGBentleyOttmannEventQueue* queue = [EGBentleyOttmannEventQueue newWithSegments:segments sweepLine:sweepLine];
        while(!([queue isEmpty])) {
            NSArray* events = [queue poll];
            [sweepLine handleEvents:events];
        }
        return sweepLine.intersections;
    }
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBentleyOttmann* o = ((EGBentleyOttmann*)other);
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


@implementation EGBentleyOttmannEventQueue{
    CNTreeMap* _events;
}
@synthesize events = _events;

+ (id)bentleyOttmannEventQueue {
    return [[EGBentleyOttmannEventQueue alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _events = [CNTreeMap treeMapWithComparator:^NSInteger(id a, id b) {
        return egPointCompare(uval(EGPoint, a), uval(EGPoint, b));
    }];
    
    return self;
}

- (BOOL)isEmpty {
    return [_events isEmpty];
}

+ (EGBentleyOttmannEventQueue*)newWithSegments:(NSArray*)segments sweepLine:(EGSweepLine*)sweepLine {
    EGBentleyOttmannEventQueue* ret = [EGBentleyOttmannEventQueue bentleyOttmannEventQueue];
    if(!([segments isEmpty])) {
        CNTreeSet* xs = [CNTreeSet new];
        [segments forEach:^void(CNTuple* s) {
            EGLineSegment* segment = ((EGLineSegment*)s.b);
            [xs addObject:numf(segment.p1.x)];
            [xs addObject:numf(segment.p2.x)];
            [ret offerPoint:segment.p1 event:[EGBentleyOttmannEventStart bentleyOttmannEventStartWithData:s.a segment:s point:segment.p1]];
            [ret offerPoint:segment.p2 event:[EGBentleyOttmannEventEnd bentleyOttmannEventEndWithData:s.a segment:s point:segment.p2]];
        }];
        double minY = unumf([[xs head] get]);
        double maxY = unumf([[xs last] get]);
        double minDeltaX = unumf([[[[[xs chain] neighbors] map:^id(CNTuple* pair) {
            return numf(unumf(pair.b) - unumf(pair.a));
        }] min] get]);
        double slope = (minY - maxY) / minDeltaX * 1000;
        sweepLine.sweepLine = [EGLine newWithSlope:slope point:EGPointMake(0, 0)];
        sweepLine.queue = ret;
    }
    return ret;
}

- (void)offerPoint:(EGPoint)point event:(id<EGBentleyOttmannEvent>)event {
    [[_events objectForKey:val(point) orUpdateWith:^NSArray*() {
        return (@[]);
    }] addObject:event];
}

- (NSArray*)poll {
    return ((CNTuple*)[[_events pollFirst] get]).b;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBentleyOttmannEventQueue* o = ((EGBentleyOttmannEventQueue*)other);
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


@implementation EGBentleyOttmannEventStart{
    id _data;
    EGLineSegment* _segment;
    EGPoint _point;
}
@synthesize data = _data;
@synthesize segment = _segment;
@synthesize point = _point;

+ (id)bentleyOttmannEventStartWithData:(id)data segment:(EGLineSegment*)segment point:(EGPoint)point {
    return [[EGBentleyOttmannEventStart alloc] initWithData:data segment:segment point:point];
}

- (id)initWithData:(id)data segment:(EGLineSegment*)segment point:(EGPoint)point {
    self = [super init];
    if(self) {
        _data = data;
        _segment = segment;
        _point = point;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBentleyOttmannEventStart* o = ((EGBentleyOttmannEventStart*)other);
    return [self.data isEqual:o.data] && [self.segment isEqual:o.segment] && EGPointEq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.data hash];
    hash = hash * 31 + [self.segment hash];
    hash = hash * 31 + EGPointHash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"data=%@", self.data];
    [description appendFormat:@", segment=%@", self.segment];
    [description appendFormat:@", point=%@", EGPointDescription(self.point)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBentleyOttmannEventEnd{
    id _data;
    EGLineSegment* _segment;
    EGPoint _point;
}
@synthesize data = _data;
@synthesize segment = _segment;
@synthesize point = _point;

+ (id)bentleyOttmannEventEndWithData:(id)data segment:(EGLineSegment*)segment point:(EGPoint)point {
    return [[EGBentleyOttmannEventEnd alloc] initWithData:data segment:segment point:point];
}

- (id)initWithData:(id)data segment:(EGLineSegment*)segment point:(EGPoint)point {
    self = [super init];
    if(self) {
        _data = data;
        _segment = segment;
        _point = point;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBentleyOttmannEventEnd* o = ((EGBentleyOttmannEventEnd*)other);
    return [self.data isEqual:o.data] && [self.segment isEqual:o.segment] && EGPointEq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.data hash];
    hash = hash * 31 + [self.segment hash];
    hash = hash * 31 + EGPointHash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"data=%@", self.data];
    [description appendFormat:@", segment=%@", self.segment];
    [description appendFormat:@", point=%@", EGPointDescription(self.point)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBentleyOttmannIntersection{
    id _data1;
    id _data2;
    EGPoint _point;
}
@synthesize data1 = _data1;
@synthesize data2 = _data2;
@synthesize point = _point;

+ (id)bentleyOttmannIntersectionWithData1:(id)data1 data2:(id)data2 point:(EGPoint)point {
    return [[EGBentleyOttmannIntersection alloc] initWithData1:data1 data2:data2 point:point];
}

- (id)initWithData1:(id)data1 data2:(id)data2 point:(EGPoint)point {
    self = [super init];
    if(self) {
        _data1 = data1;
        _data2 = data2;
        _point = point;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBentleyOttmannIntersection* o = ((EGBentleyOttmannIntersection*)other);
    return [self.data1 isEqual:o.data1] && [self.data2 isEqual:o.data2] && EGPointEq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.data1 hash];
    hash = hash * 31 + [self.data2 hash];
    hash = hash * 31 + EGPointHash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"data1=%@", self.data1];
    [description appendFormat:@", data2=%@", self.data2];
    [description appendFormat:@", point=%@", EGPointDescription(self.point)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSweepLine{
    CNTreeSet* _events;
    NSMutableDictionary* _intersections;
    EGLine* _sweepLine;
    EGPoint _currentEventPoint;
    BOOL _before;
    EGBentleyOttmannEventQueue* _queue;
}
@synthesize intersections = _intersections;
@synthesize sweepLine = _sweepLine;
@synthesize queue = _queue;

+ (id)sweepLine {
    return [[EGSweepLine alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _events = [CNTreeSet new];
        _intersections = [(@{}) mutableCopy];
        _sweepLine = nil;
        _before = YES;
        _queue = nil;
    }
    
    return self;
}

- (void)handleEvents:(NSArray*)events {
    [events forEach:^void(id<EGBentleyOttmannEvent> _) {
        [self handleOneEvent:_];
    }];
}

- (void)handleOneEvent:(id<EGBentleyOttmannEvent>)event {
    if([event isKindOfClass:[EGBentleyOttmannEventStart class]]) {
        _before = NO;
        [_events addObject:event];
        [self checkIntersectionA:event b:[self aboveEvent:event]];
        [self checkIntersectionA:event b:[self belowEvent:event]];
    } else {
        if([event isKindOfClass:[EGBentleyOttmannEventEnd class]]) {
            _before = YES;
            [_events removeObject:event];
            [self checkIntersectionA:[self aboveEvent:event] b:[self belowEvent:event]];
        } else {
            _before = YES;
            NSMutableArray* set = [[_intersections optionObjectForKey:val([event point])] get];
            NSArray* toInsert = [[[set filter:^BOOL(id<EGBentleyOttmannEvent> _) {
                return [_events removeObject:_];
            }] reverse] toArray];
            _before = NO;
            [toInsert forEach:^void(id<EGBentleyOttmannEvent> e) {
                [_events addObject:e];
                [self checkIntersectionA:e b:[self aboveEvent:e]];
                [self checkIntersectionA:e b:[self belowEvent:e]];
            }];
        }
    }
}

- (id<EGBentleyOttmannEvent>)aboveEvent:(id<EGBentleyOttmannEvent>)event {
    return [[_events higherThanObject:event] getOr:nil];
}

- (id<EGBentleyOttmannEvent>)belowEvent:(id<EGBentleyOttmannEvent>)event {
    return [[_events lowerThanObject:event] getOr:nil];
}

- (void)checkIntersectionA:(id<EGBentleyOttmannEvent>)a b:(id<EGBentleyOttmannEvent>)b {
    if(a != nil && b != nil && !([a isKindOfClass:[EGBentleyOttmannIntersection class]]) && !([b isKindOfClass:[EGBentleyOttmannIntersection class]])) [[[a segment] intersectionWithSegment:[b segment]] forEach:^void(id p) {
        if(!([[a segment] endingsContainPoint:uval(EGPoint, p)]) || !([[b segment] endingsContainPoint:uval(EGPoint, p)])) {
            NSMutableArray* existing = [_intersections objectForKey:p orUpdateWith:^NSArray*() {
                return (@[]);
            }];
            [existing addObject:a];
            [existing addObject:b];
            if([_sweepLine isRightPoint:uval(EGPoint, p)] || ([_sweepLine containsPoint:uval(EGPoint, p)] && uval(EGPoint, p).y > _currentEventPoint.y)) {
                EGBentleyOttmannIntersection* intersection = [EGBentleyOttmannIntersection bentleyOttmannIntersectionWithData1:[a data] data2:[b data] point:uval(EGPoint, p)];
                [_queue offerPoint:uval(EGPoint, p) event:intersection];
            }
        }
    }];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


