#import "CNTest.h"

@implementation CNTestCase

+ (id)testCase {
    return [[CNTestCase alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)assertEqualsA:(id)a b:(id)b {
    STAssertEqualObjects(a, b, @"!=");
}

- (void)assertTrueValue:(BOOL)value {
    STAssertTrue(value, @"Is not true");
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNTestCase* o = ((CNTestCase*)other);
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


