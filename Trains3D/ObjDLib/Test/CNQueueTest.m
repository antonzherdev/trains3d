#import "objd.h"
#import "CNQueueTest.h"

#import "CNQueue.h"
#import "ODType.h"
@implementation CNQueueTest
static ODClassType* _CNQueueTest_type;

+ (instancetype)queueTest {
    return [[CNQueueTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNQueueTest class]) _CNQueueTest_type = [ODClassType classTypeWithCls:[CNQueueTest class]];
}

- (void)testDeque {
    CNImQueue* q = [CNImQueue apply];
    assertTrue([q isEmpty]);
    assertEquals(@0, numi(((NSInteger)([q count]))));
    q = [q enqueueItem:@1];
    assertTrue(!([q isEmpty]));
    assertEquals(@1, numi(((NSInteger)([q count]))));
    q = [q enqueueItem:@2];
    assertEquals(@2, numi(((NSInteger)([q count]))));
    q = [q enqueueItem:@3];
    assertEquals(@3, numi(((NSInteger)([q count]))));
    CNTuple* p = [q dequeue];
    q = p.b;
    assertEquals(@1, [p.a get]);
    assertEquals(@2, numi(((NSInteger)([q count]))));
    p = [q dequeue];
    q = p.b;
    assertEquals(@2, [p.a get]);
    assertEquals(@1, numi(((NSInteger)([q count]))));
    p = [q dequeue];
    q = p.b;
    assertEquals(@3, [p.a get]);
    assertEquals(@0, numi(((NSInteger)([q count]))));
}

- (ODClassType*)type {
    return [CNQueueTest type];
}

+ (ODClassType*)type {
    return _CNQueueTest_type;
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


