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

@interface EGTexture : NSObject
+ (instancetype)texture;
- (instancetype)init;
- (ODClassType*)type;
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
+ (ODClassType*)type;
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
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGFileTexture : EGTexture {
@protected
    NSString* _name;
    EGTextureFileFormat* _fileFormat;
    EGTextureFormat* _format;
    CGFloat _scale;
    EGTextureFilter* _filter;
    unsigned int _id;
    GEVec2 __size;
}
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) EGTextureFileFormat* fileFormat;
@property (nonatomic, readonly) EGTextureFormat* format;
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly) EGTextureFilter* filter;
@property (nonatomic, readonly) unsigned int id;

+ (instancetype)fileTextureWithName:(NSString*)name fileFormat:(EGTextureFileFormat*)fileFormat format:(EGTextureFormat*)format scale:(CGFloat)scale filter:(EGTextureFilter*)filter;
- (instancetype)initWithName:(NSString*)name fileFormat:(EGTextureFileFormat*)fileFormat format:(EGTextureFormat*)format scale:(CGFloat)scale filter:(EGTextureFilter*)filter;
- (ODClassType*)type;
- (void)_init;
- (GEVec2)size;
+ (ODClassType*)type;
@end


@interface EGTextureFileFormat : ODEnum
@property (nonatomic, readonly) NSString* extension;

+ (EGTextureFileFormat*)PNG;
+ (EGTextureFileFormat*)JPEG;
+ (EGTextureFileFormat*)compressed;
+ (NSArray*)values;
@end


@interface EGTextureFormat : ODEnum
+ (EGTextureFormat*)RGBA8;
+ (EGTextureFormat*)RGBA4;
+ (EGTextureFormat*)RGB5A1;
+ (EGTextureFormat*)RGB8;
+ (EGTextureFormat*)RGB565;
+ (NSArray*)values;
@end


@interface EGTextureFilter : ODEnum
@property (nonatomic, readonly) unsigned int magFilter;
@property (nonatomic, readonly) unsigned int minFilter;

+ (EGTextureFilter*)nearest;
+ (EGTextureFilter*)linear;
+ (EGTextureFilter*)mipmapNearest;
+ (NSArray*)values;
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
- (ODClassType*)type;
+ (EGTextureRegion*)applyTexture:(EGTexture*)texture;
- (CGFloat)scale;
- (void)deleteTexture;
+ (ODClassType*)type;
@end


