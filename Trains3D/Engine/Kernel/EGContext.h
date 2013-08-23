#import "objd.h"
@class EGTexture;
@class EGMatrix;

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
@end


