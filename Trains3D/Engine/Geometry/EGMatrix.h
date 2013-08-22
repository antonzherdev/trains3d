#import "objd.h"

@class EGMatrix;

@interface EGMatrix : NSObject
@property(nonatomic) float *m;

- (id)initWithM:(float *)m;

+ (id)matrixWithM:(float *)m;


- (EGMatrix*)multiply:(EGMatrix*)matrix;
@end


