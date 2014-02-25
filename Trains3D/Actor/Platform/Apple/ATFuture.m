#import "ATFuture.h"

#import "ATTry.h"
@implementation ATPromise{
    id __value;
}
static ODClassType* _ATPromise_type;

+ (id)promise {
    return [[ATPromise alloc] init];
}

- (id)init {
    self = [super init];
    if(self) __value = [CNOption none];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATPromise class]) _ATPromise_type = [ODClassType classTypeWithCls:[ATPromise class]];
}

- (id)value {
    return __value;
}

- (void)successValue:(id)value {
    __value = [CNOption applyValue:[ATSuccess successWithGet:value]];
}

- (void)failureReason:(id)reason {
    __value = [CNOption applyValue:[ATFailure failureWithReason:reason]];
}

- (ODClassType*)type {
    return [ATPromise type];
}

+ (ODClassType*)type {
    return _ATPromise_type;
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


