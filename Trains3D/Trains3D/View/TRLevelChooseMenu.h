#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
#import "EGFont.h"
#import "EGTexture.h"
@class EGProgress;
@class TRGameDirector;
@class EGDirector;
@class TRShopButton;
@class CNChain;
@class EGPlatform;
@class EGGlobal;
@class TRStr;
@class TRStrings;
@class EGCamera2D;
@class EGContext;
@class EGLocalPlayerScore;
@class EGColorSource;
@class EGD2D;
@class EGEnablingState;
@class EGBlendFunction;
@class EGRecognizers;
@class EGTap;
@class EGRecognizer;

@class TRLevelChooseMenu;

@interface TRLevelChooseMenu : EGSceneView_impl {
@protected
    NSString* _name;
    NSInteger _maxLevel;
    NSArray* _buttons;
    EGFont* _fontRes;
    EGFont* _fontBottom;
    CNMHashMap* __scores;
}
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, retain) CNMHashMap* _scores;

+ (instancetype)levelChooseMenu;
- (instancetype)init;
- (CNClassType*)type;
+ (EGScene*)scene;
- (id<EGCamera>)camera;
- (void)start;
- (void)stop;
+ (GEVec4)rankColorScore:(EGLocalPlayerScore*)score;
- (void)draw;
- (BOOL)isProcessorActive;
- (EGRecognizers*)recognizers;
- (GERect)viewportWithViewSize:(GEVec2)viewSize;
- (NSString*)description;
+ (CNClassType*)type;
@end


