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
@class EGTextureFormat;
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

@interface TRLevelPauseMenuView : NSObject<EGLayerView, EGInputProcessor> {
@private
    TRLevel* _level;
    NSString* _name;
    TRPauseMenuView* _menuView;
    TRHelpView* _helpView;
    TRWinMenu* _winView;
    TRLooseMenu* _looseView;
    TRRateMenu* _rateView;
    TRSlowMotionShopMenu* _slowMotionShopView;
    id<EGCamera> _camera;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic) id<EGCamera> camera;

+ (instancetype)levelPauseMenuViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
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
+ (instancetype)pauseView;
- (instancetype)init;
- (ODClassType*)type;
- (void)reshapeWithViewport:(GERect)viewport;
- (void)draw;
- (BOOL)tapEvent:(id<EGEvent>)event;
+ (ODClassType*)type;
@end


@interface TRMenuView : TRPauseView {
@private
    EGFont* __font;
    GEVec2 _position;
    GEVec2 _size;
}
+ (instancetype)menuView;
- (instancetype)init;
- (ODClassType*)type;
- (EGFont*)font;
- (EGButton*)buttonText:(NSString*)text onClick:(void(^)())onClick;
- (void(^)(GERect))drawBack;
- (id<CNImSeq>)buttons;
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


@interface TRPauseMenuView : TRMenuView {
@private
    TRLevel* _level;
    EGButton* _resumeButton;
    EGButton* _restartButton;
    EGButton* _chooseLevelButton;
    EGButton* _leaderboardButton;
    EGButton* _supportButton;
    EGButton* _buyButton;
    EGButton* _shareButton;
    id<CNImSeq> _buttons;
    EGSprite* _soundSprite;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<CNImSeq> buttons;
@property (nonatomic, readonly) EGSprite* soundSprite;

+ (instancetype)pauseMenuViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
- (NSInteger)buttonHeight;
- (BOOL)tapEvent:(id<EGEvent>)event;
+ (ODClassType*)type;
@end


@interface TRWinMenu : TRMenuView {
@private
    TRLevel* _level;
    EGButton* _nextButton;
    EGButton* _leaderboardButton;
    EGButton* _restartButton;
    EGButton* _chooseLevelButton;
    EGButton* _shareButton;
    id __score;
    CNNotificationObserver* _obs;
    EGText* _headerText;
    EGText* _resultText;
    EGText* _bestScoreText;
    EGText* _topText;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic) id _score;

+ (instancetype)winMenuWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (id<CNImSeq>)buttons;
- (CGFloat)headerHeight;
- (NSInteger)buttonHeight;
- (void)drawHeaderRect:(GERect)rect;
- (void)reshape;
+ (ODClassType*)type;
@end


@interface TRRateMenu : TRMenuView {
@private
    EGButton* _rateButton;
    EGButton* _supportButton;
    EGButton* _laterButton;
    EGButton* _closeButton;
    EGText* _headerText;
}
+ (instancetype)rateMenu;
- (instancetype)init;
- (ODClassType*)type;
- (id<CNImSeq>)buttons;
- (CGFloat)headerHeight;
- (NSInteger)columnWidth;
- (NSInteger)buttonHeight;
- (void)drawHeaderRect:(GERect)rect;
- (void)reshape;
+ (ODClassType*)type;
@end


@interface TRLooseMenu : TRMenuView {
@private
    TRLevel* _level;
    EGButton* _restartButton;
    EGButton* _supportButton;
    EGButton* _chooseLevelButton;
    id<CNImSeq> _buttons;
    EGText* _headerText;
    EGText* _detailsText;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<CNImSeq> buttons;

+ (instancetype)looseMenuWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (CGFloat)headerHeight;
- (void)drawHeaderRect:(GERect)rect;
- (void)reshape;
+ (ODClassType*)type;
@end


@interface TRHelpView : TRPauseView {
@private
    TRLevel* _level;
    EGText* _helpText;
    EGText* _tapText;
    EGSprite* _helpBackSprite;
    BOOL __allowClose;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic) BOOL _allowClose;

+ (instancetype)helpViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)reshapeWithViewport:(GERect)viewport;
- (void)draw;
- (BOOL)tapEvent:(id<EGEvent>)event;
+ (ODClassType*)type;
@end


@interface TRSlowMotionShopMenu : TRPauseView {
@private
    CNLazy* __lazy_shop;
    EGFont* _shareFont;
    GEVec2 _buttonSize;
    id<CNImSeq> _curButtons;
}
@property (nonatomic, readonly) EGFont* shareFont;

+ (instancetype)slowMotionShopMenu;
- (instancetype)init;
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


