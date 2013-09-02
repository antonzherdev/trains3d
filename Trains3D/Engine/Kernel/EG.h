#import "objd.h"
@class EGDirector;
@class EGContext;
@class EGMutableMatrix;
@class EGTexture;

@class EG;

@interface EG : NSObject
+ (id)g;
- (id)init;
- (ODClassType*)type;
+ (EGDirector*)director;
+ (EGContext*)context;
+ (EGTexture*)textureForFile:(NSString*)file;
+ (EGMutableMatrix*)projectionMatrix;
+ (EGMutableMatrix*)cameraMatrix;
+ (EGMutableMatrix*)worldMatrix;
+ (EGMutableMatrix*)modelMatrix;
+ (void)keepMWF:(void(^)())f;
+ (ODClassType*)type;
@end


