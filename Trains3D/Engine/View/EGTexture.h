#import "objd.h"
#import "GEVec.h"
@class EGGlobal;
@class EGContext;
@class EGColorSource;

@class EGTexture;
@class EGEmptyTexture;
@class EGFileTexture;
@class EGTextureRegion;
@class EGTextureFileFormat;
@class EGTextureFormat;
@class EGTextureFilter;

typedef enum EGTextureFileFormatR {
    EGTextureFileFormat_Nil = 0,
    EGTextureFileFormat_PNG = 1,
    EGTextureFileFormat_JPEG = 2,
    EGTextureFileFormat_compressed = 3
} EGTextureFileFormatR;
@interface EGTextureFileFormat : CNEnum
@property (nonatomic, readonly) NSString* extension;

+ (NSArray*)values;
@end
static EGTextureFileFormat* EGTextureFileFormat_Values[4];
static EGTextureFileFormat* EGTextureFileFormat_PNG_Desc;
static EGTextureFileFormat* EGTextureFileFormat_JPEG_Desc;
static EGTextureFileFormat* EGTextureFileFormat_compressed_Desc;


typedef enum EGTextureFormatR {
    EGTextureFormat_Nil = 0,
    EGTextureFormat_RGBA8 = 1,
    EGTextureFormat_RGBA4 = 2,
    EGTextureFormat_RGB5A1 = 3,
    EGTextureFormat_RGB8 = 4,
    EGTextureFormat_RGB565 = 5
} EGTextureFormatR;
@interface EGTextureFormat : CNEnum
+ (NSArray*)values;
@end
static EGTextureFormat* EGTextureFormat_Values[6];
static EGTextureFormat* EGTextureFormat_RGBA8_Desc;
static EGTextureFormat* EGTextureFormat_RGBA4_Desc;
static EGTextureFormat* EGTextureFormat_RGB5A1_Desc;
static EGTextureFormat* EGTextureFormat_RGB8_Desc;
static EGTextureFormat* EGTextureFormat_RGB565_Desc;


typedef enum EGTextureFilterR {
    EGTextureFilter_Nil = 0,
    EGTextureFilter_nearest = 1,
    EGTextureFilter_linear = 2,
    EGTextureFilter_mipmapNearest = 3
} EGTextureFilterR;
@interface EGTextureFilter : CNEnum
@property (nonatomic, readonly) unsigned int magFilter;
@property (nonatomic, readonly) unsigned int minFilter;

+ (NSArray*)values;
@end
static EGTextureFilter* EGTextureFilter_Values[4];
static EGTextureFilter* EGTextureFilter_nearest_Desc;
static EGTextureFilter* EGTextureFilter_linear_Desc;
static EGTextureFilter* EGTextureFilter_mipmapNearest_Desc;


@interface EGTexture : NSObject
+ (instancetype)texture;
- (instancetype)init;
- (CNClassType*)type;
- (unsigned int)id;
- (GEVec2)size;
- (CGFloat)scale;
- (GEVec2)scaledSize;
- (void)dealloc;
- (void)deleteTexture;
- (void)saveToFile:(NSString*)file;
- (GERect)uv;
- (GERect)uvRect:(GERect)rect;
- (GERect)uvX:(float)x y:(float)y width:(float)width height:(float)height;
- (EGTextureRegion*)regionX:(float)x y:(float)y width:(CGFloat)width height:(float)height;
- (EGColorSource*)colorSource;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGEmptyTexture : EGTexture {
@protected
    GEVec2 _size;
    unsigned int _id;
}
@property (nonatomic, readonly) GEVec2 size;
@property (nonatomic, readonly) unsigned int id;

+ (instancetype)emptyTextureWithSize:(GEVec2)size;
- (instancetype)initWithSize:(GEVec2)size;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGFileTexture : EGTexture {
@protected
    NSString* _name;
    EGTextureFileFormatR _fileFormat;
    EGTextureFormatR _format;
    CGFloat _scale;
    EGTextureFilterR _filter;
    unsigned int _id;
    GEVec2 __size;
}
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) EGTextureFileFormatR fileFormat;
@property (nonatomic, readonly) EGTextureFormatR format;
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly) EGTextureFilterR filter;
@property (nonatomic, readonly) unsigned int id;

+ (instancetype)fileTextureWithName:(NSString*)name fileFormat:(EGTextureFileFormatR)fileFormat format:(EGTextureFormatR)format scale:(CGFloat)scale filter:(EGTextureFilterR)filter;
- (instancetype)initWithName:(NSString*)name fileFormat:(EGTextureFileFormatR)fileFormat format:(EGTextureFormatR)format scale:(CGFloat)scale filter:(EGTextureFilterR)filter;
- (CNClassType*)type;
- (void)_init;
- (GEVec2)size;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGTextureRegion : EGTexture {
@protected
    EGTexture* _texture;
    GERect _uv;
    unsigned int _id;
    GEVec2 _size;
}
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) GERect uv;
@property (nonatomic, readonly) unsigned int id;
@property (nonatomic, readonly) GEVec2 size;

+ (instancetype)textureRegionWithTexture:(EGTexture*)texture uv:(GERect)uv;
- (instancetype)initWithTexture:(EGTexture*)texture uv:(GERect)uv;
- (CNClassType*)type;
+ (EGTextureRegion*)applyTexture:(EGTexture*)texture;
- (CGFloat)scale;
- (void)deleteTexture;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


