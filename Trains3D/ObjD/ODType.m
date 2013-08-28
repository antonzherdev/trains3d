#import "ODType.h"

@implementation ODType{
    Class _cls;
}
@synthesize cls = _cls;

+ (id)typeWithCls:(Class)cls {
    return [[ODType alloc] initWithCls:cls];
}

- (id)initWithCls:(Class)cls {
    self = [super init];
    if(self) _cls = cls;
    
    return self;
}

- (NSString*)name {
    return NSStringFromClass(_cls);
}

- (NSString*)description {
    return [NSStringFromClass(_cls) stringByAppendingString:@".type"];
}

- (NSUInteger)hash {
    return (NSUInteger) self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    return self == other;
}

@end


