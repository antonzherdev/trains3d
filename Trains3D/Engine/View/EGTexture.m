#import "EGTexture.h"

#import "CNFile.h"
@implementation EGTexture{
    NSString* _file;
    GLuint __id;
    BOOL __loaded;
    EGSize __size;
}
static ODClassType* _EGTexture_type;
@synthesize file = _file;

+ (id)textureWithFile:(NSString*)file {
    return [[EGTexture alloc] initWithFile:file];
}

- (id)initWithFile:(NSString*)file {
    self = [super init];
    if(self) {
        _file = file;
        __id = egGenTexture();
        __loaded = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGTexture_type = [ODClassType classTypeWithCls:[EGTexture class]];
}

- (void)load {
    __size = egLoadTextureFromFile(__id, [CNBundle fileNameForResource:_file]);
    __loaded = YES;
}

- (EGSize)size {
    if(!(__loaded)) [self load];
    return __size;
}

- (void)bind {
    if(!(__loaded)) [self load];
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, __id);
}

- (void)dealloc {
    egDeleteTexture(__id);
}

- (void)unbind {
    glBindTexture(GL_TEXTURE_2D, 0);
    glDisable(GL_TEXTURE_2D);
}

- (void)applyDraw:(void(^)())draw {
    [self bind];
    ((void(^)())(draw))();
    [self unbind];
}

- (ODClassType*)type {
    return [EGTexture type];
}

+ (ODClassType*)type {
    return _EGTexture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGTexture* o = ((EGTexture*)(other));
    return [self.file isEqual:o.file];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.file hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"file=%@", self.file];
    [description appendString:@">"];
    return description;
}

@end


