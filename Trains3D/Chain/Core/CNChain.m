#import "CNChain.h"
#import "CNSourceLink.h"
#import "CNChainItem.h"
#import "CNFilterLink.h"
#import "CNMapLink.h"
#import "CNOption.h"
#import "CNAppendLink.h"
#import "CNPrependLink.h"
#import "CNRangeLink.h"
#import "CNMulLink.h"


@implementation CNChain {
    CNChainItem* _first;
    CNChainItem* _last;
}
+ (CNChain*)chainWithCollection:(id)collection {
    CNChain *chain = [[CNChain alloc] init];
    [chain link:[CNSourceLink linkWithCollection:collection]];
    return chain;
}

+ (CNChain *)chainWithStart:(NSInteger)aStart end:(NSInteger)anEnd step:(NSInteger)aStep {
    CNChain *chain = [[CNChain alloc] init];
    [chain link:[CNRangeLink linkWithStart:aStart end:anEnd step:aStep]];
    return chain;
}


- (NSArray *)array {
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


- (CNChain *)filter:(cnPredicate)predicate {
    return [self link:[CNFilterLink linkWithPredicate:predicate selectivity:0]];
}

- (CNChain *)filter:(cnPredicate)predicate selectivity:(double)selectivity {
    return [self link:[CNFilterLink linkWithPredicate:predicate selectivity:selectivity]];
}

- (CNChain *)map:(cnF)f {
    return [self link:[CNMapLink linkWithF:f]];
}

- (CNChain *)append:(id)collection {
    return [self link:[CNAppendLink linkWithCollection:collection]];
}

- (CNChain *)prepend:(id)collection {
    return [self link:[CNPrependLink linkWithCollection:collection]];
}


- (CNChain *)mul:(id)collection {
    return [self link:[CNMulLink linkWithCollection:collection]];
}

- (id)first {
    __block id ret = [CNOption none];
    [self apply:[CNYield yieldWithBegin:nil yield:^CNYieldResult(id item) {
        ret = item;
        return cnYieldBreak;
    } end:nil all:nil]];
    return ret;
}


- (CNYieldResult)apply:(CNYield *)yield {
    CNYield *y = [_first buildYield:yield];
    CNYieldResult result = [y beginYieldWithSize:0];
    return [y endYieldWithResult:result];
}

- (CNChain*)link:(id <CNChainLink>)link {
    CNChainItem *next = [CNChainItem itemWithLink:link];
    if(_first == nil) {
        _first = next;
        _last = _first;
    } else {
        _last.next = next;
        _last = next;
    }
    return self;
}

@end

id cnResolveCollection(id collection) {
    if([collection isKindOfClass:[CNChain class]]) return [collection array];
    return collection;
}
