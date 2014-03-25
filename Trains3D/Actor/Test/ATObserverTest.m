#import "ATObserverTest.h"

#import "ATObserver.h"
@implementation ATObserverTest
static ODClassType* _ATObserverTest_type;

+ (instancetype)observerTest {
    return [[ATObserverTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATObserverTest class]) _ATObserverTest_type = [ODClassType classTypeWithCls:[ATObserverTest class]];
}

- (void)testSignal {
    ATSignal* sig = [ATSignal signal];
    __block NSInteger v = 0;
    ATObserver* o = [sig observeF:^void(id i) {
        v = unumi(i);
    }];
    assertEquals(numi(v), @0);
    [sig postData:@1];
    assertEquals(numi(v), @1);
    [sig postData:@2];
    assertEquals(numi(v), @2);
    [o detach];
    [sig postData:@3];
    assertEquals(numi(v), @2);
}

- (ODClassType*)type {
    return [ATObserverTest type];
}

+ (ODClassType*)type {
    return _ATObserverTest_type;
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


