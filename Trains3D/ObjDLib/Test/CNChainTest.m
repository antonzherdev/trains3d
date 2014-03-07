#import "objd.h"
#import "CNChainTest.h"

#import "CNChain.h"
#import "CNRange.h"
#import "CNFuture.h"
#import "CNDispatchQueue.h"
#import "CNTry.h"
#import "CNAtomic.h"
#import "ODType.h"
@implementation CNChainTest
static ODClassType* _CNChainTest_type;

+ (instancetype)chainTest {
    return [[CNChainTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNChainTest class]) _CNChainTest_type = [ODClassType classTypeWithCls:[CNChainTest class]];
}

- (void)testAnd {
    assertTrue((!([[(@[@YES, @NO, @YES]) chain] and])));
    assertTrue((!([[(@[@NO, @NO, @NO]) chain] and])));
    assertTrue(([[(@[@YES, @YES, @YES]) chain] and]));
    assertTrue([[(@[]) chain] and]);
}

- (void)testOr {
    assertTrue(([[(@[@NO, @NO, @YES]) chain] or]));
    assertTrue((!([[(@[@NO, @NO, @NO]) chain] or])));
    assertTrue(([[(@[@YES, @YES, @YES]) chain] or]));
    assertTrue(!([[(@[]) chain] or]));
}

- (void)testFuture {
    [self repeatTimes:1000 f:^void() {
        id<CNImSeq> arr = [[[intTo(0, 1000) chain] map:^CNTuple*(id i) {
            return tuple(i, [CNPromise apply]);
        }] toArray];
        [arr forEach:^void(CNTuple* t) {
            [CNDispatchQueue.aDefault asyncF:^void() {
                [((CNPromise*)(((CNTuple*)(t)).b)) successValue:numi(unumi(((CNTuple*)(t)).a) * unumi(((CNTuple*)(t)).a))];
            }];
        }];
        CNFuture* fut = [[[arr chain] map:^CNPromise*(CNTuple* _) {
            return ((CNTuple*)(_)).b;
        }] futureF:^id<CNImSeq>(CNChain* chain) {
            return [chain toArray];
        }];
        id<CNImSeq> set = [[[[arr chain] map:^id(CNTuple* _) {
            return ((CNTuple*)(_)).a;
        }] map:^id(id _) {
            return numi(unumi(_) * unumi(_));
        }] toArray];
        assertEquals(set, [((CNTry*)([[fut waitResultPeriod:5.0] get])) get]);
    }];
}

- (void)testVoidFuture {
    id<CNImSeq> arr = [[[intTo(0, 1000) chain] map:^CNPromise*(id i) {
        return [CNPromise apply];
    }] toArray];
    CNFuture* fut = [[arr chain] voidFuture];
    CNAtomicInt* count = [CNAtomicInt atomicInt];
    [arr forEach:^void(CNPromise* p) {
        [CNDispatchQueue.aDefault asyncF:^void() {
            [count incrementAndGet];
            [((CNPromise*)(p)) successValue:nil];
        }];
    }];
    assertTrue([[fut waitResultPeriod:5.0] isDefined]);
    assertEquals(numi4([count intValue]), numi4(((int)([arr count]))));
}

- (void)testFlat {
    assertEquals(((@[@1, @5, @2, @3, @2])), ([[[(@[(@[@1, @5]), (@[@2, @3]), (@[@2])]) chain] flat] toArray]));
}

- (void)testZip {
    assertEquals(((@[@2, @3])), ([[[(@[@1, @0, @3]) chain] zipA:(@[@1, @3]) by:^id(id a, id b) {
        return numi(unumi(a) + unumi(b));
    }] toArray]));
}

- (void)testZip3 {
    assertEquals(((@[@3, @4])), ([[[(@[@1, @0, @3]) chain] zip3A:(@[@1, @3]) b:(@[@1, @1, @2, @4]) by:^id(id a, id b, id c) {
        return numi(unumi(a) + unumi(b) + unumi(c));
    }] toArray]));
}

- (void)testZipFor {
    __block id<CNImSeq> arr = (@[]);
    [[(@[@1, @0, @3]) chain] zipForA:(@[@1, @3]) by:^void(id a, id b) {
        arr = [arr addItem:numi(unumi(a) + unumi(b))];
    }];
    assertEquals(((@[@2, @3])), arr);
}

- (ODClassType*)type {
    return [CNChainTest type];
}

+ (ODClassType*)type {
    return _CNChainTest_type;
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


