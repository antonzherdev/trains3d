#import "objd.h"
#import "CNSet.h"

#import "ODType.h"
#import "CNChain.h"
#import "CNDispatchQueue.h"
@implementation CNHashSetBuilder{
    NSMutableSet* _set;
}
static ODClassType* _CNHashSetBuilder_type;
@synthesize set = _set;

+ (instancetype)hashSetBuilder {
    return [[CNHashSetBuilder alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _set = [NSMutableSet mutableSet];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNHashSetBuilder class]) _CNHashSetBuilder_type = [ODClassType classTypeWithCls:[CNHashSetBuilder class]];
}

- (void)appendItem:(id)item {
    [_set appendItem:item];
}

- (NSSet*)build {
    return [_set im];
}

- (void)appendAllItems:(id<CNTraversable>)items {
    [items forEach:^void(id _) {
        [self appendItem:_];
    }];
}

- (ODClassType*)type {
    return [CNHashSetBuilder type];
}

+ (ODClassType*)type {
    return _CNHashSetBuilder_type;
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


