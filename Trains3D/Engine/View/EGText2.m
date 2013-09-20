#import "EGText2.h"

@implementation EGFont{
    NSString* _name;
    NSInteger _size;
}
static ODClassType* _EGFont_type;
@synthesize name = _name;
@synthesize size = _size;

+ (id)fontWithName:(NSString*)name size:(NSInteger)size {
    return [[EGFont alloc] initWithName:name size:size];
}

- (id)initWithName:(NSString*)name size:(NSInteger)size {
    self = [super init];
    if(self) {
        _name = name;
        _size = size;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFont_type = [ODClassType classTypeWithCls:[EGFont class]];
}

- (ODClassType*)type {
    return [EGFont type];
}

+ (ODClassType*)type {
    return _EGFont_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGFont* o = ((EGFont*)(other));
    return [self.name isEqual:o.name] && self.size == o.size;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.name hash];
    hash = hash * 31 + self.size;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name=%@", self.name];
    [description appendFormat:@", size=%li", self.size];
    [description appendString:@">"];
    return description;
}

@end


