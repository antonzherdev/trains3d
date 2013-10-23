#import "objd.h"

@class EGPlatform;

@interface EGPlatform : ODEnum
@property (nonatomic, readonly) BOOL shadows;
@property (nonatomic, readonly) BOOL touch;

+ (EGPlatform*)MacOS;
+ (EGPlatform*)iOS;
+ (NSArray*)values;
@end


