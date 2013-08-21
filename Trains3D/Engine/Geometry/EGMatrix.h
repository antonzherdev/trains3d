#import "objd.h"

@class EGMatrix;

@interface EGMatrix : NSObject
@property(nonatomic) double *m;

- (id)initWithM:(double *)m;

+ (id)matrixWithM:(double *)m;


- (EGMatrix*)multiply:(EGMatrix*)matrix;
@end


