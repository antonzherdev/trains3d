#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRGameDirector;
@class EGProgress;
@class EGDirector;
@class EGButton;
@class EGCamera2D;
@class EGPlatform;
@class EGGlobal;
@class TRStr;
@class TRStrings;
@class EGContext;
@class EGLocalPlayerScore;
@class EGColorSource;
@class EGD2D;
@class EGBlendFunction;
@class EGTextureFileFormat;
@class EGEnablingState;
@class EGRecognizers;
@class EGTap;
@class EGRecognizer;
@class EGEnvironment;

@class TRLevelChooseMenu;

@interface TRLevelChooseMenu : NSObject<EGSceneView> {
@private
    NSString* _name;
    id<CNImSeq> _buttons;
    EGFont* _fontRes;
    EGFont* _fontBottom;
    NSMutableDictionary* __scores;
}
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, retain) EGFont* fontRes;
@property (nonatomic, retain) EGFont* fontBottom;
@property (nonatomic) NSMutableDictionary* _scores;

+ (instancetype)levelChooseMenu;
- (instancetype)init;
- (ODClassType*)type;
+ (EGScene*)scene;
- (id<EGCamera>)camera;
- (void)reshapeWithViewport:(GERect)viewport;
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


