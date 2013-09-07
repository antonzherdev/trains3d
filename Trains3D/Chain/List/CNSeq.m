#import "objd.h"
#import "CNSeq.h"

#import "CNChain.h"
#import "CNSet.h"
@implementation CNArrayBuilder{
    NSMutableArray* _array;
}
static ODClassType* _CNArrayBuilder_type;
@synthesize array = _array;

+ (id)arrayBuilder {
    return [[CNArrayBuilder alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _array = [NSMutableArray mutableArray];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNArrayBuilder_type = [ODClassType classTypeWithCls:[CNArrayBuilder class]];
}

- (void)addObject:(id)object {
    [_array addObject:object];
    self;
}

- (NSArray*)build {
    return _array;
}

- (void)addAllObject:(id<CNTraversable>)object {
    [object forEach:^void(id _) {
        [self addObject:_];
    }];
}

- (ODClassType*)type {
    return [CNArrayBuilder type];
}

+ (ODClassType*)type {
    return _CNArrayBuilder_type;
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


