#import "CNChain.h"
#import "CNSourceLink.h"
#import "CNFilterLink.h"
#import "CNMapLink.h"
#import "CNAppendLink.h"
#import "CNPrependLink.h"
#import "CNMulLink.h"
#import "CNReverseLink.h"
#import "CNOption.h"
#import "CNTuple.h"
#import "CNFlatMapLink.h"
#import "CNDistinctLink.h"
#import "CNTreeMap.h"
#import "CNNeighboursLink.h"
#import "CNCombinationsLink.h"
#import "CNUncombinationsLink.h"
#import "CNGroupByLink.h"
#import "CNList.h"


@implementation CNChain {
    id<CNChainLink> _link;
    CNChain* _previous;
}

- (id)initWithLink:(id <CNChainLink>)link previous:(CNChain *)previous {
    self = [super init];
    if (self) {
        _link = link;
        _previous = previous;
    }

    return self;
}

+ (id)chainWithLink:(id <CNChainLink>)link previous:(CNChain *)previous {
    return [[self alloc] initWithLink:link previous:previous];
}

- (CNYield *)buildYield:(CNYield *)yield {
    if(_previous == nil ) return [_link buildYield:yield];
    return [_previous buildYield:[_link buildYield:yield]];
}


+ (CNChain*)chainWithCollection:(id)collection {
    return [CNChain chainWithLink:[CNSourceLink linkWithCollection:collection] previous:nil];
}

- (NSArray *)toArray {
    __block id ret;
    CNYield *yield = [CNYield alloc];
    yield = [yield initWithBegin:^CNYieldResult(NSUInteger size) {
        ret = [NSMutableArray arrayWithCapacity:size];
        return cnYieldContinue;
    } yield:^CNYieldResult(id item) {
        [ret addObject:item];
        return cnYieldContinue;
    } end:nil all:^CNYieldResult(id collection) {
        if([collection isKindOfClass:[NSArray class]]) {
            ret = collection;
            return cnYieldContinue;
        }
        return [CNYield yieldAll:collection byItemsTo:yield];
    }];
    [self apply:yield];
    return ret;
}

- (NSSet *)toSet {
    __block id ret;
    CNYield *yield = [CNYield alloc];
    yield = [yield initWithBegin:^CNYieldResult(NSUInteger size) {
        ret = [NSMutableSet setWithCapacity:size];
        return cnYieldContinue;
    } yield:^CNYieldResult(id item) {
        [ret addObject:item];
        return cnYieldContinue;
    } end:nil all:^CNYieldResult(id collection) {
        if ([collection isKindOfClass:[NSSet class]]) {
            ret = collection;
            return cnYieldContinue;
        }
        return [CNYield yieldAll:collection byItemsTo:yield];
    }];
    [self apply:yield];
    return ret;
}

- (id)fold:(cnF2)f withStart:(id)start {
    __block id ret = start;
    CNYield *yield = [CNYield alloc];
    yield = [yield initWithBegin:nil yield:^CNYieldResult(id item) {
        ret = f(ret, item);
        return cnYieldContinue;
    } end:nil all:nil];
    [self apply:yield];
    return ret;
}

- (id )find:(cnPredicate)predicate {
    __block id ret = [CNOption none];
    CNYield *yield = [CNYield alloc];
    yield = [yield initWithBegin:nil yield:^CNYieldResult(id item) {
        if(predicate(item)) {
            ret = item;
            return cnYieldBreak;
        }
        return cnYieldContinue;
    } end:nil all:nil];
    [self apply:yield];
    return ret;
}


- (CNChain *)filter:(cnPredicate)predicate {
    return [self link:[CNFilterLink linkWithPredicate:predicate selectivity:0]];
}

- (CNChain *)filter:(cnPredicate)predicate selectivity:(double)selectivity {
    return [self link:[CNFilterLink linkWithPredicate:predicate selectivity:selectivity]];
}

- (CNChain *)map:(cnF)f {
    return [self link:[CNMapLink linkWithF:f]];
}

- (CNChain *)flatMap:(cnF)f {
    return [self link:[CNFlatMapLink linkWithF:f factor:2]];
}

- (CNChain *)flatMap:(cnF)f factor:(double)factor {
    return [self link:[CNFlatMapLink linkWithF:f factor:factor]];
}


- (CNChain *)neighbors {
    return [self link:[CNNeighboursLink linkWithRing:NO]];
}

- (CNChain *)neighborsRing {
    return [self link:[CNNeighboursLink linkWithRing:YES]];
}


- (CNChain *)combinations {
    return [self link:[CNCombinationsLink link]];
}

- (CNChain *)uncombinations {
    return [self link:[CNUncombinationsLink link]];
}

- (CNChain *)groupBy:(cnF)by fold:(cnF2)fold withStart:(cnF0)start {
    return [self link:[CNGroupByLink linkWithBy:by fold:fold withStart:start factor:0.5 mutableMode:NO mapAfter:nil]];
}

