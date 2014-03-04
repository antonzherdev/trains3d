#import "objd.h"
#import "CNFlatLink.h"

#import "CNYield.h"
#import "CNCollection.h"
#import "ODType.h"
@implementation CNFlatLink{
    CGFloat _factor;
}
static ODClassType* _CNFlatLink_type;
@synthesize factor = _factor;

+ (instancetype)flatLinkWithFactor:(CGFloat)factor {
    return [[CNFlatLink alloc] initWithFactor:factor];
}

- (instancetype)initWithFactor:(CGFloat)factor {
    self = [super init];
    if(self) _factor = factor;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNFlatLink class]) _CNFlatLink_type = [ODClassType classTypeWithCls:[CNFlatLink class]];
}

- (CNYield*)buildYield:(CNYield*)yield {
    return [CNYield decorateBase:yield begin:^NSInteger(NSUInteger size) {
        return [yield beginYieldWithSize:((NSUInteger)(size * _factor))];
    } yield:^NSInteger(id<CNTraversable> col) {
        __block NSInteger result = 0;
        [((id<CNTraversable>)(col)) goOn:^BOOL(id item) {
            if([yield yieldItem:item] != 0) {
                result = 1;
                return NO;
            } else {
                return YES;
            }
        }];
        return result;
    }];
}

- (ODClassType*)type {
    return [CNFlatLink type];
}

+ (ODClassType*)type {
    return _CNFlatLink_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNFlatLink* o = ((CNFlatLink*)(other));
    return eqf(self.factor, o.factor);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.factor);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"factor=%f", self.factor];
    [description appendString:@">"];
    return description;
}

@end

