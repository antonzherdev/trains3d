#import "EGContext.h"

#import "EGTexture.h"
#import "CNCache.h"
@implementation EGContext{
    CNCache* _textureCache;
}

+ (id)context {
    return [[EGContext alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _textureCache = [CNCache new];
    
    return self;
}

- (EGTexture*)textureForFile:(NSString*)file {
    return [_textureCache lookupWithInit:^EGTexture *() {
        return [EGTexture textureWithFile:file];
    }                             forKey:file];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


