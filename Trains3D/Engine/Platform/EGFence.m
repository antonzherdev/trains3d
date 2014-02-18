#import "EGFence.h"

@implementation EGFence {
    GLsync _id;
    BOOL _init;
}
static ODClassType* _EGFence_type;

+ (id)fence {
    return [[EGFence alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _init = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFence class]) _EGFence_type = [ODClassType classTypeWithCls:[EGFence class]];
}

- (void)set {
    if(_init) {
#if TARGET_OS_IPHONE
        glDeleteSyncAPPLE(_id);
#else
        glDeleteSync(_id);
#endif
    } else {
        _init = YES;
    }
#if TARGET_OS_IPHONE
    _id = glFenceSyncAPPLE(GL_SYNC_GPU_COMMANDS_COMPLETE_APPLE, 0);
#else
    _id = glFenceSync(GL_SYNC_GPU_COMMANDS_COMPLETE, 0);
#endif
}

- (void)clientWait {
    if(_init) {
#if TARGET_OS_IPHONE
        GLenum i = glClientWaitSyncAPPLE(_id, 0, 100000000);
#if DEBUG
        if(i != GL_ALREADY_SIGNALED_APPLE) {
            NSLog(@"Wait sync = 0x%x", i);
        }
#endif
#else
        GLenum i = glClientWaitSync(_id, 0, 100000);
#if DEBUG
        if(i != GL_ALREADY_SIGNALED) {
            NSLog(@"Wait sync = 0x%x", i);
        }
#endif
#endif
    }
}

- (void)dealloc {
    if(_init) {
#if TARGET_OS_IPHONE
        glDeleteSyncAPPLE(_id);
#else
        glDeleteSync(_id);
#endif
    }
}


- (ODClassType*)type {
    return [EGFence type];
}

+ (ODClassType*)type {
    return _EGFence_type;
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

- (void)syncF:(void (^)())f {
    [self clientWait];
    f();
    [self set];
}
@end


