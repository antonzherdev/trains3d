#import "objd.h"
#import "EG.h"
#import "EGTexture.h"
#import "TRLevel.h"
#import "EGMapIso.h"

@class TRLevelBackgroundView;

@interface TRLevelBackgroundView : NSObject
+ (id)levelBackgroundView;
- (id)init;
- (void)drawLevel:(TRLevel*)level;
@end


