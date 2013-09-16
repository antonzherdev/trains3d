#import "objd.h"
#import "core.h"

@implementation Chain
static NSString* _Chain_prefix = @"CN";
static ODClassType* _Chain_type;

+ (void)initialize {
    [super initialize];
    _Chain_type = [ODClassType classTypeWithCls:[Chain class]];
}

- (ODClassType*)type {
    return [Chain type];
}

+ (NSString*)prefix {
    return _Chain_prefix;
}

+ (ODClassType*)type {
    return _Chain_type;
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


@implementation Test
static NSString* _Test_prefix = @"TS";
static ODClassType* _Test_type;

+ (void)initialize {
    [super initialize];
    _Test_type = [ODClassType classTypeWithCls:[Test class]];
}

- (ODClassType*)type {
    return [Test type];
}

+ (NSString*)prefix {
    return _Test_prefix;
}

+ (ODClassType*)type {
    return _Test_type;
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


