#import "ATReactTest.h"

#import "ATReact.h"
@implementation ATReactTest
static ODClassType* _ATReactTest_type;

+ (instancetype)reactTest {
    return [[ATReactTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATReactTest class]) _ATReactTest_type = [ODClassType classTypeWithCls:[ATReactTest class]];
}

- (void)testMap {
    ATVar* v = [ATVar applyInitial:@2];
    ATReact* m = [v mapF:^id(id _) {
        return numi(unumi(_) * unumi(_));
    }];
    ATReact* m2 = [m mapF:^id(id _) {
        return numi(unumi(_) * unumi(_));
    }];
    assertEquals([m value], @4);
    assertEquals([m2 value], @16);
    [v setValue:@4];
    assertEquals([m value], @16);
    assertEquals([m2 value], numi(16 * 16));
}

- (void)testReactFlag {
    ATVar* a1 = [ATVar applyInitial:@1];
    ATVar* a2 = [ATVar applyInitial:@2];
    ATReactFlag* f = [ATReactFlag reactFlagWithInitial:YES reacts:(@[a1, a2])];
    assertTrue(unumb([f value]));
    [f clear];
    assertFalse(unumb([f value]));
    [f set];
    assertTrue(unumb([f value]));
    [f clear];
    assertFalse(unumb([f value]));
    [a1 setValue:@1];
    assertFalse(unumb([f value]));
    [a1 setValue:@2];
    assertTrue(unumb([f value]));
    [f clear];
    assertFalse(unumb([f value]));
    [a2 setValue:@1];
    assertTrue(unumb([f value]));
    [f clear];
    assertFalse(unumb([f value]));
    [a1 setValue:@3];
    [a2 setValue:@3];
    assertTrue(unumb([f value]));
}

- (ODClassType*)type {
    return [ATReactTest type];
}

+ (ODClassType*)type {
    return _ATReactTest_type;
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


