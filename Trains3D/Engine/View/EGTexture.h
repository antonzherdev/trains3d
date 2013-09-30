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
- (void)bindTarget:(unsigned int)target;
- (void)dealloc;
+ (void)unbind;
+ (void)unbindTarget:(unsigned int)target;
- (void)applyDraw:(void(^)())draw;
- (void)applyTarget:(unsigned int)target draw:(void(^)())draw;
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
- (GEVec2)size;
- (void)bindTarget:(unsigned int)target;
+ (ODClassType*)type;
@end


