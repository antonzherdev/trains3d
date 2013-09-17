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
- (void)bindTarget:(GLenum)target;
- (void)dealloc;
+ (void)unbind;
+ (void)unbindTarget:(GLenum)target;
- (void)applyDraw:(void(^)())draw;
- (void)applyTarget:(GLenum)target draw:(void(^)())draw;
- (void)saveToFile:(NSString*)file;
+ (ODClassType*)type;
@end


@interface EGFileTexture : EGTexture
@property (nonatomic, readonly) NSString* file;

+ (id)fileTextureWithFile:(NSString*)file;
- (id)initWithFile:(NSString*)file;
- (ODClassType*)type;
- (GEVec2)size;
- (void)bindTarget:(GLenum)target;
+ (ODClassType*)type;
@end


