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
- (void)bind;
- (GEVec2)size;
- (void)bindTarget:(GLenum)target;
- (void)dealloc;
+ (void)unbind;
+ (void)unbindTarget:(GLenum)target;
- (void)applyDraw:(void(^)())draw;
- (void)applyTarget:(GLenum)target draw:(void(^)())draw;
- (void)saveToFile:(NSString*)file;
- (GERect)uvRect:(GERect)rect;
- (GERect)uvX:(float)x y:(float)y width:(float)width height:(float)height;
+ (ODClassType*)type;
@end


@interface EGFileTexture : EGTexture
@property (nonatomic, readonly) NSString* file;
@property (nonatomic, readonly) GLenum magFilter;
@property (nonatomic, readonly) GLenum minFilter;

+ (id)fileTextureWithFile:(NSString*)file magFilter:(GLenum)magFilter minFilter:(GLenum)minFilter;
- (id)initWithFile:(NSString*)file magFilter:(GLenum)magFilter minFilter:(GLenum)minFilter;
- (ODClassType*)type;
+ (EGFileTexture*)applyFile:(NSString*)file;
- (GEVec2)size;
- (void)bindTarget:(GLenum)target;
+ (ODClassType*)type;
@end


