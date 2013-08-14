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
    CNTreeMap* map = [CNTreeMap new];
    [self assertEqualsA:@0 b:numi([map count])];
    [self assertTrueValue:[[map objectForKey:@0] isEmpty]];
    [map setObject:@"test" forKey:@0];
    [self assertEqualsA:@"test" b:[[map objectForKey:@0] get]];
    NSArray* tests = (@[@-10, @-20, @-30, @10, @20, @-15, @20, @0, @11, @13, @-18]);
    [tests forEach:^void(id i) {
        [map setObject:[@"test" stringByAppendingFormat:@"%li", unumi(i)] forKey:i];
    }];
    [self assertEqualsA:numi([[tests distinct] count]) b:numi([map count])];
    [[tests distinct] forEach:^void(id i) {
        [self assertEqualsA:[@"test" stringByAppendingFormat:@"%li", unumi(i)] b:[[map objectForKey:i] get]];
    }];
    [self assertEqualsA:(@[@-30, @-20, @-18, @-15, @-10, @0, @10, @11, @13, @20]) b:[[map.keys chain] toArray]];
    [[tests distinct] forEach:^void(id i) {
        [self assertEqualsA:[@"test" stringByAppendingFormat:@"%li", unumi(i)] b:[[map objectForKey:i] get]];
        [map removeObjectForKey:i];
        [self assertTrueValue:[[map objectForKey:i] isEmpty]];
    }];
    [self assertEqualsA:@0 b:numi([map count])];
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


