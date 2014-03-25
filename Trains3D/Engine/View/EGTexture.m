#import "EGTexture.h"

#import "EGContext.h"
#import "EGTexturePlat.h"
#import "EGMaterial.h"
#import "GL.h"
@implementation EGTexture
static ODClassType* _EGTexture_type;

+ (instancetype)texture {
    return [[EGTexture alloc] init];
}

- (instancetype)init {
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
    return [EGTextureRegion textureRegionWithTexture:self uv:geRectDivVec2((geRectApplyXYWidthHeight(x, y, ((float)(width)), height)), [self scaledSize])];
}

- (EGColorSource*)colorSource {
    return [EGColorSource applyTexture:self];
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGEmptyTexture
static ODClassType* _EGEmptyTexture_type;
@synthesize size = _size;
@synthesize id = _id;

+ (instancetype)emptyTextureWithSize:(GEVec2)size {
    return [[EGEmptyTexture alloc] initWithSize:size];
}

- (instancetype)initWithSize:(GEVec2)size {
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%@", GEVec2Description(self.size)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGFileTexture
static ODClassType* _EGFileTexture_type;
@synthesize name = _name;
@synthesize fileFormat = _fileFormat;
@synthesize format = _format;
@synthesize scale = _scale;
@synthesize filter = _filter;
@synthesize id = _id;

+ (instancetype)fileTextureWithName:(NSString*)name fileFormat:(EGTextureFileFormat*)fileFormat format:(EGTextureFormat*)format scale:(CGFloat)scale filter:(EGTextureFilter*)filter {
    return [[EGFileTexture alloc] initWithName:name fileFormat:fileFormat format:format scale:scale filter:filter];
}

- (instancetype)initWithName:(NSString*)name fileFormat:(EGTextureFileFormat*)fileFormat format:(EGTextureFormat*)format scale:(CGFloat)scale filter:(EGTextureFilter*)filter {
    self = [super init];
    if(self) {
        _name = name;
        _fileFormat = fileFormat;
        _format = format;
        _scale = scale;
        _filter = filter;
        _id = egGenTexture();
        if([self class] == [EGFileTexture class]) [self _init];
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
static EGTextureFileFormat* _EGTextureFileFormat_compressed;
static NSArray* _EGTextureFileFormat_values;
@synthesize extension = _extension;

+ (instancetype)textureFileFormatWithOrdinal:(NSUInteger)ordinal name:(NSString*)name extension:(NSString*)extension {
    return [[EGTextureFileFormat alloc] initWithOrdinal:ordinal name:name extension:extension];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name extension:(NSString*)extension {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _extension = extension;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGTextureFileFormat_PNG = [EGTextureFileFormat textureFileFormatWithOrdinal:0 name:@"PNG" extension:@"png"];
    _EGTextureFileFormat_JPEG = [EGTextureFileFormat textureFileFormatWithOrdinal:1 name:@"JPEG" extension:@"jpg"];
    _EGTextureFileFormat_compressed = [EGTextureFileFormat textureFileFormatWithOrdinal:2 name:@"compressed" extension:@"?"];
    _EGTextureFileFormat_values = (@[_EGTextureFileFormat_PNG, _EGTextureFileFormat_JPEG, _EGTextureFileFormat_compressed]);
}

+ (EGTextureFileFormat*)PNG {
    return _EGTextureFileFormat_PNG;
}

+ (EGTextureFileFormat*)JPEG {
    return _EGTextureFileFormat_JPEG;
}

+ (EGTextureFileFormat*)compressed {
    return _EGTextureFileFormat_compressed;
}

+ (NSArray*)values {
    return _EGTextureFileFormat_values;
}

@end


@implementation EGTextureFormat
static EGTextureFormat* _EGTextureFormat_RGBA8;
static EGTextureFormat* _EGTextureFormat_RGBA4;
static EGTextureFormat* _EGTextureFormat_RGB5A1;
static EGTextureFormat* _EGTextureFormat_RGB8;
static EGTextureFormat* _EGTextureFormat_RGB565;
static NSArray* _EGTextureFormat_values;

+ (instancetype)textureFormatWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[EGTextureFormat alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGTextureFormat_RGBA8 = [EGTextureFormat textureFormatWithOrdinal:0 name:@"RGBA8"];
    _EGTextureFormat_RGBA4 = [EGTextureFormat textureFormatWithOrdinal:1 name:@"RGBA4"];
    _EGTextureFormat_RGB5A1 = [EGTextureFormat textureFormatWithOrdinal:2 name:@"RGB5A1"];
    _EGTextureFormat_RGB8 = [EGTextureFormat textureFormatWithOrdinal:3 name:@"RGB8"];
    _EGTextureFormat_RGB565 = [EGTextureFormat textureFormatWithOrdinal:4 name:@"RGB565"];
    _EGTextureFormat_values = (@[_EGTextureFormat_RGBA8, _EGTextureFormat_RGBA4, _EGTextureFormat_RGB5A1, _EGTextureFormat_RGB8, _EGTextureFormat_RGB565]);
}

+ (EGTextureFormat*)RGBA8 {
    return _EGTextureFormat_RGBA8;
}

+ (EGTextureFormat*)RGBA4 {
    return _EGTextureFormat_RGBA4;
}

+ (EGTextureFormat*)RGB5A1 {
    return _EGTextureFormat_RGB5A1;
}

+ (EGTextureFormat*)RGB8 {
    return _EGTextureFormat_RGB8;
}

+ (EGTextureFormat*)RGB565 {
    return _EGTextureFormat_RGB565;
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

+ (instancetype)textureFilterWithOrdinal:(NSUInteger)ordinal name:(NSString*)name magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter {
    return [[EGTextureFilter alloc] initWithOrdinal:ordinal name:name magFilter:magFilter minFilter:minFilter];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter {
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


@implementation EGTextureRegion
static ODClassType* _EGTextureRegion_type;
@synthesize texture = _texture;
@synthesize uv = _uv;
@synthesize id = _id;
@synthesize size = _size;

+ (instancetype)textureRegionWithTexture:(EGTexture*)texture uv:(GERect)uv {
    return [[EGTextureRegion alloc] initWithTexture:texture uv:uv];
}

- (instancetype)initWithTexture:(EGTexture*)texture uv:(GERect)uv {
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%@", self.texture];
    [description appendFormat:@", uv=%@", GERectDescription(self.uv)];
    [description appendString:@">"];
    return description;
}

@end


