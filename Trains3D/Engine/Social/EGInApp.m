#import "EGInApp.h"

@implementation EGInAppProduct{
    NSString* _id;
    NSString* _name;
    NSString* _price;
}
static ODClassType* _EGInAppProduct_type;
@synthesize id = _id;
@synthesize name = _name;
@synthesize price = _price;

+ (id)inAppProductWithId:(NSString*)id name:(NSString*)name price:(NSString*)price {
    return [[EGInAppProduct alloc] initWithId:id name:name price:price];
}

- (id)initWithId:(NSString*)id name:(NSString*)name price:(NSString*)price {
    self = [super init];
    if(self) {
        _id = id;
        _name = name;
        _price = price;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGInAppProduct_type = [ODClassType classTypeWithCls:[EGInAppProduct class]];
}

- (ODClassType*)type {
    return [EGInAppProduct type];
}

+ (ODClassType*)type {
    return _EGInAppProduct_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGInAppProduct* o = ((EGInAppProduct*)(other));
    return [self.id isEqual:o.id] && [self.name isEqual:o.name] && [self.price isEqual:o.price];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.id hash];
    hash = hash * 31 + [self.name hash];
    hash = hash * 31 + [self.price hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"id=%@", self.id];
    [description appendFormat:@", name=%@", self.name];
    [description appendFormat:@", price=%@", self.price];
    [description appendString:@">"];
    return description;
}

@end


