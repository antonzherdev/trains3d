#import "objd.h"
#import "TRLevelPauseMenuView.h"
#import "GEVec.h"
#import "EGFont.h"
@class EGText;
@class TRStr;
@class TRStrings;
@class TRGameDirector;
@class EGPlatform;
@class CNReact;
@class EGColorSource;
@class EGGlobal;

@class TRRateMenu;

@interface TRRateMenu : TRMenuView {
@protected
    EGText* _headerText;
}
+ (instancetype)rateMenu;
- (instancetype)init;
- (CNClassType*)type;
- (NSArray*)buttons;
- (CGFloat)headerHeight;
- (NSInteger)columnWidth;
- (NSInteger)buttonHeight;
- (CNReact*)headerMaterial;
- (void)_init;
- (void)drawHeader;
- (NSString*)description;
+ (CNClassType*)type;
@end


