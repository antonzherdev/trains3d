#import "EGBentleyOttmann.h"

#import "EGFigure.h"
#import "CNTreeSet.h"
#import "CNCollection.h"
@implementation EGBentleyOttmann

+ (id)bentleyOttmann {
    return [[EGBentleyOttmann alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (NSSet*)intersectionsForSegments:(NSArray*)segments {
    if([segments count] < 2) {
        return [NSSet set];
    } else {
        EGSweepLine* sweepLine = [EGSweepLine sweepLine];
        EGBentleyOttmannEventQueue* queue = [EGBentleyOttmannEventQueue newWithSegments:segments sweepLine:sweepLine];
        while(!([queue isEmpty])) {
            NSArray* events = [queue poll];
            [sweepLine handleEvents:events];
        }
        return [[[sweepLine.intersections chain] map:^EGIntersection*(CNTuple* p) {
            return [EGIntersection intersectionWithPoint:((EGPointClass*)p.a).point data:[[[((NSMutableSet*)p.b) chain] map:^EGSweepLine*(EGBentleyOttmannPointEvent* _) {
                return ((EGSweepLine*)_.data);
            }] toSet]];
        }] toSet];
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


@implementation EGIntersection{
    EGPoint _point;
    NSSet* _data;
}
@synthesize point = _point;
@synthesize data = _data;

+ (id)intersectionWithPoint:(EGPoint)point data:(NSSet*)data {
    return [[EGIntersection alloc] initWithPoint:point data:data];
}

- (id)initWithPoint:(EGPoint)point data:(NSSet*)data {
    self = [super init];
    if(self) {
        _point = point;
        _data = data;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGIntersection* o = ((EGIntersection*)other);
    return EGPointEq(self.point, o.point) && [self.data isEqual:o.data];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGPointHash(self.point);
    hash = hash * 31 + [self.data hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"point=%@", EGPointDescription(self.point)];
    [description appendFormat:@", data=%@", self.data];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBentleyOttmannEvent

+ (id)bentleyOttmannEvent {
    return [[EGBentleyOttmannEvent alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (EGPoint)point {
    @throw @"Method point is abstract";
}

- (BOOL)isIntersection {
    @throw @"Method isIntersection is abstract";
}

- (BOOL)isStart {
    @throw @"Method isStart is abstract";
}

- (BOOL)isEnd {
    return !([self isStart]) && !([self isIntersection]);
}

- (double)yForX:(double)x {
    @throw @"Method yFor is abstract";
}

- (double)slope {
    @throw @"Method slope is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBentleyOttmannEvent* o = ((EGBentleyOttmannEvent*)other);
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


@implementation EGBentleyOttmannPointEvent{
    BOOL _isStart;
    id _data;
    EGLineSegment* _segment;
    EGPoint _point;
}
@synthesize isStart = _isStart;
@synthesize data = _data;
@synthesize segment = _segment;
@synthesize point = _point;

+ (id)bentleyOttmannPointEventWithIsStart:(BOOL)isStart data:(id)data segment:(EGLineSegment*)segment point:(EGPoint)point {
    return [[EGBentleyOttmannPointEvent alloc] initWithIsStart:isStart data:data segment:segment point:point];
}

- (id)initWithIsStart:(BOOL)isStart data:(id)data segment:(EGLineSegment*)segment point:(EGPoint)point {
    self = [super init];
    if(self) {
        _isStart = isStart;
        _data = data;
        _segment = segment;
        _point = point;
    }
    
    return self;
}

- (BOOL)isIntersection {
    return NO;
}

- (double)yForX:(double)x {
    if([_segment.line isVertical]) return _segment.p1.y;
    else return [((EGSlopeLine*)_segment.line) yForX:x];
}

- (double)slope {
    return [_segment.line slope];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBentleyOttmannPointEvent* o = ((EGBentleyOttmannPointEvent*)other);
    return self.isStart == o.isStart && [self.data isEqual:o.data] && [self.segment isEqual:o.segment] && EGPointEq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.isStart;
    hash = hash * 31 + [self.data hash];
    hash = hash * 31 + [self.segment hash];
    hash = hash * 31 + EGPointHash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"isStart=%d", self.isStart];
    [description appendFormat:@", data=%@", self.data];
    [description appendFormat:@", segment=%@", self.segment];
    [description appendFormat:@", point=%@", EGPointDescription(self.point)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBentleyOttmannIntersectionEvent{
    EGPoint _point;
}
@synthesize point = _point;

+ (id)bentleyOttmannIntersectionEventWithPoint:(EGPoint)point {
    return [[EGBentleyOttmannIntersectionEvent alloc] initWithPoint:point];
}

- (id)initWithPoint:(EGPoint)point {
    self = [super init];
    if(self) _point = point;
    
    return self;
}

- (BOOL)isIntersection {
    return YES;
}

- (BOOL)isStart {
    return NO;
}

- (double)yForX:(double)x {
    return _point.y;
}

- (double)slope {
    return 0;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBentleyOttmannIntersectionEvent* o = ((EGBentleyOttmannIntersectionEvent*)other);
    return EGPointEq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGPointHash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"point=%@", EGPointDescription(self.point)];
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
        [segments forEach:^void(CNTuple* s) {
            EGLineSegment* segment = ((EGLineSegment*)s.b);
            [ret offerPoint:segment.p1 event:[EGBentleyOttmannPointEvent bentleyOttmannPointEventWithIsStart:YES data:s.a segment:segment point:segment.p1]];
            [ret offerPoint:segment.p2 event:[EGBentleyOttmannPointEvent bentleyOttmannPointEventWithIsStart:NO data:s.a segment:segment point:segment.p2]];
        }];
        sweepLine.queue = ret;
    }
    return ret;
}

- (void)offerPoint:(EGPoint)point event:(EGBentleyOttmannEvent*)event {
    [[_events objectForKey:val(point) orUpdateWith:^NSMutableArray*() {
        return [(@[]) mutableCopy];
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


@implementation EGPointClass{
    EGPoint _point;
}
@synthesize point = _point;

+ (id)pointClassWithPoint:(EGPoint)point {
    return [[EGPointClass alloc] initWithPoint:point];
}

- (id)initWithPoint:(EGPoint)point {
    self = [super init];
    if(self) _point = point;
    
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGPointClass* o = ((EGPointClass*)other);
    return EGPointEq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGPointHash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"point=%@", EGPointDescription(self.point)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSweepLine{
    CNTreeSet* _events;
    NSMutableDictionary* _intersections;
    EGPoint _currentEventPoint;
    EGBentleyOttmannEventQueue* _queue;
}
@synthesize events = _events;
@synthesize intersections = _intersections;
@synthesize queue = _queue;

+ (id)sweepLine {
    return [[EGSweepLine alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _events = [CNTreeSet newWithComparator:^NSInteger(EGBentleyOttmannEvent* a, EGBentleyOttmannEvent* b) {
            return [self compareEventsA:a b:b];
        }];
        _intersections = [(@{}) mutableCopy];
        _queue = nil;
    }
    
    return self;
}

- (void)handleEvents:(NSArray*)events {
    [events forEach:^void(EGBentleyOttmannEvent* _) {
        [self handleOneEvent:_];
    }];
}

- (void)sweepToEvent:(EGBentleyOttmannEvent*)event {
    _currentEventPoint = [event point];
}

- (void)handleOneEvent:(EGBentleyOttmannEvent*)event {
    if([event isStart]) {
        [self sweepToEvent:event];
        [_events addObject:event];
        [self checkIntersectionA:[CNOption opt:event] b:[self aboveEvent:event]];
        [self checkIntersectionA:[CNOption opt:event] b:[self belowEvent:event]];
    } else {
        if([event isEnd]) {
            [self sweepToEvent:event];
            [_events removeObject:event];
            [self checkIntersectionA:[self aboveEvent:event] b:[self belowEvent:event]];
        } else {
            NSMutableSet* set = ((NSMutableSet*)[[_intersections optionObjectForKey:[EGPointClass pointClassWithPoint:[event point]]] get]);
            NSArray* toInsert = [[[set chain] filter:^BOOL(EGBentleyOttmannPointEvent* _) {
                return [_events removeObject:_];
            }] toArray];
            [self sweepToEvent:event];
            [toInsert forEach:^void(EGBentleyOttmannPointEvent* e) {
                [_events addObject:e];
                [self checkIntersectionA:[CNOption opt:e] b:[self aboveEvent:e]];
                [self checkIntersectionA:[CNOption opt:e] b:[self belowEvent:e]];
            }];
        }
    }
}

- (id)aboveEvent:(EGBentleyOttmannEvent*)event {
    return [_events higherThanObject:event];
}

- (id)belowEvent:(EGBentleyOttmannEvent*)event {
    return [_events lowerThanObject:event];
}

- (void)checkIntersectionA:(id)a b:(id)b {
    if([a isDefined] && [b isDefined] && [((EGBentleyOttmannEvent*)[a get]) isKindOfClass:[EGBentleyOttmannPointEvent class]] && [((EGBentleyOttmannEvent*)[b get]) isKindOfClass:[EGBentleyOttmannPointEvent class]]) {
        EGBentleyOttmannPointEvent* aa = ((EGBentleyOttmannPointEvent*)((EGBentleyOttmannEvent*)[a get]));
        EGBentleyOttmannPointEvent* bb = ((EGBentleyOttmannPointEvent*)((EGBentleyOttmannEvent*)[b get]));
        [[aa.segment intersectionWithSegment:bb.segment] forEach:^void(id pp) {
            EGPoint p = uval(EGPoint, pp);
            if(!([aa.segment endingsContainPoint:p]) && !([bb.segment endingsContainPoint:p])) {
                NSMutableSet* existing = ((NSMutableSet*)[_intersections objectForKey:[EGPointClass pointClassWithPoint:p] orUpdateWith:^NSMutableSet*() {
                    return [NSMutableSet mutableSet];
                }]);
                [existing addObject:aa];
                [existing addObject:bb];
                if(p.x > _currentEventPoint.x || (eqf(p.x, _currentEventPoint.x) && p.y > _currentEventPoint.y)) {
                    EGBentleyOttmannIntersectionEvent* intersection = [EGBentleyOttmannIntersectionEvent bentleyOttmannIntersectionEventWithPoint:p];
                    [_queue offerPoint:p event:intersection];
                }
            }
        }];
    }
}

- (NSInteger)compareEventsA:(EGBentleyOttmannEvent*)a b:(EGBentleyOttmannEvent*)b {
    if([a isEqual:b]) return 0;
    double ay = [a yForX:_currentEventPoint.x];
    double by = [b yForX:_currentEventPoint.x];
    NSInteger c = floatCompare(ay, by);
    if(c == 0) {
        c = floatCompare([a slope], [b slope]);
        if(ay > _currentEventPoint.y) c = -c;
        if(c == 0) c = floatCompare([a point].x, [b point].x);
    }
    return c;
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


