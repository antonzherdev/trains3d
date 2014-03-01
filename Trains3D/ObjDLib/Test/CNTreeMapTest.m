#import "objd.h"
#import "CNTreeMapTest.h"

#import "CNTreeMap.h"
#import "CNChain.h"
#import "ODType.h"
@implementation CNTreeMapTest
static ODClassType* _CNTreeMapTest_type;

+ (instancetype)treeMapTest {
    return [[CNTreeMapTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNTreeMapTest class]) _CNTreeMapTest_type = [ODClassType classTypeWithCls:[CNTreeMapTest class]];
}

- (void)testMain {
    CNMTreeMap* map = [CNMTreeMap apply];
    assertEquals(@0, numi(((NSInteger)([map count]))));
    assertTrue([[map optKey:@0] isEmpty]);
    [map setKey:@0 value:@"test"];
    assertEquals(@"test", [map applyKey:@0]);
    id<CNSeq> tests = (@[@-10, @-20, @-30, @10, @20, @-15, @20, @0, @11, @13, @-18]);
    [tests forEach:^void(id i) {
        [map setKey:i value:[@"test" stringByAppendingFormat:@"%ld", unumi(i)]];
    }];
    assertEquals(numui([[[tests chain] distinct] count]), numui([map count]));
    [[[tests chain] distinct] forEach:^void(id i) {
        assertEquals(([@"test" stringByAppendingFormat:@"%ld", unumi(i)]), [map applyKey:i]);
    }];
    assertEquals(((@[@-30, @-20, @-18, @-15, @-10, @0, @10, @11, @13, @20])), [[map.keys chain] toArray]);
    [[[tests chain] distinct] forEach:^void(id i) {
        assertEquals(([@"test" stringByAppendingFormat:@"%ld", unumi(i)]), [map applyKey:i]);
        [map removeForKey:i];
        assertTrue([[map optKey:i] isEmpty]);
    }];
    assertEquals(@0, numi(((NSInteger)([map count]))));
}

- (ODClassType*)type {
    return [CNTreeMapTest type];
}

+ (ODClassType*)type {
    return _CNTreeMapTest_type;
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


