#import "EGDirector.h"

@implementation EGDirector{
    EGScene* _scene;
}
@synthesize scene = _scene;

+ (id)director {
    return [[EGDirector alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)draw {
    [_scene draw];
}

- (void)reshapeWithSize:(CGSize)size {
    [_scene reshapeWithSize:size];
}

@end


