#import "objd.h"
@class CNCache;
@class EGTexture;
@class EGMatrix;

@class EGContext;
@class EGMatrixModel;
@class EGMutableMatrix;

@interface EGContext : NSObject
@property (nonatomic, readonly) EGMatrixModel* matrixModel;

+ (id)context;
- (id)init;
- (EGTexture*)textureForFile:(NSString*)file;
@end


@interface EGMatrixModel : NSObject
+ (id)matrixModel;
- (id)init;
- (EGMatrix*)mvp;
- (void)clear;
- (EGMatrix*)model;
- (void)setModelMatrix:(EGMatrix*)matrix;
- (EGMatrix*)view;
- (void)setViewMatrix:(EGMatrix*)matrix;
- (EGMatrix*)projection;
- (void)setProjectionMatrix:(EGMatrix*)matrix;
@end


@interface EGMutableMatrix : NSObject
+ (id)mutableMatrix;
- (id)init;
@end


