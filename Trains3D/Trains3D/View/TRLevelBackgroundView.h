#import "objd.h"
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
@class EGTexture;
@class EGFileTexture;
@class TRLevelRules;
@class TRLevel;
@class EGMapSso;
@class EGMapSsoView;
#import "EGMaterial.h"

@class TRLevelBackgroundView;

@interface TRLevelBackgroundView : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) EGMapSsoView* mapView;
@property (nonatomic, readonly) EGStandardMaterial* material;

+ (id)levelBackgroundViewWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (ODClassType*)type;
- (void)draw;
+ (ODClassType*)type;
@end


