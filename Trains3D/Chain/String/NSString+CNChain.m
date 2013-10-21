#import "NSString+CNChain.h"
#import "NSArray+CNChain.h"
#import "CNTuple.h"
#import "CNOption.h"
#import "CNCollection.h"
#import "CNChain.h"
#import "CNSet.h"

@interface CNSplitByIterator : NSObject<CNIterator>
- (id)initWithString:(NSString *)string by:(NSString *)by;

+ (id)iteratorWithString:(NSString *)string by:(NSString *)by;

@end

@implementation CNSplitByIterator {
    NSString* _string;
    NSString* _by;
}
- (id)initWithString:(NSString *)string by:(NSString *)by {
    self = [super init];
    if (self) {
        _string = string;
        _by = by;
    }

    return self;
}

- (BOOL)hasNext {
    return _string != nil && ![_string length] == 0;
}

- (id)next {
    NSRange range = [_string rangeOfString:_by];
    if(range.length <= 0) {
        NSString *r = _string;
        _string = nil;
        return r;
    } else {
        NSString *r = [_string substringToIndex:range.location];
        _string = [_string substringFromIndex:range.location + range.length];
        return r;
    }
}

+ (id)iteratorWithString:(NSString *)string by:(NSString *)by {
    return [[self alloc] initWithString:string by:by];
}
@end

@implementation NSString (CNChain)
- (id)tupleBy:(NSString *)by {
    NSRange range = [self rangeOfString:by];
    if(range.length <= 0) return [CNOption none];
    return [CNSome someWithValue:[CNTuple tupleWithA:[self substringToIndex:range.location] b:[self substringFromIndex:range.location + range.length]]];
}

- (id <CNIterable>)splitBy:(NSString *)by {
    return [CNIterableF iterableFWithIteratorF:^id <CNIterator> {
        return [CNSplitByIterator iteratorWithString:self by:by];
    }];
}

- (CGFloat)toFloat {
    return [self floatValue];
}

- (NSInteger)toInt {
    return [self integerValue];
}

- (NSUInteger)toUInt {
    return (NSUInteger) [self integerValue];
}


- (id)applyIndex:(NSUInteger)index1 {
    if(index1 >= [self length]) @throw @"Incorrect index";
    return nums([self characterAtIndex:index1]);
}

- (NSUInteger)count {
    return self.length;
}

- (id <CNIterator>)iterator {
    return [CNIndexFunSeqIterator indexFunSeqIteratorWithCount:self.length f:^id(NSUInteger i) {
        return nums([self characterAtIndex:i]);
    }];
}

- (id)optIndex:(NSUInteger)index1 {
    if(index1 >= [self length]) return [CNOption none];
    return [CNOption someValue:nums([self characterAtIndex:index1])];
}

- (id)randomItem {
    if([self isEmpty]) return [CNOption none];
    else return [CNSome someWithValue:[self applyIndex:oduIntRndMax([self count] - 1)]];
}

- (id<CNSet>)toSet {
    return [self convertWithBuilder:[CNHashSetBuilder hashSetBuilder]];
}

- (id<CNSeq>)addItem:(id)item {
    CNArrayBuilder* builder = [CNArrayBuilder arrayBuilder];
    [builder appendAllItems:self];
    [builder appendItem:item];
    return ((NSArray*)([builder build]));
}

- (id <CNSeq>)addSeq:(id <CNSeq>)seq {
    CNArrayBuilder* builder = [CNArrayBuilder arrayBuilder];
    [builder appendAllItems:self];
    [builder appendAllItems:seq];
    return ((NSArray*)([builder build]));
}


- (id<CNSeq>)subItem:(id)item {
    return [[[self chain] filter:^BOOL(id _) {
        return !([_ isEqual:item]);
    }] toArray];
}

- (BOOL)isEqualToSeq:(id<CNSeq>)seq {
    if([self count] != [seq count]) return NO;
    id<CNIterator> ia = [self iterator];
    id<CNIterator> ib = [seq iterator];
    while([ia hasNext] && [ib hasNext]) {
        if(!([[ia next] isEqual:[ib next]])) return NO;
    }
    return YES;
}

- (BOOL)isEmpty {
    return [self length] == 0;
}

- (id)head {
    return nums([self characterAtIndex:0]);
}

- (id)headOpt {
    if([self length] == 0) return [CNOption none];
    return [CNOption someValue:nums([self characterAtIndex:0])];
}

- (CNChain*)chain {
    return [CNChain chainWithCollection:self];
}

- (void)forEach:(void(^)(id))each {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        each([i next]);
    }
}

- (BOOL)goOn:(BOOL(^)(id))on {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        if(!(on([i next]))) return NO;
    }
    return YES;
}

- (BOOL)containsItem:(id)item {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        if([[i next] isEqual:i]) return YES;
    }
    return NO;
}

- (id)findWhere:(BOOL(^)(id))where {
    __block id ret = [CNOption none];
    [self goOn:^BOOL(id x) {
        if(where(ret)) {
            ret = [CNOption applyValue:x];
            NO;
        }
        return YES;
    }];
    return ret;
}

- (id)convertWithBuilder:(id<CNBuilder>)builder {
    [self forEach:^void(id x) {
        [builder appendItem:x];
    }];
    return [builder build];
}

@end

