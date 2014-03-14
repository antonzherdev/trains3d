#import "objd.h"
#import "TRLevelPauseMenuView.h"
#import "GEVec.h"
#import "EGFont.h"
@class EGGlobal;
@class ATReact;
@class TRStr;
@class TRStrings;
@class TRGameDirector;
@class EGPlatform;
@class EGColorSource;

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
- (void)drawHeader;
+ (ODClassType*)type;
@end


