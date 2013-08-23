#import "objd.h"

@class EGMatrix;

struct EGMatrixImpl;
typedef struct EGMatrixImpl EGMatrixImpl;
@interface EGMatrix : NSObject
- (EGMatrixImpl*)impl;

- (id)initWithImpl:(EGMatrixImpl *)m;

+ (id)matrixWithImpl:(EGMatrixImpl *)m;
+ (id)matrixWithArray:(float[16])m;

- (EGMatrix*)multiply:(EGMatrix*)matrix;

+ (EGMatrix *)identity;

- (CGFloat const *)array;

- (EGMatrix *)rotateAngle:(CGFloat)angle x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z;

- (EGMatrix *)scaleX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z;

- (EGMatrix *)translateX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z;
@end


