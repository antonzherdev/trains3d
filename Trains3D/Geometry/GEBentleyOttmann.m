#import "GEBentleyOttmann.h"

#import "CNChain.h"
#import "GEFigure.h"
@implementation GEBentleyOttmann
static CNClassType* _GEBentleyOttmann_type;

+ (instancetype)bentleyOttmann {
    return [[GEBentleyOttmann alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GEBentleyOttmann class]) _GEBentleyOttmann_type = [CNClassType classTypeWithCls:[GEBentleyOttmann class]];
}

+ (id<CNSet>)intersectionsForSegments:(NSArray*)segments {
    if([segments count] < 2) {
        return ((id<CNSet>)([CNImHashSet imHashSet]));
    } else {
        GESweepLine* sweepLine = [GESweepLine sweepLine];
        GEBentleyOttmannEventQueue* queue = [GEBentleyOttmannEventQueue newWithSegments:segments sweepLine:sweepLine];
        while(!([queue isEmpty])) {
            id<CNSeq> events = [queue poll];
            [sweepLine handleEvents:events];
        }
        return [[[sweepLine.intersections chain] flatMapF:^CNChain*(CNTuple* p) {
            return [[[[((id<CNMSet>)(((CNTuple*)(p)).b)) chain] combinations] filterWhen:^BOOL(CNTuple* comb) {
                return !([((GEBentleyOttmannPointEvent*)(((CNTuple*)(comb)).a)) isVertical]) || !([((GEBentleyOttmannPointEvent*)(((CNTuple*)(comb)).b)) isVertical]);
            }] mapF:^GEIntersection*(CNTuple* comb) {
                return [GEIntersection intersectionWithItems:[CNPair pairWithA:((GEBentleyOttmannPointEvent*)(((CNTuple*)(comb)).a)).data b:((GEBentleyOttmannPointEvent*)(((CNTuple*)(comb)).b)).data] point:uwrap(GEVec2, ((CNTuple*)(p)).a)];
            }];
        }] toSet];
    }
}

- (NSString*)description {
    return @"BentleyOttmann";
}

- (CNClassType*)type {
    return [GEBentleyOttmann type];
}

