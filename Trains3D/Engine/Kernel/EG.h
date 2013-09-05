#import "objd.h"
@class EGDirector;
@class EGTexture;
@class EGFileTexture;
@class EGMatrix;
#import "EGVec.h"
#import "EGTypes.h"

@class EG;
@class EGContext;
@class EGMutableMatrix;

@interface EG : NSObject
+ (id)g;
- (id)init;
- (ODClassType*)type;
+ (EGDirector*)director;
+ (EGFileTexture*)textureForFile:(NSString*)file;
+ (EGMutableMatrix*)projectionMatrix;
+ (EGMutableMatrix*)cameraMatrix;
+ (EGMutableMatrix*)worldMatrix;
+ (EGMutableMatrix*)modelMatrix;
+ (void)keepMWF:(void(^)())f;
+ (EGContext*)context;
+ (ODClassType*)type;
@end


@interface EGContext : NSObject
@property (nonatomic, retain) EGDirector* director;
@property (nonatomic) EGVec3 eyeDirection;
@property (nonatomic, retain) EGEnvironment* environment;
@property (nonatomic, readonly) EGMutableMatrix* modelMatrix;
@property (nonatomic, readonly) EGMutableMatrix* worldMatrix;
@property (nonatomic, readonly) EGMutableMatrix* cameraMatrix;
@property (nonatomic, readonly) EGMutableMatrix* projectionMatrix;

+ (id)context;
- (id)init;
- (ODClassType*)type;
- (EGFileTexture*)textureForFile:(NSString*)file;
- (EGMatrix*)m;
- (EGMatrix*)w;
- (EGMatrix*)c;
- (EGMatrix*)p;
- (EGMatrix*)mw;
- (EGMatrix*)mwc;
- (EGMatrix*)mwcp;
- (EGMatrix*)cp;
- (EGMatrix*)wcp;
- (void)clearMatrix;
+ (ODClassType*)type;
@end


@interface EGMutableMatrix : NSObject
+ (id)mutableMatrix;
- (id)init;
- (ODClassType*)type;
- (void)push;
- (void)pop;
- (EGMatrix*)value;
- (void)setValue:(EGMatrix*)value;
- (void)setIdentity;
- (void)clear;
- (void)rotateAngle:(CGFloat)angle x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z;
- (void)scaleX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z;
- (void)translateX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z;
- (void)orthoLeft:(CGFloat)left right:(CGFloat)right bottom:(CGFloat)bottom top:(CGFloat)top zNear:(CGFloat)zNear zFar:(CGFloat)zFar;
- (void)keepF:(void(^)())f;
+ (ODClassType*)type;
@end


