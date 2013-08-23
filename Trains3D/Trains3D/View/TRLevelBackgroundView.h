#import "objd.h"
@class EG;
@class EGTexture;
@class TRLevelRules;
@class TRLevel;
@class EGMapSso;
@class EGMapSsoView;
@class EGMaterial;

@class TRLevelBackgroundView;

@interface TRLevelBackgroundView : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) EGMapSsoView* mapView;

+ (id)levelBackgroundViewWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (void)draw;
@end


