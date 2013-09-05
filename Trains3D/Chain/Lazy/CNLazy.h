#import "objdcore.h"

@class CNLazy;

@interface CNLazy : NSObject
@property (nonatomic, readonly) id(^f)();

+ (id)lazyWithF:(id(^)())f;
- (id)initWithF:(id(^)())f;
- (ODClassType*)type;
- (BOOL)isCalculated;
- (id)get;
+ (ODClassType*)type;
@end


