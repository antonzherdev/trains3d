#import "objd.h"
#import "EGTexture.h"
#import "TRLevel.h"
#import "EGMap.h"

@interface TRLevelBackgroundView : NSObject
+ (id)levelBackgroundView;
- (id)init;
- (void)drawLevel:(TRLevel*)level;
@end


