#import "objd.h"
@class EG;
@class EGTexture;
@class TRLevelRules;
@class TRLevel;
@class EGMapSso;
@class EGMaterial;

@class TRLevelBackgroundView;

@interface TRLevelBackgroundView : NSObject
+ (id)levelBackgroundView;
- (id)init;
- (void)drawLevel:(TRLevel*)level;
@end


