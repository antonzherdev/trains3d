#import "objd.h"
#import "TRLevelPauseMenuView.h"
#import "PGVec.h"
#import "PGFont.h"
@class TRLevel;
@class CNVar;
@class CNObserver;
@class TRGameDirector;
@class PGDirector;
@class CNSignal;
@class PGText;
@class TRStr;
@class TRStrings;
@class PGGameCenter;
@class PGShareDialog;
@class PGPlatform;
@class CNReact;
@class PGLocalPlayerScore;
@class TRLevelChooseMenu;
@class PGColorSource;
@class PGGlobal;
@class TRScore;

@class TRWinMenu;
@class TRLooseMenu;

@interface TRWinMenu : TRMenuView {
@public
    TRLevel* _level;
    CNVar* _gcScore;
    CNObserver* _obs;
    PGText* _headerText;
    PGText* _resultText;
    PGText* _bestScoreText;
    PGText* _topText;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)winMenuWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (NSArray*)buttons;
- (CGFloat)headerHeight;
- (NSInteger)buttonHeight;
- (void)drawHeader;
- (CNReact*)headerMaterial;
- (void)_init;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRLooseMenu : TRMenuView {
@public
    TRLevel* _level;
    PGText* _headerText;
    PGText* _detailsText;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)looseMenuWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (NSArray*)buttons;
- (CGFloat)headerHeight;
- (void)drawHeader;
- (CNReact*)headerMaterial;
- (void)_init;
- (NSString*)description;
+ (CNClassType*)type;
@end


