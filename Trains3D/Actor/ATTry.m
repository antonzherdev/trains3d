#import "ATTry.h"

@implementation ATTry
static ODClassType* _ATTry_type;

+ (id)try {
    return [[ATTry alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATTry class]) _ATTry_type = [ODClassType classTypeWithCls:[ATTry class]];
}

- (id)get {
    @throw @"Method get is abstract";
}

- (BOOL)isSuccess {
    @throw @"Method isSuccess is abstract";
}

- (BOOL)isFailure {
    return !([self isSuccess]);
}

- (ODClassType*)type {
    return [ATTry type];
}

+ (ODClassType*)type {
    return _ATTry_type;
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


@implementation ATSuccess{
    id _get;
}
static ODClassType* _ATSuccess_type;
@synthesize get = _get;

+ (id)successWithGet:(id)get {
    return [[ATSuccess alloc] initWithGet:get];
}

- (id)initWithGet:(id)get {
    self = [super init];
    if(self) _get = get;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATSuccess class]) _ATSuccess_type = [ODClassType classTypeWithCls:[ATSuccess class]];
}

- (BOOL)isSuccess {
    return YES;
}

- (BOOL)isFailure {
    return NO;
}

- (ODClassType*)type {
    return [ATSuccess type];
}

+ (ODClassType*)type {
    return _ATSuccess_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    ATSuccess* o = ((ATSuccess*)(other));
    return [self.get isEqual:o.get];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.get hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"get=%@", self.get];
    [description appendString:@">"];
    return description;
}

@end


@implementation ATFailure{
    id _reason;
}
static ODClassType* _ATFailure_type;
@synthesize reason = _reason;

+ (id)failureWithReason:(id)reason {
    return [[ATFailure alloc] initWithReason:reason];
}

- (id)initWithReason:(id)reason {
    self = [super init];
    if(self) _reason = reason;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATFailure class]) _ATFailure_type = [ODClassType classTypeWithCls:[ATFailure class]];
}

- (id)get {
    @throw [NSString stringWithFormat:@"Getting failure try: %@", _reason];
}

- (BOOL)isSuccess {
    return NO;
}

- (BOOL)isFailure {
    return YES;
}

- (ODClassType*)type {
    return [ATFailure type];
}

+ (ODClassType*)type {
    return _ATFailure_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    ATFailure* o = ((ATFailure*)(other));
    return [self.reason isEqual:o.reason];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.reason hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"reason=%@", self.reason];
    [description appendString:@">"];
    return description;
}

@end


