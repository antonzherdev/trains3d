#import "CNChain.h"
#import "CNSourceLink.h"
#import "CNFilterLink.h"
#import "CNMapLink.h"
#import "CNAppendLink.h"
#import "CNPrependLink.h"
#import "CNRangeLink.h"
#import "CNMulLink.h"
#import "CNReverseLink.h"
#import "CNOption.h"
#import "CNTuple.h"
#import "CNFlatMapLink.h"
#import "CNDistinctLink.h"


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

+ (CNChain *)chainWithStart:(NSInteger)aStart end:(NSInteger)anEnd step:(NSInteger)aStep {
    return [CNChain chainWithLink:[CNRangeLink linkWithStart:aStart end:anEnd step:aStep] previous:nil];
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

- (NSSet *)set {
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
    u_int32_t n = arc4random_uniform((u_int32_t)array.count);
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
