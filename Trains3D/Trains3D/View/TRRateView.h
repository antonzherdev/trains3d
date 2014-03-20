#import "objd.h"
#import "TRLevelPauseMenuView.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRStr;
@class TRStrings;
@class TRGameDirector;
@class EGPlatform;
@class ATReact;
@class EGColorSource;
@class EGGlobal;

@class TRRateMenu;

@interface TRRateMenu : TRMenuView {
@private
    EGText* _headerText;
}
+ (instancetype)rateMenu;
- (instancetype)init;
- (ODClassType*)type;
- (id<CNImSeq>)buttons;
- (CGFloat)headerHeight;
- (NSInteger)columnWidth;
- (NSInteger)buttonHeight;
- (ATReact*)headerMaterial;
- (void)_init;
- (void)drawHeader;
+ (ODClassType*)type;
@end