- (CNChain *)groupBy:(cnF)by withBuilder:(cnF0)builder {
    return [self link:[CNGroupByLink linkWithBy:by fold:^id(id r, id x) {
        [r addObject:x];
        return r;
    } withStart:builder factor:0.5 mutableMode:YES mapAfter:^id(id x) {
        return [x build];
    }]];
}

- (CNChain *)groupBy:(cnF)by map:(cnF)f withBuilder:(cnF0)builder {
    return [self link:[CNGroupByLink linkWithBy:by fold:^id(id r, id x) {
        [r addObject:f(x)];
        return r;
    } withStart:builder factor:0.5 mutableMode:YES mapAfter:^id(id x) {
        return [x build];
    }]];
}


- (CNChain *)groupBy:(cnF)by map:(cnF)f {
    return [self groupBy:by map: f withBuilder:^id {
        return [CNArrayBuilder arrayBuilder];
    }];
}

- (CNChain *)groupBy:(cnF)by {
    return [self groupBy:by withBuilder:^id {
        return [CNArrayBuilder arrayBuilder];
    }];
}

- (CNChain *)append:(id)collection {
    return [self link:[CNAppendLink linkWithCollection:collection]];
}

- (CNChain *)prepend:(id)collection {
    return [self link:[CNPrependLink linkWithCollection:collection]];
}

- (CNChain *)exclude:(id)collection {
    id col = cnResolveCollection(collection);
    return [self filter:^BOOL(id x) {
        return ![col containsObject:x];
    }];
}

- (CNChain *)intersect:(id)collection {
    id col = cnResolveCollection(collection);
    return [self filter:^BOOL(id x) {
        return [col containsObject:x];
    }];
}


- (CNChain *)mul:(id)collection {
    return [self link:[CNMulLink linkWithCollection:collection]];
}

- (CNChain *)reverse {
    return [self link:[CNReverseLink link]];
}

- (void)forEach:(cnP)p {
    [self apply:[CNYield yieldWithBegin:nil yield:^CNYieldResult(id item) {
        p(item);
        return cnYieldContinue;
    } end:nil all:nil]];
}

- (BOOL)goOn:(BOOL(^)(id))on {
    return [self apply:[CNYield yieldWithBegin:nil yield:^CNYieldResult(id item) {
        return on(item) ? cnYieldContinue : cnYieldBreak;
    } end:nil all:nil]] == cnYieldContinue;
}

- (CNChain *)chain {
    return self;
}


- (id)head {
    __block id ret = [CNOption none];
    [self apply:[CNYield yieldWithBegin:nil yield:^CNYieldResult(id item) {
        ret = item;
        return cnYieldBreak;
    } end:nil all:nil]];
    return ret;
}

- (id)randomItem {
    NSArray *array = [self toArray];
    if(array.count == 0) {
        return [CNOption none];
    }
    u_int32_t n = randomWith((u_int32_t)array.count - 1);
    return [array objectAtIndex:n];
}

- (NSUInteger)count {
    __block NSUInteger ret = 0;
    [self apply:[CNYield yieldWithBegin:nil yield:^CNYieldResult(id item) {
        ret++;
        return cnYieldContinue;
    } end:nil all:nil]];
    return ret;
}


- (CNYieldResult)apply:(CNYield *)yield {
    CNYield *y = [self buildYield:yield];
    CNYieldResult result = [y beginYieldWithSize:0];
    return [y endYieldWithResult:result];
}

- (CNChain*)link:(id <CNChainLink>)link {
    return [CNChain chainWithLink:link previous:_link == nil ? nil : self];
}

- (id)min {
    return [self fold:^id(id r, id x) {
        if([r isEmpty]) return x;
        return [x compareTo:r] < 0 ? x : r;
    } withStart:[CNOption none]];
}

- (id)max {
    return [self fold:^id(id r, id x) {
        if([r isEmpty]) return x;
        return [x compareTo:r] > 0 ? x : r;
    } withStart:[CNOption none]];
}

- (NSDictionary *)toMap {
    return [self toMutableMap];
}

- (NSMutableDictionary *)toMutableMap {
    __block NSMutableDictionary* ret;
    CNYield *yield = [CNYield alloc];
    yield = [yield initWithBegin:^CNYieldResult(NSUInteger size) {
        ret = [NSMutableDictionary dictionaryWithCapacity:size];
        return cnYieldContinue;
    } yield:^CNYieldResult(CNTuple* item) {
        [ret setObject:item.b forKey:item.a];
        return cnYieldContinue;
    } end:nil all:nil];
    [self apply:yield];
    return ret;
}

- (CNChain *)distinct {
    return [self link:[CNDistinctLink linkWithSelectivity:1.0]];
}

- (CNChain *)distinctWithSelectivity:(double)selectivity {
    return [self link:[CNDistinctLink linkWithSelectivity:selectivity]];
}

@end

id cnResolveCollection(id collection) {
    if([collection isKindOfClass:[CNChain class]]) return [collection toArray];
    return collection;
}
