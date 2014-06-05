#import "objd.h"
#import "PGScene.h"
#import "PGInput.h"
#import "PGVec.h"
#import "PGTexture.h"
@class TRLevel;
@class TRHelpView;
@class TRWinMenu;
@class TRLooseMenu;
@class TRRateMenu;
@class TRShopMenu;
@class CNReact;
@class PGGlobal;
@class PGContext;
@class PGCamera2D;
@class CNVar;
@class TRHelp;
@class TRLevelResult;
@class PGDirector;
@class PGEnablingState;
@class PGBlendFunction;
@class PGColorSource;
@class PGD2D;
@class PGSprite;
@class TRStr;
@class TRStrings;
@class PGFont;
@class PGButton;
@class CNSignal;
@class CNChain;
@class TRGameDirector;
@class CNObserver;
@class PGGameCenter;
@class PGShareDialog;
@class PGPlatform;

@class TRLevelPauseMenuView;
@class TRPauseView;
@class TRMenuView;
@class TRPauseMenuView;

@interface TRLevelPauseMenuView : PGLayerView_impl<PGInputProcessor> {
@public
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
- (id<PGCamera>)camera;
- (TRPauseView*)view;
- (void)draw;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)isActive;
- (BOOL)isProcessorActive;
- (PGRecognizers*)recognizers;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRPauseView : NSObject
+ (instancetype)pauseView;
- (instancetype)init;
- (CNClassType*)type;
- (void)draw;
- (BOOL)tapEvent:(id<PGEvent>)event;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRMenuView : TRPauseView {
@public
    NSArray* __buttons;
    CNReact* _headerRect;
    NSArray* __buttonObservers;
    PGSprite* _headerSprite;
}
@property (nonatomic, readonly) CNReact* headerRect;

+ (instancetype)menuView;
- (instancetype)init;
- (CNClassType*)type;
- (NSArray*)buttons;
- (void)_init;
- (BOOL)tapEvent:(id<PGEvent>)event;
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
@public
    TRLevel* _level;
    PGSprite* _soundSprite;
    CNObserver* _ssObs;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)pauseMenuViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (NSArray*)buttons;
- (void)draw;
- (NSInteger)buttonHeight;
- (BOOL)tapEvent:(id<PGEvent>)event;
- (NSString*)description;
+ (CNClassType*)type;
@end


