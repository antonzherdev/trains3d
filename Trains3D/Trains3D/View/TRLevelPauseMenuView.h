#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGTexture.h"
@class TRLevel;
@class TRHelpView;
@class TRWinMenu;
@class TRLooseMenu;
@class TRRateMenu;
@class TRShopMenu;
@class CNReact;
@class EGGlobal;
@class EGContext;
@class EGCamera2D;
@class CNVar;
@class TRHelp;
@class TRLevelResult;
@class EGDirector;
@class EGEnablingState;
@class EGBlendFunction;
@class EGColorSource;
@class EGD2D;
@class EGSprite;
@class TRStr;
@class TRStrings;
@class EGFont;
@class EGButton;
@class CNSignal;
@class CNChain;
@class TRGameDirector;
@class CNObserver;
@class EGGameCenter;
@class EGShareDialog;
@class EGPlatform;

@class TRLevelPauseMenuView;
@class TRPauseView;
@class TRMenuView;
@class TRPauseMenuView;

@interface TRLevelPauseMenuView : EGLayerView_impl<EGInputProcessor> {
@protected
    TRLevel* _level;
    NSString* _name;
    CNLazy* __lazy_menuView;
    CNLazy* __lazy_helpView;
    CNLazy* __lazy_winView;
    CNLazy* __lazy_looseView;
    CNLazy* __lazy_rateView;
    CNLazy* __lazy_slowMotionShopView;
    CNReact* __camera;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;

+ (instancetype)levelPauseMenuViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (id<EGCamera>)camera;
- (TRPauseView*)view;
- (void)draw;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)isActive;
- (BOOL)isProcessorActive;
- (EGRecognizers*)recognizers;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRPauseView : NSObject
+ (instancetype)pauseView;
- (instancetype)init;
- (CNClassType*)type;
- (void)draw;
- (BOOL)tapEvent:(id<EGEvent>)event;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRMenuView : TRPauseView {
@protected
    NSArray* __buttons;
    CNReact* _headerRect;
    NSArray* __buttonObservers;
    EGSprite* _headerSprite;
}
@property (nonatomic, readonly) CNReact* headerRect;

+ (instancetype)menuView;
- (instancetype)init;
- (CNClassType*)type;
- (NSArray*)buttons;
- (void)_init;
- (BOOL)tapEvent:(id<EGEvent>)event;
- (void)draw;
- (CGFloat)headerHeight;
- (NSInteger)buttonHeight;
- (void)drawHeader;
- (NSInteger)columnWidth;
- (CNReact*)headerMaterial;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRPauseMenuView : TRMenuView {
@protected
    TRLevel* _level;
    EGSprite* _soundSprite;
    CNObserver* _ssObs;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)pauseMenuViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (NSArray*)buttons;
- (void)draw;
- (NSInteger)buttonHeight;
- (BOOL)tapEvent:(id<EGEvent>)event;
- (NSString*)description;
+ (CNClassType*)type;
@end


