#import "ATActorTest.h"

#import "ATFuture.h"
#import "ATActor.h"
#import "ATTry.h"
@implementation ATTestedActor{
    id<CNSeq> _items;
}
static ODClassType* _ATTestedActor_type;
@synthesize items = _items;

+ (id)testedActor {
    return [[ATTestedActor alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _items = (@[]);
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATTestedActor class]) _ATTestedActor_type = [ODClassType classTypeWithCls:[ATTestedActor class]];
}

- (void)addNumber:(NSInteger)number {
    _items = [_items addItem:numi(number)];
}

- (ATFuture*)getItems {
    __weak ATTestedActor* _weakSelf = self;
    return [self promptF:^id<CNSeq>() {
        return _weakSelf.items;
    }];
}

- (ATFuture*)futureF:(id(^)())f {
    return [ATTypedActorFuture typedActorFutureWithF:f prompt:NO];
}

- (ATFuture*)promptF:(id(^)())f {
    return [ATTypedActorFuture typedActorFutureWithF:f prompt:YES];
}

- (id)actor {
    return [ATActors typedActor:self];
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

+ (id)actorTest {
    return [[ATActorTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATActorTest class]) _ATActorTest_type = [ODClassType classTypeWithCls:[ATActorTest class]];
}

- (void)testTypedActor {
    ATTestedActor* ta = [ATTestedActor testedActor];
    ATTestedActor* a = [ta actor];
    __block NSInteger n = 0;
    __block id<CNSeq> items = (@[]);
    __block NSInteger en = 0;
    [CNLog applyText:@"!!ADD"];
    [intTo(1, 100) forEach:^void(id i) {
        items = [items addItem:i];
        [a addNumber:unumi(i)];
        n++;
        if([ta.items count] == n) en++;
    }];
    [CNLog applyText:@"!!END_ADD"];
    id<CNSeq> result = [((ATTry*)([[[a getItems] waitResultPeriod:1.0] get])) get];
    [CNLog applyText:@"!!GOT"];
    [self assertEqualsA:items b:result];
    [self assertTrueValue:en != 100];
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


