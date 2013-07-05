#import "objd.h"
@class EGTexture;
@class TRLevel;

@class TRLevelBackgroundView;

@interface TRLevelBackgroundView : NSObject
+ (id)levelBackgroundView;
- (id)init;
- (void)drawLevel:(TRLevel*)level;
@end


