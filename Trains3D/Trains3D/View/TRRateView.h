#import "objd.h"
#import "TRLevelPauseMenuView.h"
#import "GEVec.h"
#import "EGFont.h"
@class EGText;
@class TRStr;
@class TRStrings;
@class TRGameDirector;
@class EGPlatform;
@class ATReact;
@class EGColorSource;
@class EGGlobal;

@class TRRateMenu;

@interface TRRateMenu : TRMenuView {
@protected
    EGText* _headerText;
}
+ (instancetype)rateMenu;
- (instancetype)init;
- (ODClassType*)type;
- (NSArray*)buttons;
- (CGFloat)headerHeight;
- (NSInteger)columnWidth;
- (NSInteger)buttonHeight;
- (ATReact*)headerMaterial;
- (void)_init;
- (void)drawHeader;
+ (ODClassType*)type;
@end


