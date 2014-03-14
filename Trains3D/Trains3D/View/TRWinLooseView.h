#import "objd.h"
#import "TRLevelPauseMenuView.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class ATVar;
@class TRGameDirector;
@class EGDirector;
@class EGGlobal;
@class ATReact;
@class TRStr;
@class TRStrings;
@class TRScore;
@class EGLocalPlayerScore;
@class EGGameCenter;
@class EGShareDialog;
@class EGPlatform;
@class TRLevelChooseMenu;
@class EGColorSource;

@class TRWinMenu;
@class TRLooseMenu;

@interface TRWinMenu : TRMenuView {
@private
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
- (id<CNImSeq>)buttons;
- (CGFloat)headerHeight;
- (NSInteger)buttonHeight;
- (void)drawHeader;
- (ATReact*)headerMaterial;
+ (ODClassType*)type;
@end


@interface TRLooseMenu : TRMenuView {
@private
    TRLevel* _level;
    EGText* _headerText;
    EGText* _detailsText;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)looseMenuWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (id<CNImSeq>)buttons;
- (CGFloat)headerHeight;
- (void)drawHeader;
- (ATReact*)headerMaterial;
+ (ODClassType*)type;
@end


