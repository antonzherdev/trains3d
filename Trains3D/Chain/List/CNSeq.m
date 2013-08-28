#import "CNSeq.h"
#import "cnTypes.h"
#import "NSMutableArray+CNChain.h"

#import "CNChain.h"
@implementation CNArrayBuilder{
    NSMutableArray* _array;
}
static ODType* _CNArrayBuilder_type;
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
    _CNArrayBuilder_type = [ODType typeWithCls:[CNArrayBuilder class]];
}

- (void)addObject:(id)object {
    [_array addObject:object];
    self;
}

- (NSArray*)build {
    return _array;
}

- (ODType*)type {
    return _CNArrayBuilder_type;
}

- (void)addAllObject:(id<CNTraversable>)object {
    [object forEach:^void(id _) {
        [self addObject:_];
    }];
}

+ (ODType*)type {
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