+ (CNClassType*)type {
    return _GEBentleyOttmann_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation GEIntersection
static CNClassType* _GEIntersection_type;
@synthesize items = _items;
@synthesize point = _point;

+ (instancetype)intersectionWithItems:(CNPair*)items point:(GEVec2)point {
    return [[GEIntersection alloc] initWithItems:items point:point];
}

- (instancetype)initWithItems:(CNPair*)items point:(GEVec2)point {
    self = [super init];
    if(self) {
        _items = items;
        _point = point;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GEIntersection class]) _GEIntersection_type = [CNClassType classTypeWithCls:[GEIntersection class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Intersection(%@, %@)", _items, geVec2Description(_point)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[GEIntersection class]])) return NO;
    GEIntersection* o = ((GEIntersection*)(to));
    return [_items isEqual:o.items] && geVec2IsEqualTo(_point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_items hash];
    hash = hash * 31 + geVec2Hash(_point);
    return hash;
}

- (CNClassType*)type {
    return [GEIntersection type];
}

+ (CNClassType*)type {
    return _GEIntersection_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation GEBentleyOttmannEvent
static CNClassType* _GEBentleyOttmannEvent_type;

+ (instancetype)bentleyOttmannEvent {
    return [[GEBentleyOttmannEvent alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GEBentleyOttmannEvent class]) _GEBentleyOttmannEvent_type = [CNClassType classTypeWithCls:[GEBentleyOttmannEvent class]];
}

- (GEVec2)point {
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

- (NSString*)description {
    return @"BentleyOttmannEvent";
}

- (CNClassType*)type {
    return [GEBentleyOttmannEvent type];
}

+ (CNClassType*)type {
    return _GEBentleyOttmannEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation GEBentleyOttmannPointEvent
static CNClassType* _GEBentleyOttmannPointEvent_type;
@synthesize isStart = _isStart;
@synthesize data = _data;
@synthesize segment = _segment;
@synthesize point = _point;

+ (instancetype)bentleyOttmannPointEventWithIsStart:(BOOL)isStart data:(id)data segment:(GELineSegment*)segment point:(GEVec2)point {
    return [[GEBentleyOttmannPointEvent alloc] initWithIsStart:isStart data:data segment:segment point:point];
}

- (instancetype)initWithIsStart:(BOOL)isStart data:(id)data segment:(GELineSegment*)segment point:(GEVec2)point {
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
    if(self == [GEBentleyOttmannPointEvent class]) _GEBentleyOttmannPointEvent_type = [CNClassType classTypeWithCls:[GEBentleyOttmannPointEvent class]];
}

- (CGFloat)yForX:(CGFloat)x {
    if([[_segment line] isVertical]) {
        if(_isStart) return ((CGFloat)(_segment.p0.y));
        else return ((CGFloat)(_segment.p1.y));
    } else {
        return ((CGFloat)(((float)([((GESlopeLine*)([_segment line])) yForX:x]))));
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

- (NSString*)description {
    return [NSString stringWithFormat:@"BentleyOttmannPointEvent(%d, %@, %@, %@)", _isStart, _data, _segment, geVec2Description(_point)];
}

- (CNClassType*)type {
    return [GEBentleyOttmannPointEvent type];
}

+ (CNClassType*)type {
    return _GEBentleyOttmannPointEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation GEBentleyOttmannIntersectionEvent
static CNClassType* _GEBentleyOttmannIntersectionEvent_type;
@synthesize point = _point;

+ (instancetype)bentleyOttmannIntersectionEventWithPoint:(GEVec2)point {
    return [[GEBentleyOttmannIntersectionEvent alloc] initWithPoint:point];
}

- (instancetype)initWithPoint:(GEVec2)point {
    self = [super init];
    if(self) _point = point;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GEBentleyOttmannIntersectionEvent class]) _GEBentleyOttmannIntersectionEvent_type = [CNClassType classTypeWithCls:[GEBentleyOttmannIntersectionEvent class]];
}

- (BOOL)isIntersection {
    return YES;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BentleyOttmannIntersectionEvent(%@)", geVec2Description(_point)];
}

- (CNClassType*)type {
    return [GEBentleyOttmannIntersectionEvent type];
}

+ (CNClassType*)type {
    return _GEBentleyOttmannIntersectionEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation GEBentleyOttmannEventQueue
static CNClassType* _GEBentleyOttmannEventQueue_type;
@synthesize events = _events;

+ (instancetype)bentleyOttmannEventQueue {
    return [[GEBentleyOttmannEventQueue alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _events = [CNMTreeMap treeMapWithComparator:^NSInteger(id a, id b) {
        return geVec2CompareTo((uwrap(GEVec2, a)), (uwrap(GEVec2, b)));
    }];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GEBentleyOttmannEventQueue class]) _GEBentleyOttmannEventQueue_type = [CNClassType classTypeWithCls:[GEBentleyOttmannEventQueue class]];
}

- (BOOL)isEmpty {
    return [_events isEmpty];
}

+ (GEBentleyOttmannEventQueue*)newWithSegments:(NSArray*)segments sweepLine:(GESweepLine*)sweepLine {
    GEBentleyOttmannEventQueue* ret = [GEBentleyOttmannEventQueue bentleyOttmannEventQueue];
    if(!([segments isEmpty])) {
        for(CNTuple* s in segments) {
            GELineSegment* segment = ((CNTuple*)(s)).b;
            [ret offerPoint:segment.p0 event:[GEBentleyOttmannPointEvent bentleyOttmannPointEventWithIsStart:YES data:((CNTuple*)(s)).a segment:segment point:segment.p0]];
            [ret offerPoint:segment.p1 event:[GEBentleyOttmannPointEvent bentleyOttmannPointEventWithIsStart:NO data:((CNTuple*)(s)).a segment:segment point:segment.p1]];
        }
        sweepLine.queue = ret;
    }
    return ret;
}

- (void)offerPoint:(GEVec2)point event:(GEBentleyOttmannEvent*)event {
    [((CNMArray*)([_events applyKey:wrap(GEVec2, point) orUpdateWith:^CNMArray*() {
        return [CNMArray array];
    }])) appendItem:event];
}

- (id<CNSeq>)poll {
    return ((CNTuple*)(nonnil([_events pollFirst]))).b;
}

- (NSString*)description {
    return @"BentleyOttmannEventQueue";
}

- (CNClassType*)type {
    return [GEBentleyOttmannEventQueue type];
}

+ (CNClassType*)type {
    return _GEBentleyOttmannEventQueue_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation GESweepLine
static CNClassType* _GESweepLine_type;
@synthesize events = _events;
@synthesize intersections = _intersections;
@synthesize queue = _queue;

+ (instancetype)sweepLine {
    return [[GESweepLine alloc] init];
}

- (instancetype)init {
    self = [super init];
    __weak GESweepLine* _weakSelf = self;
    if(self) {
        _events = [CNMTreeSet applyComparator:^NSInteger(GEBentleyOttmannPointEvent* a, GEBentleyOttmannPointEvent* b) {
            GESweepLine* _self = _weakSelf;
            if(_self != nil) return [_self compareEventsA:a b:b];
            else return 0;
        }];
        _intersections = [CNMHashMap hashMap];
        _currentEventPoint = GEVec2Make(0.0, 0.0);
        _queue = nil;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GESweepLine class]) _GESweepLine_type = [CNClassType classTypeWithCls:[GESweepLine class]];
}

- (void)handleEvents:(id<CNSeq>)events {
    id<CNIterator> __il__0i = [events iterator];
    while([__il__0i hasNext]) {
        GEBentleyOttmannEvent* _ = [__il__0i next];
        [self handleOneEvent:_];
    }
}

- (void)sweepToEvent:(GEBentleyOttmannEvent*)event {
    _currentEventPoint = [event point];
}

- (void)handleOneEvent:(GEBentleyOttmannEvent*)event {
    if([event isStart]) {
        [self sweepToEvent:event];
        GEBentleyOttmannPointEvent* pe = ((GEBentleyOttmannPointEvent*)(event));
        if([pe isVertical]) {
            float minY = pe.segment.p0.y;
            float maxY = pe.segment.p1.y;
            id<CNIterator> i = [_events iteratorHigherThanItem:pe];
            while([i hasNext]) {
                GEBentleyOttmannPointEvent* e = [i next];
                if(!([e isVertical])) {
                    CGFloat y = [e yForX:((CGFloat)(_currentEventPoint.x))];
                    if(y > maxY) break;
                    if(y >= minY) [self registerIntersectionA:pe b:e point:GEVec2Make(_currentEventPoint.x, ((float)(y)))];
                }
            }
        } else {
            [_events appendItem:pe];
            [self checkIntersectionA:event b:[self aboveEvent:pe]];
            [self checkIntersectionA:event b:[self belowEvent:pe]];
        }
    } else {
        if([event isEnd]) {
            GEBentleyOttmannPointEvent* pe = ((GEBentleyOttmannPointEvent*)(event));
            if(!([pe isVertical])) {
                GEBentleyOttmannPointEvent* a = [self aboveEvent:pe];
                GEBentleyOttmannPointEvent* b = [self belowEvent:pe];
                [_events removeItem:pe];
                [self sweepToEvent:event];
                [self checkIntersectionA:a b:b];
            }
        } else {
            id<CNMSet> set = ((id<CNMSet>)(nonnil(([_intersections applyKey:wrap(GEVec2, [event point])]))));
            NSArray* toInsert = [[[set chain] filterWhen:^BOOL(GEBentleyOttmannPointEvent* _) {
                return [_events removeItem:_];
            }] toArray];
            [self sweepToEvent:event];
            for(GEBentleyOttmannPointEvent* e in toInsert) {
                [_events appendItem:e];
                [self checkIntersectionA:e b:[self aboveEvent:e]];
                [self checkIntersectionA:e b:[self belowEvent:e]];
            }
        }
    }
}

- (GEBentleyOttmannPointEvent*)aboveEvent:(GEBentleyOttmannPointEvent*)event {
    return [_events higherThanItem:event];
}

- (GEBentleyOttmannPointEvent*)belowEvent:(GEBentleyOttmannPointEvent*)event {
    return [_events lowerThanItem:event];
}

- (void)checkIntersectionA:(GEBentleyOttmannEvent*)a b:(GEBentleyOttmannEvent*)b {
    if(a != nil && b != nil && [((GEBentleyOttmannEvent*)(a)) isKindOfClass:[GEBentleyOttmannPointEvent class]] && [((GEBentleyOttmannEvent*)(b)) isKindOfClass:[GEBentleyOttmannPointEvent class]]) {
        GEBentleyOttmannPointEvent* aa = ((GEBentleyOttmannPointEvent*)(a));
        GEBentleyOttmannPointEvent* bb = ((GEBentleyOttmannPointEvent*)(b));
        {
            id _ = [aa.segment intersectionWithSegment:bb.segment];
            if(_ != nil) [self registerIntersectionA:aa b:bb point:uwrap(GEVec2, _)];
        }
    }
}

- (void)registerIntersectionA:(GEBentleyOttmannPointEvent*)a b:(GEBentleyOttmannPointEvent*)b point:(GEVec2)point {
    if(!([a.segment endingsContainPoint:point]) || !([b.segment endingsContainPoint:point])) {
        id<CNMSet> existing = [_intersections applyKey:wrap(GEVec2, point) orUpdateWith:^CNMHashSet*() {
            return [CNMHashSet hashSet];
        }];
        [existing appendItem:a];
        [existing appendItem:b];
        if(point.x > _currentEventPoint.x || (eqf4(point.x, _currentEventPoint.x) && point.y > _currentEventPoint.y)) {
            GEBentleyOttmannIntersectionEvent* intersection = [GEBentleyOttmannIntersectionEvent bentleyOttmannIntersectionEventWithPoint:point];
            [((GEBentleyOttmannEventQueue*)(_queue)) offerPoint:point event:intersection];
        }
    }
}

- (NSInteger)compareEventsA:(GEBentleyOttmannPointEvent*)a b:(GEBentleyOttmannPointEvent*)b {
    if([a isEqual:b]) return 0;
    CGFloat ay = [a yForX:((CGFloat)(_currentEventPoint.x))];
    CGFloat by = [b yForX:((CGFloat)(_currentEventPoint.x))];
    NSInteger c = floatCompareTo(ay, by);
    if(c == 0) {
        if([a isVertical]) {
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
    }
    return c;
}

- (NSString*)description {
    return @"SweepLine";
}

- (CNClassType*)type {
    return [GESweepLine type];
}

+ (CNClassType*)type {
    return _GESweepLine_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

