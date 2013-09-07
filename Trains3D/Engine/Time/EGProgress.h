#import "objd.h"
@class CNOption;

@class EGProgress;

@interface EGProgress : NSObject
- (ODClassType*)type;
+ (float(^)(float))progressY1:(float)y1 y2:(float)y2;
+ (id(^)(float))gapT1:(float)t1 t2:(float)t2;
+ (void(^)(float))compileFunctions:(id<CNSeq>)functions;
+ (ODClassType*)type;
@end


