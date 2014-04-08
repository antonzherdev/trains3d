#import "ATActorTest.h"

@implementation ATTestedActor
static ODClassType* _ATTestedActor_type;
@synthesize items = _items;

+ (instancetype)testedActor {
    return [[ATTestedActor alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _items = (@[]);
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATTestedActor class]) _ATTestedActor_type = [ODClassType classTypeWithCls:[ATTestedActor class]];
}

- (CNFuture*)addNumber:(NSString*)number {
    return [self futureF:^id() {
        _items = [_items addItem:number];
        return nil;
    }];
}

- (CNFuture*)getItems {
    return [self promptF:^NSArray*() {
        return _items;
    }];
}

- (CNFuture*)getItemsF {
    return [self futureF:^NSArray*() {
        return _items;
    }];
}

- (CNFuture*)lockFuture:(CNFuture*)future {
    return [self lockAndOnSuccessFuture:future f:^NSString*(NSString* s) {
        _items = [_items addItem:[NSString stringWithFormat:@"w%@", s]];
        return s;
    }];
}

- (ODClassType*)type {
    return [ATTestedActor type];
}

+ (ODClassType*)type {
    return _ATTestedActor_type;
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


@implementation ATActorTest
static ODClassType* _ATActorTest_type;

+ (instancetype)actorTest {
    return [[ATActorTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATActorTest class]) _ATActorTest_type = [ODClassType classTypeWithCls:[ATActorTest class]];
}

- (void)testTypedActor {
    ATTestedActor* a = [ATTestedActor testedActor];
    __block NSArray* items = (@[]);
    NSInteger en = 0;
    cnLogApplyText(@"!!ADD");
    NSInteger count = 10000;
    [intTo(1, count) forEach:^void(id i) {
        items = [items addItem:[NSString stringWithFormat:@"%@", i]];
    }];
    [[[[intTo(1, count) chain] map:^CNFuture*(id i) {
        return [CNFuture applyF:^id() {
            autoreleasePoolStart();
            [a addNumber:[NSString stringWithFormat:@"%@", i]];
            autoreleasePoolEnd();
            return nil;
        }];
    }] voidFuture] getResultAwait:5.0];
    cnLogApplyText(@"!!END_ADD");
    NSArray* result = [[a getItems] getResultAwait:5.0];
    NSArray* result2 = [[a getItemsF] getResultAwait:5.0];
    cnLogApplyText(@"!!GOT");
    assertEquals([[items chain] toSet], [[result chain] toSet]);
    assertEquals([[items chain] toSet], [[result2 chain] toSet]);
    assertTrue(en != count);
}

- (void)testTypedActor2 {
    [self repeatTimes:100 f:^void() {
        ATTestedActor* a = [ATTestedActor testedActor];
        __block NSArray* items = (@[]);
        NSInteger en = 0;
        cnLogApplyText(@"!!ADD");
        NSInteger count = 1000;
        [intTo(1, count) forEach:^void(id i) {
            items = [items addItem:[NSString stringWithFormat:@"%@", i]];
        }];
        [[[[intTo(1, count) chain] map:^CNFuture*(id i) {
            return [a addNumber:[NSString stringWithFormat:@"%@", i]];
        }] voidFuture] getResultAwait:5.0];
        cnLogApplyText(@"!!END_ADD");
        NSArray* result = [[a getItems] getResultAwait:5.0];
        NSArray* result2 = [[a getItemsF] getResultAwait:5.0];
        cnLogApplyText(@"!!GOT");
        assertEquals([[items chain] toSet], [[result chain] toSet]);
        assertEquals([[items chain] toSet], [[result2 chain] toSet]);
        assertTrue(en != count);
    }];
}

- (void)testLock {
    [self repeatTimes:100 f:^void() {
        ATTestedActor* a = [ATTestedActor testedActor];
        NSInteger count = 100;
        NSArray* arr = [[[intTo(1, count) chain] map:^CNTuple*(id _) {
            return tuple(_, [CNPromise apply]);
        }] toArray];
        for(CNTuple* t in arr) {
            [a lockFuture:((CNTuple*)(t)).b];
        }
        CNFuture* f = [a getItems];
        [[[arr chain] shuffle] forEach:^void(CNTuple* t) {
            [((CNPromise*)(((CNTuple*)(t)).b)) successValue:[NSString stringWithFormat:@"%@", ((CNTuple*)(t)).a]];
        }];
        NSArray* exp = [[[arr chain] map:^NSString*(CNTuple* _) {
            return [NSString stringWithFormat:@"w%@", ((CNTuple*)(_)).a];
        }] toArray];
        NSArray* items = [f getResultAwait:5.0];
        assertEquals(items, exp);
    }];
}

- (ODClassType*)type {
    return [ATActorTest type];
}

+ (ODClassType*)type {
    return _ATActorTest_type;
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


