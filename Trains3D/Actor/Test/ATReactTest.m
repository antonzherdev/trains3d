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
    assertEquals([m value], @4);
    [v setValue:@4];
    assertEquals([m value], @16);
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


