#import "EGTexture.h"

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
    [self bindTarget:GL_TEXTURE_2D];
}

- (void)bindTarget:(GLenum)target {
    glEnable(target);
    glBindTexture(target, _id);
}

- (void)dealloc {
    egDeleteTexture(_id);
}

+ (void)unbind {
    [EGTexture unbindTarget:GL_TEXTURE_2D];
}

+ (void)unbindTarget:(GLenum)target {
    glBindTexture(target, 0);
    glDisable(target);
}

- (void)applyDraw:(void(^)())draw {
    [self applyTarget:GL_TEXTURE_2D draw:draw];
}

- (void)applyTarget:(GLenum)target draw:(void(^)())draw {
    [self bindTarget:target];
    ((void(^)())(draw))();
    [EGTexture unbindTarget:target];
}

- (void)saveToFile:(NSString*)file {
    egSaveTextureToFile(_id, file);
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
    GEVec2 __size;
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

- (GEVec2)size {
    if(!(__loaded)) [self load];
    return __size;
}

- (void)bindTarget:(GLenum)target {
    if(!(__loaded)) [self load];
    glEnable(target);
    glBindTexture(target, self.id);
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


