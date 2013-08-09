#import "CNTreeMapTest.h"

#import "CNTreeMap.h"
@implementation CNTreeMapTest

+ (id)treeMapTest {
    return [[CNTreeMapTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (NSInteger)compA:(NSInteger)a b:(NSInteger)b {
    if(a < b) {
        return 1;
    } else {
        if(a > b) return -1;
        else return 0;
    }
}

- (void)testMain {
    CNTreeMap* map = [CNTreeMap treeMapWithComparator:^NSInteger(id a, id b) {
        return [self compA:unumi(a) b:unumi(b)];
    }];
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
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNTreeMapTest* o = ((CNTreeMapTest*)other);
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


