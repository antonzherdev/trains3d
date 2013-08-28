#import "objd.h"
@class EGTexture;
@class EGMatrix;
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial2;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGMaterial;
#import "EGGL.h"

@class EGContext;
@class EGMutableMatrix;

@interface EGContext : NSObject
@property (nonatomic, readonly) EGMutableMatrix* modelMatrix;
@property (nonatomic, readonly) EGMutableMatrix* viewMatrix;
@property (nonatomic, readonly) EGMutableMatrix* projectionMatrix;

+ (id)context;
- (id)init;
- (EGTexture*)textureForFile:(NSString*)file;
- (EGMatrix*)mvp;
- (void)clearMatrix;
@end


@interface EGMutableMatrix : NSObject
+ (id)mutableMatrix;
- (id)init;
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
@end


