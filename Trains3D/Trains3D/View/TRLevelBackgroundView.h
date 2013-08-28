#import "objd.h"
@class EG;
@class EGTexture;
@class TRLevelRules;
@class TRLevel;
@class EGMapSso;
@class EGMapSsoView;
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial2;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGMaterial;

@class TRLevelBackgroundView;

@interface TRLevelBackgroundView : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) EGMapSsoView* mapView;

+ (id)levelBackgroundViewWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (void)draw;
- (ODType*)type;
+ (ODType*)type;
@end


