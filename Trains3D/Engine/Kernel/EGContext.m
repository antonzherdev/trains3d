#import "EGContext.h"

@implementation EGContext
static EGContext* _current;
+ (id)context {
    return [[EGContext alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _current = [EGContext context];
}

+ (EGContext*)current {
    return _current;
}

- (EGTexture*)textureForFile:(NSString*)file {
    @throw @"Method textureFor is abstact";
}

@end


