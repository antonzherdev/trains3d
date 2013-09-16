#import "objd.h"
@class EGMapSso;
@class EGMapSsoView;
@class EGStandardMaterial;
@class EG;
@class EGColorSource;

@class TRLevelBackgroundView;

@interface TRLevelBackgroundView : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) EGMapSsoView* mapView;
@property (nonatomic, readonly) EGStandardMaterial* material;

+ (id)levelBackgroundViewWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (ODClassType*)type;
- (void)draw;
+ (ODType*)type;
@end


