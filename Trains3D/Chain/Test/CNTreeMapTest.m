#import "CNTreeMapTest.h"

@implementation CNTreeMapTest

+ (id)treeMapTest {
    return [[CNTreeMapTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)testMain {
    CNMutableTreeMap* map = [CNMutableTreeMap new];
    [self assertEqualsA:@0 b:numi(((NSInteger)([map count])))];
    [self assertTrueValue:[[map applyKey:@0] isEmpty]];
    [map setObject:@"test" forKey:@0];
    [self assertEqualsA:@"test" b:[[map applyKey:@0] get]];
    id<CNSeq> tests = (@[@-10, @-20, @-30, @10, @20, @-15, @20, @0, @11, @13, @-18]);
    [tests forEach:^void(id i) {
        [map setObject:[@"test" stringByAppendingFormat:@"%li", unumi(i)] forKey:i];
    }];
    [self assertEqualsA:numui([[[tests chain] distinct] count]) b:numui([map count])];
    [[[tests chain] distinct] forEach:^void(id i) {
        [self assertEqualsA:[@"test" stringByAppendingFormat:@"%li", unumi(i)] b:[[map applyKey:i] get]];
    }];
    [self assertEqualsA:(@[@-30, @-20, @-18, @-15, @-10, @0, @10, @11, @13, @20]) b:[[map.keys chain] toArray]];
    [[[tests chain] distinct] forEach:^void(id i) {
        [self assertEqualsA:[@"test" stringByAppendingFormat:@"%li", unumi(i)] b:[[map applyKey:i] get]];
        [map removeForKey:i];
        [self assertTrueValue:[[map applyKey:i] isEmpty]];
    }];
    [self assertEqualsA:@0 b:numi(((NSInteger)([map count])))];
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


