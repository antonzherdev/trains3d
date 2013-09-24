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

- (GEVec2)size {
    @throw @"Method size is abstract";
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

- (GERect)uvRect:(GERect)rect {
    return geRectDivVec2(rect, [self size]);
}

- (GERect)uvX:(float)x y:(float)y width:(float)width height:(float)height {
    return geRectDivVec2(geRectApplyXYWidthHeight(x, y, width, height), [self size]);
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
    GLenum _magFilter;
    GLenum _minFilter;
    BOOL __loaded;
    GEVec2 __size;
}
static ODClassType* _EGFileTexture_type;
@synthesize file = _file;
@synthesize magFilter = _magFilter;
@synthesize minFilter = _minFilter;

+ (id)fileTextureWithFile:(NSString*)file magFilter:(GLenum)magFilter minFilter:(GLenum)minFilter {
    return [[EGFileTexture alloc] initWithFile:file magFilter:magFilter minFilter:minFilter];
}

- (id)initWithFile:(NSString*)file magFilter:(GLenum)magFilter minFilter:(GLenum)minFilter {
    self = [super init];
    if(self) {
        _file = file;
        _magFilter = magFilter;
        _minFilter = minFilter;
        __loaded = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFileTexture_type = [ODClassType classTypeWithCls:[EGFileTexture class]];
}

+ (EGFileTexture*)applyFile:(NSString*)file {
    return [EGFileTexture fileTextureWithFile:file magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_LINEAR];
}

- (void)load {
    __size = egLoadTextureFromFile(self.id, [CNBundle fileNameForResource:_file], _magFilter, _minFilter);
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
    return [self.file isEqual:o.file] && GLenumEq(self.magFilter, o.magFilter) && GLenumEq(self.minFilter, o.minFilter);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.file hash];
    hash = hash * 31 + GLenumHash(self.magFilter);
    hash = hash * 31 + GLenumHash(self.minFilter);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"file=%@", self.file];
    [description appendFormat:@", magFilter=%@", GLenumDescription(self.magFilter)];
    [description appendFormat:@", minFilter=%@", GLenumDescription(self.minFilter)];
    [description appendString:@">"];
    return description;
}

@end


