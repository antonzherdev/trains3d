#import "EGTexture.h"

#import "GL.h"
@implementation EGTexture
static ODClassType* _EGTexture_type;

+ (id)texture {
    return [[EGTexture alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGTexture_type = [ODClassType classTypeWithCls:[EGTexture class]];
}

- (unsigned int)id {
    @throw @"Method id is abstract";
}

- (GEVec2)size {
    @throw @"Method size is abstract";
}

- (CGFloat)scale {
    return 1.0;
}

- (GEVec2)scaledSize {
    return geVec2DivF([self size], [self scale]);
}

- (void)dealloc {
    [self deleteTexture];
}

- (void)deleteTexture {
    egDeleteTexture([self id]);
}

- (void)saveToFile:(NSString*)file {
    egSaveTextureToFile([self id], file);
}

- (GERect)uv {
    return geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0);
}

- (GERect)uvRect:(GERect)rect {
    return geRectDivVec2(rect, [self size]);
}

- (GERect)uvX:(float)x y:(float)y width:(float)width height:(float)height {
    return [self uvRect:geRectApplyXYWidthHeight(x, y, width, height)];
}

- (EGTextureRegion*)regionX:(float)x y:(float)y width:(CGFloat)width height:(float)height {
    return [EGTextureRegion textureRegionWithTexture:self uv:geRectDivVec2(geRectApplyXYWidthHeight(x, y, ((float)(width)), height), [self size])];
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


@implementation EGEmptyTexture{
    GEVec2 _size;
    unsigned int _id;
}
static ODClassType* _EGEmptyTexture_type;
@synthesize size = _size;
@synthesize id = _id;

+ (id)emptyTextureWithSize:(GEVec2)size {
    return [[EGEmptyTexture alloc] initWithSize:size];
}

- (id)initWithSize:(GEVec2)size {
    self = [super init];
    if(self) {
        _size = size;
        _id = egGenTexture();
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEmptyTexture_type = [ODClassType classTypeWithCls:[EGEmptyTexture class]];
}

- (ODClassType*)type {
    return [EGEmptyTexture type];
}

+ (ODClassType*)type {
    return _EGEmptyTexture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGEmptyTexture* o = ((EGEmptyTexture*)(other));
    return GEVec2Eq(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%@", GEVec2Description(self.size)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGFileTexture{
    NSString* _file;
    CGFloat _scale;
    unsigned int _magFilter;
    unsigned int _minFilter;
    unsigned int _id;
    GEVec2 __size;
}
static ODClassType* _EGFileTexture_type;
@synthesize file = _file;
@synthesize scale = _scale;
@synthesize magFilter = _magFilter;
@synthesize minFilter = _minFilter;
@synthesize id = _id;

+ (id)fileTextureWithFile:(NSString*)file scale:(CGFloat)scale magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter {
    return [[EGFileTexture alloc] initWithFile:file scale:scale magFilter:magFilter minFilter:minFilter];
}

- (id)initWithFile:(NSString*)file scale:(CGFloat)scale magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter {
    self = [super init];
    if(self) {
        _file = file;
        _scale = scale;
        _magFilter = magFilter;
        _minFilter = minFilter;
        _id = egGenTexture();
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFileTexture_type = [ODClassType classTypeWithCls:[EGFileTexture class]];
}

- (void)_init {
    __size = egLoadTextureFromFile(_id, [OSBundle fileNameForResource:_file], _magFilter, _minFilter);
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
    return [self.file isEqual:o.file] && eqf(self.scale, o.scale) && self.magFilter == o.magFilter && self.minFilter == o.minFilter;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.file hash];
    hash = hash * 31 + floatHash(self.scale);
    hash = hash * 31 + self.magFilter;
    hash = hash * 31 + self.minFilter;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"file=%@", self.file];
    [description appendFormat:@", scale=%f", self.scale];
    [description appendFormat:@", magFilter=%u", self.magFilter];
    [description appendFormat:@", minFilter=%u", self.minFilter];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGTextureRegion{
    EGTexture* _texture;
    GERect _uv;
    unsigned int _id;
    GEVec2 _size;
}
static ODClassType* _EGTextureRegion_type;
@synthesize texture = _texture;
@synthesize uv = _uv;
@synthesize id = _id;
@synthesize size = _size;

+ (id)textureRegionWithTexture:(EGTexture*)texture uv:(GERect)uv {
    return [[EGTextureRegion alloc] initWithTexture:texture uv:uv];
}

- (id)initWithTexture:(EGTexture*)texture uv:(GERect)uv {
    self = [super init];
    if(self) {
        _texture = texture;
        _uv = uv;
        _id = [_texture id];
        _size = geVec2MulVec2([_texture size], _uv.size);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGTextureRegion_type = [ODClassType classTypeWithCls:[EGTextureRegion class]];
}

+ (EGTextureRegion*)applyTexture:(EGTexture*)texture {
    return [EGTextureRegion textureRegionWithTexture:texture uv:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0)];
}

- (CGFloat)scale {
    return [_texture scale];
}

- (void)deleteTexture {
}

- (ODClassType*)type {
    return [EGTextureRegion type];
}

+ (ODClassType*)type {
    return _EGTextureRegion_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGTextureRegion* o = ((EGTextureRegion*)(other));
    return [self.texture isEqual:o.texture] && GERectEq(self.uv, o.uv);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.texture hash];
    hash = hash * 31 + GERectHash(self.uv);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%@", self.texture];
    [description appendFormat:@", uv=%@", GERectDescription(self.uv)];
    [description appendString:@">"];
    return description;
}

@end


