#import "EGContext.h"

#import "CNCache.h"
#import "EGTexture.h"
@implementation EGContext{
    CNCache* _textureCache;
}

+ (id)context {
    return [[EGContext alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _textureCache = [CNCache cache];
    
    return self;
}

- (EGTexture*)textureForFile:(NSString*)file {
    return ((EGTexture*)([_textureCache lookupWithInit:^EGTexture*() {
        return [EGTexture textureWithFile:file];
    } forKey:file]));
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


