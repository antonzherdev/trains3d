#import "EGBentleyOttmann.h"

#import "EGFigure.h"
#import "CNCollection.h"
#import "CNPair.h"
@implementation EGBentleyOttmann

+ (id)bentleyOttmann {
    return [[EGBentleyOttmann alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (id<CNSet>)intersectionsForSegments:(id<CNList>)segments {
    if([segments count] < 2) {
        return [NSSet set];
    } else {
        EGSweepLine* sweepLine = [EGSweepLine sweepLine];
        EGBentleyOttmannEventQueue* queue = [EGBentleyOttmannEventQueue newWithSegments:segments sweepLine:sweepLine];
        while(!([queue isEmpty])) {
            id<CNList> events = [queue poll];
            [sweepLine handleEvents:events];
        }
        return [[[sweepLine.intersections chain] flatMap:^CNChain*(CNTuple* p) {
            return [[[[((NSMutableSet*)(p.b)) chain] combinations] filter:^BOOL(CNTuple* comb) {
                return !([((EGBentleyOttmannPointEvent*)(comb.a)) isVertical]) || !([((EGBentleyOttmannPointEvent*)(comb.b)) isVertical]);
            }] map:^EGIntersection*(CNTuple* comb) {
                return [EGIntersection intersectionWithItems:[CNPair newWithA:((EGBentleyOttmannPointEvent*)(((EGBentleyOttmannPointEvent*)(comb.a)).data)) b:((EGBentleyOttmannPointEvent*)(((EGBentleyOttmannPointEvent*)(comb.b)).data))] point:((EGPointClass*)(p.a)).point];
            }];
        }] toSet];
    }
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


@implementation EGIntersection{
    CNPair* _items;
    EGPoint _point;
}
@synthesize items = _items;
@synthesize point = _point;

+ (id)intersectionWithItems:(CNPair*)items point:(EGPoint)point {
    return [[EGIntersection alloc] initWithItems:items point:point];
}

- (id)initWithItems:(CNPair*)items point:(EGPoint)point {
    self = [super init];
    if(self) {
        _items = items;
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
    EGIntersection* o = ((EGIntersection*)(other));
    return [self.items isEqual:o.items] && EGPointEq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.items hash];
    hash = hash * 31 + EGPointHash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"items=%@", self.items];
    [description appendFormat:@", point=%@", EGPointDescription(self.point)];
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
    return NO;
}

- (BOOL)isStart {
    return NO;
}

- (BOOL)isEnd {
    return NO;
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

- (double)yForX:(double)x {
    if([[_segment line] isVertical]) {
        if(_isStart) return _segment.p1.y;
        else return _segment.p2.y;
    } else {
        return [((EGSlopeLine*)([_segment line])) yForX:x];
    }
}

- (double)slope {
    return [[_segment line] slope];
}

- (BOOL)isVertical {
    return [[_segment line] isVertical];
}

- (BOOL)isEnd {
    return !(_isStart);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBentleyOttmannPointEvent* o = ((EGBentleyOttmannPointEvent*)(other));
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

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBentleyOttmannIntersectionEvent* o = ((EGBentleyOttmannIntersectionEvent*)(other));
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
    CNMutableTreeMap* _events;
}
@synthesize events = _events;

+ (id)bentleyOttmannEventQueue {
    return [[EGBentleyOttmannEventQueue alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _events = [CNMutableTreeMap mutableTreeMapWithComparator:^NSInteger(id a, id b) {
        return egPointCompare(uwrap(EGPoint, a), uwrap(EGPoint, b));
    }];
    
    return self;
}

- (BOOL)isEmpty {
    return [_events isEmpty];
}

+ (EGBentleyOttmannEventQueue*)newWithSegments:(id<CNList>)segments sweepLine:(EGSweepLine*)sweepLine {
    EGBentleyOttmannEventQueue* ret = [EGBentleyOttmannEventQueue bentleyOttmannEventQueue];
    if(!([segments isEmpty])) {
        [segments forEach:^void(CNTuple* s) {
            EGLineSegment* segment = ((EGLineSegment*)(s.b));
            [ret offerPoint:segment.p1 event:[EGBentleyOttmannPointEvent bentleyOttmannPointEventWithIsStart:YES data:((CNTuple*)(s.a)) segment:segment point:segment.p1]];
            [ret offerPoint:segment.p2 event:[EGBentleyOttmannPointEvent bentleyOttmannPointEventWithIsStart:NO data:((CNTuple*)(s.a)) segment:segment point:segment.p2]];
        }];
        sweepLine.queue = ret;
    }
    return ret;
}

- (void)offerPoint:(EGPoint)point event:(EGBentleyOttmannEvent*)event {
    [[_events objectForKey:wrap(EGPoint, point) orUpdateWith:^NSMutableArray*() {
        return [NSMutableArray mutableArray];
    }] addObject:event];
}

- (id<CNList>)poll {
    return ((CNTuple*)([[_events pollFirst] get])).b;
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
    EGPointClass* o = ((EGPointClass*)(other));
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
    CNMutableTreeSet* _events;
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
        _events = [CNMutableTreeSet newWithComparator:^NSInteger(EGBentleyOttmannPointEvent* a, EGBentleyOttmannPointEvent* b) {
            return [self compareEventsA:a b:b];
        }];
        _intersections = [NSMutableDictionary mutableDictionary];
        _queue = nil;
    }
    
    return self;
}

- (void)handleEvents:(id<CNList>)events {
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
        EGBentleyOttmannPointEvent* pe = ((EGBentleyOttmannPointEvent*)(event));
        if([pe isVertical]) {
            double minY = pe.segment.p1.y;
            double maxY = pe.segment.p2.y;
            id<CNIterator> i = [_events iteratorHigherThanObject:event];
            while([i hasNext]) {
                EGBentleyOttmannPointEvent* e = ((EGBentleyOttmannPointEvent*)([i next]));
                if(!([e isVertical])) {
                    double y = [e yForX:_currentEventPoint.x];
                    if(y > maxY) break;
                    if(y >= minY) [self registerIntersectionA:pe b:e point:EGPointMake(_currentEventPoint.x, y)];
                }
            }
        } else {
            [_events addObject:event];
            [self checkIntersectionA:[CNOption opt:event] b:[self aboveEvent:event]];
            [self checkIntersectionA:[CNOption opt:event] b:[self belowEvent:event]];
        }
    } else {
        if([event isEnd]) {
            if(!([((EGBentleyOttmannPointEvent*)(event)) isVertical])) {
                id a = [self aboveEvent:event];
                id b = [self belowEvent:event];
                [_events removeObject:event];
                [self sweepToEvent:event];
                [self checkIntersectionA:a b:b];
            }
        } else {
            NSMutableSet* set = ((NSMutableSet*)([[_intersections applyKey:[EGPointClass pointClassWithPoint:[event point]]] get]));
            id<CNList> toInsert = [[[set chain] filter:^BOOL(EGBentleyOttmannPointEvent* _) {
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
    if([a isDefined] && [b isDefined] && [((EGBentleyOttmannEvent*)([a get])) isKindOfClass:[EGBentleyOttmannPointEvent class]] && [((EGBentleyOttmannEvent*)([b get])) isKindOfClass:[EGBentleyOttmannPointEvent class]]) {
        EGBentleyOttmannPointEvent* aa = ((EGBentleyOttmannPointEvent*)(((EGBentleyOttmannEvent*)([a get]))));
        EGBentleyOttmannPointEvent* bb = ((EGBentleyOttmannPointEvent*)(((EGBentleyOttmannEvent*)([b get]))));
        [[aa.segment intersectionWithSegment:bb.segment] forEach:^void(id _) {
            [self registerIntersectionA:aa b:bb point:uwrap(EGPoint, _)];
        }];
    }
}

- (void)registerIntersectionA:(EGBentleyOttmannPointEvent*)a b:(EGBentleyOttmannPointEvent*)b point:(EGPoint)point {
    if(!([a.segment endingsContainPoint:point]) || !([b.segment endingsContainPoint:point])) {
        NSMutableSet* existing = ((NSMutableSet*)([_intersections objectForKey:[EGPointClass pointClassWithPoint:point] orUpdateWith:^NSMutableSet*() {
            return [NSMutableSet mutableSet];
        }]));
        [existing addObject:a];
        [existing addObject:b];
        if(point.x > _currentEventPoint.x || (eqf(point.x, _currentEventPoint.x) && point.y > _currentEventPoint.y)) {
            EGBentleyOttmannIntersectionEvent* intersection = [EGBentleyOttmannIntersectionEvent bentleyOttmannIntersectionEventWithPoint:point];
            [_queue offerPoint:point event:intersection];
        }
    }
}

- (NSInteger)compareEventsA:(EGBentleyOttmannPointEvent*)a b:(EGBentleyOttmannPointEvent*)b {
    if([a isEqual:b]) return 0;
    double ay = [a yForX:_currentEventPoint.x];
    double by = [b yForX:_currentEventPoint.x];
    NSInteger c = floatCompare(ay, by);
    if(c == 0) if([a isVertical]) {
        c = -1;
    } else {
        if([b isVertical]) {
            c = 1;
        } else {
            c = floatCompare([a slope], [b slope]);
            if(ay > _currentEventPoint.y) c = -c;
            if(c == 0) c = floatCompare(a.point.x, b.point.x);
        }
    }
    return c;
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


