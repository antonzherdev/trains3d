#import "GEPerlinTest.h"

#import "GEPerlin.h"
#import "CNChain.h"
@implementation GEPerlinTest
static CNClassType* _GEPerlinTest_type;

+ (instancetype)perlinTest {
    return [[GEPerlinTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [GEPerlinTest class]) _GEPerlinTest_type = [CNClassType classTypeWithCls:[GEPerlinTest class]];
}

- (void)testMain {
    GEPerlin1* noise = [GEPerlin1 applyOctaves:2 frequency:10.0 amplitude:1.0];
    NSArray* a = [[[intTo(1, 100) chain] mapF:^id(id i) {
        return numf([noise applyX:unumi(i) / 100.0]);
    }] toArray];
    for(id v in a) {
        assertTrue((floatBetween(unumf(v), -1.0, 1.0)));
    }
    CGFloat s = unumf(([[a chain] foldStart:@0.0 by:^id(id r, id i) {
        return numf(unumf(r) + unumf(i));
    }]));
    assertTrue((!(eqf(s, 0))));
}

- (NSString*)description {
    return @"PerlinTest";
}

- (CNClassType*)type {
    return [GEPerlinTest type];
}

+ (CNClassType*)type {
    return _GEPerlinTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

