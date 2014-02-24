#import "EGTexture.h"

#import "EGContext.h"
#import "EGTexturePlat.h"
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
    if(self == [EGTexture class]) _EGTexture_type = [ODClassType classTypeWithCls:[EGTexture class]];
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
    [EGGlobal.context deleteTextureId:[self id]];
}

- (void)saveToFile:(NSString*)file {
    egSaveTextureToFile([self id], file);
}

- (GERect)uv {
    return geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0);
}

- (GERect)uvRect:(GERect)rect {
    return geRectDivVec2(rect, [self scaledSize]);
}

- (GERect)uvX:(float)x y:(float)y width:(float)width height:(float)height {
    return [self uvRect:geRectApplyXYWidthHeight(x, y, width, height)];
}

- (EGTextureRegion*)regionX:(float)x y:(float)y width:(CGFloat)width height:(float)height {
    return [EGTextureRegion textureRegionWithTexture:self uv:geRectDivVec2(geRectApplyXYWidthHeight(x, y, ((float)(width)), height), [self scaledSize])];
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
    if(self == [EGEmptyTexture class]) _EGEmptyTexture_type = [ODClassType classTypeWithCls:[EGEmptyTexture class]];
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
    NSString* _name;
    EGTextureFileFormat* _fileFormat;
    EGTextureFormat* _format;
    CGFloat _scale;
    EGTextureFilter* _filter;
    unsigned int _id;
    GEVec2 __size;
}
static ODClassType* _EGFileTexture_type;
@synthesize name = _name;
@synthesize fileFormat = _fileFormat;
@synthesize format = _format;
@synthesize scale = _scale;
@synthesize filter = _filter;
@synthesize id = _id;

+ (id)fileTextureWithName:(NSString*)name fileFormat:(EGTextureFileFormat*)fileFormat format:(EGTextureFormat*)format scale:(CGFloat)scale filter:(EGTextureFilter*)filter {
    return [[EGFileTexture alloc] initWithName:name fileFormat:fileFormat format:format scale:scale filter:filter];
}

- (id)initWithName:(NSString*)name fileFormat:(EGTextureFileFormat*)fileFormat format:(EGTextureFormat*)format scale:(CGFloat)scale filter:(EGTextureFilter*)filter {
    self = [super init];
    if(self) {
        _name = name;
        _fileFormat = fileFormat;
        _format = format;
        _scale = scale;
        _filter = filter;
        _id = egGenTexture();
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFileTexture class]) _EGFileTexture_type = [ODClassType classTypeWithCls:[EGFileTexture class]];
}

- (void)_init {
    __size = egLoadTextureFromFile(_id, _name, _fileFormat, _scale, _format, _filter);
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
    return [self.name isEqual:o.name] && self.fileFormat == o.fileFormat && self.format == o.format && eqf(self.scale, o.scale) && self.filter == o.filter;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.name hash];
    hash = hash * 31 + [self.fileFormat ordinal];
    hash = hash * 31 + [self.format ordinal];
    hash = hash * 31 + floatHash(self.scale);
    hash = hash * 31 + [self.filter ordinal];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name=%@", self.name];
    [description appendFormat:@", fileFormat=%@", self.fileFormat];
    [description appendFormat:@", format=%@", self.format];
    [description appendFormat:@", scale=%f", self.scale];
    [description appendFormat:@", filter=%@", self.filter];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGTextureFileFormat{
    NSString* _extension;
}
static EGTextureFileFormat* _EGTextureFileFormat_PNG;
static EGTextureFileFormat* _EGTextureFileFormat_JPEG;
static NSArray* _EGTextureFileFormat_values;
@synthesize extension = _extension;

+ (id)textureFileFormatWithOrdinal:(NSUInteger)ordinal name:(NSString*)name extension:(NSString*)extension {
    return [[EGTextureFileFormat alloc] initWithOrdinal:ordinal name:name extension:extension];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name extension:(NSString*)extension {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _extension = extension;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGTextureFileFormat_PNG = [EGTextureFileFormat textureFileFormatWithOrdinal:0 name:@"PNG" extension:@"png"];
    _EGTextureFileFormat_JPEG = [EGTextureFileFormat textureFileFormatWithOrdinal:1 name:@"JPEG" extension:@"jpg"];
    _EGTextureFileFormat_values = (@[_EGTextureFileFormat_PNG, _EGTextureFileFormat_JPEG]);
}

+ (EGTextureFileFormat*)PNG {
    return _EGTextureFileFormat_PNG;
}

+ (EGTextureFileFormat*)JPEG {
    return _EGTextureFileFormat_JPEG;
}

+ (NSArray*)values {
    return _EGTextureFileFormat_values;
}

@end


@implementation EGTextureFormat
static EGTextureFormat* _EGTextureFormat_RGBA8888;
static NSArray* _EGTextureFormat_values;

+ (id)textureFormatWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[EGTextureFormat alloc] initWithOrdinal:ordinal name:name];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGTextureFormat_RGBA8888 = [EGTextureFormat textureFormatWithOrdinal:0 name:@"RGBA8888"];
    _EGTextureFormat_values = (@[_EGTextureFormat_RGBA8888]);
}

+ (EGTextureFormat*)RGBA8888 {
    return _EGTextureFormat_RGBA8888;
}

+ (NSArray*)values {
    return _EGTextureFormat_values;
}

@end


@implementation EGTextureFilter{
    unsigned int _magFilter;
    unsigned int _minFilter;
}
static EGTextureFilter* _EGTextureFilter_nearest;
static EGTextureFilter* _EGTextureFilter_linear;
static EGTextureFilter* _EGTextureFilter_mipmapNearest;
static NSArray* _EGTextureFilter_values;
@synthesize magFilter = _magFilter;
@synthesize minFilter = _minFilter;

+ (id)textureFilterWithOrdinal:(NSUInteger)ordinal name:(NSString*)name magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter {
    return [[EGTextureFilter alloc] initWithOrdinal:ordinal name:name magFilter:magFilter minFilter:minFilter];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _magFilter = magFilter;
        _minFilter = minFilter;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGTextureFilter_nearest = [EGTextureFilter textureFilterWithOrdinal:0 name:@"nearest" magFilter:GL_NEAREST minFilter:GL_NEAREST];
    _EGTextureFilter_linear = [EGTextureFilter textureFilterWithOrdinal:1 name:@"linear" magFilter:GL_LINEAR minFilter:GL_LINEAR];
    _EGTextureFilter_mipmapNearest = [EGTextureFilter textureFilterWithOrdinal:2 name:@"mipmapNearest" magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_NEAREST];
    _EGTextureFilter_values = (@[_EGTextureFilter_nearest, _EGTextureFilter_linear, _EGTextureFilter_mipmapNearest]);
}

+ (EGTextureFilter*)nearest {
    return _EGTextureFilter_nearest;
}

+ (EGTextureFilter*)linear {
    return _EGTextureFilter_linear;
}

+ (EGTextureFilter*)mipmapNearest {
    return _EGTextureFilter_mipmapNearest;
}

+ (NSArray*)values {
    return _EGTextureFilter_values;
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
    if(self == [EGTextureRegion class]) _EGTextureRegion_type = [ODClassType classTypeWithCls:[EGTextureRegion class]];
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


