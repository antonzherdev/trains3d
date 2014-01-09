#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
#import "EGFont.h"
@class EGProgress;
@class TRGameDirector;
@class EGDirector;
@class EGButton;
@class EGCamera2D;
@class EGPlatform;
@class EGGlobal;
@class EGLocalPlayerScore;
@class EGColorSource;
@class EGD2D;
@class EGBlendFunction;
@class TRStr;
@class TRStrings;
@class EGContext;
@class EGEnablingState;
@class EGRecognizers;
@class EGTap;
@class EGRecognizer;
@class EGEnvironment;

@class TRLevelChooseMenu;

@interface TRLevelChooseMenu : NSObject<EGSceneView>
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSInteger maxLevel;

+ (id)levelChooseMenu;
- (id)init;
- (ODClassType*)type;
+ (EGScene*)scene;
- (EGCamera2D*)camera;
- (void)reshapeWithViewport:(GERect)viewport;
- (void)start;
+ (GEVec4)rankColorScore:(EGLocalPlayerScore*)score;
- (void)draw;
- (BOOL)isProcessorActive;
- (EGRecognizers*)recognizers;
- (GERect)viewportWithViewSize:(GEVec2)viewSize;
+ (ODClassType*)type;
@end


