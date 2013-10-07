#import "objd.h"

@class EGPlatform;

@interface EGPlatform : ODEnum
@property (nonatomic, readonly) BOOL shadows;

+ (EGPlatform*)MacOS;
+ (EGPlatform*)iOS;
+ (NSArray*)values;
@end


