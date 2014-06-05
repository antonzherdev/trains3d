#import "objd.h"
#import "PGScene.h"
#import "PGVec.h"
#import "PGFont.h"
#import "PGTexture.h"
@class PGProgress;
@class TRGameDirector;
@class PGDirector;
@class TRShopButton;
@class CNChain;
@class PGPlatform;
@class PGGlobal;
@class TRStr;
@class TRStrings;
@class PGCamera2D;
@class PGContext;
@class PGLocalPlayerScore;
@class PGColorSource;
@class PGD2D;
@class PGEnablingState;
@class PGBlendFunction;
@class PGRecognizers;
@class PGTap;
@class PGRecognizer;

@class TRLevelChooseMenu;

@interface TRLevelChooseMenu : PGSceneView_impl {
@public
    NSString* _name;
    NSInteger _maxLevel;
    NSArray* _buttons;
    PGFont* _fontRes;
    PGFont* _fontBottom;
    CNMHashMap* __scores;
}
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, retain) CNMHashMap* _scores;

+ (instancetype)levelChooseMenu;
- (instancetype)init;
- (CNClassType*)type;
+ (PGScene*)scene;
- (id<PGCamera>)camera;
- (void)start;
- (void)stop;
+ (PGVec4)rankColorScore:(PGLocalPlayerScore*)score;
- (void)draw;
- (BOOL)isProcessorActive;
- (PGRecognizers*)recognizers;
- (PGRect)viewportWithViewSize:(PGVec2)viewSize;
- (NSString*)description;
+ (CNClassType*)type;
@end


