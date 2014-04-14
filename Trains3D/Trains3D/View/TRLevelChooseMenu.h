#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRGameDirector;
@class EGProgress;
@class EGDirector;
@class TRShopButton;
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
@class EGTextureFileFormat;
@class EGRecognizers;
@class EGTap;
@class EGRecognizer;
@class EGEnvironment;

@class TRLevelChooseMenu;

@interface TRLevelChooseMenu : NSObject<EGSceneView> {
@protected
    NSString* _name;
    NSArray* _buttons;
    EGFont* _fontRes;
    EGFont* _fontBottom;
    NSMutableDictionary* __scores;
}
@property (nonatomic, readonly) NSString* name;
@property (nonatomic) NSMutableDictionary* _scores;

+ (instancetype)levelChooseMenu;
- (instancetype)init;
- (ODClassType*)type;
+ (EGScene*)scene;
- (id<EGCamera>)camera;
- (void)start;
- (void)stop;
+ (GEVec4)rankColorScore:(EGLocalPlayerScore*)score;
- (void)draw;
- (BOOL)isProcessorActive;
- (EGRecognizers*)recognizers;
- (GERect)viewportWithViewSize:(GEVec2)viewSize;
+ (NSInteger)maxLevel;
+ (ODClassType*)type;
@end


