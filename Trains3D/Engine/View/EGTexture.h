#import "objd.h"
@class CNBundle;
#import "EGTypes.h"
#import "EGGL.h"

@class EGTexture;

@interface EGTexture : NSObject
@property (nonatomic, readonly) NSString* file;

+ (id)textureWithFile:(NSString*)file;
- (id)initWithFile:(NSString*)file;
- (ODClassType*)type;
- (EGSize)size;
- (void)bind;
- (void)dealloc;
- (void)unbind;
- (void)applyDraw:(void(^)())draw;
+ (ODClassType*)type;
@end


