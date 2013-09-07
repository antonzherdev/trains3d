#import "EGTexture.h"

#import "CNFile.h"
@implementation EGTexture{
    GLuint _id;
}
static ODClassType* _EGTexture_type;
@synthesize id = _id;

+ (id)texture {
    return [[EGTexture alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _id = egGenTexture();
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGTexture_type = [ODClassType classTypeWithCls:[EGTexture class]];
}

- (void)bind {
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, _id);
}

- (void)dealloc {
    egDeleteTexture(_id);
}

+ (void)unbind {
    glBindTexture(GL_TEXTURE_2D, 0);
    glDisable(GL_TEXTURE_2D);
}

- (void)applyDraw:(void(^)())draw {
    [self bind];
    ((void(^)())(draw))();
    [EGTexture unbind];
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


@implementation EGFileTexture{
    NSString* _file;
    BOOL __loaded;
    EGVec2 __size;
}
static ODClassType* _EGFileTexture_type;
@synthesize file = _file;

+ (id)fileTextureWithFile:(NSString*)file {
    return [[EGFileTexture alloc] initWithFile:file];
}

- (id)initWithFile:(NSString*)file {
    self = [super init];
    if(self) {
        _file = file;
        __loaded = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFileTexture_type = [ODClassType classTypeWithCls:[EGFileTexture class]];
}

- (void)load {
    __size = egLoadTextureFromFile(self.id, [CNBundle fileNameForResource:_file]);
    __loaded = YES;
}

- (EGVec2)size {
    if(!(__loaded)) [self load];
    return __size;
}

- (void)bind {
    if(!(__loaded)) [self load];
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, self.id);
}

- (ODClassType*)type {
    return [EGFileTexture type];
}

+ (ODClassType*)type {
    return _EGFileTexture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGFileTexture* o = ((EGFileTexture*)(other));
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


