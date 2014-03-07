#import "ATActorTest.h"

@implementation ATTestedActor{
    id<CNImSeq> _items;
}
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
    __weak ATTestedActor* _weakSelf = self;
    return [self futureF:^id() {
        _weakSelf.items = [_weakSelf.items addItem:number];
        return nil;
    }];
}

- (CNFuture*)getItems {
    __weak ATTestedActor* _weakSelf = self;
    return [self promptF:^id<CNImSeq>() {
        return _weakSelf.items;
    }];
}

- (CNFuture*)getItemsF {
    __weak ATTestedActor* _weakSelf = self;
    return [self futureF:^id<CNImSeq>() {
        return _weakSelf.items;
    }];
}

- (CNFuture*)lockFuture:(CNFuture*)future {
    __weak ATTestedActor* _weakSelf = self;
    return [self lockAndOnSuccessFuture:future f:^NSString*(NSString* s) {
        _weakSelf.items = [_weakSelf.items addItem:[NSString stringWithFormat:@"w%@", s]];
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
    ATTestedActor* a = [[ATTestedActor testedActor] actor];
    __block id<CNImSeq> items = (@[]);
    NSInteger en = 0;
    cnLogApplyText(@"!!ADD");
    NSInteger count = 10000;
    [intTo(1, count) forEach:^void(id i) {
        items = [items addItem:[NSString stringWithFormat:@"%@", i]];
    }];
    [((CNTry*)([[[[[intTo(1, count) chain] map:^CNFuture*(id i) {
        return [CNFuture applyF:^id() {
            autoreleasePoolStart();
            [a addNumber:[NSString stringWithFormat:@"%@", i]];
            autoreleasePoolEnd();
            return nil;
        }];
    }] voidFuture] waitResultPeriod:5.0] get])) get];
    cnLogApplyText(@"!!END_ADD");
    id<CNImSeq> result = [((CNTry*)([[[a getItems] waitResultPeriod:5.0] get])) get];
    id<CNImSeq> result2 = [((CNTry*)([[[a getItemsF] waitResultPeriod:5.0] get])) get];
    cnLogApplyText(@"!!GOT");
    assertEquals([[items chain] toSet], [[result chain] toSet]);
    assertEquals([[items chain] toSet], [[result2 chain] toSet]);
    assertTrue(en != count);
}

- (void)testTypedActor2 {
    [self repeatTimes:100 f:^void() {
        ATTestedActor* a = [[ATTestedActor testedActor] actor];
        __block id<CNImSeq> items = (@[]);
        NSInteger en = 0;
        cnLogApplyText(@"!!ADD");
        NSInteger count = 1000;
        [intTo(1, count) forEach:^void(id i) {
            items = [items addItem:[NSString stringWithFormat:@"%@", i]];
        }];
        [((CNTry*)([[[[[intTo(1, count) chain] map:^CNFuture*(id i) {
            return [a addNumber:[NSString stringWithFormat:@"%@", i]];
        }] voidFuture] waitResultPeriod:5.0] get])) get];
        cnLogApplyText(@"!!END_ADD");
        id<CNImSeq> result = [((CNTry*)([[[a getItems] waitResultPeriod:5.0] get])) get];
        id<CNImSeq> result2 = [((CNTry*)([[[a getItemsF] waitResultPeriod:5.0] get])) get];
        cnLogApplyText(@"!!GOT");
        assertEquals([[items chain] toSet], [[result chain] toSet]);
        assertEquals([[items chain] toSet], [[result2 chain] toSet]);
        assertTrue(en != count);
    }];
}

- (void)testLock {
    [self repeatTimes:100 f:^void() {
        ATTestedActor* a = [[ATTestedActor testedActor] actor];
        NSInteger count = 100;
        id<CNImSeq> arr = [[[intTo(1, count) chain] map:^CNTuple*(id _) {
            return tuple(_, [CNPromise apply]);
        }] toArray];
        [arr forEach:^void(CNTuple* t) {
            [a lockFuture:((CNTuple*)(t)).b];
        }];
        CNFuture* f = [a getItems];
        [[[arr chain] shuffle] forEach:^void(CNTuple* t) {
            [((CNPromise*)(((CNTuple*)(t)).b)) successValue:[NSString stringWithFormat:@"%@", ((CNTuple*)(t)).a]];
        }];
        id<CNImSeq> exp = [[[arr chain] map:^NSString*(CNTuple* _) {
            return [NSString stringWithFormat:@"w%@", ((CNTuple*)(_)).a];
        }] toArray];
        id<CNImSeq> items = [((CNTry*)([[f waitResultPeriod:5.0] get])) get];
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


