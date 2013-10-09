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

- (GEVec2)size {
    @throw @"Method size is abstract";
}

- (void)dealloc {
    egDeleteTexture(_id);
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
    unsigned int _magFilter;
    unsigned int _minFilter;
    BOOL __loaded;
    GEVec2 __size;
}
static ODClassType* _EGFileTexture_type;
@synthesize file = _file;
@synthesize magFilter = _magFilter;
@synthesize minFilter = _minFilter;

+ (id)fileTextureWithFile:(NSString*)file magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter {
    return [[EGFileTexture alloc] initWithFile:file magFilter:magFilter minFilter:minFilter];
}

- (id)initWithFile:(NSString*)file magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter {
    self = [super init];
    if(self) {
        _file = file;
        _magFilter = magFilter;
        _minFilter = minFilter;
        __loaded = NO;
        [self _init];
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

- (void)_init {
    __size = egLoadTextureFromFile(self.id, [OSBundle fileNameForResource:_file], _magFilter, _minFilter);
    __loaded = YES;
}

- (GEVec2)size {
    return __size;
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
    return [self.file isEqual:o.file] && self.magFilter == o.magFilter && self.minFilter == o.minFilter;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.file hash];
    hash = hash * 31 + self.magFilter;
    hash = hash * 31 + self.minFilter;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"file=%@", self.file];
    [description appendFormat:@", magFilter=%d", self.magFilter];
    [description appendFormat:@", minFilter=%d", self.minFilter];
    [description appendString:@">"];
    return description;
}

@end


