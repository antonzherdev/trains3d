#import "objd.h"
#import "GEVec.h"
@class EGGlobal;
@class EGContext;

@class EGTexture;
@class EGEmptyTexture;
@class EGFileTexture;
@class EGTextureRegion;
@class EGTextureFilter;

@interface EGTexture : NSObject
+ (id)texture;
- (id)init;
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
+ (ODClassType*)type;
@end


@interface EGEmptyTexture : EGTexture
@property (nonatomic, readonly) GEVec2 size;
@property (nonatomic, readonly) unsigned int id;

+ (id)emptyTextureWithSize:(GEVec2)size;
- (id)initWithSize:(GEVec2)size;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGFileTexture : EGTexture
@property (nonatomic, readonly) NSString* file;
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly) EGTextureFilter* filter;
@property (nonatomic, readonly) unsigned int id;

+ (id)fileTextureWithFile:(NSString*)file scale:(CGFloat)scale filter:(EGTextureFilter*)filter;
- (id)initWithFile:(NSString*)file scale:(CGFloat)scale filter:(EGTextureFilter*)filter;
- (ODClassType*)type;
- (void)_init;
- (GEVec2)size;
+ (ODClassType*)type;
@end


@interface EGTextureFilter : ODEnum
@property (nonatomic, readonly) unsigned int magFilter;
@property (nonatomic, readonly) unsigned int minFilter;

+ (EGTextureFilter*)nearest;
+ (EGTextureFilter*)linear;
+ (EGTextureFilter*)mipmapNearest;
+ (NSArray*)values;
@end


@interface EGTextureRegion : EGTexture
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) GERect uv;
@property (nonatomic, readonly) unsigned int id;
@property (nonatomic, readonly) GEVec2 size;

+ (id)textureRegionWithTexture:(EGTexture*)texture uv:(GERect)uv;
- (id)initWithTexture:(EGTexture*)texture uv:(GERect)uv;
- (ODClassType*)type;
+ (EGTextureRegion*)applyTexture:(EGTexture*)texture;
- (CGFloat)scale;
- (void)deleteTexture;
+ (ODClassType*)type;
@end


