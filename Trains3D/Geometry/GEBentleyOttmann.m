#import "GEBentleyOttmann.h"

#import "GEFigure.h"
@implementation GEBentleyOttmann
static ODClassType* _GEBentleyOttmann_type;

+ (id)bentleyOttmann {
    return [[GEBentleyOttmann alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _GEBentleyOttmann_type = [ODClassType classTypeWithCls:[GEBentleyOttmann class]];
}

+ (id<CNSet>)intersectionsForSegments:(id<CNSeq>)segments {
    if([segments count] < 2) {
        return [NSSet set];
    } else {
        GESweepLine* sweepLine = [GESweepLine sweepLine];
        GEBentleyOttmannEventQueue* queue = [GEBentleyOttmannEventQueue newWithSegments:segments sweepLine:sweepLine];
        while(!([queue isEmpty])) {
            id<CNSeq> events = [queue poll];
            [sweepLine handleEvents:events];
        }
        return [[[sweepLine.intersections chain] flatMap:^CNChain*(CNTuple* p) {
            return [[[[((NSMutableSet*)(p.b)) chain] combinations] filter:^BOOL(CNTuple* comb) {
                return !([((GEBentleyOttmannPointEvent*)(comb.a)) isVertical]) || !([((GEBentleyOttmannPointEvent*)(comb.b)) isVertical]);
            }] map:^GEIntersection*(CNTuple* comb) {
                return [GEIntersection intersectionWithItems:[CNPair newWithA:((GEBentleyOttmannPointEvent*)(((GEBentleyOttmannPointEvent*)(comb.a)).data)) b:((GEBentleyOttmannPointEvent*)(((GEBentleyOttmannPointEvent*)(comb.b)).data))] point:((GEPointClass*)(p.a)).point];
            }];
        }] toSet];
    }
}

- (ODClassType*)type {
    return [GEBentleyOttmann type];
}

+ (ODClassType*)type {
    return _GEBentleyOttmann_type;
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


@implementation GEIntersection{
    CNPair* _items;
    GEVec2 _point;
}
static ODClassType* _GEIntersection_type;
@synthesize items = _items;
@synthesize point = _point;

+ (id)intersectionWithItems:(CNPair*)items point:(GEVec2)point {
    return [[GEIntersection alloc] initWithItems:items point:point];
}

- (id)initWithItems:(CNPair*)items point:(GEVec2)point {
    self = [super init];
    if(self) {
        _items = items;
        _point = point;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _GEIntersection_type = [ODClassType classTypeWithCls:[GEIntersection class]];
}

- (ODClassType*)type {
    return [GEIntersection type];
}

+ (ODClassType*)type {
    return _GEIntersection_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEIntersection* o = ((GEIntersection*)(other));
    return [self.items isEqual:o.items] && GEVec2Eq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.items hash];
    hash = hash * 31 + GEVec2Hash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"items=%@", self.items];
    [description appendFormat:@", point=%@", GEVec2Description(self.point)];
    [description appendString:@">"];
    return description;
}

@end


@implementation GEBentleyOttmannEvent
static ODClassType* _GEBentleyOttmannEvent_type;

+ (id)bentleyOttmannEvent {
    return [[GEBentleyOttmannEvent alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _GEBentleyOttmannEvent_type = [ODClassType classTypeWithCls:[GEBentleyOttmannEvent class]];
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

- (ODClassType*)type {
    return [GEBentleyOttmannEvent type];
}

+ (ODClassType*)type {
    return _GEBentleyOttmannEvent_type;
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


@implementation GEBentleyOttmannPointEvent{
    BOOL _isStart;
    id _data;
    GELineSegment* _segment;
    GEVec2 _point;
}
static ODClassType* _GEBentleyOttmannPointEvent_type;
@synthesize isStart = _isStart;
@synthesize data = _data;
@synthesize segment = _segment;
@synthesize point = _point;

+ (id)bentleyOttmannPointEventWithIsStart:(BOOL)isStart data:(id)data segment:(GELineSegment*)segment point:(GEVec2)point {
    return [[GEBentleyOttmannPointEvent alloc] initWithIsStart:isStart data:data segment:segment point:point];
}

- (id)initWithIsStart:(BOOL)isStart data:(id)data segment:(GELineSegment*)segment point:(GEVec2)point {
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
    _GEBentleyOttmannPointEvent_type = [ODClassType classTypeWithCls:[GEBentleyOttmannPointEvent class]];
}

- (CGFloat)yForX:(CGFloat)x {
    if([[_segment line] isVertical]) {
        if(_isStart) return ((CGFloat)(_segment.p0.y));
        else return ((CGFloat)(_segment.p1.y));
    } else {
        return [((GESlopeLine*)([_segment line])) yForX:x];
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
    return [GEBentleyOttmannPointEvent type];
}

+ (ODClassType*)type {
    return _GEBentleyOttmannPointEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEBentleyOttmannPointEvent* o = ((GEBentleyOttmannPointEvent*)(other));
    return self.isStart == o.isStart && [self.data isEqual:o.data] && [self.segment isEqual:o.segment] && GEVec2Eq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.isStart;
    hash = hash * 31 + [self.data hash];
    hash = hash * 31 + [self.segment hash];
    hash = hash * 31 + GEVec2Hash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"isStart=%d", self.isStart];
    [description appendFormat:@", data=%@", self.data];
    [description appendFormat:@", segment=%@", self.segment];
    [description appendFormat:@", point=%@", GEVec2Description(self.point)];
    [description appendString:@">"];
    return description;
}

@end


@implementation GEBentleyOttmannIntersectionEvent{
    GEVec2 _point;
}
static ODClassType* _GEBentleyOttmannIntersectionEvent_type;
@synthesize point = _point;

+ (id)bentleyOttmannIntersectionEventWithPoint:(GEVec2)point {
    return [[GEBentleyOttmannIntersectionEvent alloc] initWithPoint:point];
}

- (id)initWithPoint:(GEVec2)point {
    self = [super init];
    if(self) _point = point;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _GEBentleyOttmannIntersectionEvent_type = [ODClassType classTypeWithCls:[GEBentleyOttmannIntersectionEvent class]];
}

- (BOOL)isIntersection {
    return YES;
}

- (ODClassType*)type {
    return [GEBentleyOttmannIntersectionEvent type];
}

+ (ODClassType*)type {
    return _GEBentleyOttmannIntersectionEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEBentleyOttmannIntersectionEvent* o = ((GEBentleyOttmannIntersectionEvent*)(other));
    return GEVec2Eq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"point=%@", GEVec2Description(self.point)];
    [description appendString:@">"];
    return description;
}

@end


@implementation GEBentleyOttmannEventQueue{
    CNMutableTreeMap* _events;
}
static ODClassType* _GEBentleyOttmannEventQueue_type;
@synthesize events = _events;

+ (id)bentleyOttmannEventQueue {
    return [[GEBentleyOttmannEventQueue alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _events = [CNMutableTreeMap mutableTreeMapWithComparator:^NSInteger(id a, id b) {
        return geVec2CompareTo(uwrap(GEVec2, a), uwrap(GEVec2, b));
    }];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _GEBentleyOttmannEventQueue_type = [ODClassType classTypeWithCls:[GEBentleyOttmannEventQueue class]];
}

- (BOOL)isEmpty {
    return [_events isEmpty];
}

+ (GEBentleyOttmannEventQueue*)newWithSegments:(id<CNSeq>)segments sweepLine:(GESweepLine*)sweepLine {
    GEBentleyOttmannEventQueue* ret = [GEBentleyOttmannEventQueue bentleyOttmannEventQueue];
    if(!([segments isEmpty])) {
        [segments forEach:^void(CNTuple* s) {
            GELineSegment* segment = ((GELineSegment*)(s.b));
            [ret offerPoint:segment.p0 event:[GEBentleyOttmannPointEvent bentleyOttmannPointEventWithIsStart:YES data:((CNTuple*)(s.a)) segment:segment point:segment.p0]];
            [ret offerPoint:segment.p1 event:[GEBentleyOttmannPointEvent bentleyOttmannPointEventWithIsStart:NO data:((CNTuple*)(s.a)) segment:segment point:segment.p1]];
        }];
        sweepLine.queue = ret;
    }
    return ret;
}

- (void)offerPoint:(GEVec2)point event:(GEBentleyOttmannEvent*)event {
    [[_events objectForKey:wrap(GEVec2, point) orUpdateWith:^NSMutableArray*() {
        return [NSMutableArray mutableArray];
    }] addItem:event];
}

- (id<CNSeq>)poll {
    return ((CNTuple*)([[_events pollFirst] get])).b;
}

- (ODClassType*)type {
    return [GEBentleyOttmannEventQueue type];
}

+ (ODClassType*)type {
    return _GEBentleyOttmannEventQueue_type;
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


@implementation GEPointClass{
    GEVec2 _point;
}
static ODClassType* _GEPointClass_type;
@synthesize point = _point;

+ (id)pointClassWithPoint:(GEVec2)point {
    return [[GEPointClass alloc] initWithPoint:point];
}

- (id)initWithPoint:(GEVec2)point {
    self = [super init];
    if(self) _point = point;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _GEPointClass_type = [ODClassType classTypeWithCls:[GEPointClass class]];
}

- (ODClassType*)type {
    return [GEPointClass type];
}

+ (ODClassType*)type {
    return _GEPointClass_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEPointClass* o = ((GEPointClass*)(other));
    return GEVec2Eq(self.point, o.point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.point);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"point=%@", GEVec2Description(self.point)];
    [description appendString:@">"];
    return description;
}

@end


@implementation GESweepLine{
    CNMutableTreeSet* _events;
    NSMutableDictionary* _intersections;
    GEVec2 _currentEventPoint;
    GEBentleyOttmannEventQueue* _queue;
}
static ODClassType* _GESweepLine_type;
@synthesize events = _events;
@synthesize intersections = _intersections;
@synthesize queue = _queue;

+ (id)sweepLine {
    return [[GESweepLine alloc] init];
}

- (id)init {
    self = [super init];
    __weak GESweepLine* _weakSelf = self;
    if(self) {
        _events = [CNMutableTreeSet newWithComparator:^NSInteger(GEBentleyOttmannPointEvent* a, GEBentleyOttmannPointEvent* b) {
            return [_weakSelf compareEventsA:a b:b];
        }];
        _intersections = [NSMutableDictionary mutableDictionary];
        _queue = nil;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _GESweepLine_type = [ODClassType classTypeWithCls:[GESweepLine class]];
}

- (void)handleEvents:(id<CNSeq>)events {
    [events forEach:^void(GEBentleyOttmannEvent* _) {
        [self handleOneEvent:_];
    }];
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
            id<CNIterator> i = [_events iteratorHigherThanItem:event];
            while([i hasNext]) {
                GEBentleyOttmannPointEvent* e = ((GEBentleyOttmannPointEvent*)([i next]));
                if(!([e isVertical])) {
                    CGFloat y = [e yForX:((CGFloat)(_currentEventPoint.x))];
                    if(y > maxY) break;
                    if(y >= minY) [self registerIntersectionA:pe b:e point:GEVec2Make(_currentEventPoint.x, ((float)(y)))];
                }
            }
        } else {
            [_events addItem:event];
            [self checkIntersectionA:[CNOption opt:event] b:[self aboveEvent:event]];
            [self checkIntersectionA:[CNOption opt:event] b:[self belowEvent:event]];
        }
    } else {
        if([event isEnd]) {
            if(!([((GEBentleyOttmannPointEvent*)(event)) isVertical])) {
                id a = [self aboveEvent:event];
                id b = [self belowEvent:event];
                [_events removeItem:event];
                [self sweepToEvent:event];
                [self checkIntersectionA:a b:b];
            }
        } else {
            NSMutableSet* set = ((NSMutableSet*)([[_intersections applyKey:[GEPointClass pointClassWithPoint:[event point]]] get]));
            id<CNSeq> toInsert = [[[set chain] filter:^BOOL(GEBentleyOttmannPointEvent* _) {
                return [_events removeItem:_];
            }] toArray];
            [self sweepToEvent:event];
            [toInsert forEach:^void(GEBentleyOttmannPointEvent* e) {
                [_events addItem:e];
                [self checkIntersectionA:[CNOption opt:e] b:[self aboveEvent:e]];
                [self checkIntersectionA:[CNOption opt:e] b:[self belowEvent:e]];
            }];
        }
    }
}

- (id)aboveEvent:(GEBentleyOttmannEvent*)event {
    return [_events higherThanItem:event];
}

- (id)belowEvent:(GEBentleyOttmannEvent*)event {
    return [_events lowerThanItem:event];
}

- (void)checkIntersectionA:(id)a b:(id)b {
    if([a isDefined] && [b isDefined] && [((GEBentleyOttmannEvent*)([a get])) isKindOfClass:[GEBentleyOttmannPointEvent class]] && [((GEBentleyOttmannEvent*)([b get])) isKindOfClass:[GEBentleyOttmannPointEvent class]]) {
        GEBentleyOttmannPointEvent* aa = ((GEBentleyOttmannPointEvent*)(((GEBentleyOttmannEvent*)([a get]))));
        GEBentleyOttmannPointEvent* bb = ((GEBentleyOttmannPointEvent*)(((GEBentleyOttmannEvent*)([b get]))));
        [[aa.segment intersectionWithSegment:bb.segment] forEach:^void(id _) {
            [self registerIntersectionA:aa b:bb point:uwrap(GEVec2, _)];
        }];
    }
}

- (void)registerIntersectionA:(GEBentleyOttmannPointEvent*)a b:(GEBentleyOttmannPointEvent*)b point:(GEVec2)point {
    if(!([a.segment endingsContainPoint:point]) || !([b.segment endingsContainPoint:point])) {
        NSMutableSet* existing = ((NSMutableSet*)([_intersections objectForKey:[GEPointClass pointClassWithPoint:point] orUpdateWith:^NSMutableSet*() {
            return [NSMutableSet mutableSet];
        }]));
        [existing addItem:a];
        [existing addItem:b];
        if(point.x > _currentEventPoint.x || (eqf4(point.x, _currentEventPoint.x) && point.y > _currentEventPoint.y)) {
            GEBentleyOttmannIntersectionEvent* intersection = [GEBentleyOttmannIntersectionEvent bentleyOttmannIntersectionEventWithPoint:point];
            [_queue offerPoint:point event:intersection];
        }
    }
}

- (NSInteger)compareEventsA:(GEBentleyOttmannPointEvent*)a b:(GEBentleyOttmannPointEvent*)b {
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
    return [GESweepLine type];
}

+ (ODClassType*)type {
    return _GESweepLine_type;
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

