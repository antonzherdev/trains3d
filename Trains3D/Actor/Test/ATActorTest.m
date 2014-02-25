#import "ATActorTest.h"

#import "ATActor.h"
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

- (id<CNSeq>)getItems {
    return _items;
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
    ATTestedActor* a = [ATActors typedActor:ta];
    __block id<CNSeq> n = (@[]);
    __block NSInteger en = 0;
    [intTo(1, 100) forEach:^void(id i) {
        n = [n addItem:i];
        [a addNumber:unumi(i)];
        if([ta.items count] == n) en++;
    }];
    [self assertEqualsA:n b:ta.items];
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


