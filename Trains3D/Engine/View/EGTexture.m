#import "EGTexture.h"

#import "GL.h"
#import "EGContext.h"
#import "EGTexturePlat.h"
#import "EGMaterial.h"
@implementation EGTextureFileFormat{
    NSString* _extension;
}
@synthesize extension = _extension;

+ (instancetype)textureFileFormatWithOrdinal:(NSUInteger)ordinal name:(NSString*)name extension:(NSString*)extension {
    return [[EGTextureFileFormat alloc] initWithOrdinal:ordinal name:name extension:extension];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name extension:(NSString*)extension {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _extension = extension;
    
    return self;
}

+ (void)load {
    [super load];
    EGTextureFileFormat_PNG_Desc = [EGTextureFileFormat textureFileFormatWithOrdinal:0 name:@"PNG" extension:@"png"];
    EGTextureFileFormat_JPEG_Desc = [EGTextureFileFormat textureFileFormatWithOrdinal:1 name:@"JPEG" extension:@"jpg"];
    EGTextureFileFormat_compressed_Desc = [EGTextureFileFormat textureFileFormatWithOrdinal:2 name:@"compressed" extension:@"?"];
    EGTextureFileFormat_Values[0] = nil;
    EGTextureFileFormat_Values[1] = EGTextureFileFormat_PNG_Desc;
    EGTextureFileFormat_Values[2] = EGTextureFileFormat_JPEG_Desc;
    EGTextureFileFormat_Values[3] = EGTextureFileFormat_compressed_Desc;
}

+ (NSArray*)values {
    return (@[EGTextureFileFormat_PNG_Desc, EGTextureFileFormat_JPEG_Desc, EGTextureFileFormat_compressed_Desc]);
}

@end

@implementation EGTextureFormat

+ (instancetype)textureFormatWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[EGTextureFormat alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)load {
    [super load];
    EGTextureFormat_RGBA8_Desc = [EGTextureFormat textureFormatWithOrdinal:0 name:@"RGBA8"];
    EGTextureFormat_RGBA4_Desc = [EGTextureFormat textureFormatWithOrdinal:1 name:@"RGBA4"];
    EGTextureFormat_RGB5A1_Desc = [EGTextureFormat textureFormatWithOrdinal:2 name:@"RGB5A1"];
    EGTextureFormat_RGB8_Desc = [EGTextureFormat textureFormatWithOrdinal:3 name:@"RGB8"];
    EGTextureFormat_RGB565_Desc = [EGTextureFormat textureFormatWithOrdinal:4 name:@"RGB565"];
    EGTextureFormat_Values[0] = nil;
    EGTextureFormat_Values[1] = EGTextureFormat_RGBA8_Desc;
    EGTextureFormat_Values[2] = EGTextureFormat_RGBA4_Desc;
    EGTextureFormat_Values[3] = EGTextureFormat_RGB5A1_Desc;
    EGTextureFormat_Values[4] = EGTextureFormat_RGB8_Desc;
    EGTextureFormat_Values[5] = EGTextureFormat_RGB565_Desc;
}

+ (NSArray*)values {
    return (@[EGTextureFormat_RGBA8_Desc, EGTextureFormat_RGBA4_Desc, EGTextureFormat_RGB5A1_Desc, EGTextureFormat_RGB8_Desc, EGTextureFormat_RGB565_Desc]);
}

@end

@implementation EGTextureFilter{
    unsigned int _magFilter;
    unsigned int _minFilter;
}
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

+ (void)load {
    [super load];
    EGTextureFilter_nearest_Desc = [EGTextureFilter textureFilterWithOrdinal:0 name:@"nearest" magFilter:GL_NEAREST minFilter:GL_NEAREST];
    EGTextureFilter_linear_Desc = [EGTextureFilter textureFilterWithOrdinal:1 name:@"linear" magFilter:GL_LINEAR minFilter:GL_LINEAR];
    EGTextureFilter_mipmapNearest_Desc = [EGTextureFilter textureFilterWithOrdinal:2 name:@"mipmapNearest" magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_NEAREST];
    EGTextureFilter_Values[0] = nil;
    EGTextureFilter_Values[1] = EGTextureFilter_nearest_Desc;
    EGTextureFilter_Values[2] = EGTextureFilter_linear_Desc;
    EGTextureFilter_Values[3] = EGTextureFilter_mipmapNearest_Desc;
}

+ (NSArray*)values {
    return (@[EGTextureFilter_nearest_Desc, EGTextureFilter_linear_Desc, EGTextureFilter_mipmapNearest_Desc]);
}

@end

@implementation EGTexture
static CNClassType* _EGTexture_type;

+ (instancetype)texture {
    return [[EGTexture alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGTexture class]) _EGTexture_type = [CNClassType classTypeWithCls:[EGTexture class]];
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
    return geVec2DivF4([self size], ((float)([self scale])));
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

- (NSString*)description {
    return @"Texture";
}

- (CNClassType*)type {
    return [EGTexture type];
}

+ (CNClassType*)type {
    return _EGTexture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGEmptyTexture
static CNClassType* _EGEmptyTexture_type;
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
    if(self == [EGEmptyTexture class]) _EGEmptyTexture_type = [CNClassType classTypeWithCls:[EGEmptyTexture class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"EmptyTexture(%@)", geVec2Description(_size)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGEmptyTexture class]])) return NO;
    EGEmptyTexture* o = ((EGEmptyTexture*)(to));
    return geVec2IsEqualTo(_size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2Hash(_size);
    return hash;
}

- (CNClassType*)type {
    return [EGEmptyTexture type];
}

+ (CNClassType*)type {
    return _EGEmptyTexture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGFileTexture
static CNClassType* _EGFileTexture_type;
@synthesize name = _name;
@synthesize fileFormat = _fileFormat;
@synthesize format = _format;
@synthesize scale = _scale;
@synthesize filter = _filter;
@synthesize id = _id;

+ (instancetype)fileTextureWithName:(NSString*)name fileFormat:(EGTextureFileFormatR)fileFormat format:(EGTextureFormatR)format scale:(CGFloat)scale filter:(EGTextureFilterR)filter {
    return [[EGFileTexture alloc] initWithName:name fileFormat:fileFormat format:format scale:scale filter:filter];
}

- (instancetype)initWithName:(NSString*)name fileFormat:(EGTextureFileFormatR)fileFormat format:(EGTextureFormatR)format scale:(CGFloat)scale filter:(EGTextureFilterR)filter {
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
    if(self == [EGFileTexture class]) _EGFileTexture_type = [CNClassType classTypeWithCls:[EGFileTexture class]];
}

- (void)_init {
    __size = egLoadTextureFromFile(_id, _name, _fileFormat, _scale, _format, _filter);
}

- (GEVec2)size {
    return __size;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"FileTexture(%@, %@, %@, %f, %@)", _name, EGTextureFileFormat_Values[_fileFormat], EGTextureFormat_Values[_format], _scale, EGTextureFilter_Values[_filter]];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGFileTexture class]])) return NO;
    EGFileTexture* o = ((EGFileTexture*)(to));
    return [_name isEqual:o.name] && _fileFormat == o.fileFormat && _format == o.format && eqf(_scale, o.scale) && _filter == o.filter;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_name hash];
    hash = hash * 31 + [EGTextureFileFormat_Values[_fileFormat] hash];
    hash = hash * 31 + [EGTextureFormat_Values[_format] hash];
    hash = hash * 31 + floatHash(_scale);
    hash = hash * 31 + [EGTextureFilter_Values[_filter] hash];
    return hash;
}

- (CNClassType*)type {
    return [EGFileTexture type];
}

+ (CNClassType*)type {
    return _EGFileTexture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGTextureRegion
static CNClassType* _EGTextureRegion_type;
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
        _id = [texture id];
        _size = geVec2MulVec2([texture size], uv.size);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGTextureRegion class]) _EGTextureRegion_type = [CNClassType classTypeWithCls:[EGTextureRegion class]];
}

+ (EGTextureRegion*)applyTexture:(EGTexture*)texture {
    return [EGTextureRegion textureRegionWithTexture:texture uv:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0)];
}

- (CGFloat)scale {
    return [_texture scale];
}

- (void)deleteTexture {
}

- (NSString*)description {
    return [NSString stringWithFormat:@"TextureRegion(%@, %@)", _texture, geRectDescription(_uv)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGTextureRegion class]])) return NO;
    EGTextureRegion* o = ((EGTextureRegion*)(to));
    return [_texture isEqual:o.texture] && geRectIsEqualTo(_uv, o.uv);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_texture hash];
    hash = hash * 31 + geRectHash(_uv);
    return hash;
}

- (CNClassType*)type {
    return [EGTextureRegion type];
}

+ (CNClassType*)type {
    return _EGTextureRegion_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

