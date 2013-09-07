#import "EGBentleyOttmann.h"

#import "CNTreeMap.h"
#import "CNTreeSet.h"
#import "CNCollection.h"
#import "CNPair.h"
#import "CNSet.h"
#import "EGFigure.h"
@implementation EGBentleyOttmann
static ODClassType* _EGBentleyOttmann_type;

+ (id)bentleyOttmann {
    return [[EGBentleyOttmann alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBentleyOttmann_type = [ODClassType classTypeWithCls:[EGBentleyOttmann class]];
}

+ (id<CNSet>)intersectionsForSegments:(id<CNSeq>)segments {
    if([segments count] < 2) {
        return [NSSet set];
    } else {
        EGSweepLine* sweepLine = [EGSweepLine sweepLine];
        EGBentleyOttmannEventQueue* queue = [EGBentleyOttmannEventQueue newWithSegments:segments sweepLine:sweepLine];
        while(!([queue isEmpty])) {
            id<CNSeq> events = [queue poll];
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

- (ODClassType*)type {
    return [EGBentleyOttmann type];
}

+ (ODClassType*)type {
    return _EGBentleyOttmann_type;
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
    EGVec2 _point;
}
static ODClassType* _EGIntersection_type;
@synthesize items = _items;
@synthesize point = _point;

+ (id)intersectionWithItems:(CNPair*)items point:(EGVec2)point {
    return [[EGIntersection alloc] initWithItems:items point:point];
}

- (id)initWithItems:(CNPair*)items point:(EGVec2)point {
    self = [super init];
    if(self) {
        _items = items;
        _point = point;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGIntersection_type = [ODClassType classTypeWithCls:[EGIntersection class]];
}

- (ODClassType*)type {
    return [EGIntersection type];
}

+ (ODClassType*)type {
    return _EGIntersection_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGIntersection* o = ((EGIntersection*)(other));
    return [self.items isEqual:o.items] && EGVec2Eq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.items hash];
    hash = hash * 31 + EGVec2Hash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"items=%@", self.items];
    [description appendFormat:@", point=%@", EGVec2Description(self.point)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBentleyOttmannEvent
static ODClassType* _EGBentleyOttmannEvent_type;

+ (id)bentleyOttmannEvent {
    return [[EGBentleyOttmannEvent alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBentleyOttmannEvent_type = [ODClassType classTypeWithCls:[EGBentleyOttmannEvent class]];
}

- (EGVec2)point {
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

- (ODClassType*)type {
    return [EGBentleyOttmannEvent type];
}

+ (ODClassType*)type {
    return _EGBentleyOttmannEvent_type;
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
    EGVec2 _point;
}
static ODClassType* _EGBentleyOttmannPointEvent_type;
@synthesize isStart = _isStart;
@synthesize data = _data;
@synthesize segment = _segment;
@synthesize point = _point;

+ (id)bentleyOttmannPointEventWithIsStart:(BOOL)isStart data:(id)data segment:(EGLineSegment*)segment point:(EGVec2)point {
    return [[EGBentleyOttmannPointEvent alloc] initWithIsStart:isStart data:data segment:segment point:point];
}

- (id)initWithIsStart:(BOOL)isStart data:(id)data segment:(EGLineSegment*)segment point:(EGVec2)point {
    self = [super init];
    if(self) {
        _isStart = isStart;
        _data = data;
        _segment = segment;
        _point = point;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBentleyOttmannPointEvent_type = [ODClassType classTypeWithCls:[EGBentleyOttmannPointEvent class]];
}

- (CGFloat)yForX:(CGFloat)x {
    if([[_segment line] isVertical]) {
        if(_isStart) return ((CGFloat)(_segment.p1.y));
        else return ((CGFloat)(_segment.p2.y));
    } else {
        return [((EGSlopeLine*)([_segment line])) yForX:x];
    }
}

- (CGFloat)slope {
    return [[_segment line] slope];
}

- (BOOL)isVertical {
    return [[_segment line] isVertical];
}

- (BOOL)isEnd {
    return !(_isStart);
}

- (ODClassType*)type {
    return [EGBentleyOttmannPointEvent type];
}

+ (ODClassType*)type {
    return _EGBentleyOttmannPointEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBentleyOttmannPointEvent* o = ((EGBentleyOttmannPointEvent*)(other));
    return self.isStart == o.isStart && [self.data isEqual:o.data] && [self.segment isEqual:o.segment] && EGVec2Eq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.isStart;
    hash = hash * 31 + [self.data hash];
    hash = hash * 31 + [self.segment hash];
    hash = hash * 31 + EGVec2Hash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"isStart=%d", self.isStart];
    [description appendFormat:@", data=%@", self.data];
    [description appendFormat:@", segment=%@", self.segment];
    [description appendFormat:@", point=%@", EGVec2Description(self.point)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBentleyOttmannIntersectionEvent{
    EGVec2 _point;
}
static ODClassType* _EGBentleyOttmannIntersectionEvent_type;
@synthesize point = _point;

+ (id)bentleyOttmannIntersectionEventWithPoint:(EGVec2)point {
    return [[EGBentleyOttmannIntersectionEvent alloc] initWithPoint:point];
}

- (id)initWithPoint:(EGVec2)point {
    self = [super init];
    if(self) _point = point;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBentleyOttmannIntersectionEvent_type = [ODClassType classTypeWithCls:[EGBentleyOttmannIntersectionEvent class]];
}

- (BOOL)isIntersection {
    return YES;
}

- (ODClassType*)type {
    return [EGBentleyOttmannIntersectionEvent type];
}

+ (ODClassType*)type {
    return _EGBentleyOttmannIntersectionEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBentleyOttmannIntersectionEvent* o = ((EGBentleyOttmannIntersectionEvent*)(other));
    return EGVec2Eq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec2Hash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"point=%@", EGVec2Description(self.point)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBentleyOttmannEventQueue{
    CNMutableTreeMap* _events;
}
static ODClassType* _EGBentleyOttmannEventQueue_type;
@synthesize events = _events;

+ (id)bentleyOttmannEventQueue {
    return [[EGBentleyOttmannEventQueue alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _events = [CNMutableTreeMap mutableTreeMapWithComparator:^NSInteger(id a, id b) {
        return egVec2CompareTo(uwrap(EGVec2, a), uwrap(EGVec2, b));
    }];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBentleyOttmannEventQueue_type = [ODClassType classTypeWithCls:[EGBentleyOttmannEventQueue class]];
}

- (BOOL)isEmpty {
    return [_events isEmpty];
}

+ (EGBentleyOttmannEventQueue*)newWithSegments:(id<CNSeq>)segments sweepLine:(EGSweepLine*)sweepLine {
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

- (void)offerPoint:(EGVec2)point event:(EGBentleyOttmannEvent*)event {
    [[_events objectForKey:wrap(EGVec2, point) orUpdateWith:^NSMutableArray*() {
        return [NSMutableArray mutableArray];
    }] addObject:event];
}

- (id<CNSeq>)poll {
    return ((CNTuple*)([[_events pollFirst] get])).b;
}

- (ODClassType*)type {
    return [EGBentleyOttmannEventQueue type];
}

+ (ODClassType*)type {
    return _EGBentleyOttmannEventQueue_type;
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
    EGVec2 _point;
}
static ODClassType* _EGPointClass_type;
@synthesize point = _point;

+ (id)pointClassWithPoint:(EGVec2)point {
    return [[EGPointClass alloc] initWithPoint:point];
}

- (id)initWithPoint:(EGVec2)point {
    self = [super init];
    if(self) _point = point;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGPointClass_type = [ODClassType classTypeWithCls:[EGPointClass class]];
}

- (ODClassType*)type {
    return [EGPointClass type];
}

+ (ODClassType*)type {
    return _EGPointClass_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGPointClass* o = ((EGPointClass*)(other));
    return EGVec2Eq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec2Hash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"point=%@", EGVec2Description(self.point)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSweepLine{
    CNMutableTreeSet* _events;
    NSMutableDictionary* _intersections;
    EGVec2 _currentEventPoint;
    EGBentleyOttmannEventQueue* _queue;
}
static ODClassType* _EGSweepLine_type;
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

+ (void)initialize {
    [super initialize];
    _EGSweepLine_type = [ODClassType classTypeWithCls:[EGSweepLine class]];
}

- (void)handleEvents:(id<CNSeq>)events {
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
            float minY = pe.segment.p1.y;
            float maxY = pe.segment.p2.y;
            id<CNIterator> i = [_events iteratorHigherThanObject:event];
            while([i hasNext]) {
                EGBentleyOttmannPointEvent* e = ((EGBentleyOttmannPointEvent*)([i next]));
                if(!([e isVertical])) {
                    CGFloat y = [e yForX:((CGFloat)(_currentEventPoint.x))];
                    if(y > maxY) break;
                    if(y >= minY) [self registerIntersectionA:pe b:e point:EGVec2Make(_currentEventPoint.x, ((float)(y)))];
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
            id<CNSeq> toInsert = [[[set chain] filter:^BOOL(EGBentleyOttmannPointEvent* _) {
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
            [self registerIntersectionA:aa b:bb point:uwrap(EGVec2, _)];
        }];
    }
}

- (void)registerIntersectionA:(EGBentleyOttmannPointEvent*)a b:(EGBentleyOttmannPointEvent*)b point:(EGVec2)point {
    if(!([a.segment endingsContainPoint:point]) || !([b.segment endingsContainPoint:point])) {
        NSMutableSet* existing = ((NSMutableSet*)([_intersections objectForKey:[EGPointClass pointClassWithPoint:point] orUpdateWith:^NSMutableSet*() {
            return [NSMutableSet mutableSet];
        }]));
        [existing addObject:a];
        [existing addObject:b];
        if(point.x > _currentEventPoint.x || (eqf4(point.x, _currentEventPoint.x) && point.y > _currentEventPoint.y)) {
            EGBentleyOttmannIntersectionEvent* intersection = [EGBentleyOttmannIntersectionEvent bentleyOttmannIntersectionEventWithPoint:point];
            [_queue offerPoint:point event:intersection];
        }
    }
}

- (NSInteger)compareEventsA:(EGBentleyOttmannPointEvent*)a b:(EGBentleyOttmannPointEvent*)b {
    if([a isEqual:b]) return 0;
    CGFloat ay = [a yForX:((CGFloat)(_currentEventPoint.x))];
    CGFloat by = [b yForX:((CGFloat)(_currentEventPoint.x))];
    NSInteger c = floatCompareTo(ay, by);
    if(c == 0) if([a isVertical]) {
        c = -1;
    } else {
        if([b isVertical]) {
            c = 1;
        } else {
            c = floatCompareTo([a slope], [b slope]);
            if(ay > _currentEventPoint.y) c = -c;
            if(c == 0) c = float4CompareTo(a.point.x, b.point.x);
        }
    }
    return c;
}

- (ODClassType*)type {
    return [EGSweepLine type];
}

+ (ODClassType*)type {
    return _EGSweepLine_type;
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


