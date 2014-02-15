#import "GEPerlinTest.h"

#import "GEPerlin.h"
@implementation GEPerlinTest
static ODClassType* _GEPerlinTest_type;

+ (id)perlinTest {
    return [[GEPerlinTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GEPerlinTest class]) _GEPerlinTest_type = [ODClassType classTypeWithCls:[GEPerlinTest class]];
}

- (void)testMain {
    GEPerlin1* noise = [GEPerlin1 applyOctaves:2 frequency:10.0 amplitude:1.0];
    id<CNSeq> a = [[[intTo(1, 100) chain] map:^id(id i) {
        return numf([noise applyX:unumi(i) / 100.0]);
    }] toArray];
    [a forEach:^void(id v) {
        [self assertTrueValue:floatBetween(unumf(v), -1.0, 1.0)];
    }];
    CGFloat s = unumf([[a chain] foldStart:@0.0 by:^id(id r, id i) {
        return numf(unumf(r) + unumf(i));
    }]);
    [self assertTrueValue:!(eqf(s, 0))];
}

- (ODClassType*)type {
    return [GEPerlinTest type];
}

+ (ODClassType*)type {
    return _GEPerlinTest_type;
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


