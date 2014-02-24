#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGGlobal;
@class EGContext;
@class EGCamera2D;
@class TRLevelResult;
@class EGDirector;
@class EGBlendFunction;
@class EGColorSource;
@class EGD2D;
@class EGEnablingState;
@class EGEnvironment;
@class EGButton;
@class TRStr;
@class TRStrings;
@class TRGameDirector;
@class EGGameCenter;
@class EGShareDialog;
@class EGSprite;
@class EGTexture;
@class EGPlatform;
@class TRLevelChooseMenu;
@class TRScore;
@class EGLocalPlayerScore;
@class TRHelp;
@class EGInAppProduct;

@class TRLevelPauseMenuView;
@class TRPauseView;
@class TRMenuView;
@class TRPauseMenuView;
@class TRWinMenu;
@class TRRateMenu;
@class TRLooseMenu;
@class TRHelpView;
@class TRSlowMotionShopMenu;

@interface TRLevelPauseMenuView : NSObject<EGLayerView, EGInputProcessor>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic) id<EGCamera> camera;

+ (id)levelPauseMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)reshapeWithViewport:(GERect)viewport;
- (TRPauseView*)view;
- (void)draw;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)isActive;
- (BOOL)isProcessorActive;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


@interface TRPauseView : NSObject
+ (id)pauseView;
- (id)init;
- (ODClassType*)type;
- (void)reshapeWithViewport:(GERect)viewport;
- (void)draw;
- (BOOL)tapEvent:(id<EGEvent>)event;
+ (ODClassType*)type;
@end


@interface TRMenuView : TRPauseView
+ (id)menuView;
- (id)init;
- (ODClassType*)type;
- (EGFont*)font;
- (EGButton*)buttonText:(NSString*)text onClick:(void(^)())onClick;
- (void(^)(GERect))drawBack;
- (id<CNSeq>)buttons;
- (BOOL)tapEvent:(id<EGEvent>)event;
- (void)draw;
- (CGFloat)headerHeight;
- (NSInteger)buttonHeight;
- (void)reshapeWithViewport:(GERect)viewport;
- (void)reshape;
- (void)drawHeaderRect:(GERect)rect;
- (NSInteger)columnWidth;
+ (ODClassType*)type;
@end


@interface TRPauseMenuView : TRMenuView
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<CNSeq> buttons;
@property (nonatomic, readonly) EGSprite* soundSprite;

+ (id)pauseMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
- (NSInteger)buttonHeight;
- (BOOL)tapEvent:(id<EGEvent>)event;
+ (ODClassType*)type;
@end


@interface TRWinMenu : TRMenuView
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic) id _score;

+ (id)winMenuWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (id<CNSeq>)buttons;
- (CGFloat)headerHeight;
- (NSInteger)buttonHeight;
- (void)drawHeaderRect:(GERect)rect;
- (void)reshape;
+ (ODClassType*)type;
@end


@interface TRRateMenu : TRMenuView
+ (id)rateMenu;
- (id)init;
- (ODClassType*)type;
- (id<CNSeq>)buttons;
- (CGFloat)headerHeight;
- (NSInteger)columnWidth;
- (NSInteger)buttonHeight;
- (void)drawHeaderRect:(GERect)rect;
- (void)reshape;
+ (ODClassType*)type;
@end


@interface TRLooseMenu : TRMenuView
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<CNSeq> buttons;

+ (id)looseMenuWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (CGFloat)headerHeight;
- (void)drawHeaderRect:(GERect)rect;
- (void)reshape;
+ (ODClassType*)type;
@end


@interface TRHelpView : TRPauseView
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic) BOOL _allowClose;

+ (id)helpViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)reshapeWithViewport:(GERect)viewport;
- (void)draw;
- (BOOL)tapEvent:(id<EGEvent>)event;
+ (ODClassType*)type;
@end


@interface TRSlowMotionShopMenu : TRPauseView
@property (nonatomic, readonly) EGFont* shareFont;

+ (id)slowMotionShopMenu;
- (id)init;
- (ODClassType*)type;
- (EGTexture*)shop;
- (void)reshapeWithViewport:(GERect)viewport;
- (void)drawBuyButtonCount:(NSUInteger)count price:(NSString*)price rect:(GERect)rect;
- (void)drawShareButtonColor:(GEVec3)color texture:(EGTexture*)texture name:(NSString*)name count:(NSUInteger)count rect:(GERect)rect;
- (void)drawButtonBackgroundColor:(GEVec3)color rect:(GERect)rect;
- (void)drawSnailColor:(GEVec3)color count:(NSUInteger)count rect:(GERect)rect;
- (void)drawCloseButtonRect:(GERect)rect;
- (void)draw;
- (BOOL)tapEvent:(id<EGEvent>)event;
+ (ODClassType*)type;
@end


