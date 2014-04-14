#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
@class TRLevel;
@class TRHelpView;
@class TRWinMenu;
@class TRLooseMenu;
@class TRRateMenu;
@class TRShopMenu;
@class ATReact;
@class EGGlobal;
@class EGContext;
@class EGCamera2D;
@class ATVar;
@class TRHelp;
@class TRLevelResult;
@class EGDirector;
@class EGEnablingState;
@class EGBlendFunction;
@class EGColorSource;
@class EGD2D;
@class EGEnvironment;
@class EGSprite;
@class TRStr;
@class TRStrings;
@class EGFont;
@class EGButton;
@class ATSignal;
@class TRGameDirector;
@class EGTextureFormat;
@class EGTexture;
@class EGTextureRegion;
@class ATObserver;
@class EGGameCenter;
@class EGShareDialog;
@class EGPlatform;

@class TRLevelPauseMenuView;
@class TRPauseView;
@class TRMenuView;
@class TRPauseMenuView;

@interface TRLevelPauseMenuView : NSObject<EGLayerView, EGInputProcessor> {
@protected
    TRLevel* _level;
    NSString* _name;
    CNLazy* __lazy_menuView;
    CNLazy* __lazy_helpView;
    CNLazy* __lazy_winView;
    CNLazy* __lazy_looseView;
    CNLazy* __lazy_rateView;
    CNLazy* __lazy_slowMotionShopView;
    ATReact* __camera;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;

+ (instancetype)levelPauseMenuViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (id<EGCamera>)camera;
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
- (void)draw;
- (BOOL)tapEvent:(id<EGEvent>)event;
+ (ODClassType*)type;
@end


@interface TRMenuView : TRPauseView {
@protected
    NSArray* __buttons;
    ATReact* _headerRect;
    NSArray* __buttonObservers;
    EGSprite* _headerSprite;
}
@property (nonatomic, readonly) ATReact* headerRect;

+ (instancetype)menuView;
- (instancetype)init;
- (ODClassType*)type;
- (NSArray*)buttons;
- (void)_init;
- (BOOL)tapEvent:(id<EGEvent>)event;
- (void)draw;
- (CGFloat)headerHeight;
- (NSInteger)buttonHeight;
- (void)drawHeader;
- (NSInteger)columnWidth;
- (ATReact*)headerMaterial;
+ (ODClassType*)type;
@end


@interface TRPauseMenuView : TRMenuView {
@protected
    TRLevel* _level;
    EGSprite* _soundSprite;
    ATObserver* _ssObs;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)pauseMenuViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (NSArray*)buttons;
- (void)draw;
- (NSInteger)buttonHeight;
- (BOOL)tapEvent:(id<EGEvent>)event;
+ (ODClassType*)type;
@end


