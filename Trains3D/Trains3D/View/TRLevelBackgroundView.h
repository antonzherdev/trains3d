#import "objd.h"
@class EGTexture;
@class TRLevelRules;
@class TRLevel;
@class EGMapSso;

@class TRLevelBackgroundView;

@interface TRLevelBackgroundView : NSObject
+ (id)levelBackgroundView;
- (id)init;
- (void)drawLevel:(TRLevel*)level;
@end


