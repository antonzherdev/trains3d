#import "EGBillboard.h"

#import "EG.h"
#import "EGMatrix.h"
@implementation EGBillboard
static ODClassType* _EGBillboard_type;

+ (id)billboard {
    return [[EGBillboard alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboard_type = [ODClassType classTypeWithCls:[EGBillboard class]];
}

+ (void)drawWithSize:(EGVec2)size {
}

- (ODClassType*)type {
    return [EGBillboard type];
}

+ (ODClassType*)type {
    return _EGBillboard_type;
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


