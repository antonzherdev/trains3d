#import "objd.h"
@class EGDirector;
@class EGContext;
@class EGMatrixModel;
@class EGMutableMatrix;
@class EGTexture;

@class EG;

@interface EG : NSObject
+ (id)g;
- (id)init;
+ (EGDirector*)director;
+ (EGContext*)context;
+ (EGTexture*)textureForFile:(NSString*)file;
@end


