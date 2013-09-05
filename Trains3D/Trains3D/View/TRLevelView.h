#import "objd.h"
#import "EGTypes.h"
@class EGCameraIso;
@class EG;
@class EGContext;
@class EGMutableMatrix;
#import "EGGL.h"
@class EGMapSso;
@class EGMapSsoView;
#import "EGVec.h"
@class TRLevelRules;
@class TRLevel;
@class TRLevelBackgroundView;
@class TRCityView;
@class TRRailroadView;
@class TRRailView;
@class TRSwitchView;
@class TRLightView;
@class TRDamageView;
@class TRTrainView;

@class TRLevelView;

@interface TRLevelView : NSObject<EGView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGEnvironment* environment;
@property (nonatomic, readonly) id<EGCamera> camera;

+ (id)levelViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)drawView;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


