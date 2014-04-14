#import "objd.h"
#import "TRLevelPauseMenuView.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class ATVar;
@class TRGameDirector;
@class EGDirector;
@class EGText;
@class TRStr;
@class TRStrings;
@class EGGameCenter;
@class EGShareDialog;
@class EGPlatform;
@class ATReact;
@class EGLocalPlayerScore;
@class TRLevelChooseMenu;
@class EGColorSource;
@class EGGlobal;
@class TRScore;

@class TRWinMenu;
@class TRLooseMenu;

@interface TRWinMenu : TRMenuView {
@protected
    TRLevel* _level;
    ATVar* _gcScore;
    CNNotificationObserver* _obs;
    EGText* _headerText;
    EGText* _resultText;
    EGText* _bestScoreText;
    EGText* _topText;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)winMenuWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (NSArray*)buttons;
- (CGFloat)headerHeight;
- (NSInteger)buttonHeight;
- (void)drawHeader;
- (ATReact*)headerMaterial;
- (void)_init;
+ (ODClassType*)type;
@end


@interface TRLooseMenu : TRMenuView {
@protected
    TRLevel* _level;
    EGText* _headerText;
    EGText* _detailsText;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)looseMenuWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (NSArray*)buttons;
- (CGFloat)headerHeight;
- (void)drawHeader;
- (ATReact*)headerMaterial;
- (void)_init;
+ (ODClassType*)type;
@end


