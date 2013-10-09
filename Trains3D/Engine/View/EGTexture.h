#import "objd.h"
#import "GL.h"
#import "GEVec.h"

@class EGTexture;
@class EGFileTexture;

@interface EGTexture : NSObject
@property (nonatomic, readonly) GLuint id;

+ (id)texture;
- (id)init;
- (ODClassType*)type;
- (GEVec2)size;
- (void)dealloc;
- (void)saveToFile:(NSString*)file;
- (GERect)uvRect:(GERect)rect;
- (GERect)uvX:(float)x y:(float)y width:(float)width height:(float)height;
+ (ODClassType*)type;
@end


@interface EGFileTexture : EGTexture
@property (nonatomic, readonly) NSString* file;
@property (nonatomic, readonly) unsigned int magFilter;
@property (nonatomic, readonly) unsigned int minFilter;

+ (id)fileTextureWithFile:(NSString*)file magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter;
- (id)initWithFile:(NSString*)file magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter;
- (ODClassType*)type;
+ (EGFileTexture*)applyFile:(NSString*)file;
- (void)_init;
- (GEVec2)size;
+ (ODClassType*)type;
@end


