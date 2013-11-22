#import "objd.h"

@class EGPlatform;
@class EGInterfaceIdiom;

@interface EGPlatform : ODEnum
@property (nonatomic, readonly) BOOL shadows;
@property (nonatomic, readonly) BOOL touch;

+ (EGPlatform*)MacOS;
+ (EGPlatform*)iOS;
+ (NSArray*)values;
@end


@interface EGInterfaceIdiom : ODEnum
+ (EGInterfaceIdiom*)phone;
+ (EGInterfaceIdiom*)pad;
+ (EGInterfaceIdiom*)computer;
+ (NSArray*)values;
@end


