#import "objd.h"
@class EGDirector;
@class EGContext;
@class EGMutableMatrix;
@class EGTexture;

@class EG;

@interface EG : NSObject
+ (id)g;
- (id)init;
+ (EGDirector*)director;
+ (EGContext*)context;
+ (EGTexture*)textureForFile:(NSString*)file;
+ (EGMutableMatrix*)projectionMatrix;
+ (EGMutableMatrix*)cameraMatrix;
+ (EGMutableMatrix*)worldMatrix;
+ (EGMutableMatrix*)modelMatrix;
- (ODType*)type;
+ (ODType*)type;
@end


