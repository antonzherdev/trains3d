#import "objd.h"
#import "EGGL.h"
#import "GEVec.h"

@class EGTexture;
@class EGFileTexture;

@interface EGTexture : NSObject
@property (nonatomic, readonly) GLuint id;

+ (id)texture;
- (id)init;
- (ODClassType*)type;
- (void)bind;
- (void)dealloc;
+ (void)unbind;
- (void)applyDraw:(void(^)())draw;
+ (ODClassType*)type;
@end


@interface EGFileTexture : EGTexture
@property (nonatomic, readonly) NSString* file;

+ (id)fileTextureWithFile:(NSString*)file;
- (id)initWithFile:(NSString*)file;
- (ODClassType*)type;
- (GEVec2)size;
- (void)bind;
+ (ODClassType*)type;
@end


